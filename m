Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3A2EfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:35:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:20512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3A2Eec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:34:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,556,1355126400"; 
   d="scan'208";a="253942326"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 3/4] PCI/PM: Set pci_dev->set_d3cold in pci_set_power_state
Date: Tue, 29 Jan 2013 12:34:17 +0800
Message-Id: <1359434058-15918-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
References: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because now pci_dev->set_d3cold is only used after
pci_set_power_state(, PCI_D3cold) and before pci_set_power_state(,
PCI_D0).  And we will use pci_dev->set_d3cold for D3cold support
during system suspend too, but now pci_dev->set_d3cold is set only in
runtime power management code path now.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-driver.c |    2 --
 drivers/pci/pci.c        |   12 +++++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1036,8 +1036,6 @@ static int pci_pm_runtime_resume(struct
 
 	rc = pm->runtime_resume(dev);
 
-	pci_dev->set_d3cold = false;
-
 	return rc;
 }
 
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -775,6 +775,9 @@ int pci_set_power_state(struct pci_dev *
 	if (dev->current_state == state)
 		return 0;
 
+	if (state == PCI_D3cold)
+		dev->set_d3cold = true;
+
 	__pci_start_power_transition(dev, state);
 
 	/* This device is quirked not to be put into D3, so
@@ -798,6 +801,9 @@ int pci_set_power_state(struct pci_dev *
 	if (!error && dev->bus->self)
 		pcie_aspm_powersave_config_link(dev->bus->self);
 
+	if (error || state != PCI_D3cold)
+		dev->set_d3cold = false;
+
 	return error;
 }
 
@@ -1833,16 +1839,12 @@ int pci_finish_runtime_suspend(struct pc
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
-	dev->set_d3cold = target_state == PCI_D3cold;
-
 	__pci_enable_wake(dev, target_state, true, pci_dev_run_wake(dev));
 
 	error = pci_set_power_state(dev, target_state);
 
-	if (error) {
+	if (error)
 		__pci_enable_wake(dev, target_state, true, false);
-		dev->set_d3cold = false;
-	}
 
 	return error;
 }
