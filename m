Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbaJ3Gh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:37:58 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15186 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbaJ3GhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:37:08 -0400
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="49476493"
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
Subject: [PATCHv2 4/5] mmc: shdci-bcm2835: add verify for 32-bit back-to-back workaround
Date: Wed, 29 Oct 2014 23:36:56 -0700
Message-ID: <1414651017-3545-5-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414651017-3545-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a verify option to driver to print out an error message if a
potential back to back write could cause a clock domain issue.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/mmc/host/Kconfig         |    9 +++++++++
 drivers/mmc/host/sdhci-bcm2835.c |   17 +++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1386065..020de98 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -292,6 +292,15 @@ config MMC_SDHCI_BCM2835
 
 	  If unsure, say N.
 
+config MMC_SDHCI_BCM2835_VERIFY_WORKAROUND
+	bool "Verify BCM2835 workaround does not do back to back writes"
+	depends on MMC_SDHCI_BCM2835
+	default y
+	help
+	  This enables code that verifies the bcm2835 workaround.
+	  The verification code checks that back to back writes to the same
+	  register do not occur.
+
 config MMC_MOXART
 	tristate "MOXART SD/MMC Host Controller support"
 	depends on ARCH_MOXART && MMC
diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index f8c450a..11af27f 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -27,6 +27,9 @@
 struct bcm2835_sdhci_host {
 	u32 shadow_cmd;
 	u32 shadow_blk;
+#ifdef CONFIG_MMC_SDHCI_BCM2835_VERIFY_WORKAROUND
+	int previous_reg;
+#endif
 };
 
 #define REG_OFFSET_IN_BITS(reg) ((reg) << 3 & 0x18)
@@ -58,6 +61,20 @@ static u8 bcm2835_sdhci_readb(struct sdhci_host *host, int reg)
 static inline void bcm2835_sdhci_writel(struct sdhci_host *host,
 						u32 val, int reg)
 {
+#ifdef CONFIG_MMC_SDHCI_BCM2835_VERIFY_WORKAROUND
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
+
+	if (bcm2835_host->previous_reg == reg) {
+		if ((reg != SDHCI_HOST_CONTROL)
+			&& (reg != SDHCI_CLOCK_CONTROL)) {
+			dev_err(mmc_dev(host->mmc),
+			"back-to-back write to 0x%x\n", reg);
+		}
+	}
+	bcm2835_host->previous_reg = reg;
+#endif
+
 	writel(val, host->ioaddr + reg);
 }
 
-- 
1.7.9.5

