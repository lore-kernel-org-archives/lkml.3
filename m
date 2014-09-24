Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaIXHiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:38:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:19153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbaIXHiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="578069968"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tj@kernel.org, rjw@rjwysocki.net
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        mister.freeman@laposte.net, rui.zhang@intel.com,
        chuansheng.liu@intel.com
Subject: [PATCH V2] ata: Disabling the async PM for JMicron chips
Date: Wed, 24 Sep 2014 15:22:18 +0800
Message-Id: <1411543338-2257-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361"),
Barto found the similar issue for JMicron chip 368, that 363/368 has no
parent-children relationship, but they have the power dependency.

So here we can exclude the JMicron chips out of pm_async method directly,
to avoid further similar issues.

Details in:
https://bugzilla.kernel.org/show_bug.cgi?id=84861

Reported-and-tested-by: Barto <mister.freeman@laposte.net>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/ata/ahci.c         |   11 +++++------
 drivers/ata/pata_jmicron.c |   11 +++++------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a0cc0ed..85aa6ec 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1340,15 +1340,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
 	/*
-	 * The JMicron chip 361/363 contains one SATA controller and one
+	 * The JMicron chip 361/363/368 contains one SATA controller and one
 	 * PATA controller,for powering on these both controllers, we must
 	 * follow the sequence one by one, otherwise one of them can not be
-	 * powered on successfully, so here we disable the async suspend
-	 * method for these chips.
+	 * powered on successfully.
+	 * Here we can exclude the Jmicron family directly out of pm_async
+	 * method to follow the power-on sequence.
 	 */
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
-		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
-		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON)
 		device_disable_async_suspend(&pdev->dev);
 
 	/* acquire resources */
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 47e418b..1d685b6 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -144,15 +144,14 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/*
-	 * The JMicron chip 361/363 contains one SATA controller and one
+	 * The JMicron chip 361/363/368 contains one SATA controller and one
 	 * PATA controller,for powering on these both controllers, we must
 	 * follow the sequence one by one, otherwise one of them can not be
-	 * powered on successfully, so here we disable the async suspend
-	 * method for these chips.
+	 * powered on successfully.
+	 * Here we can exclude the Jmicron family directly out of pm_async
+	 * method to follow the power-on sequence.
 	 */
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
-		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
-		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON)
 		device_disable_async_suspend(&pdev->dev);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
-- 
1.7.9.5

