Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FVUnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:43:49 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54421 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FVUnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:22 -0400
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
Subject: [RFC PATCH v2 04/12] dmaengine: PL08x: Add support for PL080S variant
Date: Sat, 22 Jun 2013 22:42:36 +0200
Message-Id: <1371933764-24875-5-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL080S is a modified version of PL080 that can be found on Samsung SoCs,
such as S3C6400 and S3C6410.

It has different offset of CONFIG register, separate CONTROL1 register
that holds transfer size and larger maximum transfer size.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c   | 73 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/amba/pl080.h |  1 +
 2 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 50d2f77..103bc1a 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -96,7 +96,11 @@ enum {
 	PL080_LLI_LLI,
 	PL080_LLI_CCTL,
 
-	PL080_LLI_WORDS
+	PL080_LLI_WORDS,
+
+	PL080S_LLI_CCTL2 = PL080_LLI_WORDS,
+
+	PL080S_LLI_WORDS = 8
 };
 
 static struct amba_driver pl08x_amba_driver;
@@ -109,14 +113,18 @@ struct pl08x_driver_data;
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
 
+	u32 cctl1;
 /**
  * struct pl08x_bus_data - information of source or destination
  * busses for a transfer
@@ -351,6 +359,10 @@ static void pl08x_write_lli(struct pl08x_driver_data *pl08x,
 	writel(lli[PL080_LLI_LLI], phychan->base + PL080_CH_LLI);
 	writel(lli[PL080_LLI_CCTL], phychan->base + PL080_CH_CONTROL);
 
+	if (pl08x->vd->pl080s)
+		writel(lli[PL080S_LLI_CCTL2],
+				phychan->base + PL080S_CH_CONTROL2);
+
 	writel(ccfg, phychan->reg_config);
 }
 
@@ -469,6 +481,24 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
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
@@ -494,7 +524,12 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
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
@@ -515,7 +550,12 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
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
@@ -778,7 +818,7 @@ static void pl08x_choose_master_bus(struct pl08x_lli_build_data *bd,
  */
 static void pl08x_fill_lli_for_desc(struct pl08x_driver_data *pl08x,
 				    struct pl08x_lli_build_data *bd,
-				    int num_llis, int len, u32 cctl)
+				    int num_llis, int len, u32 cctl, u32 cctl2)
 {
 	u32 offset = num_llis * pl08x->lli_words;
 	u32 *llis_va = bd->txd->llis_va + offset;
@@ -794,6 +834,8 @@ static void pl08x_fill_lli_for_desc(struct pl08x_driver_data *pl08x,
 	llis_va[PL080_LLI_LLI] = (llis_bus + sizeof(u32) * offset);
 	llis_va[PL080_LLI_LLI] |= bd->lli_bus;
 	llis_va[PL080_LLI_CCTL] = cctl;
+	if (pl08x->vd->pl080s)
+		llis_va[PL080S_LLI_CCTL2] = cctl2;
 
 	if (cctl & PL080_CONTROL_SRC_INCR)
 		bd->srcbus.addr += len;
@@ -810,7 +852,7 @@ static inline void prep_byte_width_lli(struct pl08x_driver_data *pl08x,
 			int num_llis, size_t *total_bytes)
 {
 	*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
-	pl08x_fill_lli_for_desc(pl08x, bd, num_llis, len, *cctl);
+	pl08x_fill_lli_for_desc(pl08x, bd, num_llis, len, *cctl, len);
 	(*total_bytes) += len;
 }
 
@@ -915,7 +957,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, 0);
 			pl08x_fill_lli_for_desc(pl08x, &bd, num_llis++,
-					0, cctl);
+					0, cctl, 0);
 			break;
 		}
 
@@ -995,7 +1037,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, tsize);
 				pl08x_fill_lli_for_desc(pl08x, &bd, num_llis++,
-						lli_len, cctl);
+						lli_len, cctl, tsize);
 				total_bytes += lli_len;
 			}
 
@@ -1923,7 +1965,10 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		pl08x->mem_buses = pl08x->pd->mem_buses;
 	}
 
-	pl08x->lli_words = PL080_LLI_WORDS;
+	if (vd->pl080s)
+		pl08x->lli_words = PL080S_LLI_WORDS;
+	else
+		pl08x->lli_words = PL080_LLI_WORDS;
 	tsfr_size = MAX_NUM_TSFR_LLIS * pl08x->lli_words * sizeof(u32);
 
 	/* A DMA memory pool for LLIs, align on 1-byte boundary */
@@ -2075,6 +2120,12 @@ static struct vendor_data vendor_nomadik = {
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
@@ -2082,6 +2133,12 @@ static struct vendor_data vendor_pl081 = {
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

