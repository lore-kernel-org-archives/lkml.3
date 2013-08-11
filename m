Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3HKSDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:03:52 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43832 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3HKR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:55 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 05/18] dmaengine: PL08x: Add support for PL080S variant
Date: Sun, 11 Aug 2013 19:59:17 +0200
Message-Id: <1376243970-6489-6-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL080S is a modified version of PL080 that can be found on Samsung SoCs,
such as S3C6400 and S3C6410.

It has different offset of CONFIG register, separate CONTROL1 register
that holds transfer size and larger maximum transfer size.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c   | 145 ++++++++++++++++++++++++++++++++++++---------
 include/linux/amba/pl080.h |   1 +
 2 files changed, 119 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 1fa05d6..75915be 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -24,6 +24,7 @@
  *
  * Documentation: ARM DDI 0196G == PL080
  * Documentation: ARM DDI 0218E == PL081
+ * Documentation: S3C6410 User's Manual == PL080S
  *
  * PL080 & PL081 both have 16 sets of DMA signals that can be routed to any
  * channel.
@@ -36,6 +37,14 @@
  *
  * The PL080 has a dual bus master, PL081 has a single master.
  *
+ * PL080S is a version modified by Samsung and used in S3C64xx SoCs.
+ * It differs in following aspects:
+ * - CH_CONFIG register at different offset,
+ * - separate CH_CONTROL2 register for transfer size,
+ * - bigger maximum transfer size,
+ * - 8-word aligned LLI, instead of 4-word, due to extra CCTL2 word,
+ * - no support for peripheral flow control.
+ *
  * Memory to peripheral transfer may be visualized as
  *	Get data from memory to DMAC
  *	Until no data left
@@ -64,10 +73,7 @@
  *  - Peripheral flow control: the transfer size is ignored (and should be
  *    zero).  The data is transferred from the current LLI entry, until
  *    after the final transfer signalled by LBREQ or LSREQ.  The DMAC
- *    will then move to the next LLI entry.
- *
- * Global TODO:
- * - Break out common code from arch/arm/mach-s3c64xx and share
+ *    will then move to the next LLI entry. Unsupported by PL080S.
  */
 #include <linux/amba/bus.h>
 #include <linux/amba/pl08x.h>
@@ -100,12 +106,15 @@ struct pl08x_driver_data;
  * @nomadik: whether the channels have Nomadik security extension bits
  *	that need to be checked for permission before use and some registers are
  *	missing
+ * @pl080s: whether this version is a PL080S, which has separate register and
+ *	LLI word for transfer size.
  */
 struct vendor_data {
 	u8 config_offset;
 	u8 channels;
 	bool dualmaster;
 	bool nomadik;
+	bool pl080s;
 };
 
 /**
@@ -264,9 +273,11 @@ struct pl08x_driver_data {
 #define PL080_LLI_DST		1
 #define PL080_LLI_LLI		2
 #define PL080_LLI_CCTL		3
+#define PL080S_LLI_CCTL2	4
 
 /* Total words in an LLI. */
 #define PL080_LLI_WORDS		4
+#define PL080S_LLI_WORDS	8
 
 /*
  * Number of LLIs in each LLI buffer allocated for one transfer
@@ -340,17 +351,29 @@ static int pl08x_phy_channel_busy(struct pl08x_phy_chan *ch)
 static void pl08x_write_lli(struct pl08x_driver_data *pl08x,
 		struct pl08x_phy_chan *phychan, const u32 *lli, u32 ccfg)
 {
-	dev_vdbg(&pl08x->adev->dev,
-		"WRITE channel %d: csrc=0x%08x, cdst=0x%08x, "
-		"clli=0x%08x, cctl=0x%08x, ccfg=0x%08x\n",
-		phychan->id, lli[PL080_LLI_SRC], lli[PL080_LLI_DST],
-		lli[PL080_LLI_LLI], lli[PL080_LLI_CCTL], ccfg);
+	if (pl08x->vd->pl080s)
+		dev_vdbg(&pl08x->adev->dev,
+			"WRITE channel %d: csrc=0x%08x, cdst=0x%08x, "
+			"clli=0x%08x, cctl=0x%08x, cctl2=0x%08x, ccfg=0x%08x\n",
+			phychan->id, lli[PL080_LLI_SRC], lli[PL080_LLI_DST],
+			lli[PL080_LLI_LLI], lli[PL080_LLI_CCTL],
+			lli[PL080S_LLI_CCTL2], ccfg);
+	else
+		dev_vdbg(&pl08x->adev->dev,
+			"WRITE channel %d: csrc=0x%08x, cdst=0x%08x, "
+			"clli=0x%08x, cctl=0x%08x, ccfg=0x%08x\n",
+			phychan->id, lli[PL080_LLI_SRC], lli[PL080_LLI_DST],
+			lli[PL080_LLI_LLI], lli[PL080_LLI_CCTL], ccfg);
 
 	writel_relaxed(lli[PL080_LLI_SRC], phychan->base + PL080_CH_SRC_ADDR);
 	writel_relaxed(lli[PL080_LLI_DST], phychan->base + PL080_CH_DST_ADDR);
 	writel_relaxed(lli[PL080_LLI_LLI], phychan->base + PL080_CH_LLI);
 	writel_relaxed(lli[PL080_LLI_CCTL], phychan->base + PL080_CH_CONTROL);
 
+	if (pl08x->vd->pl080s)
+		writel_relaxed(lli[PL080S_LLI_CCTL2],
+				phychan->base + PL080S_CH_CONTROL2);
+
 	writel(ccfg, phychan->reg_config);
 }
 
@@ -469,6 +492,24 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 	return bytes;
 }
 
+static inline u32 get_bytes_in_cctl_pl080s(u32 cctl, u32 cctl1)
+{
+	/* The source width defines the number of bytes */
+	u32 bytes = cctl1 & PL080S_CONTROL_TRANSFER_SIZE_MASK;
+
+	switch (cctl >> PL080_CONTROL_SWIDTH_SHIFT) {
+	case PL080_WIDTH_8BIT:
+		break;
+	case PL080_WIDTH_16BIT:
+		bytes *= 2;
+		break;
+	case PL080_WIDTH_32BIT:
+		bytes *= 4;
+		break;
+	}
+	return bytes;
+}
+
 /* The channel should be paused when calling this */
 static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 {
@@ -494,7 +535,12 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 	clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
 
 	/* First get the remaining bytes in the active transfer */
-	bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
+	if (pl08x->vd->pl080s)
+		bytes = get_bytes_in_cctl_pl080s(
+				readl(ch->base + PL080_CH_CONTROL),
+				readl(ch->base + PL080S_CH_CONTROL2));
+	else
+		bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
 
 	if (!clli)
 		return bytes;
@@ -515,7 +561,12 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 	llis_va_limit = llis_va + llis_max_words;
 
 	for (; llis_va < llis_va_limit; llis_va += pl08x->lli_words) {
-		bytes += get_bytes_in_cctl(llis_va[PL080_LLI_CCTL]);
+		if (pl08x->vd->pl080s)
+			bytes += get_bytes_in_cctl_pl080s(
+						llis_va[PL080_LLI_CCTL],
+						llis_va[PL080S_LLI_CCTL2]);
+		else
+			bytes += get_bytes_in_cctl(llis_va[PL080_LLI_CCTL]);
 
 		/*
 		 * A LLI pointer of 0 terminates the LLI list
@@ -778,7 +829,7 @@ static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
  */
 static void pl08x_fill_lli_for_desc(struct pl08x_driver_data *pl08x,
 				    struct pl08x_lli_build_data *bd,
-				    int num_llis, int len, u32 cctl)
+				    int num_llis, int len, u32 cctl, u32 cctl2)
 {
 	u32 offset = num_llis * pl08x->lli_words;
 	u32 *llis_va = bd->txd->llis_va + offset;
@@ -794,6 +845,8 @@ static void pl08x_fill_lli_for_desc(struct pl08x_driver_data *pl08x,
 	llis_va[PL080_LLI_LLI] = (llis_bus + sizeof(u32) * offset);
 	llis_va[PL080_LLI_LLI] |= bd->lli_bus;
 	llis_va[PL080_LLI_CCTL] = cctl;
+	if (pl08x->vd->pl080s)
+		llis_va[PL080S_LLI_CCTL2] = cctl2;
 
 	if (cctl & PL080_CONTROL_SRC_INCR)
 		bd->srcbus.addr += len;
@@ -810,7 +863,7 @@ static inline void prep_byte_width_lli(struct pl08x_driver_data *pl08x,
 			int num_llis, size_t *total_bytes)
 {
 	*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
-	pl08x_fill_lli_for_desc(pl08x, bd, num_llis, len, *cctl);
+	pl08x_fill_lli_for_desc(pl08x, bd, num_llis, len, *cctl, len);
 	(*total_bytes) += len;
 }
 
@@ -820,16 +873,31 @@ static void pl08x_dump_lli(struct pl08x_driver_data *pl08x,
 {
 	int i;
 
-	dev_vdbg(&pl08x->adev->dev,
-		"%-3s %-9s  %-10s %-10s %-10s %s\n",
-		"lli", "", "csrc", "cdst", "clli", "cctl");
-	for (i = 0; i < num_llis; i++) {
+	if (pl08x->vd->pl080s) {
 		dev_vdbg(&pl08x->adev->dev,
-			"%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x\n",
-			i, llis_va, llis_va[PL080_LLI_SRC],
-			llis_va[PL080_LLI_DST], llis_va[PL080_LLI_LLI],
-			llis_va[PL080_LLI_CCTL]);
-		llis_va += pl08x->lli_words;
+			"%-3s %-9s  %-10s %-10s %-10s %-10s %s\n",
+			"lli", "", "csrc", "cdst", "clli", "cctl", "cctl2");
+		for (i = 0; i < num_llis; i++) {
+			dev_vdbg(&pl08x->adev->dev,
+				"%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x 0x%08x\n",
+				i, llis_va, llis_va[PL080_LLI_SRC],
+				llis_va[PL080_LLI_DST], llis_va[PL080_LLI_LLI],
+				llis_va[PL080_LLI_CCTL],
+				llis_va[PL080S_LLI_CCTL2]);
+			llis_va += pl08x->lli_words;
+		}
+	} else {
+		dev_vdbg(&pl08x->adev->dev,
+			"%-3s %-9s  %-10s %-10s %-10s %s\n",
+			"lli", "", "csrc", "cdst", "clli", "cctl");
+		for (i = 0; i < num_llis; i++) {
+			dev_vdbg(&pl08x->adev->dev,
+				"%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x\n",
+				i, llis_va, llis_va[PL080_LLI_SRC],
+				llis_va[PL080_LLI_DST], llis_va[PL080_LLI_LLI],
+				llis_va[PL080_LLI_CCTL]);
+			llis_va += pl08x->lli_words;
+		}
 	}
 }
 #else
@@ -938,7 +1006,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, 0);
 			pl08x_fill_lli_for_desc(pl08x, &bd, num_llis++,
-					0, cctl);
+					0, cctl, 0);
 			break;
 		}
 
@@ -1018,7 +1086,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, tsize);
 				pl08x_fill_lli_for_desc(pl08x, &bd, num_llis++,
-						lli_len, cctl);
+						lli_len, cctl, tsize);
 				total_bytes += lli_len;
 			}
 
@@ -1332,6 +1400,7 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 				  struct dma_slave_config *config)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
 
 	if (!plchan->slave)
 		return -EINVAL;
@@ -1341,6 +1410,13 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 	    config->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
 		return -EINVAL;
 
+	if (config->device_fc && pl08x->vd->pl080s) {
+		dev_err(&pl08x->adev->dev,
+			"%s: PL080S does not support peripheral flow control\n",
+			__func__);
+		return -EINVAL;
+	}
+
 	plchan->cfg = *config;
 
 	return 0;
@@ -1930,7 +2006,10 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		pl08x->mem_buses = pl08x->pd->mem_buses;
 	}
 
-	pl08x->lli_words = PL080_LLI_WORDS;
+	if (vd->pl080s)
+		pl08x->lli_words = PL080S_LLI_WORDS;
+	else
+		pl08x->lli_words = PL080_LLI_WORDS;
 	tsfr_size = MAX_NUM_TSFR_LLIS * pl08x->lli_words * sizeof(u32);
 
 	/* A DMA memory pool for LLIs, align on 1-byte boundary */
@@ -2040,8 +2119,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	amba_set_drvdata(adev, pl08x);
 	init_pl08x_debugfs(pl08x);
-	dev_info(&pl08x->adev->dev, "DMA: PL%03x rev%u at 0x%08llx irq %d\n",
-		 amba_part(adev), amba_rev(adev),
+	dev_info(&pl08x->adev->dev, "DMA: PL%03x%s rev%u at 0x%08llx irq %d\n",
+		 amba_part(adev), pl08x->vd->pl080s ? "s" : "", amba_rev(adev),
 		 (unsigned long long)adev->res.start, adev->irq[0]);
 
 	return 0;
@@ -2082,6 +2161,12 @@ static struct vendor_data vendor_nomadik = {
 	.nomadik = true,
 };
 
+static struct vendor_data vendor_pl080s = {
+	.config_offset = PL080S_CH_CONFIG,
+	.channels = 8,
+	.pl080s = true,
+};
+
 static struct vendor_data vendor_pl081 = {
 	.config_offset = PL080_CH_CONFIG,
 	.channels = 2,
@@ -2089,6 +2174,12 @@ static struct vendor_data vendor_pl081 = {
 };
 
 static struct amba_id pl08x_ids[] = {
+	/* Samsung PL080S variant */
+	{
+		.id	= 0x0a141080,
+		.mask	= 0xffffffff,
+		.data	= &vendor_pl080s,
+	},
 	/* PL080 */
 	{
 		.id	= 0x00041080,
diff --git a/include/linux/amba/pl080.h b/include/linux/amba/pl080.h
index 3e7b62f..91b84a7 100644
--- a/include/linux/amba/pl080.h
+++ b/include/linux/amba/pl080.h
@@ -87,6 +87,7 @@
 #define PL080_CONTROL_SB_SIZE_MASK		(0x7 << 12)
 #define PL080_CONTROL_SB_SIZE_SHIFT		(12)
 #define PL080_CONTROL_TRANSFER_SIZE_MASK	(0xfff << 0)
+#define PL080S_CONTROL_TRANSFER_SIZE_MASK	(0x1ffffff << 0)
 #define PL080_CONTROL_TRANSFER_SIZE_SHIFT	(0)
 
 #define PL080_BSIZE_1				(0x0)
-- 
1.8.3.2

