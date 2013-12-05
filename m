Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3LEMAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:00:07 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:38538 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3LEMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:00:05 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
CC: <linux-pci@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 5/9] parisc/pci: Repalce local inline function with PCI standard marco
Date: Thu, 5 Dec 2013 19:59:38 +0800
Message-ID: <1386244778-22820-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repalce local inline function is_pci_dev() with PCI standard marco
dev_is_pci().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/parisc/kernel/drivers.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 14285ca..dba508f 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -282,18 +282,6 @@ find_pa_parent_type(const struct parisc_device *padev, int type)
 	return NULL;
 }
 
-#ifdef CONFIG_PCI
-static inline int is_pci_dev(struct device *dev)
-{
-	return dev->bus == &pci_bus_type;
-}
-#else
-static inline int is_pci_dev(struct device *dev)
-{
-	return 0;
-}
-#endif
-
 /*
  * get_node_path fills in @path with the firmware path to the device.
  * Note that if @node is a parisc device, we don't fill in the 'mod' field.
@@ -306,7 +294,7 @@ static void get_node_path(struct device *dev, struct hardware_path *path)
 	int i = 5;
 	memset(&path->bc, -1, 6);
 
-	if (is_pci_dev(dev)) {
+	if (dev_is_pci(dev)) {
 		unsigned int devfn = to_pci_dev(dev)->devfn;
 		path->mod = PCI_FUNC(devfn);
 		path->bc[i--] = PCI_SLOT(devfn);
@@ -314,7 +302,7 @@ static void get_node_path(struct device *dev, struct hardware_path *path)
 	}
 
 	while (dev != &root) {
-		if (is_pci_dev(dev)) {
+		if (dev_is_pci(dev)) {
 			unsigned int devfn = to_pci_dev(dev)->devfn;
 			path->bc[i--] = PCI_SLOT(devfn) | (PCI_FUNC(devfn)<< 5);
 		} else if (dev->bus == &parisc_bus_type) {
@@ -695,7 +683,7 @@ static int check_parent(struct device * dev, void * data)
 		if (dev->bus == &parisc_bus_type) {
 			if (match_parisc_device(dev, d->index, d->modpath))
 				d->dev = dev;
-		} else if (is_pci_dev(dev)) {
+		} else if (dev_is_pci(dev)) {
 			if (match_pci_device(dev, d->index, d->modpath))
 				d->dev = dev;
 		} else if (dev->bus == NULL) {
@@ -753,7 +741,7 @@ struct device *hwpath_to_device(struct hardware_path *modpath)
 		if (!parent)
 			return NULL;
 	}
-	if (is_pci_dev(parent)) /* pci devices already parse MOD */
+	if (dev_is_pci(parent)) /* pci devices already parse MOD */
 		return parent;
 	else
 		return parse_tree_node(parent, 6, modpath);
@@ -772,7 +760,7 @@ void device_to_hwpath(struct device *dev, struct hardware_path *path)
 		padev = to_parisc_device(dev);
 		get_node_path(dev->parent, path);
 		path->mod = padev->hw_path;
-	} else if (is_pci_dev(dev)) {
+	} else if (dev_is_pci(dev)) {
 		get_node_path(dev, path);
 	}
 }
-- 
1.7.1


