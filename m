Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3A2Eej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:34:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:65168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab3A2Eeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,556,1355126400"; 
   d="scan'208";a="253942319"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 2/4] PCI: Rename pci_dev->runtime_d3cold to pci_dev->set_d3cold
Date: Tue, 29 Jan 2013 12:34:16 +0800
Message-Id: <1359434058-15918-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
References: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use this flag for system suspend in addition to runtime suspend.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-driver.c |    2 +-
 drivers/pci/pci.c        |    6 +++---
 include/linux/pci.h      |    7 +++----
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1036,7 +1036,7 @@ static int pci_pm_runtime_resume(struct
 
 	rc = pm->runtime_resume(dev);
 
-	pci_dev->runtime_d3cold = false;
+	pci_dev->set_d3cold = false;
 
 	return rc;
 }
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -681,7 +681,7 @@ static void __pci_start_power_transition
 		 * devices powered on/off by corresponding bridge,
 		 * because have already delayed for the bridge.
 		 */
-		if (dev->runtime_d3cold) {
+		if (dev->set_d3cold) {
 			msleep(dev->d3cold_delay);
 			/*
 			 * When powering on a bridge from D3cold, the
@@ -1833,7 +1833,7 @@ int pci_finish_runtime_suspend(struct pc
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
-	dev->runtime_d3cold = target_state == PCI_D3cold;
+	dev->set_d3cold = target_state == PCI_D3cold;
 
 	__pci_enable_wake(dev, target_state, true, pci_dev_run_wake(dev));
 
@@ -1841,7 +1841,7 @@ int pci_finish_runtime_suspend(struct pc
 
 	if (error) {
 		__pci_enable_wake(dev, target_state, true, false);
-		dev->runtime_d3cold = false;
+		dev->set_d3cold = false;
 	}
 
 	return error;
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -263,10 +263,9 @@ struct pci_dev {
 	unsigned int	mmio_always_on:1;	/* disallow turning off io/mem
 						   decoding during bar sizing */
 	unsigned int	wakeup_prepared:1;
-	unsigned int	runtime_d3cold:1;	/* whether go through runtime
-						   D3cold, not set for devices
-						   powered on/off by the
-						   corresponding bridge */
+	unsigned int	set_d3cold:1;	/* whether go through runtime D3cold,
+					   not set for devices powered on/off
+					   by the corresponding bridge */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 
