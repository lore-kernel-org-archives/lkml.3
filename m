Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3KOX5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:57:03 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62796 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KOX46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:56:58 -0500
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
        Stephen Hurd <shurd@broadcom.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH] mmc: disable UHS on broadcom sdhci
Date: Fri, 15 Nov 2013 15:56:22 -0800
Message-Id: <1384559782-7614-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hurd <shurd@broadcom.com>

Add two new quirks needed by BCM57785 card reader:
SDHCI_QUIRK2_BROKEN_UHS:
    Disables all UHS modes.

SDHCI_QUIRK2_BCM57785_CR:
    Bit twiddles some Broadcom-specific registers and supresses an error
    about the 64k bar0.

Add sdhci_pci_fixes for:
o the chip itself with the required quirks in general (lightly tested).
o "parrot" (Acer C7 Chromebook) which uses the SDHCI_QUIRK2_BROKEN_UHS
   quirk: disables ADMA mode, and adds a delay after power.

Signed-off-by: Stephen Hurd <shurd@broadcom.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/host/sdhci-pci.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     | 33 +++++++++++++++++++++++++++++++--
 include/linux/mmc/sdhci.h    |  6 ++++++
 3 files changed, 75 insertions(+), 2 deletions(-)

This patch is "V2" of what ChromeOS has been using for the past year to
support Acer C7 Chromebook card reader:
    https://chromium.googlesource.com/chromiumos/third_party/kernel-next/+/fd1acc54a6b3db4e6503ccc4a9349f28b436031a

This patch is for linux-2.6 3.12.0 and is "Compile Tested" only.


diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d7d6bc8..96e3116 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -168,6 +168,28 @@ static const struct sdhci_pci_fixes sdhci_cafe = {
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 
+#define BRCM_SDHCI_QUIRKS ( \
+	SDHCI_QUIRK_32BIT_DMA_ADDR | \
+	SDHCI_QUIRK_32BIT_DMA_SIZE | \
+	SDHCI_QUIRK_32BIT_ADMA_SIZE | \
+	SDHCI_QUIRK_BROKEN_TIMEOUT_VAL | \
+	SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 | \
+	0)
+
+#define BRCM_SDHCI_QUIRKS2 (SDHCI_QUIRK2_BCM57785_CR | 0)
+
+static const struct sdhci_pci_fixes sdhci_brcm = {
+	.quirks		= BRCM_SDHCI_QUIRKS,
+	.quirks2	= BRCM_SDHCI_QUIRKS2,
+};
+
+static const struct sdhci_pci_fixes sdhci_nouhs_brcm = {
+	.quirks		= BRCM_SDHCI_QUIRKS |
+				SDHCI_QUIRK_DELAY_AFTER_POWER |
+				SDHCI_QUIRK_BROKEN_ADMA,
+	.quirks2	= BRCM_SDHCI_QUIRKS2 | SDHCI_QUIRK2_BROKEN_UHS,
+};
+
 static int mrst_hc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
@@ -979,6 +1001,22 @@ static const struct pci_device_id pci_ids[] = {
 		.driver_data	= (kernel_ulong_t)&sdhci_o2,
 	},
 
+	{
+		.vendor		= PCI_VENDOR_ID_BROADCOM,
+		.device		= 0x16bc,
+		.subvendor	= PCI_VENDOR_ID_AI,
+		.subdevice	= 0x0742,
+		.driver_data	= (kernel_ulong_t)&sdhci_nouhs_brcm,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_BROADCOM,
+		.device		= 0x16bc,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_brcm,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..cf26c0f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1144,6 +1144,27 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 			return;
 	}
 
+	if (host->quirks2 & SDHCI_QUIRK2_BCM57785_CR) {
+		u32 tmp;
+
+		/*
+		 * Register descriptions from:
+		 *     http://www.broadcom.com/collateral/pg/57785-PG103-R.pdf
+		 */
+		tmp = sdhci_readl(host, BCM57785_CR_MUX_CTL);
+		tmp &= ~0x3000;		/* bits 12:15 are reserved */
+		sdhci_writel(host, tmp, BCM57785_CR_MUX_CTL);
+
+		tmp = sdhci_readl(host, BCM57785_CR_CLK_CTL);
+		tmp &= ~(0x01a03f30);	/* Internal debug for SD3.0 */
+		tmp |= (0x00500000);
+
+		if ((sdhci_readw(host, SDHCI_HOST_CONTROL2) &
+			    SDHCI_CTRL_VDD_180) && (clock >= 200000000))
+			tmp |= (1<<24);
+		sdhci_writel(host, tmp, BCM57785_CR_CLK_CTL);
+	}
+
 	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
 	if (clock == 0)
@@ -1546,9 +1567,11 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 			if ((ios->timing == MMC_TIMING_MMC_HS200) ||
 			    (ios->timing == MMC_TIMING_UHS_SDR104))
 				ctrl_2 |= SDHCI_CTRL_UHS_SDR104;
-			else if (ios->timing == MMC_TIMING_UHS_SDR12)
+			else if ((ios->timing == MMC_TIMING_UHS_SDR12) &&
+					(host->mmc->caps & MMC_CAP_UHS_SDR12))
 				ctrl_2 |= SDHCI_CTRL_UHS_SDR12;
-			else if (ios->timing == MMC_TIMING_UHS_SDR25)
+			else if ((ios->timing == MMC_TIMING_UHS_SDR25) &&
+					(host->mmc->caps & MMC_CAP_UHS_SDR25))
 				ctrl_2 |= SDHCI_CTRL_UHS_SDR25;
 			else if (ios->timing == MMC_TIMING_UHS_SDR50)
 				ctrl_2 |= SDHCI_CTRL_UHS_SDR50;
@@ -2791,12 +2814,18 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	caps[0] = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ? host->caps :
 		sdhci_readl(host, SDHCI_CAPABILITIES);
+	if (host->quirks2 & SDHCI_QUIRK2_BROKEN_UHS)
+		caps[0] &= ~(SDHCI_CAN_VDD_180);
 
 	if (host->version >= SDHCI_SPEC_300)
 		caps[1] = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ?
 			host->caps1 :
 			sdhci_readl(host, SDHCI_CAPABILITIES_1);
 
+	if (host->quirks2 & SDHCI_QUIRK2_BROKEN_UHS)
+		caps[1] &= ~(SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_SDR104 |
+			    SDHCI_SUPPORT_DDR50 | SDHCI_USE_SDR50_TUNING);
+
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
 		host->flags |= SDHCI_USE_SDMA;
 	else if (!(caps[0] & SDHCI_CAN_DO_SDMA))
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 3e781b8..664003a 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -98,6 +98,12 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON		(1<<4)
 /* Controller has a non-standard host control register */
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
+/* UHS modes do not work */
+#define SDHCI_QUIRK2_BROKEN_UHS				(1<<6)
+/* hacks for Broadcom-specific card reader bugs */
+#define SDHCI_QUIRK2_BCM57785_CR			(1<<7)
+#define	  BCM57785_CR_MUX_CTL 0x198  /* Card Reader MUX control */
+#define	  BCM57785_CR_CLK_CTL 0x19c  /* Card Reader Clock Status/Ctl */
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.8.4.1

