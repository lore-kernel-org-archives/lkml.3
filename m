Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaIWFxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:53:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:46861 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaIWFxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390164832"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tj@kernel.org, rjw@rjwysocki.net
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        mister.freeman@laposte.net, rui.zhang@intel.com,
        chuansheng.liu@intel.com
Subject: [PATCH] ata: Disabling the async PM for JMicron chips
Date: Tue, 23 Sep 2014 13:37:51 +0800
Message-Id: <1411450671-2367-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be similar with commit (ata: Disabling the async PM for JMicron chip 363/361),
Barto found the similar issue for JMicron chip 368, that 363/368 has no
parent-children relationship, but they have the power dependency.

So here we can exclude the JMicron chips out of pm_async method directly,
to avoid further similar issues.

Details in:
https://bugzilla.kernel.org/show_bug.cgi?id=84861

Reported-and-tested-by: Barto <mister.freeman@laposte.net>
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/ata/ahci.c         |    6 +++---
 drivers/ata/pata_jmicron.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a0cc0ed..c096d49 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1345,10 +1345,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * follow the sequence one by one, otherwise one of them can not be
 	 * powered on successfully, so here we disable the async suspend
 	 * method for these chips.
+	 * Jmicron chip 368 has been found has the similar issue, here we can
+	 * exclude the Jmicron family directly to avoid other similar issues.
 	 */
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
-		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
-		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON)
 		device_disable_async_suspend(&pdev->dev);
 
 	/* acquire resources */
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 47e418b..48c993b 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -149,10 +149,10 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	 * follow the sequence one by one, otherwise one of them can not be
 	 * powered on successfully, so here we disable the async suspend
 	 * method for these chips.
+	 * Jmicron chip 368 has been found has the similar issue, here we can
+	 * exclude the Jmicron family directly to avoid other similar issues.
 	 */
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON &&
-		(pdev->device == PCI_DEVICE_ID_JMICRON_JMB363 ||
-		pdev->device == PCI_DEVICE_ID_JMICRON_JMB361))
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON)
 		device_disable_async_suspend(&pdev->dev);
 
 	return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
-- 
1.7.9.5

