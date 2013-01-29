Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3A2Eel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:34:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:65168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab3A2Eec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:34:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,556,1355126400"; 
   d="scan'208";a="253942330"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 4/4] PCI/PM: Enable D3cold support for system suspend
Date: Tue, 29 Jan 2013 12:34:18 +0800
Message-Id: <1359434058-15918-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
References: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device may need to be put in D3cold on some platforms, especially
because we treat ACPI_STATE_D3 as ACPI_STATE_D3_COLD now.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-driver.c |    5 +++++
 drivers/pci/pci.c        |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -579,6 +579,7 @@ static bool pci_has_legacy_pm_support(st
 static int pci_pm_prepare(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	int error = 0;
 
 	/*
@@ -592,6 +593,10 @@ static int pci_pm_prepare(struct device
 	 */
 	pm_runtime_resume(dev);
 
+	if (!pci_dev->d3cold_allowed)
+		pci_dev->no_d3cold = true;
+	else
+		pci_dev->no_d3cold = false;
 	if (drv && drv->pm && drv->pm->prepare)
 		error = drv->pm->prepare(dev);
 
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1798,10 +1798,6 @@ int pci_prepare_to_sleep(struct pci_dev
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
-	/* D3cold during system suspend/hibernate is not supported */
-	if (target_state > PCI_D3hot)
-		target_state = PCI_D3hot;
-
 	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
 
 	error = pci_set_power_state(dev, target_state);
