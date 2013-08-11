Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3HKR75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:59:57 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39602 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3HKR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:51 -0400
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
Subject: [PATCH 03/18] dmaengine: PL08x: Rework LLI handling to be less fragile
Date: Sun, 11 Aug 2013 19:59:15 +0200
Message-Id: <1376243970-6489-4-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently memory allocated for LLIs is casted to an array of structs,
which is fragile and also limits the driver to a single, predefined LLI
layout, while there are some variants of PL08x, which have more fields
in LLI (namely PL080S with its extra CCTL2).

This patch makes LLIs a sequence of 32-bit words, which is just filled
with appropriate values in appropriate order and padded with required
amount of dummy words (currently zero, but PL080S will make better use
of this).

Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 147 ++++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 65 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 2538e05..d3399c2 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -108,19 +108,6 @@ struct vendor_data {
 	bool nomadik;
 };
 
-/*
- * PL08X private data structures
- * An LLI struct - see PL08x TRM.  Note that next uses bit[0] as a bus bit,
- * start & end do not - their bus bit info is in cctl.  Also note that these
- * are fixed 32-bit quantities.
- */
-struct pl08x_lli {
-	u32 src;
-	u32 dst;
-	u32 lli;
-	u32 cctl;
-};
-
 /**
  * struct pl08x_bus_data - information of source or destination
  * busses for a transfer
@@ -181,7 +168,7 @@ struct pl08x_txd {
 	struct virt_dma_desc vd;
 	struct list_head dsg_list;
 	dma_addr_t llis_bus;
-	struct pl08x_lli *llis_va;
+	u32 *llis_va;
 	/* Default cctl value for LLIs */
 	u32 cctl;
 	/*
@@ -265,17 +252,27 @@ struct pl08x_driver_data {
 	struct dma_pool *pool;
 	u8 lli_buses;
 	u8 mem_buses;
+	u8 lli_words;
 };
 
 /*
  * PL08X specific defines
  */
 
-/* Size (bytes) of each LLI buffer allocated for one transfer */
-# define PL08X_LLI_TSFR_SIZE	0x2000
+/* The order of words in an LLI. */
+#define PL080_LLI_SRC		0
+#define PL080_LLI_DST		1
+#define PL080_LLI_LLI		2
+#define PL080_LLI_CCTL		3
+
+/* Total words in an LLI. */
+#define PL080_LLI_WORDS		4
 
-/* Maximum times we call dma_pool_alloc on this pool without freeing */
-#define MAX_NUM_TSFR_LLIS	(PL08X_LLI_TSFR_SIZE/sizeof(struct pl08x_lli))
+/*
+ * Number of LLIs in each LLI buffer allocated for one transfer
+ * (maximum times we call dma_pool_alloc on this pool without freeing)
+ */
+#define MAX_NUM_TSFR_LLIS	512
 #define PL08X_ALIGN		8
 
 static inline struct pl08x_dma_chan *to_pl08x_chan(struct dma_chan *chan)
@@ -340,6 +337,23 @@ static int pl08x_phy_channel_busy(struct pl08x_phy_chan *ch)
 	return val & PL080_CONFIG_ACTIVE;
 }
 
+static void pl08x_write_lli(struct pl08x_driver_data *pl08x,
+		struct pl08x_phy_chan *phychan, const u32 *lli, u32 ccfg)
+{
+	dev_vdbg(&pl08x->adev->dev,
+		"WRITE channel %d: csrc=0x%08x, cdst=0x%08x, "
+		"clli=0x%08x, cctl=0x%08x, ccfg=0x%08x\n",
+		phychan->id, lli[PL080_LLI_SRC], lli[PL080_LLI_DST],
+		lli[PL080_LLI_LLI], lli[PL080_LLI_CCTL], ccfg);
+
+	writel_relaxed(lli[PL080_LLI_SRC], phychan->base + PL080_CH_SRC_ADDR);
+	writel_relaxed(lli[PL080_LLI_DST], phychan->base + PL080_CH_DST_ADDR);
+	writel_relaxed(lli[PL080_LLI_LLI], phychan->base + PL080_CH_LLI);
+	writel_relaxed(lli[PL080_LLI_CCTL], phychan->base + PL080_CH_CONTROL);
+
+	writel(ccfg, phychan->reg_config);
+}
+
 /*
  * Set the initial DMA register values i.e. those for the first LLI
  * The next LLI pointer and the configuration interrupt bit have
@@ -352,7 +366,6 @@ static void pl08x_start_next_txd(struct pl08x_dma_chan *plchan)
 	struct pl08x_phy_chan *phychan = plchan->phychan;
 	struct virt_dma_desc *vd = vchan_next_desc(&plchan->vc);
 	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
-	struct pl08x_lli *lli;
 	u32 val;
 
 	list_del(&txd->vd.node);
@@ -363,19 +376,7 @@ static void pl08x_start_next_txd(struct pl08x_dma_chan *plchan)
 	while (pl08x_phy_channel_busy(phychan))
 		cpu_relax();
 
-	lli = &txd->llis_va[0];
-
-	dev_vdbg(&pl08x->adev->dev,
-		"WRITE channel %d: csrc=0x%08x, cdst=0x%08x, "
-		"clli=0x%08x, cctl=0x%08x, ccfg=0x%08x\n",
-		phychan->id, lli->src, lli->dst, lli->lli, lli->cctl,
-		txd->ccfg);
-
-	writel(lli->src, phychan->base + PL080_CH_SRC_ADDR);
-	writel(lli->dst, phychan->base + PL080_CH_DST_ADDR);
-	writel(lli->lli, phychan->base + PL080_CH_LLI);
-	writel(lli->cctl, phychan->base + PL080_CH_CONTROL);
-	writel(txd->ccfg, phychan->reg_config);
+	pl08x_write_lli(pl08x, phychan, &txd->llis_va[0], txd->ccfg);
 
 	/* Enable the DMA channel */
 	/* Do not access config register until channel shows as disabled */
@@ -471,12 +472,13 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 /* The channel should be paused when calling this */
 static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 {
-	struct pl08x_lli *llis_va;
+	struct pl08x_driver_data *pl08x = plchan->host;
+	const u32 *llis_va, *llis_va_limit;
 	struct pl08x_phy_chan *ch;
 	dma_addr_t llis_bus;
 	struct pl08x_txd *txd;
+	u32 llis_max_words;
 	size_t bytes;
-	int index;
 	u32 clli;
 
 	ch = plchan->phychan;
@@ -500,22 +502,25 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 	llis_va = txd->llis_va;
 	llis_bus = txd->llis_bus;
 
+	llis_max_words = pl08x->lli_words * MAX_NUM_TSFR_LLIS;
 	BUG_ON(clli < llis_bus || clli >= llis_bus +
-				sizeof(struct pl08x_lli) * MAX_NUM_TSFR_LLIS);
+						sizeof(u32) * llis_max_words);
 
 	/*
 	 * Locate the next LLI - as this is an array,
 	 * it's simple maths to find.
 	 */
-	index = (clli - llis_bus) / sizeof(struct pl08x_lli);
+	llis_va += (clli - llis_bus) / sizeof(u32);
 
-	for (; index < MAX_NUM_TSFR_LLIS; index++) {
-		bytes += get_bytes_in_cctl(llis_va[index].cctl);
+	llis_va_limit = llis_va + llis_max_words;
+
+	for (; llis_va < llis_va_limit; llis_va += pl08x->lli_words) {
+		bytes += get_bytes_in_cctl(llis_va[PL080_LLI_CCTL]);
 
 		/*
 		 * A LLI pointer of 0 terminates the LLI list
 		 */
-		if (!llis_va[index].lli)
+		if (!llis_va[PL080_LLI_LLI])
 			break;
 	}
 
@@ -771,20 +776,24 @@ static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
 /*
  * Fills in one LLI for a certain transfer descriptor and advance the counter
  */
-static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
-	int num_llis, int len, u32 cctl)
+static void pl08x_fill_lli_for_desc(struct pl08x_driver_data *pl08x,
+				    struct pl08x_lli_build_data *bd,
+				    int num_llis, int len, u32 cctl)
 {
-	struct pl08x_lli *llis_va = bd->txd->llis_va;
+	u32 offset = num_llis * pl08x->lli_words;
+	u32 *llis_va = bd->txd->llis_va + offset;
 	dma_addr_t llis_bus = bd->txd->llis_bus;
 
 	BUG_ON(num_llis >= MAX_NUM_TSFR_LLIS);
 
-	llis_va[num_llis].cctl = cctl;
-	llis_va[num_llis].src = bd->srcbus.addr;
-	llis_va[num_llis].dst = bd->dstbus.addr;
-	llis_va[num_llis].lli = llis_bus + (num_llis + 1) *
-		sizeof(struct pl08x_lli);
-	llis_va[num_llis].lli |= bd->lli_bus;
+	/* Advance the offset to next LLI. */
+	offset += pl08x->lli_words;
+
+	llis_va[PL080_LLI_SRC] = bd->srcbus.addr;
+	llis_va[PL080_LLI_DST] = bd->dstbus.addr;
+	llis_va[PL080_LLI_LLI] = (llis_bus + sizeof(u32) * offset);
+	llis_va[PL080_LLI_LLI] |= bd->lli_bus;
+	llis_va[PL080_LLI_CCTL] = cctl;
 
 	if (cctl & PL080_CONTROL_SRC_INCR)
 		bd->srcbus.addr += len;
@@ -796,11 +805,12 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 	bd->remainder -= len;
 }
 
-static inline void prep_byte_width_lli(struct pl08x_lli_build_data *bd,
-		u32 *cctl, u32 len, int num_llis, size_t *total_bytes)
+static inline void prep_byte_width_lli(struct pl08x_driver_data *pl08x,
+			struct pl08x_lli_build_data *bd, u32 *cctl, u32 len,
+			int num_llis, size_t *total_bytes)
 {
 	*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
-	pl08x_fill_lli_for_desc(bd, num_llis, len, *cctl);
+	pl08x_fill_lli_for_desc(pl08x, bd, num_llis, len, *cctl);
 	(*total_bytes) += len;
 }
 
@@ -817,7 +827,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	int num_llis = 0;
 	u32 cctl, early_bytes = 0;
 	size_t max_bytes_per_lli, total_bytes;
-	struct pl08x_lli *llis_va;
+	u32 *llis_va, *last_lli;
 	struct pl08x_sg *dsg;
 
 	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT, &txd->llis_bus);
@@ -904,7 +914,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, 0);
-			pl08x_fill_lli_for_desc(&bd, num_llis++, 0, cctl);
+			pl08x_fill_lli_for_desc(pl08x, &bd, num_llis++,
+					0, cctl);
 			break;
 		}
 
@@ -926,8 +937,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			dev_vdbg(&pl08x->adev->dev,
 				"%s byte width LLIs (remain 0x%08x)\n",
 				__func__, bd.remainder);
-			prep_byte_width_lli(&bd, &cctl, early_bytes, num_llis++,
-				&total_bytes);
+			prep_byte_width_lli(pl08x, &bd, &cctl, early_bytes,
+				num_llis++, &total_bytes);
 		}
 
 		if (bd.remainder) {
@@ -983,7 +994,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 				cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, tsize);
-				pl08x_fill_lli_for_desc(&bd, num_llis++,
+				pl08x_fill_lli_for_desc(pl08x, &bd, num_llis++,
 						lli_len, cctl);
 				total_bytes += lli_len;
 			}
@@ -995,8 +1006,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				dev_vdbg(&pl08x->adev->dev,
 					"%s align with boundary, send odd bytes (remain %zu)\n",
 					__func__, bd.remainder);
-				prep_byte_width_lli(&bd, &cctl, bd.remainder,
-						num_llis++, &total_bytes);
+				prep_byte_width_lli(pl08x, &bd, &cctl,
+					bd.remainder, num_llis++, &total_bytes);
 			}
 		}
 
@@ -1010,16 +1021,17 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		if (num_llis >= MAX_NUM_TSFR_LLIS) {
 			dev_err(&pl08x->adev->dev,
 				"%s need to increase MAX_NUM_TSFR_LLIS from 0x%08x\n",
-				__func__, (u32) MAX_NUM_TSFR_LLIS);
+				__func__, MAX_NUM_TSFR_LLIS);
 			return 0;
 		}
 	}
 
 	llis_va = txd->llis_va;
+	last_lli = llis_va + (num_llis - 1) * pl08x->lli_words;
 	/* The final LLI terminates the LLI. */
-	llis_va[num_llis - 1].lli = 0;
+	last_lli[PL080_LLI_LLI] = 0;
 	/* The final LLI element shall also fire an interrupt. */
-	llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
+	last_lli[PL080_LLI_CCTL] |= PL080_CONTROL_TC_IRQ_EN;
 
 #ifdef VERBOSE_DEBUG
 	{
@@ -1031,9 +1043,10 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		for (i = 0; i < num_llis; i++) {
 			dev_vdbg(&pl08x->adev->dev,
 				 "%3d @%p: 0x%08x 0x%08x 0x%08x 0x%08x\n",
-				 i, &llis_va[i], llis_va[i].src,
-				 llis_va[i].dst, llis_va[i].lli, llis_va[i].cctl
-				);
+				 i, llis_va, llis_va[PL080_LLI_SRC],
+				 llis_va[PL080_LLI_DST], llis_va[PL080_LLI_LLI],
+				 llis_va[PL080_LLI_CCTL]);
+			llis_va += pl08x->lli_words;
 		}
 	}
 #endif
@@ -1853,6 +1866,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	struct pl08x_driver_data *pl08x;
 	const struct vendor_data *vd = id->data;
+	u32 tsfr_size;
 	int ret = 0;
 	int i;
 
@@ -1909,9 +1923,12 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		pl08x->mem_buses = pl08x->pd->mem_buses;
 	}
 
+	pl08x->lli_words = PL080_LLI_WORDS;
+	tsfr_size = MAX_NUM_TSFR_LLIS * pl08x->lli_words * sizeof(u32);
+
 	/* A DMA memory pool for LLIs, align on 1-byte boundary */
 	pl08x->pool = dma_pool_create(DRIVER_NAME, &pl08x->adev->dev,
-			PL08X_LLI_TSFR_SIZE, PL08X_ALIGN, 0);
+						tsfr_size, PL08X_ALIGN, 0);
 	if (!pl08x->pool) {
 		ret = -ENOMEM;
 		goto out_no_lli_pool;
-- 
1.8.3.2

