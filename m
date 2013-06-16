Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3FPUyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:54:45 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43958 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3FPUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:54:40 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH 04/11] dma: amba-pl08x: Add support for PL080S variant
Date: Sun, 16 Jun 2013 22:54:11 +0200
Message-Id: <1371416058-22047-5-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL080S is a modified version of PL080 that can be found on Samsung SoCs,
such as S3C6400 and S3C6410.

It has different offset of CONFIG register, separate CONTROL1 register
that holds transfer size and larger maximum transfer size.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c   | 68 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/amba/pl080.h |  1 +
 2 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 93913b4..d1f1333 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -100,6 +100,8 @@ struct pl08x_driver_data;
  * for permission before use and some registers are missing.
  */
 #define PL08X_IS_NOMADIK	(1 << 1)
+/** Controller is PL080S (PL080 modified by Samsung) */
+#define PL08X_IS_PL080S		(1 << 2)
 
 /**
  * struct vendor_data - vendor-specific config parameters for PL08x derivatives
@@ -123,6 +125,7 @@ struct pl08x_lli {
 	u32 dst;
 	u32 lli;
 	u32 cctl;
+	u32 cctl1;
 };
 
 /**
@@ -381,6 +384,9 @@ static void pl08x_start_next_txd(struct pl08x_dma_chan *plchan)
 	writel(lli->cctl, phychan->base + PL080_CH_CONTROL);
 	writel(txd->ccfg, phychan->base + pl08x->vd->config_offset);
 
+	if (pl08x->vd->flags & PL08X_IS_PL080S)
+		writel(lli->cctl1, phychan->base + PL080S_CH_CONTROL2);
+
 	/* Enable the DMA channel */
 	/* Do not access config register until channel shows as disabled */
 	while (readl(pl08x->base + PL080_EN_CHAN) & (1 << phychan->id))
@@ -476,9 +482,28 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
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
+	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_lli *llis_va;
 	struct pl08x_phy_chan *ch;
 	dma_addr_t llis_bus;
@@ -500,7 +525,12 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 	clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
 
 	/* First get the remaining bytes in the active transfer */
-	bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
+	if (pl08x->vd->flags & PL08X_IS_PL080S)
+		bytes = get_bytes_in_cctl_pl080s(
+				readl(ch->base + PL080_CH_CONTROL),
+				readl(ch->base + PL080S_CH_CONTROL2));
+	else
+		bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
 
 	if (!clli)
 		return bytes;
@@ -518,7 +548,11 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 	index = (clli - llis_bus) / sizeof(struct pl08x_lli);
 
 	for (; index < MAX_NUM_TSFR_LLIS; index++) {
-		bytes += get_bytes_in_cctl(llis_va[index].cctl);
+		if (pl08x->vd->flags & PL08X_IS_PL080S)
+			bytes += get_bytes_in_cctl_pl080s(llis_va[index].cctl,
+						llis_va[index].cctl1);
+		else
+			bytes += get_bytes_in_cctl(llis_va[index].cctl);
 
 		/*
 		 * A LLI pointer of 0 terminates the LLI list
@@ -780,7 +814,7 @@ static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
  * Fills in one LLI for a certain transfer descriptor and advance the counter
  */
 static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
-	int num_llis, int len, u32 cctl)
+	int num_llis, int len, u32 cctl, u32 cctl1)
 {
 	struct pl08x_lli *llis_va = bd->txd->llis_va;
 	dma_addr_t llis_bus = bd->txd->llis_bus;
@@ -788,6 +822,7 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 	BUG_ON(num_llis >= MAX_NUM_TSFR_LLIS);
 
 	llis_va[num_llis].cctl = cctl;
+	llis_va[num_llis].cctl1 = cctl1;
 	llis_va[num_llis].src = bd->srcbus.addr;
 	llis_va[num_llis].dst = bd->dstbus.addr;
 	llis_va[num_llis].lli = llis_bus + (num_llis + 1) *
@@ -804,11 +839,12 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 	bd->remainder -= len;
 }
 
-static inline void prep_byte_width_lli(struct pl08x_lli_build_data *bd,
+static inline void prep_byte_width_lli(struct pl08x_driver_data *pl08x,
+		struct pl08x_lli_build_data *bd,
 		u32 *cctl, u32 len, int num_llis, size_t *total_bytes)
 {
 	*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
-	pl08x_fill_lli_for_desc(bd, num_llis, len, *cctl);
+	pl08x_fill_lli_for_desc(bd, num_llis, len, *cctl, len);
 	(*total_bytes) += len;
 }
 
@@ -912,7 +948,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, 0);
-			pl08x_fill_lli_for_desc(&bd, num_llis++, 0, cctl);
+			pl08x_fill_lli_for_desc(&bd, num_llis++, 0, cctl, 0);
 			break;
 		}
 
@@ -934,7 +970,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			dev_vdbg(&pl08x->adev->dev,
 				"%s byte width LLIs (remain 0x%08x)\n",
 				__func__, bd.remainder);
-			prep_byte_width_lli(&bd, &cctl, early_bytes, num_llis++,
+			prep_byte_width_lli(pl08x, &bd, &cctl, early_bytes, num_llis++,
 				&total_bytes);
 		}
 
@@ -992,7 +1028,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, tsize);
 				pl08x_fill_lli_for_desc(&bd, num_llis++,
-						lli_len, cctl);
+						lli_len, cctl, tsize);
 				total_bytes += lli_len;
 			}
 
@@ -1003,8 +1039,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				dev_vdbg(&pl08x->adev->dev,
 					"%s align with boundary, send odd bytes (remain %zu)\n",
 					__func__, bd.remainder);
-				prep_byte_width_lli(&bd, &cctl, bd.remainder,
-						num_llis++, &total_bytes);
+				prep_byte_width_lli(pl08x, &bd, &cctl,
+					bd.remainder, num_llis++, &total_bytes);
 			}
 		}
 
@@ -2064,6 +2100,12 @@ static struct vendor_data vendor_nomadik = {
 	.config_offset = PL080_CH_CONFIG,
 };
 
+static struct vendor_data vendor_pl080s = {
+	.channels = 8,
+	.flags = PL08X_IS_DUALMASTER | PL08X_IS_PL080S,
+	.config_offset = PL080S_CH_CONFIG,
+};
+
 static struct vendor_data vendor_pl081 = {
 	.channels = 2,
 	.flags = 0,
@@ -2071,6 +2113,12 @@ static struct vendor_data vendor_pl081 = {
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
index 3e7b62f..ef36a0a 100644
--- a/include/linux/amba/pl080.h
+++ b/include/linux/amba/pl080.h
@@ -87,6 +87,7 @@
 #define PL080_CONTROL_SB_SIZE_MASK		(0x7 << 12)
 #define PL080_CONTROL_SB_SIZE_SHIFT		(12)
 #define PL080_CONTROL_TRANSFER_SIZE_MASK	(0xfff << 0)
+#define PL080S_CONTROL_TRANSFER_SIZE_MASK	(0xffffff << 0)
 #define PL080_CONTROL_TRANSFER_SIZE_SHIFT	(0)
 
 #define PL080_BSIZE_1				(0x0)
-- 
1.8.2.1

