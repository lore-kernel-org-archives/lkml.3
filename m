Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbaJ3GhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:37:10 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:60240 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbaJ3GhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:37:06 -0400
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="49699556"
From: Scott Branden <sbranden@broadcom.com>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Chris Ball <chris@printf.net>,
        Piotr Krol <pietrushnic@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCHv2 3/5] mmc: shdci-bcm2835: add efficient back-to-back write workaround
Date: Wed, 29 Oct 2014 23:36:55 -0700
Message-ID: <1414651017-3545-4-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bcm2835 has clock domain issues when back to back writes to certain
registers are written.  The existing driver works around this issue with
udelay.  A more efficient method is to store the 8 and 16 bit writes
to the registers affected and then write them as 32 bits at the appropriate
time.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mmc/host/sdhci-bcm2835.c |  103 ++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index b6cb365..f8c450a 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -24,34 +24,9 @@
 #include <linux/mmc/host.h>
 #include "sdhci-pltfm.h"
 
-/*
- * 400KHz is max freq for card ID etc. Use that as min card clock. We need to
- * know the min to enable static calculation of max BCM2835_SDHCI_WRITE_DELAY.
- */
-#define MIN_FREQ 400000
-
-/*
- * The Arasan has a bugette whereby it may lose the content of successive
- * writes to registers that are within two SD-card clock cycles of each other
- * (a clock domain crossing problem). It seems, however, that the data
- * register does not have this problem, which is just as well - otherwise we'd
- * have to nobble the DMA engine too.
- *
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
- */
-#define BCM2835_SDHCI_WRITE_DELAY	(((2 * 1000000) / MIN_FREQ) + 1)
-
-struct bcm2835_sdhci {
-	u32 shadow;
+struct bcm2835_sdhci_host {
+	u32 shadow_cmd;
+	u32 shadow_blk;
 };
 
 #define REG_OFFSET_IN_BITS(reg) ((reg) << 3 & 0x18)
@@ -80,33 +55,71 @@ static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
 	return byte;
 }
 
-static void bcm2835_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+static inline void bcm2835_sdhci_writel(struct sdhci_host *host,
+						u32 val, int reg)
 {
 	writel(val, host->ioaddr + reg);
-
-	udelay(BCM2835_SDHCI_WRITE_DELAY);
 }
 
-
+/*
+ * The Arasan has a bugette whereby it may lose the content of successive
+ * writes to the same register that are within two SD-card clock cycles of
+ * each other (a clock domain crossing problem). The data
+ * register does not have this problem, which is just as well - otherwise we'd
+ * have to nobble the DMA engine too.
+ *
+ * This wouldn't be a problem with the code except that we can only write the
+ * controller with 32-bit writes.  So two different 16-bit registers are
+ * written back to back creates the problem.
+ *
+ * In reality, this only happens when SDHCI_BLOCK_SIZE and SDHCI_BLOCK_COUNT
+ * are written followed by SDHCI_TRANSFER_MODE and SDHCI_COMMAND.
+ * The BLOCK_SIZE and BLOCK_COUNT are meaningless until a command issued so
+ * the work around can be further optimized. We can keep shadow values of
+ * BLOCK_SIZE, BLOCK_COUNT, and TRANSFER_MODE until a COMMAND is issued.
+ * Then, write the BLOCK_SIZE+BLOCK_COUNT in a single 32-bit write followed
+ * by the TRANSFER+COMMAND in another 32-bit write.
+ */
 static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct bcm2835_sdhci *bcm2835_host = pltfm_host->priv;
-	u32 oldval = (reg == SDHCI_COMMAND) ? bcm2835_host->shadow :
-		bcm2835_sdhci_readl(host, reg & ~3);
+	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
 	u32 word_shift = REG_OFFSET_IN_BITS(reg);
 	u32 mask = 0xffff << word_shift;
-	u32 newval = (oldval & ~mask) | (val << word_shift);
-
-	if (reg == SDHCI_TRANSFER_MODE)
-		bcm2835_host->shadow = newval;
-	else
+	u32 oldval, newval;
+
+	if (reg == SDHCI_COMMAND) {
+		/* Write the block now as we are issuing a command */
+		if (bcm2835_host->shadow_blk != 0) {
+			bcm2835_sdhci_writel(host, bcm2835_host->shadow_blk,
+				SDHCI_BLOCK_SIZE);
+			bcm2835_host->shadow_blk = 0;
+		}
+		oldval = bcm2835_host->shadow_cmd;
+	} else if (reg == SDHCI_BLOCK_SIZE || reg == SDHCI_BLOCK_COUNT) {
+		/* Block size and count are stored in shadow reg */
+		oldval = bcm2835_host->shadow_blk;
+	} else {
+		/* Read reg, all other registers are not shadowed */
+		oldval = readl(host->ioaddr + (reg & ~3));
+	}
+	newval = (oldval & ~mask) | (val << word_shift);
+
+	if (reg == SDHCI_TRANSFER_MODE) {
+		/* Save the transfer mode until the command is issued */
+		bcm2835_host->shadow_cmd = newval;
+	} else if (reg == SDHCI_BLOCK_SIZE || reg == SDHCI_BLOCK_COUNT) {
+		/* Save the block info until the command is issued */
+		bcm2835_host->shadow_blk = newval;
+	} else {
+		/* Command or other regular 32-bit write */
 		bcm2835_sdhci_writel(host, newval, reg & ~3);
+	}
 }
 
 static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
 {
-	u32 oldval = bcm2835_sdhci_readl(host, reg & ~3);
+	u32 oldval = readl(host->ioaddr + (reg & ~3));
 	u32 byte_shift = REG_OFFSET_IN_BITS(reg);
 	u32 mask = 0xff << byte_shift;
 	u32 newval = (oldval & ~mask) | (val << byte_shift);
@@ -114,11 +127,6 @@ static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
 	bcm2835_sdhci_writel(host, newval, reg & ~3);
 }
 
-static unsigned int bcm2835_sdhci_get_min_clock(struct sdhci_host *host)
-{
-	return MIN_FREQ;
-}
-
 static const struct sdhci_ops bcm2835_sdhci_ops = {
 	.read_l = bcm2835_sdhci_readl,
 	.read_w = bcm2835_sdhci_readw,
@@ -128,7 +136,6 @@ static const struct sdhci_ops bcm2835_sdhci_ops = {
 	.write_b = bcm2835_sdhci_writeb,
 	.set_clock = sdhci_set_clock,
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
-	.get_min_clock = bcm2835_sdhci_get_min_clock,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
@@ -143,7 +150,7 @@ static const struct sdhci_pltfm_data bcm2835_sdhci_pdata = {
 static int bcm2835_sdhci_probe(struct platform_device *pdev)
 {
 	struct sdhci_host *host;
-	struct bcm2835_sdhci *bcm2835_host;
+	struct bcm2835_sdhci_host *bcm2835_host;
 	struct sdhci_pltfm_host *pltfm_host;
 	int ret;
 
-- 
1.7.9.5

