Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaBUKiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:38:19 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49941 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaBUKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:38:17 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1LAbRgH016978, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] mmc: sdhci: add support for realtek rts5250
Date: Fri, 21 Feb 2014 18:40:35 +0800
Message-ID: <1392979235-26664-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add support for realtek rts5250 pci card reader. The card reader have
some problem with DDR50 mode, so add a new quirks2 for broken ddr50.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/sdhci-pci.c |   20 ++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |    3 ++-
 include/linux/mmc/sdhci.h    |    2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 0955777..fdc6121 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -610,6 +610,18 @@ static const struct sdhci_pci_fixes sdhci_via = {
 	.probe		= via_probe,
 };
 
+static int rtsx_probe_slot(struct sdhci_pci_slot *slot)
+{
+	slot->host->mmc->caps2 |= MMC_CAP2_HS200;
+	return 0;
+}
+
+static const struct sdhci_pci_fixes sdhci_rtsx = {
+	.quirks2	= SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+			SDHCI_QUIRK2_BROKEN_DDR50,
+	.probe_slot	= rtsx_probe_slot,
+};
+
 static const struct pci_device_id pci_ids[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_RICOH,
@@ -732,6 +744,14 @@ static const struct pci_device_id pci_ids[] = {
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_REALTEK,
+		.device		= 0x5250,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_rtsx,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_INTEL,
 		.device		= PCI_DEVICE_ID_INTEL_MRST_SD0,
 		.subvendor	= PCI_ANY_ID,
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9ddef47..8958edc 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3020,7 +3020,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	} else if (caps[1] & SDHCI_SUPPORT_SDR50)
 		mmc->caps |= MMC_CAP_UHS_SDR50;
 
-	if (caps[1] & SDHCI_SUPPORT_DDR50)
+	if ((caps[1] & SDHCI_SUPPORT_DDR50) &&
+		!(host->quirks2 & SDHCI_QUIRK2_BROKEN_DDR50))
 		mmc->caps |= MMC_CAP_UHS_DDR50;
 
 	/* Does the host need tuning for SDR50? */
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 362927c4..7be12b8 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -100,6 +100,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
 /* Controller does not support HS200 */
 #define SDHCI_QUIRK2_BROKEN_HS200			(1<<6)
+/* Controller does not support DDR50 */
+#define SDHCI_QUIRK2_BROKEN_DDR50			(1<<7)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.9.5

