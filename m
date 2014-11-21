Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbaKUJYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:24:50 -0500
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:55818
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755073AbaKUJYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:24:47 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Topic: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Index: AQHP7dxw0ZXsnje90ESiN3180LVrWZxq5yNQ
Date: Fri, 21 Nov 2014 09:09:47 +0000
Message-ID: <d487ad8a5496405cbba77f29633a192a@BN3PR0301MB1236.namprd03.prod.outlook.com>
References: <1413968035-12855-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1413968035-12855-1-git-send-email-jingchang.lu@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
x-forefront-prvs: 0402872DA1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377454003)(13464003)(189002)(199003)(74316001)(122556002)(120916001)(99286002)(2351001)(99396003)(62966003)(40100003)(77096003)(107046002)(77156002)(106116001)(105586002)(110136001)(106356001)(21056001)(108616004)(97736003)(2501002)(31966008)(19580395003)(19580405001)(46102003)(2656002)(87936001)(86362001)(92566001)(50986999)(33646002)(66066001)(20776003)(54356999)(95666004)(4396001)(64706001)(76576001)(76176999)(101416001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1234;H:BN3PR0301MB1236.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAL9OvFM016306

Hi, Vinod,

  Could you please help review and merge this patch if possible. Thanks.

Best Regards,
Jingchang

>-----Original Message-----
>From: Jingchang Lu [mailto:jingchang.lu@freescale.com]
>Sent: Wednesday, October 22, 2014 4:54 PM
>To: vinod.koul@intel.com
>Cc: dmaengine@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>linux-kernel@vger.kernel.org; Lu Jingchang-B35083
>Subject: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
>support in big-endian model
>
>The offset of all 8-/16-bit registers in big-endian eDMA model are swapped
>in a 32-bit size opposite those in the little-endian model.
>
>The hardware Scatter/Gather requires the subsequent TCDs stored in memory
>in little endian independent of the register endian model, the eDMA engine
>will do the swap if need.
>
>This patch also use regular assignment for tcd variables r/w instead of
>with io function previously that may not always be true.
>
>Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>---
>changes in v4:
> use __le32/16 define little endian tcd struct explicitly.
> modify fsl_edma_set_tcd_regs() to simplify parameters.
> define fsl_edma_fill_tcd() as inline function.
>
>changes in v3:
> use unsigned long instead of u32 in reg offset swap cast to avoid warning.
>
>changes in v2:
> simplify register offset swap calculation.
> use regular assignment for tcd variables r/w instead of io function.
>
> drivers/dma/fsl-edma.c | 189 +++++++++++++++++++++++++-------------------
>-----
> 1 file changed, 96 insertions(+), 93 deletions(-)
>
>diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c index
>3c5711d..2ce7076 100644
>--- a/drivers/dma/fsl-edma.c
>+++ b/drivers/dma/fsl-edma.c
>@@ -118,17 +118,17 @@
> 				BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)
>
> struct fsl_edma_hw_tcd {
>-	u32	saddr;
>-	u16	soff;
>-	u16	attr;
>-	u32	nbytes;
>-	u32	slast;
>-	u32	daddr;
>-	u16	doff;
>-	u16	citer;
>-	u32	dlast_sga;
>-	u16	csr;
>-	u16	biter;
>+	__le32	saddr;
>+	__le16	soff;
>+	__le16	attr;
>+	__le32	nbytes;
>+	__le32	slast;
>+	__le32	daddr;
>+	__le16	doff;
>+	__le16	citer;
>+	__le32	dlast_sga;
>+	__le16	csr;
>+	__le16	biter;
> };
>
> struct fsl_edma_sw_tcd {
>@@ -175,18 +175,12 @@ struct fsl_edma_engine {  };
>
> /*
>- * R/W functions for big- or little-endian registers
>- * the eDMA controller's endian is independent of the CPU core's endian.
>+ * R/W functions for big- or little-endian registers:
>+ * The eDMA controller's endian is independent of the CPU core's endian.
>+ * For the big-endian IP module, the offset for 8-bit or 16-bit
>+ registers
>+ * should also be swapped opposite to that in little-endian IP.
>  */
>
>-static u16 edma_readw(struct fsl_edma_engine *edma, void __iomem *addr) -
>{
>-	if (edma->big_endian)
>-		return ioread16be(addr);
>-	else
>-		return ioread16(addr);
>-}
>-
> static u32 edma_readl(struct fsl_edma_engine *edma, void __iomem *addr)
>{
> 	if (edma->big_endian)
>@@ -197,13 +191,18 @@ static u32 edma_readl(struct fsl_edma_engine *edma,
>void __iomem *addr)
>
> static void edma_writeb(struct fsl_edma_engine *edma, u8 val, void
>__iomem *addr)  {
>-	iowrite8(val, addr);
>+	/* swap the reg offset for these in big-endian mode */
>+	if (edma->big_endian)
>+		iowrite8(val, (void __iomem *)((unsigned long)addr ^ 0x3));
>+	else
>+		iowrite8(val, addr);
> }
>
> static void edma_writew(struct fsl_edma_engine *edma, u16 val, void
>__iomem *addr)  {
>+	/* swap the reg offset for these in big-endian mode */
> 	if (edma->big_endian)
>-		iowrite16be(val, addr);
>+		iowrite16be(val, (void __iomem *)((unsigned long)addr ^ 0x2));
> 	else
> 		iowrite16(val, addr);
> }
>@@ -254,13 +253,12 @@ static void fsl_edma_chan_mux(struct fsl_edma_chan
>*fsl_chan,
> 	chans_per_mux = fsl_chan->edma->n_chans / DMAMUX_NR;
> 	ch_off = fsl_chan->vchan.chan.chan_id % chans_per_mux;
> 	muxaddr = fsl_chan->edma->muxbase[ch / chans_per_mux];
>+	slot = EDMAMUX_CHCFG_SOURCE(slot);
>
> 	if (enable)
>-		edma_writeb(fsl_chan->edma,
>-				EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(slot),
>-				muxaddr + ch_off);
>+		iowrite8(EDMAMUX_CHCFG_ENBL | slot, muxaddr + ch_off);
> 	else
>-		edma_writeb(fsl_chan->edma, EDMAMUX_CHCFG_DIS, muxaddr +
>ch_off);
>+		iowrite8(EDMAMUX_CHCFG_DIS, muxaddr + ch_off);
> }
>
> static unsigned int fsl_edma_get_tcd_attr(enum dma_slave_buswidth
>addr_width) @@ -286,9 +284,8 @@ static void fsl_edma_free_desc(struct
>virt_dma_desc *vdesc)
>
> 	fsl_desc = to_fsl_edma_desc(vdesc);
> 	for (i = 0; i < fsl_desc->n_tcds; i++)
>-			dma_pool_free(fsl_desc->echan->tcd_pool,
>-					fsl_desc->tcd[i].vtcd,
>-					fsl_desc->tcd[i].ptcd);
>+		dma_pool_free(fsl_desc->echan->tcd_pool, fsl_desc->tcd[i].vtcd,
>+			      fsl_desc->tcd[i].ptcd);
> 	kfree(fsl_desc);
> }
>
>@@ -363,8 +360,8 @@ static size_t fsl_edma_desc_residue(struct
>fsl_edma_chan *fsl_chan,
>
> 	/* calculate the total size in this desc */
> 	for (len = i = 0; i < fsl_chan->edesc->n_tcds; i++)
>-		len += edma_readl(fsl_chan->edma, &(edesc->tcd[i].vtcd-
>>nbytes))
>-			* edma_readw(fsl_chan->edma, &(edesc->tcd[i].vtcd-
>>biter));
>+		len += le32_to_cpu(edesc->tcd[i].vtcd->nbytes)
>+			* le16_to_cpu(edesc->tcd[i].vtcd->biter);
>
> 	if (!in_progress)
> 		return len;
>@@ -376,14 +373,12 @@ static size_t fsl_edma_desc_residue(struct
>fsl_edma_chan *fsl_chan,
>
> 	/* figure out the finished and calculate the residue */
> 	for (i = 0; i < fsl_chan->edesc->n_tcds; i++) {
>-		size = edma_readl(fsl_chan->edma, &(edesc->tcd[i].vtcd-
>>nbytes))
>-			* edma_readw(fsl_chan->edma, &(edesc->tcd[i].vtcd-
>>biter));
>+		size = le32_to_cpu(edesc->tcd[i].vtcd->nbytes)
>+			* le16_to_cpu(edesc->tcd[i].vtcd->biter);
> 		if (dir == DMA_MEM_TO_DEV)
>-			dma_addr = edma_readl(fsl_chan->edma,
>-					&(edesc->tcd[i].vtcd->saddr));
>+			dma_addr = le32_to_cpu(edesc->tcd[i].vtcd->saddr);
> 		else
>-			dma_addr = edma_readl(fsl_chan->edma,
>-					&(edesc->tcd[i].vtcd->daddr));
>+			dma_addr = le32_to_cpu(edesc->tcd[i].vtcd->daddr);
>
> 		len -= size;
> 		if (cur_addr > dma_addr && cur_addr < dma_addr + size) { @@ -
>424,55 +419,67 @@ static enum dma_status fsl_edma_tx_status(struct
>dma_chan *chan,
> 	return fsl_chan->status;
> }
>
>-static void fsl_edma_set_tcd_params(struct fsl_edma_chan *fsl_chan,
>-		u32 src, u32 dst, u16 attr, u16 soff, u32 nbytes,
>-		u32 slast, u16 citer, u16 biter, u32 doff, u32 dlast_sga,
>-		u16 csr)
>+static void fsl_edma_set_tcd_regs(struct fsl_edma_chan *fsl_chan,
>+				  struct fsl_edma_hw_tcd *tcd)
> {
>+	struct fsl_edma_engine *edma = fsl_chan->edma;
> 	void __iomem *addr = fsl_chan->edma->membase;
> 	u32 ch = fsl_chan->vchan.chan.chan_id;
>
> 	/*
>-	 * TCD parameters have been swapped in fill_tcd_params(),
>-	 * so just write them to registers in the cpu endian here
>+	 * TCD parameters are stored in struct fsl_edma_hw_tcd in little
>+	 * endian format. However, we need to load the TCD registers in
>+	 * big- or little-endian obeying the eDMA engine model endian.
> 	 */
>-	writew(0, addr + EDMA_TCD_CSR(ch));
>-	writel(src, addr + EDMA_TCD_SADDR(ch));
>-	writel(dst, addr + EDMA_TCD_DADDR(ch));
>-	writew(attr, addr + EDMA_TCD_ATTR(ch));
>-	writew(soff, addr + EDMA_TCD_SOFF(ch));
>-	writel(nbytes, addr + EDMA_TCD_NBYTES(ch));
>-	writel(slast, addr + EDMA_TCD_SLAST(ch));
>-	writew(citer, addr + EDMA_TCD_CITER(ch));
>-	writew(biter, addr + EDMA_TCD_BITER(ch));
>-	writew(doff, addr + EDMA_TCD_DOFF(ch));
>-	writel(dlast_sga, addr + EDMA_TCD_DLAST_SGA(ch));
>-	writew(csr, addr + EDMA_TCD_CSR(ch));
>-}
>-
>-static void fill_tcd_params(struct fsl_edma_engine *edma,
>-		struct fsl_edma_hw_tcd *tcd, u32 src, u32 dst,
>-		u16 attr, u16 soff, u32 nbytes, u32 slast, u16 citer,
>-		u16 biter, u16 doff, u32 dlast_sga, bool major_int,
>-		bool disable_req, bool enable_sg)
>+	edma_writew(edma, 0, addr + EDMA_TCD_CSR(ch));
>+	edma_writel(edma, le32_to_cpu(tcd->saddr), addr +
>EDMA_TCD_SADDR(ch));
>+	edma_writel(edma, le32_to_cpu(tcd->daddr), addr +
>EDMA_TCD_DADDR(ch));
>+
>+	edma_writew(edma, le16_to_cpu(tcd->attr), addr + EDMA_TCD_ATTR(ch));
>+	edma_writew(edma, le16_to_cpu(tcd->soff), addr + EDMA_TCD_SOFF(ch));
>+
>+	edma_writel(edma, le32_to_cpu(tcd->nbytes), addr +
>EDMA_TCD_NBYTES(ch));
>+	edma_writel(edma, le32_to_cpu(tcd->slast), addr +
>EDMA_TCD_SLAST(ch));
>+
>+	edma_writew(edma, le16_to_cpu(tcd->citer), addr +
>EDMA_TCD_CITER(ch));
>+	edma_writew(edma, le16_to_cpu(tcd->biter), addr +
>EDMA_TCD_BITER(ch));
>+	edma_writew(edma, le16_to_cpu(tcd->doff), addr + EDMA_TCD_DOFF(ch));
>+
>+	edma_writel(edma, le32_to_cpu(tcd->dlast_sga), addr +
>+EDMA_TCD_DLAST_SGA(ch));
>+
>+	edma_writew(edma, le16_to_cpu(tcd->csr), addr + EDMA_TCD_CSR(ch)); }
>+
>+static inline
>+void fsl_edma_fill_tcd(struct fsl_edma_hw_tcd *tcd, u32 src, u32 dst,
>+		       u16 attr, u16 soff, u32 nbytes, u32 slast, u16 citer,
>+		       u16 biter, u16 doff, u32 dlast_sga, bool major_int,
>+		       bool disable_req, bool enable_sg)
> {
> 	u16 csr = 0;
>
> 	/*
>-	 * eDMA hardware SGs require the TCD parameters stored in memory
>-	 * the same endian as the eDMA module so that they can be loaded
>-	 * automatically by the engine
>+	 * eDMA hardware SGs require the TCDs to be stored in little
>+	 * endian format irrespective of the register endian model.
>+	 * So we put the value in little endian in memory, waiting
>+	 * for fsl_edma_set_tcd_regs doing the swap.
> 	 */
>-	edma_writel(edma, src, &(tcd->saddr));
>-	edma_writel(edma, dst, &(tcd->daddr));
>-	edma_writew(edma, attr, &(tcd->attr));
>-	edma_writew(edma, EDMA_TCD_SOFF_SOFF(soff), &(tcd->soff));
>-	edma_writel(edma, EDMA_TCD_NBYTES_NBYTES(nbytes), &(tcd->nbytes));
>-	edma_writel(edma, EDMA_TCD_SLAST_SLAST(slast), &(tcd->slast));
>-	edma_writew(edma, EDMA_TCD_CITER_CITER(citer), &(tcd->citer));
>-	edma_writew(edma, EDMA_TCD_DOFF_DOFF(doff), &(tcd->doff));
>-	edma_writel(edma, EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga), &(tcd-
>>dlast_sga));
>-	edma_writew(edma, EDMA_TCD_BITER_BITER(biter), &(tcd->biter));
>+	tcd->saddr = cpu_to_le32(src);
>+	tcd->daddr = cpu_to_le32(dst);
>+
>+	tcd->attr = cpu_to_le16(attr);
>+
>+	tcd->soff = cpu_to_le16(EDMA_TCD_SOFF_SOFF(soff));
>+
>+	tcd->nbytes = cpu_to_le32(EDMA_TCD_NBYTES_NBYTES(nbytes));
>+	tcd->slast = cpu_to_le32(EDMA_TCD_SLAST_SLAST(slast));
>+
>+	tcd->citer = cpu_to_le16(EDMA_TCD_CITER_CITER(citer));
>+	tcd->doff = cpu_to_le16(EDMA_TCD_DOFF_DOFF(doff));
>+
>+	tcd->dlast_sga =
>cpu_to_le32(EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga));
>+
>+	tcd->biter = cpu_to_le16(EDMA_TCD_BITER_BITER(biter));
> 	if (major_int)
> 		csr |= EDMA_TCD_CSR_INT_MAJOR;
>
>@@ -482,7 +489,7 @@ static void fill_tcd_params(struct fsl_edma_engine
>*edma,
> 	if (enable_sg)
> 		csr |= EDMA_TCD_CSR_E_SG;
>
>-	edma_writew(edma, csr, &(tcd->csr));
>+	tcd->csr = cpu_to_le16(csr);
> }
>
> static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan
>*fsl_chan, @@ -558,9 +565,9 @@ static struct dma_async_tx_descriptor
>*fsl_edma_prep_dma_cyclic(
> 			doff = fsl_chan->fsc.addr_width;
> 		}
>
>-		fill_tcd_params(fsl_chan->edma, fsl_desc->tcd[i].vtcd,
>src_addr,
>-				dst_addr, fsl_chan->fsc.attr, soff, nbytes, 0,
>-				iter, iter, doff, last_sg, true, false, true);
>+		fsl_edma_fill_tcd(fsl_desc->tcd[i].vtcd, src_addr, dst_addr,
>+				  fsl_chan->fsc.attr, soff, nbytes, 0, iter,
>+				  iter, doff, last_sg, true, false, true);
> 		dma_buf_next += period_len;
> 	}
>
>@@ -607,16 +614,16 @@ static struct dma_async_tx_descriptor
>*fsl_edma_prep_slave_sg(
> 		iter = sg_dma_len(sg) / nbytes;
> 		if (i < sg_len - 1) {
> 			last_sg = fsl_desc->tcd[(i + 1)].ptcd;
>-			fill_tcd_params(fsl_chan->edma, fsl_desc->tcd[i].vtcd,
>-					src_addr, dst_addr, fsl_chan->fsc.attr,
>-					soff, nbytes, 0, iter, iter, doff, last_sg,
>-					false, false, true);
>+			fsl_edma_fill_tcd(fsl_desc->tcd[i].vtcd, src_addr,
>+					  dst_addr, fsl_chan->fsc.attr, soff,
>+					  nbytes, 0, iter, iter, doff, last_sg,
>+					  false, false, true);
> 		} else {
> 			last_sg = 0;
>-			fill_tcd_params(fsl_chan->edma, fsl_desc->tcd[i].vtcd,
>-					src_addr, dst_addr, fsl_chan->fsc.attr,
>-					soff, nbytes, 0, iter, iter, doff, last_sg,
>-					true, true, false);
>+			fsl_edma_fill_tcd(fsl_desc->tcd[i].vtcd, src_addr,
>+					  dst_addr, fsl_chan->fsc.attr, soff,
>+					  nbytes, 0, iter, iter, doff, last_sg,
>+					  true, true, false);
> 		}
> 	}
>
>@@ -625,17 +632,13 @@ static struct dma_async_tx_descriptor
>*fsl_edma_prep_slave_sg(
>
> static void fsl_edma_xfer_desc(struct fsl_edma_chan *fsl_chan)  {
>-	struct fsl_edma_hw_tcd *tcd;
> 	struct virt_dma_desc *vdesc;
>
> 	vdesc = vchan_next_desc(&fsl_chan->vchan);
> 	if (!vdesc)
> 		return;
> 	fsl_chan->edesc = to_fsl_edma_desc(vdesc);
>-	tcd = fsl_chan->edesc->tcd[0].vtcd;
>-	fsl_edma_set_tcd_params(fsl_chan, tcd->saddr, tcd->daddr, tcd->attr,
>-			tcd->soff, tcd->nbytes, tcd->slast, tcd->citer,
>-			tcd->biter, tcd->doff, tcd->dlast_sga, tcd->csr);
>+	fsl_edma_set_tcd_regs(fsl_chan, fsl_chan->edesc->tcd[0].vtcd);
> 	fsl_edma_enable_request(fsl_chan);
> 	fsl_chan->status = DMA_IN_PROGRESS;
> }
>--
>1.8.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
