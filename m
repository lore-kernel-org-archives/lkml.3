Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaL3IVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 03:21:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28118 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaL3IVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 03:21:07 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] PCI: export pci device assignment info as read only via sysfs
Date: Tue, 30 Dec 2014 17:21:47 +0900
Message-Id: <1419927707-14462-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports assignment flag of PCI device via sysfs, so user
space application could know if PCI device was assigned to guest OS
or not via interface as following from viewpoint of host device
management:

 PCI device was assigned to guest OS
 $cat /sys/devices/pci0000:00/0000:00:1f.3/assigned
 1

 PCI device isn't assigned to guest OS
 $cat /sys/devices/pci0000:00/0000:00:1f.3/assigned
 0

Compiled and tested with v3.18.1

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/pci/pci-sysfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 2c6643f..0ac3780 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -547,6 +547,15 @@ static ssize_t driver_override_show(struct device *dev,
 }
 static DEVICE_ATTR_RW(driver_override);
 
+static ssize_t assigned_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%d\n", pci_is_dev_assigned(pdev) ? 1 : 0);
+}
+static DEVICE_ATTR_RO(assigned);
+
 static struct attribute *pci_dev_attrs[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_vendor.attr,
@@ -573,6 +582,7 @@ static struct attribute *pci_dev_attrs[] = {
 	&dev_attr_devspec.attr,
 #endif
 	&dev_attr_driver_override.attr,
+	&dev_attr_assigned.attr,
 	NULL,
 };
 
-- 
1.8.3.1

