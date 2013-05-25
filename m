Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3EYNwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:52:16 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45000 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3EYNwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:52:11 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donald Dutile <ddutile@redhat.com>, Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v3, part1 10/10] PCI, IOV: hide remove and rescan sysfs interfaces for SR-IOV virtual functions
Date: Sat, 25 May 2013 21:48:38 +0800
Message-Id: <1369489718-25869-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices for SR-IOV virtual functions should only be created/
destroyed by pci_enable_sriov()/pci_disable_sriov() because special
data structures are assoicated with SR-IOV virtual functions.
So hide hotplug related sysfs interfaces "remove" and "rescan" for
SR-IOV virtual functions, otherwise it may causes memory leakage
and other issues.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/iov.c       |  5 ++---
 drivers/pci/pci-sysfs.c | 30 ++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 3e33499..5eb8165 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -80,6 +80,8 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
 	pci_setup_device(virtfn);
 	virtfn->dev.parent = dev->dev.parent;
+	virtfn->physfn = pci_dev_get(dev);
+	virtfn->is_virtfn = 1;
 
 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
 		res = dev->resource + PCI_IOV_RESOURCES + i;
@@ -101,9 +103,6 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	pci_device_add(virtfn, virtfn->bus);
 	mutex_unlock(&iov->dev->sriov->lock);
 
-	virtfn->physfn = pci_dev_get(dev);
-	virtfn->is_virtfn = 1;
-
 	rc = pci_bus_add_device(virtfn);
 	sprintf(buf, "virtfn%u", id);
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5b4a9d9..403da60 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -325,6 +325,8 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 	}
 	return count;
 }
+struct device_attribute dev_rescan_attr = __ATTR(rescan, (S_IWUSR|S_IWGRP),
+						 NULL, dev_rescan_store);
 
 static void remove_callback(struct device *dev)
 {
@@ -354,6 +356,8 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 		count = ret;
 	return count;
 }
+struct device_attribute dev_remove_attr = __ATTR(remove, (S_IWUSR|S_IWGRP),
+						 NULL, remove_store);
 
 static ssize_t
 dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
@@ -504,8 +508,6 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
-	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
-	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
 	__ATTR(d3cold_allowed, 0644, d3cold_allowed_show, d3cold_allowed_store),
 #endif
@@ -1463,6 +1465,29 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
 	return a->mode;
 }
 
+static struct attribute *pci_dev_hp_attrs[] = {
+	&dev_remove_attr.attr,
+	&dev_rescan_attr.attr,
+	NULL,
+};
+
+static umode_t pci_dev_hp_attrs_are_visible(struct kobject *kobj,
+						struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev->is_virtfn)
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group pci_dev_hp_attr_group = {
+	.attrs = pci_dev_hp_attrs,
+	.is_visible = pci_dev_hp_attrs_are_visible,
+};
+
 #ifdef CONFIG_PCI_IOV
 static struct attribute *sriov_dev_attrs[] = {
 	&sriov_totalvfs_attr.attr,
@@ -1494,6 +1519,7 @@ static struct attribute_group pci_dev_attr_group = {
 
 static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_attr_group,
+	&pci_dev_hp_attr_group,
 #ifdef CONFIG_PCI_IOV
 	&sriov_dev_attr_group,
 #endif
-- 
1.8.1.2

