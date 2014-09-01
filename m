Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaIAAwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:52:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:6322 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaIAAwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,438,1406617200"; 
   d="scan'208";a="596015339"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tj@kernel.org
Cc: MyMailClone@t-online.de, rjw@rjwysocki.net, aaron.lu@intel.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH] ata: Disabling the async PM for JMicron chip 363/361
Date: Mon,  1 Sep 2014 08:38:03 +0800
Message-Id: <1409531883-17260-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabled the PM feature that supporting async noirq(76569faa62
(PM / sleep: Asynchronous threads for resume_noirq)),
Jay hit the system resuming issue, that one of the JMicron controller
can not be powered up.

His device tree is like below:
             +-1c.4-[02]--+-00.0  JMicron Technology Corp. JMB363 SATA/IDE Controller
             |            \-00.1  JMicron Technology Corp. JMB363 SATA/IDE Controller

After investigation, we found the the Micron chip 363 included
one SATA controller(0000:02:00.0) and one PATA controller(0000:02:00.1),
these two controllers do not have parent-children relationship,
but the PATA controller only can be powered on after the SATA controller
has finished the powering on.

If we enabled the async noirq(), then the below error is hit during noirq
phase:
pata_jmicron 0000:02:00.1: Refused to change power state, currently in D3

Here for JMicron chip 363/361, we need forcedly to disable the async method.

Bug detail: https://bugzilla.kernel.org/show_bug.cgi?id=81551

Reported-by: Jay <MyMailClone@t-online.de>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/ata/ahci.c         |   11 +++++++++++
 drivers/ata/pata_jmicron.c |   11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a29f801..f5634cd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1329,6 +1329,17 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
 		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
+	/* The JMicron chip 361/363 contains one SATA controller and
+	 * one PATA controller,for powering on these both controllers,
+	 * we must follow the sequence one by one, otherwise one of them
+	 * can not be powered on successfully.
+	 * So here we disabled the async suspend method for these chips.
+	*/
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
+		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
+		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+		device_disable_async_suspend(&pdev->dev);
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 4d1a5d2..6b7aa77 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -143,6 +143,17 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
+	/* The JMicron chip 361/363 contains one SATA controller and
+	 * one PATA controller,for powering on these both controllers,
+	 * we must follow the sequence one by one, otherwise one of them
+	 * can not be powered on successfully.
+	 * So here we disabled the async suspend method for these chips.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
+		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
+		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+		device_disable_async_suspend(&pdev->dev);
+
 	return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
 }
 
-- 
1.7.9.5

