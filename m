Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaF0J5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:57:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41913 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbaF0J5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:57:49 -0400
Date: Fri, 27 Jun 2014 18:56:43 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, peter.p.waskiewicz.jr@intel.com,
        sachin.kamat@linaro.org, fempsci@gmail.com, weo@weo1.de,
        sima.baymani@gmail.com, shaun@XResource.ca, lisa@xenapiadmin.com,
        eu@opreamatei.ro, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: cxt1e1: remove OS_mem_token_xxxx interfaces in
 sbecom_inline_linux.h
Message-ID: <20140627095643.GA9445@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OS_mem_token_xxxx interfaces are useless, so just replaced with
sk_buff related fuctions.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c              |   45 +++++++++---------
 drivers/staging/cxt1e1/pmcc4_drv.c           |   11 ++--
 drivers/staging/cxt1e1/pmcc4_private.h       |    2 +-
 drivers/staging/cxt1e1/sbecom_inline_linux.h |   65 --------------------------
 4 files changed, 28 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 5fc45a4..d61f7d9 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -935,16 +935,15 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 		md->data = 0;
 		if (md->mem_token) {
 			/* upcount channel */
-			atomic_sub(OS_mem_token_tlen(md->mem_token),
-				   &ch->tx_pending);
+			unsigned int total_len = md->mem_token->len;
+			atomic_sub(total_len, &ch->tx_pending);
 			/* upcount card */
-			atomic_sub(OS_mem_token_tlen(md->mem_token),
-				   &pi->up->tx_pending);
+			atomic_sub(total_len, &pi->up->tx_pending);
 #ifdef SBE_WAN256T3_ENABLE
 			if (!atomic_read(&pi->up->tx_pending))
 				wan256t3_led(pi->up, LED_TX, 0);
 #endif
-			OS_mem_token_free_irq(md->mem_token);
+			dev_kfree_skb_irq(md->mem_token);
 			md->mem_token = NULL;
 		}
 		md->status = 0;
@@ -1016,7 +1015,7 @@ static void
 musycc_bh_rx_eom(mpi_t *pi, int gchan)
 {
 	mch_t      *ch;
-	void       *m, *m2;
+	struct sk_buff *m, *m2;
 	struct mdesc *md;
 	volatile u_int32_t status;
 	u_int32_t   error;
@@ -1041,12 +1040,12 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 		error = (status >> 16) & 0xf;
 		if (error == 0) {
 			{
-				m2 = OS_mem_token_alloc(cxt1e1_max_mru);
+				m2 = dev_alloc_skb(cxt1e1_max_mru);
 				if (m2) {
 					/* substitute the mbuf+cluster */
 					md->mem_token = m2;
 					md->data = cpu_to_le32(__pa(
-							       OS_mem_token_data(m2)));
+							       m2->data));
 
 					/* pass the received mbuf upward */
 					sd_recv_consume(m, status & LENGTH_MASK,
@@ -1552,11 +1551,11 @@ musycc_chan_down(ci_t *dummy, int channum)
 	FLUSH_MEM_WRITE();
 	for (i = 0; i < ch->txd_num; i++)
 		if (ch->mdt[i].mem_token)
-			OS_mem_token_free(ch->mdt[i].mem_token);
+			dev_kfree_skb_any(ch->mdt[i].mem_token);
 
 	for (i = 0; i < ch->rxd_num; i++)
 		if (ch->mdr[i].mem_token)
-			OS_mem_token_free(ch->mdr[i].mem_token);
+			dev_kfree_skb_any(ch->mdr[i].mem_token);
 
 	kfree(ch->mdr);
 	ch->mdr = NULL;
@@ -1574,11 +1573,11 @@ musycc_chan_down(ci_t *dummy, int channum)
 #endif
 
 int
-musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
+musycc_start_xmit(ci_t *ci, int channum, struct sk_buff *mem_token)
 {
 	mch_t      *ch;
 	struct mdesc *md;
-	void       *m2;
+	struct sk_buff *m2;
 	int         txd_need_cnt = 0;
 	u_int32_t   len, data_len;
 
@@ -1611,23 +1610,23 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	/** Determine total amount of data to be sent **/
 	/***********************************************/
 	m2 = mem_token;
-	len = OS_mem_token_tlen(m2);
+	len = m2->len;
 
 	while (m2 && len > 0) {
-		data_len = OS_mem_token_len(m2);
+		data_len = m2->data_len;
 		if (data_len) {
 			len -= data_len;
 			txd_need_cnt++;
 		}
 
-		m2 = OS_mem_token_next(m2);
+		m2 = m2->next;
 	}
 
 	if (txd_need_cnt == 0) {
 		if (cxt1e1_log_level >= LOG_MONITOR2)
 			pr_info("%s channel %d: no TX data in User buffer\n",
 				ci->devname, channum);
-		OS_mem_token_free(mem_token);
+		dev_kfree_skb_any(mem_token);
 		return 0;                   /* no data to send */
 	}
 	/*************************************************/
@@ -1639,7 +1638,7 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 			pr_info("start_xmit: discarding buffer, insufficient descriptor cnt %d, need %d.\n",
 				ch->txd_num, txd_need_cnt + 1);
 		ch->s.tx_dropped++;
-		OS_mem_token_free(mem_token);
+		dev_kfree_skb_any(mem_token);
 		return 0;
 	}
 
@@ -1661,14 +1660,14 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	/**************************************************/
 	m2 = mem_token;
 	md = ch->txd_usr_add;           /* get current available descriptor */
-	len = OS_mem_token_tlen(m2);
+	len = m2->len;
 
 	while (m2 && len > 0) {
-		u_int32_t data_len = OS_mem_token_len(m2);
+		u_int32_t data_len = m2->data_len;
 		u_int32_t status = 0;
 
 		if (!data_len) {
-			m2 = OS_mem_token_next(m2);
+			m2 = m2->next;
 			continue;
 		}
 
@@ -1705,13 +1704,13 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		 */
 		md->mem_token = len ? NULL : mem_token;
 
-		md->data = cpu_to_le32(__pa(OS_mem_token_data(m2)));
+		md->data = cpu_to_le32(__pa(m2->data));
 		FLUSH_MEM_WRITE();
 		md->status = cpu_to_le32(status);
 		--ch->txd_free;
 		md = md->snext;
 
-		m2 = OS_mem_token_next(m2);
+		m2 = m2->next;
 	}
 	FLUSH_MEM_WRITE();
 
@@ -1723,7 +1722,7 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	FLUSH_MEM_WRITE();
 	ch->txd_usr_add = md;
 
-	len = OS_mem_token_tlen(mem_token);
+	len = mem_token->len;
 	atomic_add(len, &ch->tx_pending);
 	atomic_add(len, &ci->tx_pending);
 	ch->s.tx_packets++;
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 5f4865a..9f57730 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -1216,7 +1216,6 @@ c4_chan_up (ci_t *ci, int channum)
 {
     mpi_t      *pi;
     mch_t      *ch;
-    struct mbuf *m;
     struct mdesc *md;
     int         nts, nbuf, txnum, rxnum;
     int         addr, i, j, gchan;
@@ -1357,16 +1356,16 @@ c4_chan_up (ci_t *ci, int channum)
         }
         md->next = cpu_to_le32 (__pa(md->snext));
 
-	m = OS_mem_token_alloc(cxt1e1_max_mru);
-	if (!m) {
+	md->mem_token = dev_alloc_skb(cxt1e1_max_mru);
+	if (!md->mem_token) {
 		if (cxt1e1_log_level >= LOG_MONITOR)
 			pr_info(
 			"%s: c4_chan_up[%d] - token alloc failure, size = %d.\n",
 			ci->devname, channum, cxt1e1_max_mru);
 		goto errfree;
         }
-        md->mem_token = m;
-        md->data = cpu_to_le32 (__pa(OS_mem_token_data (m)));
+
+        md->data = cpu_to_le32 (__pa(md->mem_token->data));
         md->status = tmp | MUSYCC_RX_OWNED;     /* MUSYCC owns RX descriptor **
                                                  * CODING NOTE:
                                                  * MUSYCC_RX_OWNED = 0 so no
@@ -1431,7 +1430,7 @@ errfree:
     {
         /* Don't leak all the previously allocated mbufs in this loop */
         i--;
-        OS_mem_token_free (ch->mdr[i].mem_token);
+        dev_kfree_skb_any(ch->mdr[i].mem_token);
     }
     kfree(ch->mdt);
     ch->mdt = NULL;
diff --git a/drivers/staging/cxt1e1/pmcc4_private.h b/drivers/staging/cxt1e1/pmcc4_private.h
index 451f12f..0edb9f7 100644
--- a/drivers/staging/cxt1e1/pmcc4_private.h
+++ b/drivers/staging/cxt1e1/pmcc4_private.h
@@ -50,7 +50,7 @@ struct mdesc
     volatile u_int32_t status;  /* Buffer Descriptor */
     u_int32_t   data;           /* Data Pointer */
     u_int32_t   next;           /* MUSYCC view of Next Pointer */
-    void       *mem_token;      /* Data */
+    struct sk_buff *mem_token;      /* Data */
     struct mdesc *snext;
 };
 
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index a99073b..5470142 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -34,71 +34,6 @@
 u_int32_t   pci_read_32 (u_int32_t *p);
 void        pci_write_32 (u_int32_t *p, u_int32_t v);
 
-
-/*
- * system dependent callbacks
- */
-
-/****************/
-/* memory token */
-/****************/
-
-static inline void *
-OS_mem_token_alloc (size_t size)
-{
-    struct sk_buff *skb;
-
-    skb = dev_alloc_skb (size);
-    if (!skb)
-    {
-        //pr_warning("no mem in OS_mem_token_alloc !\n");
-        return NULL;
-    }
-    return skb;
-}
-
-
-static inline void
-OS_mem_token_free (void *token)
-{
-    dev_kfree_skb_any (token);
-}
-
-
-static inline void
-OS_mem_token_free_irq (void *token)
-{
-    dev_kfree_skb_irq (token);
-}
-
-
-static inline void *
-OS_mem_token_data (void *token)
-{
-    return ((struct sk_buff *) token)->data;
-}
-
-
-static inline void *
-OS_mem_token_next (void *token)
-{
-    return ((struct sk_buff*)token)->next;
-}
-
-
-static inline int
-OS_mem_token_len (void *token)
-{
-    return ((struct sk_buff *) token)->data_len;
-}
-
-
-static inline int
-OS_mem_token_tlen (void *token)
-{
-    return ((struct sk_buff *) token)->len;
-}
-
 /**********/
 /* semops */
 /**********/
-- 
1.7.1

