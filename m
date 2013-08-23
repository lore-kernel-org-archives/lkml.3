Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3HWVZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:25:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3HWVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 09/15] PCI: convert bus code to use drv_groups
Date: Fri, 23 Aug 2013 14:24:35 -0700
Message-Id: <1377293081-10957-9-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drv_attrs field of struct bus_type is going away soon, drv_groups
should be used instead.  This converts the PCI bus code to use the
correct field.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 09db761e..a9c53f03 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -135,6 +135,7 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
 		return retval;
 	return count;
 }
+static DRIVER_ATTR(new_id, S_IWUSR, NULL, store_new_id);
 
 /**
  * store_remove_id - remove a PCI device ID from this driver
@@ -180,12 +181,14 @@ store_remove_id(struct device_driver *driver, const char *buf, size_t count)
 		return retval;
 	return count;
 }
+static DRIVER_ATTR(remove_id, S_IWUSR, NULL, store_remove_id);
 
-static struct driver_attribute pci_drv_attrs[] = {
-	__ATTR(new_id, S_IWUSR, NULL, store_new_id),
-	__ATTR(remove_id, S_IWUSR, NULL, store_remove_id),
-	__ATTR_NULL,
+static struct attribute *pci_drv_attrs[] = {
+	&driver_attr_new_id.attr,
+	&driver_attr_remove_id.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(pci_drv);
 
 /**
  * pci_match_id - See if a pci device matches a given pci_id table
@@ -1275,7 +1278,7 @@ struct bus_type pci_bus_type = {
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
 	.bus_groups	= pci_bus_groups,
-	.drv_attrs	= pci_drv_attrs,
+	.drv_groups	= pci_drv_groups,
 	.pm		= PCI_PM_OPS_PTR,
 };
 
-- 
1.8.3.rc0.20.gb99dd2e

