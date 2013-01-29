Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3A2EfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:35:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:20512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab3A2Eeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,556,1355126400"; 
   d="scan'208";a="253942314"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 1/4] PCI/ACPI: Add target state as parameter to pci_platform_pm_ops->run_wake
Date: Tue, 29 Jan 2013 12:34:15 +0800
Message-Id: <1359434058-15918-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
References: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, if PCI device uses native PME interrupt for runtime wake up,
platform need not to do anything for runtime wake up.

But per PCI Express Base Specification Revision 2.0 section 5.3.3.2
Link Wakeup, platform support is needed for D3cold waking up to power
on the main link even if there is native PME interrupt support for
D3cold.

So the needed work for platform runtime wake up is different among
different target state.  Originally, pci_dev->runtime_d3cold flag is
used for that, but we want to restrict its usage.  Now the target
state is added as parameter to pci_platform_pm_ops->run_wake to solve
the issue.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-acpi.c |    5 +++--
 drivers/pci/pci.c      |    9 +++++----
 drivers/pci/pci.h      |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -261,7 +261,8 @@ static void acpi_pci_propagate_run_wake(
 		acpi_pm_device_run_wake(bus->bridge, enable);
 }
 
-static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
+static int acpi_pci_run_wake(struct pci_dev *dev, bool enable,
+			     pci_power_t state)
 {
 	/*
 	 * Per PCI Express Base Specification Revision 2.0 section
@@ -269,7 +270,7 @@ static int acpi_pci_run_wake(struct pci_
 	 * waking up to power on the main link even if there is PME
 	 * support for D3cold
 	 */
-	if (dev->pme_interrupt && !dev->runtime_d3cold)
+	if (dev->pme_interrupt && state != PCI_D3cold)
 		return 0;
 
 	if (!acpi_pm_device_run_wake(&dev->dev, enable))
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -484,10 +484,11 @@ static inline int platform_pci_sleep_wak
 			pci_platform_pm->sleep_wake(dev, enable) : -ENODEV;
 }
 
-static inline int platform_pci_run_wake(struct pci_dev *dev, bool enable)
+static inline int platform_pci_run_wake(struct pci_dev *dev, bool enable,
+					pci_power_t state)
 {
 	return pci_platform_pm ?
-			pci_platform_pm->run_wake(dev, enable) : -ENODEV;
+			pci_platform_pm->run_wake(dev, enable, state) : -ENODEV;
 }
 
 /**
@@ -1687,7 +1688,7 @@ int __pci_enable_wake(struct pci_dev *de
 			pci_pme_active(dev, true);
 		else
 			ret = 1;
-		error = runtime ? platform_pci_run_wake(dev, true) :
+		error = runtime ? platform_pci_run_wake(dev, true, state) :
 					platform_pci_sleep_wake(dev, true);
 		if (ret)
 			ret = error;
@@ -1695,7 +1696,7 @@ int __pci_enable_wake(struct pci_dev *de
 			dev->wakeup_prepared = true;
 	} else {
 		if (runtime)
-			platform_pci_run_wake(dev, false);
+			platform_pci_run_wake(dev, false, state);
 		else
 			platform_pci_sleep_wake(dev, false);
 		pci_pme_active(dev, false);
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -61,7 +61,7 @@ struct pci_platform_pm_ops {
 	pci_power_t (*choose_state)(struct pci_dev *dev);
 	bool (*can_wakeup)(struct pci_dev *dev);
 	int (*sleep_wake)(struct pci_dev *dev, bool enable);
-	int (*run_wake)(struct pci_dev *dev, bool enable);
+	int (*run_wake)(struct pci_dev *dev, bool enable, pci_power_t state);
 };
 
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
