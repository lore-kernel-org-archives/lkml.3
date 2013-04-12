Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3DLWuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:50:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3DLWpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:45:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 15/29] PCI: Use for_each_pci_resource() in pci_assign_resource
Date: Fri, 12 Apr 2013 15:44:29 -0700
Message-Id: <1365806683-26717-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also replace dev->resource[n] with pci_dev_resource_n().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-res.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 81b88bd..94ef232 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -110,7 +110,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
-	struct resource *res = &dev->resource[resource];
+	struct resource *res = pci_dev_resource_n(dev, resource);
 	struct resource *root, *conflict;
 
 	root = pci_find_parent_resource(dev, res);
@@ -200,7 +200,7 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		int resno, resource_size_t size, resource_size_t align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t min;
 	int ret;
 
@@ -227,7 +227,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 static int _pci_assign_resource(struct pci_dev *dev, int resno,
 				resource_size_t size, resource_size_t min_align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	struct pci_bus *bus;
 	int ret;
 	char *type;
@@ -259,7 +259,7 @@ static int _pci_assign_resource(struct pci_dev *dev, int resno,
 
 int pci_assign_resource(struct pci_dev *dev, int resno)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t align, size;
 	struct pci_bus *bus;
 	int ret;
@@ -295,7 +295,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsize,
 			resource_size_t min_align)
 {
-	struct resource *res = dev->resource + resno;
+	struct resource *res = pci_dev_resource_n(dev, resno);
 	resource_size_t new_size;
 	int ret;
 
@@ -326,12 +326,10 @@ int pci_enable_resources(struct pci_dev *dev, int mask)
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	old_cmd = cmd;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+	for_each_pci_resource(dev, r, i, PCI_ALL_RES) {
 		if (!(mask & (1 << i)))
 			continue;
 
-		r = &dev->resource[i];
-
 		if (!(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
 			continue;
 		if ((i == PCI_ROM_RESOURCE) &&
-- 
1.8.1.4

