Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3JAUOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:14:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:8203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab3JAUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:14:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1015,1371106800"; 
   d="scan'208";a="412602638"
From: David Cohen <david.a.cohen@linux.intel.com>
To: cjb@laptop.org, bhelgaas@google.com, adrian.hunter@intel.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org, g.liakhovetski@gmx.de
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2] mmc: sdhci-pci: add Intel Merrifield support
Date: Tue,  1 Oct 2013 13:18:15 -0700
Message-Id: <1380658695-20047-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement initial SDHCI Intel Merrifield support.
This patch is based on previous one from Yunpeng Gao <yunpeng.gao@intel.com>

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/mmc/host/sdhci-pci.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d7d6bc8..06f026a 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -37,6 +37,7 @@
 #define PCI_DEVICE_ID_INTEL_BYT_SDIO	0x0f15
 #define PCI_DEVICE_ID_INTEL_BYT_SD	0x0f16
 #define PCI_DEVICE_ID_INTEL_BYT_EMMC2	0x0f50
+#define PCI_DEVICE_ID_INTEL_MRFL_MMC	0x1190
 
 /*
  * PCI registers
@@ -356,6 +357,28 @@ static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 	.allow_runtime_pm = true,
 };
 
+/* Define Host controllers for Intel Merrifield platform */
+#define INTEL_MRFL_EMMC_0	0
+#define INTEL_MRFL_EMMC_1	1
+
+static int intel_mrfl_mmc_probe_slot(struct sdhci_pci_slot *slot)
+{
+	if ((PCI_FUNC(slot->chip->pdev->devfn) != INTEL_MRFL_EMMC_0) &&
+	    (PCI_FUNC(slot->chip->pdev->devfn) != INTEL_MRFL_EMMC_1))
+		/* SD support is not ready yet */
+		return -ENODEV;
+
+	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE |
+				 MMC_CAP_1_8V_DDR;
+
+	return 0;
+}
+
+static const struct sdhci_pci_fixes sdhci_intel_mrfl_mmc = {
+	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
+	.probe_slot	= intel_mrfl_mmc_probe_slot,
+};
+
 /* O2Micro extra registers */
 #define O2_SD_LOCK_WP		0xD3
 #define O2_SD_MULTI_VCC3V	0xEE
@@ -940,6 +963,13 @@ static const struct pci_device_id pci_ids[] = {
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_MRFL_MMC,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_mrfl_mmc,
+	},
+	{
 		.vendor		= PCI_VENDOR_ID_O2,
 		.device		= PCI_DEVICE_ID_O2_8120,
 		.subvendor	= PCI_ANY_ID,
-- 
1.8.4.rc3

