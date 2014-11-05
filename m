Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaKEBYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:24:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:43268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKEBYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:24:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,316,1413270000"; 
   d="scan'208";a="602412350"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: bhelgaas@google.com, aaron.lu@intel.com, tj@kernel.org, rjw@rjwysocki.net,
        mister.freeman@laposte.net
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: [PATCH] PCI: Do not enable async suspend for JMicron chips
Date: Wed,  5 Nov 2014 09:07:45 +0800
Message-Id: <1415149665-26669-1-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The JMicron chip 361/363/368 contains one SATA controller and
one PATA controller, they are brother-relation ship in PCI tree,
but for powering on these both controller, we must follow the
sequence one by one, otherwise one of them can not be powered on
successfully.

So here we disable the async suspend method for Jmicron chip.

Cc: stable@vger.kernel.org # 3.15+
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/pci/pci.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 625a4ac..53128f0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2046,7 +2046,17 @@ void pci_pm_init(struct pci_dev *dev)
 	pm_runtime_forbid(&dev->dev);
 	pm_runtime_set_active(&dev->dev);
 	pm_runtime_enable(&dev->dev);
-	device_enable_async_suspend(&dev->dev);
+
+	/*
+	 * The JMicron chip 361/363/368 contains one SATA controller and
+	 * one PATA controller, they are brother-relation ship in PCI tree,
+	 * but for powering on these both controller, we must follow the
+	 * sequence one by one, otherwise one of them can not be powered on
+	 * successfully, so here we disable the async suspend method for
+	 * Jmicron chip.
+	 */
+	if (dev->vendor != PCI_VENDOR_ID_JMICRON)
+		device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;
 
 	dev->pm_cap = 0;
-- 
1.7.9.5

