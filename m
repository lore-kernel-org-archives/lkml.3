Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986Ab3CMXch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:32:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17606 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964906Ab3CMX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 22/27] PCI: Add helpers to add addon_resource
Date: Wed, 13 Mar 2013 16:28:17 -0700
Message-Id: <1363217302-14383-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper to put add_on resources into pci devices resource list.

-v2: change one function to static according to Fengguang.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    5 ++++
 2 files changed, 73 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9e659c7..f3038c2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -144,6 +144,74 @@ int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
 	return -1;
 }
 
+static struct pci_dev_addon_resource *pci_alloc_dev_addon_resource(
+		 struct pci_dev *dev, int addr, char *name)
+{
+	struct pci_dev_addon_resource *addon_res;
+
+	addon_res = kzalloc(sizeof(*addon_res), GFP_KERNEL);
+
+	if (!addon_res)
+		return NULL;
+
+	addon_res->reg_addr = addr;
+
+	if (name)
+		addon_res->res.name = name;
+	else
+		addon_res->res.name = pci_name(dev);
+
+	list_add_tail(&addon_res->list, &dev->addon_resources);
+
+	return addon_res;
+}
+
+struct pci_dev_addon_resource *pci_add_dev_addon_fixed_resource(
+		 struct pci_dev *dev, int start, int size, int flags,
+		 int addr, char *name)
+{
+	struct pci_dev_addon_resource *addon_res;
+	struct resource *res;
+
+	addon_res = pci_alloc_dev_addon_resource(dev, addr, name);
+	if (addon_res)
+		return NULL;
+
+	res = &addon_res->res;
+	res->start = start;
+	res->end = start + size - 1;
+	res->flags = flags | IORESOURCE_PCI_FIXED;
+
+	dev_printk(KERN_DEBUG, &dev->dev,
+		   "addon fixed resource %s %pR added\n", res->name, res);
+
+	return addon_res;
+}
+
+struct pci_dev_addon_resource *pci_add_dev_addon_resource(struct pci_dev *dev,
+		 int addr, int size, struct resource_ops *ops, char *name)
+{
+	struct pci_dev_addon_resource *addon_res;
+	struct resource *res;
+
+	addon_res = pci_alloc_dev_addon_resource(dev, addr, name);
+	if (!addon_res)
+		return NULL;
+
+	res = &addon_res->res;
+	if (ops) {
+		addon_res->ops = ops;
+		addon_res->size = size;
+		ops->read(dev, res, addr);
+	} else
+		__pci_read_base(dev, pci_bar_unknown, res, addr);
+
+	dev_printk(KERN_DEBUG, &dev->dev,
+		   "addon resource %s %pR added\n", res->name, res);
+
+	return addon_res;
+}
+
 static void pci_release_dev_addon_resource(struct pci_dev *dev)
 {
 	struct pci_dev_addon_resource *addon_res, *tmp;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b73245b..624c62f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -379,6 +379,11 @@ struct pci_dev_addon_resource {
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
 int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
+struct pci_dev_addon_resource *pci_add_dev_addon_fixed_resource(
+		 struct pci_dev *dev, int start, int size, int flags,
+		 int addr, char *name);
+struct pci_dev_addon_resource *pci_add_dev_addon_resource(struct pci_dev *dev,
+		 int addr, int size, struct resource_ops *ops, char *name);
 
 #define PCI_STD_RES		(1<<0)
 #define PCI_ROM_RES		(1<<1)
-- 
1.7.10.4

