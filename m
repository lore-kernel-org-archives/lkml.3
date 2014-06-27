Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaF0Jxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:53:33 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48500 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0Jxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:53:32 -0400
Date: Fri, 27 Jun 2014 18:52:26 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, peter.p.waskiewicz.jr@intel.com,
        sachin.kamat@linaro.org, fempsci@gmail.com, weo@weo1.de,
        sima.baymani@gmail.com, shaun@XResource.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: cxt1e1: Remove useless OS_phystov() and
 OS_vtophys()
Message-ID: <20140627095226.GA9420@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OS_phystov()/OS_vtophys() are replaced with __va()/__pa().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c              |   16 ++++++++--------
 drivers/staging/cxt1e1/pmcc4_drv.c           |   12 ++++++------
 drivers/staging/cxt1e1/sbecom_inline_linux.h |   19 -------------------
 3 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 9495c0b..563076c 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -103,7 +103,7 @@ musycc_dump_rxbuffer_ring_locked(mch_t *ch)
 				if (m->data)
 #endif
 				{
-					dp = (u_int32_t *)OS_phystov((void *)(le32_to_cpu(m->data)));
+					dp = __va(le32_to_cpu(m->data));
 					if (len >= 0x10)
 						pr_info("    %x[%x]: %08X %08X %08X %08x\n",
 							(u_int32_t)dp, len,
@@ -173,7 +173,7 @@ musycc_dump_txbuffer_ring_locked(mch_t *ch)
 			len = status & LENGTH_MASK;
 
 			if (m->data) {
-				dp = (u_int32_t *)OS_phystov((void *)(le32_to_cpu(m->data)));
+				dp = __va(le32_to_cpu(m->data));
 				if (len >= 0x10)
 					pr_info("    %x[%x]: %08X %08X %08X %08x\n",
 						(u_int32_t) dp, len,
@@ -328,7 +328,7 @@ musycc_update_tx_thp(mch_t *ch)
 		musycc_bh_tx_eom(ch->up, ch->gchan);
 	}
 	md = ch->txd_irq_srv;
-	ch->up->regram->thp[ch->gchan] = cpu_to_le32(OS_vtophys(md));
+	ch->up->regram->thp[ch->gchan] = cpu_to_le32(__pa(md));
 	FLUSH_MEM_WRITE();
 
 	if (ch->tx_full) {
@@ -729,7 +729,7 @@ musycc_chan_proto(int proto)
 static void __init
 musycc_init_port(mpi_t *pi)
 {
-	pci_write_32((u_int32_t *) &pi->reg->gbp, OS_vtophys(pi->regram));
+	pci_write_32((u_int32_t *) &pi->reg->gbp, __pa(pi->regram));
 
 	pi->regram->grcd =
 		__constant_cpu_to_le32(MUSYCC_GRCD_RX_ENABLE |
@@ -817,7 +817,7 @@ musycc_init(ci_t *ci)
 	ci->regram = ci->port[0].regram;
 	musycc_serv_req(&ci->port[0], SR_CHIP_RESET);
 
-	pci_write_32((u_int32_t *) &ci->reg->gbp, OS_vtophys(ci->regram));
+	pci_write_32((u_int32_t *) &ci->reg->gbp, __pa(ci->regram));
 	pci_flush_write(ci);
 #ifdef CONFIG_SBE_PMCC4_NCOMM
 	ci->regram->__glcd = __constant_cpu_to_le32(GCD_MAGIC);
@@ -827,7 +827,7 @@ musycc_init(ci_t *ci)
 						    MUSYCC_GCD_INTB_DISABLE);
 #endif
 
-	ci->regram->__iqp = cpu_to_le32(OS_vtophys(&ci->iqd_p[0]));
+	ci->regram->__iqp = cpu_to_le32(__pa(&ci->iqd_p[0]));
 	ci->regram->__iql = __constant_cpu_to_le32(INT_QUEUE_SIZE - 1);
 	pci_write_32((u_int32_t *) &ci->reg->dacbp, 0);
 	FLUSH_MEM_WRITE();
@@ -1045,7 +1045,7 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 				if (m2) {
 					/* substitute the mbuf+cluster */
 					md->mem_token = m2;
-					md->data = cpu_to_le32(OS_vtophys(
+					md->data = cpu_to_le32(__pa(
 							       OS_mem_token_data(m2)));
 
 					/* pass the received mbuf upward */
@@ -1698,7 +1698,7 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		 */
 		md->mem_token = len ? NULL : mem_token;
 
-		md->data = cpu_to_le32(OS_vtophys(OS_mem_token_data(m2)));
+		md->data = cpu_to_le32(__pa(OS_mem_token_data(m2)));
 		FLUSH_MEM_WRITE();
 		md->status = cpu_to_le32(u);
 		--ch->txd_free;
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 76bebdd..5f4865a 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -919,7 +919,7 @@ c4_set_port (ci_t *ci, int portnum)
 
     pci_write_32 ((u_int32_t *) &ci->cpldbase->mclk, clck);
     pci_write_32 ((u_int32_t *) &ci->cpldbase->mcsr, PMCC4_CPLD_MCSR_IND);
-    pci_write_32 ((u_int32_t *) &pi->reg->gbp, OS_vtophys (pi->regram));
+    pci_write_32 ((u_int32_t *) &pi->reg->gbp, __pa(pi->regram));
 
     /*********************************************************************/
     /* ERRATA: If transparent mode is used, do not set OOFMP_DISABLE bit */
@@ -1355,7 +1355,7 @@ c4_chan_up (ci_t *ci, int channum)
         {
             md->snext = &ch->mdr[i + 1];
         }
-        md->next = cpu_to_le32 (OS_vtophys (md->snext));
+        md->next = cpu_to_le32 (__pa(md->snext));
 
 	m = OS_mem_token_alloc(cxt1e1_max_mru);
 	if (!m) {
@@ -1366,7 +1366,7 @@ c4_chan_up (ci_t *ci, int channum)
 		goto errfree;
         }
         md->mem_token = m;
-        md->data = cpu_to_le32 (OS_vtophys (OS_mem_token_data (m)));
+        md->data = cpu_to_le32 (__pa(OS_mem_token_data (m)));
         md->status = tmp | MUSYCC_RX_OWNED;     /* MUSYCC owns RX descriptor **
                                                  * CODING NOTE:
                                                  * MUSYCC_RX_OWNED = 0 so no
@@ -1387,7 +1387,7 @@ c4_chan_up (ci_t *ci, int channum)
         {
             md->snext = &ch->mdt[i + 1];
         }
-        md->next = cpu_to_le32 (OS_vtophys (md->snext));
+        md->next = cpu_to_le32 (__pa(md->snext));
     }
     ch->txd_irq_srv = ch->txd_usr_add = &ch->mdt[0];
     ch->txd_free = txnum;
@@ -1395,11 +1395,11 @@ c4_chan_up (ci_t *ci, int channum)
     ch->txd_required = 0;
 
     /* Configure it into the chip */
-    tmp = cpu_to_le32 (OS_vtophys (&ch->mdt[0]));
+    tmp = cpu_to_le32 (__pa(&ch->mdt[0]));
     pi->regram->thp[gchan] = tmp;
     pi->regram->tmp[gchan] = tmp;
 
-    tmp = cpu_to_le32 (OS_vtophys (&ch->mdr[0]));
+    tmp = cpu_to_le32 (__pa(&ch->mdr[0]));
     pi->regram->rhp[gchan] = tmp;
     pi->regram->rmp[gchan] = tmp;
 
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index f5835c2..af2bffe 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -99,25 +99,6 @@ OS_mem_token_tlen (void *token)
     return ((struct sk_buff *) token)->len;
 }
 
-
-/***************************************/
-/* virtual to physical addr conversion */
-/***************************************/
-
-static inline u_long
-OS_phystov (void *addr)
-{
-    return (u_long) __va (addr);
-}
-
-
-static inline u_long
-OS_vtophys (void *addr)
-{
-    return __pa (addr);
-}
-
-
 /**********/
 /* semops */
 /**********/
-- 
1.7.1

