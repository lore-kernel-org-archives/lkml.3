Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab3CMX3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:29:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51512 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab3CMX3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:29:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 24/27] PCI: Assign/update resource to addon_res
Date: Wed, 13 Mar 2013 16:28:19 -0700
Message-Id: <1363217302-14383-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend pci_update_resource to check resno and call addon resources
ops to update bar for it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-res.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 94ef232..6a85dcf 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -35,7 +35,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	u32 new, check, mask;
 	int reg;
 	enum pci_bar_type type;
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 
 	/*
 	 * Ignore resources for unimplemented BARs and unused resource slots
@@ -52,6 +52,21 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	if (res->flags & IORESOURCE_PCI_FIXED)
 		return;
 
+	if (resno >= PCI_NUM_RESOURCES) {
+		struct pci_dev_addon_resource *addon_res;
+
+		addon_res = to_pci_dev_addon_resource(res);
+		reg = addon_res->reg_addr;
+		if (addon_res->ops) {
+			addon_res->ops->write(dev, res, reg);
+			return;
+		}
+	} else
+		reg = pci_resource_bar(dev, resno, &type);
+
+	if (!reg)
+		return;
+
 	pcibios_resource_to_bus(dev, &region, res);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
@@ -60,9 +75,6 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	else
 		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 
-	reg = pci_resource_bar(dev, resno, &type);
-	if (!reg)
-		return;
 	if (type != pci_bar_unknown) {
 		if (!(res->flags & IORESOURCE_ROM_ENABLE))
 			return;
@@ -286,7 +298,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
-		if (resno < PCI_BRIDGE_RESOURCES)
+		if (!is_pci_bridge_resource_idx(resno))
 			pci_update_resource(dev, resno);
 	}
 	return ret;
@@ -311,7 +323,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
-		if (resno < PCI_BRIDGE_RESOURCES)
+		if (!is_pci_bridge_resource_idx(resno))
 			pci_update_resource(dev, resno);
 	}
 	return ret;
-- 
1.7.10.4

