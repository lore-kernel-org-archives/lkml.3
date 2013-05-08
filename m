Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3EHC6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab3EHC6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:58:09 -0400
Subject: [PATCH v2 5/8] pci: Add reset_slot option to pci_dev_reset
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 20:58:07 -0600
Message-ID: <20130508025807.30771.14527.stgit@bling.home>
In-Reply-To: <20130508025339.30771.61937.stgit@bling.home>
References: <20130508025339.30771.61937.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hotplug controller provides a way to reset a slot, use that
before a direct parent bus reset.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d0f313f..f5035f5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pci_hotplug.h>
 #include <asm-generic/pci-bridge.h>
 #include <asm/setup.h>
 #include "pci.h"
@@ -3251,6 +3252,20 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 	return 0;
 }
 
+static int pci_dev_reset_slot_function(struct pci_dev *dev, int probe)
+{
+	struct pci_dev *pdev;
+
+	if (dev->subordinate || !dev->slot)
+		return -ENOTTY;
+
+	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
+		if (pdev != dev && pdev->slot == dev->slot)
+			return -ENOTTY;
+
+	return pci_hp_reset_slot(dev->slot->hotplug, probe);
+}
+
 static int __pci_dev_reset(struct pci_dev *dev, int probe)
 {
 	int rc;
@@ -3273,6 +3288,10 @@ static int __pci_dev_reset(struct pci_dev *dev, int probe)
 	if (rc != -ENOTTY)
 		goto done;
 
+	rc = pci_dev_reset_slot_function(dev, probe);
+	if (rc != -ENOTTY)
+		goto done;
+
 	rc = pci_parent_bus_reset(dev, probe);
 done:
 	return rc;

