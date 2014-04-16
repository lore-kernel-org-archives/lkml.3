Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161253AbaDPN1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:27:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:52522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161207AbaDPN0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="scan'208";a="494141421"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2] ahci: disable DEVSLP for Intel Valleyview
Date: Tue, 15 Apr 2014 22:27:11 -0700
Message-Id: <1397626031-4064-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Intel Valleyview SoC, SATA device sleep is not reliable. When
DEVSLP is attempted on certain SSDs, port_devslp write would fail
and result in malfunction of AHCI controller. AHCI controller may
be not shown in PCI enumeration after reset. Complete power source
removal may be required to recover from this failure. So we blacklist
this device and override host device reported capabilities such that
device LPM will only attempt slumber but not DEVSLP.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/ahci.c    | 15 +++++++++++++++
 drivers/ata/ahci.h    |  1 +
 drivers/ata/libahci.c |  7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5a0bf8e..e090d5f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1115,6 +1115,17 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
 }
 
+static bool ahci_broken_devslp(struct pci_dev *pdev)
+{
+	/* device with broken DEVSLP but still showing SDS capability */
+	static const struct pci_device_id ids[] = {
+		{ PCI_VDEVICE(INTEL, 0x0f23)}, /* Valleyview SoC */
+		{}
+	};
+
+	return pci_match_id(ids, pdev);
+}
+
 #ifdef CONFIG_ATA_ACPI
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
@@ -1357,6 +1368,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
+	/* must set flag prior to save config in order to take effect */
+	if (ahci_broken_devslp(pdev))
+		hpriv->flags |= AHCI_HFLAG_NO_DEVSLP;
+
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 0b670c0..630089a 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -235,6 +235,7 @@ enum {
 						        port start (wait until
 						        error-handling stage) */
 	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
+	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 8cd0184..32fd860 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -653,6 +653,13 @@ void ahci_save_initial_config(struct device *dev,
 		cap &= ~HOST_CAP_SNTF;
 	}
 
+	if ((cap2 & HOST_CAP2_SDS) && (hpriv->flags & AHCI_HFLAG_NO_DEVSLP)) {
+		dev_info(dev,
+			 "controller can't do DEVSLP, turning off\n");
+		cap2 &= ~HOST_CAP2_SDS;
+		cap2 &= ~HOST_CAP2_SADM;
+	}
+
 	if (!(cap & HOST_CAP_FBS) && (hpriv->flags & AHCI_HFLAG_YES_FBS)) {
 		dev_info(dev, "controller can do FBS, turning on CAP_FBS\n");
 		cap |= HOST_CAP_FBS;
-- 
1.8.1.2

