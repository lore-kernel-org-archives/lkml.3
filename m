Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbaJ3Gid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:38:33 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15186 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108AbaJ3GhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:37:05 -0400
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="49476488"
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
Subject: [PATCHv2 2/5] mmc: sdhci-bcm2835: make shift calculations consistent
Date: Wed, 29 Oct 2014 23:36:54 -0700
Message-ID: <1414651017-3545-3-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the shift calculations consistent rather than having different
implementations to calculate the same thing.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mmc/host/sdhci-bcm2835.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index c8ee02c..b6cb365 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -54,6 +54,8 @@ struct bcm2835_sdhci {
 	u32 shadow;
 };
 
+#define REG_OFFSET_IN_BITS(reg) ((reg) << 3 & 0x18)
+
 static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
 {
 	u32 val = readl(host->ioaddr + reg);
@@ -67,20 +69,14 @@ static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
 static u16 bcm2835_sdhci_readw(struct sdhci_host *host, int reg)
 {
 	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
-	u32 word_num = (reg >> 1) & 1;
-	u32 word_shift = word_num * 16;
-	u32 word = (val >> word_shift) & 0xffff;
-
+	u16 word = val >> REG_OFFSET_IN_BITS(reg) & 0xffff;
 	return word;
 }
 
 static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
 {
 	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
-	u32 byte_num = reg & 3;
-	u32 byte_shift = byte_num * 8;
-	u32 byte = (val >> byte_shift) & 0xff;
-
+	u8 byte = val >> REG_OFFSET_IN_BITS(reg) & 0xff;
 	return byte;
 }
 
@@ -98,8 +94,7 @@ static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 	struct bcm2835_sdhci *bcm2835_host = pltfm_host->priv;
 	u32 oldval = (reg == SDHCI_COMMAND) ? bcm2835_host->shadow :
 		bcm2835_sdhci_readl(host, reg & ~3);
-	u32 word_num = (reg >> 1) & 1;
-	u32 word_shift = word_num * 16;
+	u32 word_shift = REG_OFFSET_IN_BITS(reg);
 	u32 mask = 0xffff << word_shift;
 	u32 newval = (oldval & ~mask) | (val << word_shift);
 
@@ -112,8 +107,7 @@ static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
 static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
 {
 	u32 oldval = bcm2835_sdhci_readl(host, reg & ~3);
-	u32 byte_num = reg & 3;
-	u32 byte_shift = byte_num * 8;
+	u32 byte_shift = REG_OFFSET_IN_BITS(reg);
 	u32 mask = 0xff << byte_shift;
 	u32 newval = (oldval & ~mask) | (val << byte_shift);
 
-- 
1.7.9.5

