Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaKRPIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:08:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaKROJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:37 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>,
        Chris Ball <cjb@laptop.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/206] mmc: sdhci-pci: add Intel Merrifield support
Date: Tue, 18 Nov 2014 15:06:41 +0100
Message-Id: <b6ae6483e85c0cb9c26d8b0b0236a3f4ad21f34d.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Cohen <david.a.cohen@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8776a165d152d57a3a58895d55204614abe93d7f upstream.

Implement initial SDHCI Intel Merrifield support.  This patch is based
on previous one from Yunpeng Gao <yunpeng.gao@intel.com>.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/sdhci-pci.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 27ae563d0caa..689e655a122b 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -37,6 +37,7 @@
 #define PCI_DEVICE_ID_INTEL_BYT_SDIO	0x0f15
 #define PCI_DEVICE_ID_INTEL_BYT_SD	0x0f16
 #define PCI_DEVICE_ID_INTEL_BYT_EMMC2	0x0f50
+#define PCI_DEVICE_ID_INTEL_MRFL_MMC	0x1190
 
 /*
  * PCI registers
@@ -359,6 +360,28 @@ static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 	.own_cd_for_runtime_pm = true,
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
@@ -943,6 +966,13 @@ static const struct pci_device_id pci_ids[] = {
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
2.1.3

