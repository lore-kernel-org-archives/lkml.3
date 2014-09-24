Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaIXKRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:17:32 -0400
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:17632
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbaIXKR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:17:28 -0400
X-Greylist: delayed 60204 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 06:17:28 EDT
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <vinod.koul@intel.com>
CC: <linux@arm.linux.org.uk>, <arnd@arndb.de>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G support in big-endian model
Date: Wed, 24 Sep 2014 17:24:02 +0800
Message-ID: <1411550642-12577-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(106466001)(95666004)(76482002)(105606002)(50466002)(87286001)(50986999)(84676001)(89996001)(64706001)(99396003)(36756003)(6806004)(77156001)(87936001)(85852003)(21056001)(97736003)(110136001)(92726001)(33646002)(90102001)(74662003)(107046002)(4396001)(102836001)(46102003)(50226001)(229853001)(81542003)(104016003)(31966008)(19580395003)(86362001)(19580405001)(62966002)(85306004)(68736004)(104166001)(81342003)(2351001)(83072002)(20776003)(74502003)(92566001)(79102003)(44976005)(80022003)(120916001)(77982003)(83322001)(10300001)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offset of all 8-/16-bit register in big-endian eDMA model are
swapped in a 32-bit size opposite those in the little-endian model.

The hardware Scatter/Gather requires the subsequent TCDs in memory
to be auto loaded should retain little endian independent of the
register endian model, the dma engine will do the swap if need.

This patch also use regular assignment for tcd variables r/w
instead of with io function previously that may not always be true.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
changes in v3:
 use unsigned long instead of u32 in reg offset swap cast to avoid warning.

changes in v2:
 simplify register offset swap calculation.
 use regular assignment for tcd variables r/w instead of io function.

 drivers/dma/fsl-edma.c | 106 ++++++++++++++++++++++++++-----------------------
 1 file changed, 57 insertions(+), 49 deletions(-)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index 3c5711d..9ca55ee 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -177,16 +177,10 @@ struct fsl_edma_engine {
 /*
  * R/W functions for big- or little-endian registers
  * the eDMA controller's endian is independent of the CPU core's endian.
+ * for the big-endian IP module, the offset for 8-bit or 16-bit register
+ * should also be swapped oposite to that in little-endian IP.
  */
 
-static u16 edma_readw(struct fsl_edma_engine *edma, void __iomem *addr)
-{
-	if (edma->big_endian)
-		return ioread16be(addr);
-	else
-		return ioread16(addr);
-}
-
 static u32 edma_readl(struct fsl_edma_engine *edma, void __iomem *addr)
 {
 	if (edma->big_endian)
@@ -197,13 +191,18 @@ static u32 edma_readl(struct fsl_edma_engine *edma, void __iomem *addr)
 
 static void edma_writeb(struct fsl_edma_engine *edma, u8 val, void __iomem *addr)
 {
-	iowrite8(val, addr);
+	/* swap the reg offset for these in big-endian mode */
+	if (edma->big_endian)
+		iowrite8(val, (void __iomem *)((unsigned long)addr ^ 0x3));
+	else
+		iowrite8(val, addr);
 }
 
 static void edma_writew(struct fsl_edma_engine *edma, u16 val, void __iomem *addr)
 {
+	/* swap the reg offset for these in big-endian mode */
 	if (edma->big_endian)
-		iowrite16be(val, addr);
+		iowrite16be(val, (void __iomem *)((unsigned long)addr ^ 0x2));
 	else
 		iowrite16(val, addr);
 }
@@ -256,11 +255,10 @@ static void fsl_edma_chan_mux(struct fsl_edma_chan *fsl_chan,
 	muxaddr = fsl_chan->edma->muxbase[ch / chans_per_mux];
 
 	if (enable)
-		edma_writeb(fsl_chan->edma,
-				EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(slot),
+		writeb(EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(slot),
 				muxaddr + ch_off);
 	else
-		edma_writeb(fsl_chan->edma, EDMAMUX_CHCFG_DIS, muxaddr + ch_off);
+		writeb(EDMAMUX_CHCFG_DIS, muxaddr + ch_off);
 }
 
 static unsigned int fsl_edma_get_tcd_attr(enum dma_slave_buswidth addr_width)
@@ -363,8 +361,8 @@ static size_t fsl_edma_desc_residue(struct fsl_edma_chan *fsl_chan,
 
 	/* calculate the total size in this desc */
 	for (len = i = 0; i < fsl_chan->edesc->n_tcds; i++)
-		len += edma_readl(fsl_chan->edma, &(edesc->tcd[i].vtcd->nbytes))
-			* edma_readw(fsl_chan->edma, &(edesc->tcd[i].vtcd->biter));
+		len += le32_to_cpu(edesc->tcd[i].vtcd->nbytes)
+			* le16_to_cpu(edesc->tcd[i].vtcd->biter);
 
 	if (!in_progress)
 		return len;
@@ -376,14 +374,12 @@ static size_t fsl_edma_desc_residue(struct fsl_edma_chan *fsl_chan,
 
 	/* figure out the finished and calculate the residue */
 	for (i = 0; i < fsl_chan->edesc->n_tcds; i++) {
-		size = edma_readl(fsl_chan->edma, &(edesc->tcd[i].vtcd->nbytes))
-			* edma_readw(fsl_chan->edma, &(edesc->tcd[i].vtcd->biter));
+		size = le32_to_cpu(edesc->tcd[i].vtcd->nbytes)
+			* le16_to_cpu(edesc->tcd[i].vtcd->biter);
 		if (dir == DMA_MEM_TO_DEV)
-			dma_addr = edma_readl(fsl_chan->edma,
-					&(edesc->tcd[i].vtcd->saddr));
+			dma_addr = le32_to_cpu(edesc->tcd[i].vtcd->saddr);
 		else
-			dma_addr = edma_readl(fsl_chan->edma,
-					&(edesc->tcd[i].vtcd->daddr));
+			dma_addr = le32_to_cpu(edesc->tcd[i].vtcd->daddr);
 
 		len -= size;
 		if (cur_addr > dma_addr && cur_addr < dma_addr + size) {
@@ -433,21 +429,26 @@ static void fsl_edma_set_tcd_params(struct fsl_edma_chan *fsl_chan,
 	u32 ch = fsl_chan->vchan.chan.chan_id;
 
 	/*
-	 * TCD parameters have been swapped in fill_tcd_params(),
-	 * so just write them to registers in the cpu endian here
+	 * TCD parameters should be swapped according the eDMA
+	 * engine requirement.
 	 */
-	writew(0, addr + EDMA_TCD_CSR(ch));
-	writel(src, addr + EDMA_TCD_SADDR(ch));
-	writel(dst, addr + EDMA_TCD_DADDR(ch));
-	writew(attr, addr + EDMA_TCD_ATTR(ch));
-	writew(soff, addr + EDMA_TCD_SOFF(ch));
-	writel(nbytes, addr + EDMA_TCD_NBYTES(ch));
-	writel(slast, addr + EDMA_TCD_SLAST(ch));
-	writew(citer, addr + EDMA_TCD_CITER(ch));
-	writew(biter, addr + EDMA_TCD_BITER(ch));
-	writew(doff, addr + EDMA_TCD_DOFF(ch));
-	writel(dlast_sga, addr + EDMA_TCD_DLAST_SGA(ch));
-	writew(csr, addr + EDMA_TCD_CSR(ch));
+	edma_writew(fsl_chan->edma, 0, addr + EDMA_TCD_CSR(ch));
+	edma_writel(fsl_chan->edma, src, addr + EDMA_TCD_SADDR(ch));
+	edma_writel(fsl_chan->edma, dst, addr + EDMA_TCD_DADDR(ch));
+
+	edma_writew(fsl_chan->edma, attr, addr + EDMA_TCD_ATTR(ch));
+	edma_writew(fsl_chan->edma, soff, addr + EDMA_TCD_SOFF(ch));
+
+	edma_writel(fsl_chan->edma, nbytes, addr + EDMA_TCD_NBYTES(ch));
+	edma_writel(fsl_chan->edma, slast, addr + EDMA_TCD_SLAST(ch));
+
+	edma_writew(fsl_chan->edma, citer, addr + EDMA_TCD_CITER(ch));
+	edma_writew(fsl_chan->edma, biter, addr + EDMA_TCD_BITER(ch));
+	edma_writew(fsl_chan->edma, doff, addr + EDMA_TCD_DOFF(ch));
+
+	edma_writel(fsl_chan->edma, dlast_sga, addr + EDMA_TCD_DLAST_SGA(ch));
+
+	edma_writew(fsl_chan->edma, csr, addr + EDMA_TCD_CSR(ch));
 }
 
 static void fill_tcd_params(struct fsl_edma_engine *edma,
@@ -459,20 +460,27 @@ static void fill_tcd_params(struct fsl_edma_engine *edma,
 	u16 csr = 0;
 
 	/*
-	 * eDMA hardware SGs require the TCD parameters stored in memory
-	 * the same endian as the eDMA module so that they can be loaded
-	 * automatically by the engine
+	 * eDMA hardware SGs requires the TCDs to be auto loaded
+	 * in the little endian whenver the register endian model,
+	 * So we put the value in little endian in memory, waitting
+	 * for fsl_set_tcd_params doing the swap.
 	 */
-	edma_writel(edma, src, &(tcd->saddr));
-	edma_writel(edma, dst, &(tcd->daddr));
-	edma_writew(edma, attr, &(tcd->attr));
-	edma_writew(edma, EDMA_TCD_SOFF_SOFF(soff), &(tcd->soff));
-	edma_writel(edma, EDMA_TCD_NBYTES_NBYTES(nbytes), &(tcd->nbytes));
-	edma_writel(edma, EDMA_TCD_SLAST_SLAST(slast), &(tcd->slast));
-	edma_writew(edma, EDMA_TCD_CITER_CITER(citer), &(tcd->citer));
-	edma_writew(edma, EDMA_TCD_DOFF_DOFF(doff), &(tcd->doff));
-	edma_writel(edma, EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga), &(tcd->dlast_sga));
-	edma_writew(edma, EDMA_TCD_BITER_BITER(biter), &(tcd->biter));
+	tcd->saddr = cpu_to_le32(src);
+	tcd->daddr = cpu_to_le32(dst);
+
+	tcd->attr = cpu_to_le16(attr);
+
+	tcd->soff = cpu_to_le16(EDMA_TCD_SOFF_SOFF(soff));
+
+	tcd->nbytes = cpu_to_le32(EDMA_TCD_NBYTES_NBYTES(nbytes));
+	tcd->slast = cpu_to_le32(EDMA_TCD_SLAST_SLAST(slast));
+
+	tcd->citer = cpu_to_le16(EDMA_TCD_CITER_CITER(citer));
+	tcd->doff = cpu_to_le16(EDMA_TCD_DOFF_DOFF(doff));
+
+	tcd->dlast_sga = cpu_to_le32(EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga));
+
+	tcd->biter = cpu_to_le16(EDMA_TCD_BITER_BITER(biter));
 	if (major_int)
 		csr |= EDMA_TCD_CSR_INT_MAJOR;
 
@@ -482,7 +490,7 @@ static void fill_tcd_params(struct fsl_edma_engine *edma,
 	if (enable_sg)
 		csr |= EDMA_TCD_CSR_E_SG;
 
-	edma_writew(edma, csr, &(tcd->csr));
+	tcd->csr = cpu_to_le16(csr);
 }
 
 static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan *fsl_chan,
-- 
1.8.0

