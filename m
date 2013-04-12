Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3DLWpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:45:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46631 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3DLWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:45:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 23/29] PCI: Treat addon res as std resources
Date: Fri, 12 Apr 2013 15:44:37 -0700
Message-Id: <1365806683-26717-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace PCI_STD_... with PCI_STD..._ADDON_... in the loop
of for_each_pci_resource.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c                | 2 +-
 drivers/pci/hotplug/acpiphp_glue.c | 2 +-
 drivers/pci/pci-driver.c           | 3 ++-
 drivers/pci/pci.c                  | 6 +++---
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 4dafa08..a3a7e89 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -240,7 +240,7 @@ static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 	struct resource *r;
 
 	pci_read_config_word(dev, PCI_COMMAND, &command);
-	for_each_pci_resource(dev, r, idx, PCI_STD_IOV_RES) {
+	for_each_pci_resource(dev, r, idx, PCI_STD_IOV_ADDON_RES) {
 		if (r->parent)	/* Already allocated */
 			continue;
 		if (!r->start)	/* Address not assigned at all */
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index c35b2b1..702871c 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1088,7 +1088,7 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 	struct resource *res;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		for_each_pci_resource(dev, res, i, PCI_STD_ROM_IOV_RES) {
+		for_each_pci_resource(dev, res, i, PCI_STD_ROM_IOV_ADDON_RES) {
 			if ((res->flags & type_mask) && !res->start &&
 					res->end) {
 				/* Could not assign a required resources
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 009f6c2..73238a8 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1173,7 +1173,8 @@ pci_dev_driver(const struct pci_dev *dev)
 		struct resource *res;
 		int i;
 
-		for_each_pci_resource((struct pci_dev *)dev, res, i, PCI_STD_ROM_RES)
+		for_each_pci_resource((struct pci_dev *)dev, res, i,
+					 PCI_STD_ROM_ADDON_RES)
 			if (res->flags & IORESOURCE_BUSY)
 				return &pci_compat_driver;
 	}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d6203e9..c1010be 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -442,7 +442,7 @@ pci_restore_bars(struct pci_dev *dev)
 	int i;
 	struct resource *res;
 
-	for_each_pci_resource(dev, res, i, PCI_STD_ROM_IOV_RES)
+	for_each_pci_resource(dev, res, i, PCI_STD_ROM_IOV_ADDON_RES)
 		pci_update_resource(dev, i);
 }
 
@@ -1172,7 +1172,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 		return 0;		/* already enabled */
 
 	/* only skip sriov related */
-	for_each_pci_resource(dev, res, i, PCI_STD_ROM_BRIDGE_RES) {
+	for_each_pci_resource(dev, res, i, PCI_STD_ROM_BRIDGE_ADDON_RES) {
 		/* TODO: check i with bits of bars */
 		if (res->flags & flags)
 			bars |= (1 << i);
@@ -3782,7 +3782,7 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
 
-	for_each_pci_resource(dev, r, i, PCI_STD_ROM_IOV_RES) {
+	for_each_pci_resource(dev, r, i, PCI_STD_ROM_IOV_ADDON_RES) {
 		r = &dev->resource[i];
 		if (!(r->flags & IORESOURCE_MEM))
 			continue;
-- 
1.8.1.4

