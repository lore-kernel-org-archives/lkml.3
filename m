Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3HWVYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:24:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3HWVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 01/15] PCI: convert bus code to use bus_groups
Date: Fri, 23 Aug 2013 14:24:27 -0700
Message-Id: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bus_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the PCI bus code to use the
correct field.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |  2 +-
 drivers/pci/pci-sysfs.c  | 16 +++++++++++++---
 drivers/pci/pci.h        |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e6515e21..09db761e 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1274,7 +1274,7 @@ struct bus_type pci_bus_type = {
 	.remove		= pci_device_remove,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
-	.bus_attrs	= pci_bus_attrs,
+	.bus_groups	= pci_bus_groups,
 	.drv_attrs	= pci_drv_attrs,
 	.pm		= PCI_PM_OPS_PTR,
 };
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c0dbe1f6..f0195946 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -302,10 +302,20 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 	}
 	return count;
 }
+static BUS_ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store);
 
-struct bus_attribute pci_bus_attrs[] = {
-	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store),
-	__ATTR_NULL
+struct attribute *pci_bus_attrs[] = {
+	&bus_attr_rescan.attr,
+	NULL,
+};
+
+static const struct attribute_group pci_bus_group = {
+	.attrs = pci_bus_attrs,
+};
+
+const struct attribute_group *pci_bus_groups[] = {
+	&pci_bus_group,
+	NULL,
 };
 
 static ssize_t
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d1182c4a..62bcf2bd 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -153,7 +153,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute pcibus_dev_attrs[];
 extern struct device_type pci_dev_type;
-extern struct bus_attribute pci_bus_attrs[];
+extern const struct attribute_group *pci_bus_groups[];
 
 
 /**
-- 
1.8.3.rc0.20.gb99dd2e

