Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3HAQzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab3HAQzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:55:36 -0400
Subject: [PATCH v3 4/9] pci: Add slot reset option to pci_dev_reset
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 01 Aug 2013 10:55:33 -0600
Message-ID: <20130801165533.16145.14078.stgit@bling.home>
In-Reply-To: <20130801164652.16145.79918.stgit@bling.home>
References: <20130801164652.16145.79918.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hotplug controller provides a way to reset a slot, use that
before a direct parent bus reset.  Like the bus reset option, this is
only available when a single pci_dev occupies the slot.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index bfd629c..db90692 100644
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
@@ -3317,6 +3318,35 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 	return 0;
 }
 
+static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, int probe)
+{
+	int rc = -ENOTTY;
+
+	if (!hotplug || !try_module_get(hotplug->ops->owner))
+		return rc;
+
+	if (hotplug->ops->reset_slot)
+		rc = hotplug->ops->reset_slot(hotplug, probe);
+
+	module_put(hotplug->ops->owner);
+
+	return rc;
+}
+
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
+	return pci_reset_hotplug_slot(dev->slot->hotplug, probe);
+}
+
 static int __pci_dev_reset(struct pci_dev *dev, int probe)
 {
 	int rc;
@@ -3339,6 +3369,10 @@ static int __pci_dev_reset(struct pci_dev *dev, int probe)
 	if (rc != -ENOTTY)
 		goto done;
 
+	rc = pci_dev_reset_slot_function(dev, probe);
+	if (rc != -ENOTTY)
+		goto done;
+
 	rc = pci_parent_bus_reset(dev, probe);
 done:
 	return rc;

