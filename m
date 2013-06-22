Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3FVUnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:43:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33448 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3FVUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:21 -0400
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
Subject: [RFC PATCH v2 02/12] dmaengine: PL08x: Add support for different offset of CONFIG register
Date: Sat, 22 Jun 2013 22:42:34 +0200
Message-Id: <1371933764-24875-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variants of PL08x (namely PL080S, found in Samsung S3C64xx SoCs)
have CONFIG register at different offset. This patch makes the driver
use offset from vendor data struct.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6a12392..2538e05 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -102,6 +102,7 @@ struct pl08x_driver_data;
  *	missing
  */
 struct vendor_data {
+	u8 config_offset;
 	u8 channels;
 	bool dualmaster;
 	bool nomadik;
@@ -145,6 +146,7 @@ struct pl08x_bus_data {
 struct pl08x_phy_chan {
 	unsigned int id;
 	void __iomem *base;
+	void __iomem *reg_config;
 	spinlock_t lock;
 	struct pl08x_dma_chan *serving;
 	bool locked;
@@ -334,7 +336,7 @@ static int pl08x_phy_channel_busy(struct pl08x_phy_chan *ch)
 {
 	unsigned int val;
 
-	val = readl(ch->base + PL080_CH_CONFIG);
+	val = readl(ch->reg_config);
 	return val & PL080_CONFIG_ACTIVE;
 }
 
@@ -373,7 +375,7 @@ static void pl08x_start_next_txd(struct pl08x_dma_chan *plchan)
 	writel(lli->dst, phychan->base + PL080_CH_DST_ADDR);
 	writel(lli->lli, phychan->base + PL080_CH_LLI);
 	writel(lli->cctl, phychan->base + PL080_CH_CONTROL);
-	writel(txd->ccfg, phychan->base + PL080_CH_CONFIG);
+	writel(txd->ccfg, phychan->reg_config);
 
 	/* Enable the DMA channel */
 	/* Do not access config register until channel shows as disabled */
@@ -381,11 +383,11 @@ static void pl08x_start_next_txd(struct pl08x_dma_chan *plchan)
 		cpu_relax();
 
 	/* Do not access config register until channel shows as inactive */
-	val = readl(phychan->base + PL080_CH_CONFIG);
+	val = readl(phychan->reg_config);
 	while ((val & PL080_CONFIG_ACTIVE) || (val & PL080_CONFIG_ENABLE))
-		val = readl(phychan->base + PL080_CH_CONFIG);
+		val = readl(phychan->reg_config);
 
-	writel(val | PL080_CONFIG_ENABLE, phychan->base + PL080_CH_CONFIG);
+	writel(val | PL080_CONFIG_ENABLE, phychan->reg_config);
 }
 
 /*
@@ -404,9 +406,9 @@ static void pl08x_pause_phy_chan(struct pl08x_phy_chan *ch)
 	int timeout;
 
 	/* Set the HALT bit and wait for the FIFO to drain */
-	val = readl(ch->base + PL080_CH_CONFIG);
+	val = readl(ch->reg_config);
 	val |= PL080_CONFIG_HALT;
-	writel(val, ch->base + PL080_CH_CONFIG);
+	writel(val, ch->reg_config);
 
 	/* Wait for channel inactive */
 	for (timeout = 1000; timeout; timeout--) {
@@ -423,9 +425,9 @@ static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
 	u32 val;
 
 	/* Clear the HALT bit */
-	val = readl(ch->base + PL080_CH_CONFIG);
+	val = readl(ch->reg_config);
 	val &= ~PL080_CONFIG_HALT;
-	writel(val, ch->base + PL080_CH_CONFIG);
+	writel(val, ch->reg_config);
 }
 
 /*
@@ -437,12 +439,12 @@ static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
 static void pl08x_terminate_phy_chan(struct pl08x_driver_data *pl08x,
 	struct pl08x_phy_chan *ch)
 {
-	u32 val = readl(ch->base + PL080_CH_CONFIG);
+	u32 val = readl(ch->reg_config);
 
 	val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
 	         PL080_CONFIG_TC_IRQ_MASK);
 
-	writel(val, ch->base + PL080_CH_CONFIG);
+	writel(val, ch->reg_config);
 
 	writel(1 << ch->id, pl08x->base + PL080_ERR_CLEAR);
 	writel(1 << ch->id, pl08x->base + PL080_TC_CLEAR);
@@ -1952,6 +1954,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 		ch->id = i;
 		ch->base = pl08x->base + PL080_Cx_BASE(i);
+		ch->reg_config = ch->base + vd->config_offset;
 		spin_lock_init(&ch->lock);
 
 		/*
@@ -1962,7 +1965,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		if (vd->nomadik) {
 			u32 val;
 
-			val = readl(ch->base + PL080_CH_CONFIG);
+			val = readl(ch->reg_config);
 			if (val & (PL080N_CONFIG_ITPROT | PL080N_CONFIG_SECPROT)) {
 				dev_info(&adev->dev, "physical channel %d reserved for secure access only\n", i);
 				ch->locked = true;
@@ -2043,17 +2046,20 @@ out_no_pl08x:
 
 /* PL080 has 8 channels and the PL080 have just 2 */
 static struct vendor_data vendor_pl080 = {
+	.config_offset = PL080_CH_CONFIG,
 	.channels = 8,
 	.dualmaster = true,
 };
 
 static struct vendor_data vendor_nomadik = {
+	.config_offset = PL080_CH_CONFIG,
 	.channels = 8,
 	.dualmaster = true,
 	.nomadik = true,
 };
 
 static struct vendor_data vendor_pl081 = {
+	.config_offset = PL080_CH_CONFIG,
 	.channels = 2,
 	.dualmaster = false,
 };
-- 
1.8.2.1

