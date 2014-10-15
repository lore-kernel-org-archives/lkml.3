Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJOQnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:43:14 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:26913 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaJOQnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:43:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="scan'208";a="48511100"
From: Scott Branden <sbranden@broadcom.com>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <chris@printf.net>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCH 1/1] mmc: sdhci-bcm2835: added quirk and removed udelay in write ops
Date: Wed, 15 Oct 2014 09:43:05 -0700
Message-ID: <1413391385-4061-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added quirk SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 present in controller.
Removed udelay in write ops by using shadow registers for 16 bit
accesses to 32-bit registers (where necessary).
Optimized 32-bit operations when doing 8/16 register accesses.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mmc/host/sdhci-bcm2835.c |  139 ++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 73 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index 439d259..d967a4f 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -25,42 +25,28 @@
 #include "sdhci-pltfm.h"
 
 /*
- * 400KHz is max freq for card ID etc. Use that as min card clock. We need to
- * know the min to enable static calculation of max BCM2835_SDHCI_WRITE_DELAY.
- */
-#define MIN_FREQ 400000
-
-/*
  * The Arasan has a bugette whereby it may lose the content of successive
- * writes to registers that are within two SD-card clock cycles of each other
- * (a clock domain crossing problem). It seems, however, that the data
- * register does not have this problem, which is just as well - otherwise we'd
- * have to nobble the DMA engine too.
+ * writes to the same register that are within two SD-card clock cycles of
+ * each other (a clock domain crossing problem).  Problem does not happen with
+ * data.
+ * This wouldn't be a problem with the code except that we can only write the
+ * controller with 32-bit writes.  So two different 16-bit registers in the
+ * written back to back creates the problem.
  *
- * This should probably be dynamically calculated based on the actual card
- * frequency. However, this is the longest we'll have to wait, and doesn't
- * seem to slow access down too much, so the added complexity doesn't seem
- * worth it for now.
- *
- * 1/MIN_FREQ is (max) time per tick of eMMC clock.
- * 2/MIN_FREQ is time for two ticks.
- * Multiply by 1000000 to get uS per two ticks.
- * *1000000 for uSecs.
- * +1 for hack rounding.
+ * In reality, this only happens when a SDHCI_BLOCK_SIZE and SDHCI_BLOCK_COUNT
+ * are written followed by SDHCI_TRANSFER_MODE and SDHCI_COMMAND.
+ * The BLOCK_SIZE and BLOCK_COUNT are meaningless until a command issued so
+ * the work around can be further optimized. We can keep shadow values of
+ * BLOCK_SIZE, BLOCK_COUNT, and TRANSFER_MODE until a COMMAND is issued.
+ * Then, write the BLOCK_SIZE+BLOCK_COUNT in a single 32-bit write followed
+ * by the TRANSFER+COMMAND in another 32-bit write.
  */
-#define BCM2835_SDHCI_WRITE_DELAY	(((2 * 1000000) / MIN_FREQ) + 1)
 
-struct bcm2835_sdhci {
-	u32 shadow;
+struct bcm2835_sdhci_host {
+	u32 shadow_cmd;
+	u32 shadow_blk;
 };
 
-static void bcm2835_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
-{
-	writel(val, host->ioaddr + reg);
-
-	udelay(BCM2835_SDHCI_WRITE_DELAY);
-}
-
 static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
 {
 	u32 val = readl(host->ioaddr + reg);
@@ -71,76 +57,83 @@ static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
 	return val;
 }
 
-static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct bcm2835_sdhci *bcm2835_host = pltfm_host->priv;
-	u32 oldval = (reg == SDHCI_COMMAND) ? bcm2835_host->shadow :
-		bcm2835_sdhci_readl(host, reg & ~3);
-	u32 word_num = (reg >> 1) & 1;
-	u32 word_shift = word_num * 16;
-	u32 mask = 0xffff << word_shift;
-	u32 newval = (oldval & ~mask) | (val << word_shift);
-
-	if (reg == SDHCI_TRANSFER_MODE)
-		bcm2835_host->shadow = newval;
-	else
-		bcm2835_sdhci_writel(host, newval, reg & ~3);
-}
-
 static u16 bcm2835_sdhci_readw(struct sdhci_host *host, int reg)
 {
-	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
-	u32 word_num = (reg >> 1) & 1;
-	u32 word_shift = word_num * 16;
-	u32 word = (val >> word_shift) & 0xffff;
-
+	u32 val = bcm2835_sdhci_readl(host->ioaddr, (reg & ~3));
+	u16 word = val >> (reg << 3 & 0x18) & 0xffff;
 	return word;
 }
 
-static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
+static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
 {
-	u32 oldval = bcm2835_sdhci_readl(host, reg & ~3);
-	u32 byte_num = reg & 3;
-	u32 byte_shift = byte_num * 8;
-	u32 mask = 0xff << byte_shift;
-	u32 newval = (oldval & ~mask) | (val << byte_shift);
+	u32 val = bcm2835_sdhci_readl(host->ioaddr, (reg & ~3));
+	u8 byte = val >> (reg << 3 & 0x18) & 0xff;
+	return byte;
+}
 
-	bcm2835_sdhci_writel(host, newval, reg & ~3);
+static void bcm2835_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	writel(val, host->ioaddr + reg);
 }
 
-static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
+static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 {
-	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
-	u32 byte_num = reg & 3;
-	u32 byte_shift = byte_num * 8;
-	u32 byte = (val >> byte_shift) & 0xff;
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
+	u32 word_shift = reg << 3 & 0x18;
+	u32 mask = 0xffff << word_shift;
+	u32 oldval;
+	u32 newval;
+
+	if (reg == SDHCI_COMMAND) {
+		if (bcm2835_host->shadow_blk != 0) {
+			writel(bcm2835_host->shadow_blk,
+			       host->ioaddr + SDHCI_BLOCK_SIZE);
+			bcm2835_host->shadow_blk = 0;
+		}
+		oldval = bcm2835_host->shadow_cmd;
+	} else if (reg == SDHCI_BLOCK_SIZE || reg == SDHCI_BLOCK_COUNT) {
+		oldval = bcm2835_host->shadow_blk;
+	} else {
+		oldval = readl(host->ioaddr + (reg & ~3));
+	}
+	newval = (oldval & ~mask) | (val << word_shift);
 
-	return byte;
+	if (reg == SDHCI_TRANSFER_MODE)
+		bcm2835_host->shadow_cmd = newval;
+	else if (reg == SDHCI_BLOCK_SIZE || reg == SDHCI_BLOCK_COUNT)
+		bcm2835_host->shadow_blk = newval;
+	else
+		writel(newval, host->ioaddr + (reg & ~3));
 }
 
-static unsigned int bcm2835_sdhci_get_min_clock(struct sdhci_host *host)
+static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
 {
-	return MIN_FREQ;
+	u32 oldval = readl(host->ioaddr + (reg & ~3));
+	u32 byte_shift = reg << 3 & 0x18;
+	u32 mask = 0xff << byte_shift;
+	u32 newval = (oldval & ~mask) | (val << byte_shift);
+
+	writel(newval, host->ioaddr + (reg & ~3));
 }
 
 static const struct sdhci_ops bcm2835_sdhci_ops = {
-	.write_l = bcm2835_sdhci_writel,
-	.write_w = bcm2835_sdhci_writew,
-	.write_b = bcm2835_sdhci_writeb,
 	.read_l = bcm2835_sdhci_readl,
 	.read_w = bcm2835_sdhci_readw,
 	.read_b = bcm2835_sdhci_readb,
+	.write_l = bcm2835_sdhci_writel,
+	.write_w = bcm2835_sdhci_writew,
+	.write_b = bcm2835_sdhci_writeb,
 	.set_clock = sdhci_set_clock,
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
-	.get_min_clock = bcm2835_sdhci_get_min_clock,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
 };
 
 static const struct sdhci_pltfm_data bcm2835_sdhci_pdata = {
-	.quirks = SDHCI_QUIRK_BROKEN_CARD_DETECTION |
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK,
 	.ops = &bcm2835_sdhci_ops,
 };
@@ -148,7 +141,7 @@ static const struct sdhci_pltfm_data bcm2835_sdhci_pdata = {
 static int bcm2835_sdhci_probe(struct platform_device *pdev)
 {
 	struct sdhci_host *host;
-	struct bcm2835_sdhci *bcm2835_host;
+	struct bcm2835_sdhci_host *bcm2835_host;
 	struct sdhci_pltfm_host *pltfm_host;
 	int ret;
 
-- 
1.7.9.5

