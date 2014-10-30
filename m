Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbaJ3GhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:37:08 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:2020 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbaJ3GhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:37:04 -0400
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="49320875"
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
Subject: [PATCHv2 1/5] mmc: sdhci-bcm2835: group read and write functions to improve readability
Date: Wed, 29 Oct 2014 23:36:53 -0700
Message-ID: <1414651017-3545-2-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group the read and write functions to improve readability.  Now all
similar functions are grouped together to evaluate behaviours.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mmc/host/sdhci-bcm2835.c |   61 +++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index 439d259..c8ee02c 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -54,13 +54,6 @@ struct bcm2835_sdhci {
 	u32 shadow;
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
@@ -71,6 +64,34 @@ static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
 	return val;
 }
 
+static u16 bcm2835_sdhci_readw(struct sdhci_host *host, int reg)
+{
+	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
+	u32 word_num = (reg >> 1) & 1;
+	u32 word_shift = word_num * 16;
+	u32 word = (val >> word_shift) & 0xffff;
+
+	return word;
+}
+
+static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
+{
+	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
+	u32 byte_num = reg & 3;
+	u32 byte_shift = byte_num * 8;
+	u32 byte = (val >> byte_shift) & 0xff;
+
+	return byte;
+}
+
+static void bcm2835_sdhci_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	writel(val, host->ioaddr + reg);
+
+	udelay(BCM2835_SDHCI_WRITE_DELAY);
+}
+
+
 static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -88,16 +109,6 @@ static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 		bcm2835_sdhci_writel(host, newval, reg & ~3);
 }
 
-static u16 bcm2835_sdhci_readw(struct sdhci_host *host, int reg)
-{
-	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
-	u32 word_num = (reg >> 1) & 1;
-	u32 word_shift = word_num * 16;
-	u32 word = (val >> word_shift) & 0xffff;
-
-	return word;
-}
-
 static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
 {
 	u32 oldval = bcm2835_sdhci_readl(host, reg & ~3);
@@ -109,28 +120,18 @@ static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
 	bcm2835_sdhci_writel(host, newval, reg & ~3);
 }
 
-static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
-{
-	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
-	u32 byte_num = reg & 3;
-	u32 byte_shift = byte_num * 8;
-	u32 byte = (val >> byte_shift) & 0xff;
-
-	return byte;
-}
-
 static unsigned int bcm2835_sdhci_get_min_clock(struct sdhci_host *host)
 {
 	return MIN_FREQ;
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
 	.get_min_clock = bcm2835_sdhci_get_min_clock,
-- 
1.7.9.5

