Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3EGWSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:18:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21147 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3EGWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:18:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 5/5] PCI: Retry assign unassigned resources for hotadd root bus
Date: Tue,  7 May 2013 15:17:34 -0700
Message-Id: <1367965054-9013-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
References: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let root bus hotadd path use same code for booting path.
As driver is not loaded yet, we could retry to make sure
all pci devices get resources allocated.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/pci_root.c |    2 +-
 drivers/pci/setup-bus.c |   11 +++++------
 include/linux/pci.h     |    1 +
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1331,7 +1331,7 @@ static void pci_bus_dump_resources(struc
 	}
 }
 
-static int __init pci_bus_get_depth(struct pci_bus *bus)
+static int pci_bus_get_depth(struct pci_bus *bus)
 {
 	int depth = 0;
 	struct pci_dev *dev;
@@ -1365,7 +1365,7 @@ enum enable_type {
 	auto_enabled,
 };
 
-static enum enable_type pci_realloc_enable __initdata = undefined;
+static enum enable_type pci_realloc_enable = undefined;
 void __init pci_realloc_get_opt(char *str)
 {
 	if (!strncmp(str, "off", 3))
@@ -1373,12 +1373,12 @@ void __init pci_realloc_get_opt(char *st
 	else if (!strncmp(str, "on", 2))
 		pci_realloc_enable = user_enabled;
 }
-static bool __init pci_realloc_enabled(enum enable_type enable)
+static bool pci_realloc_enabled(enum enable_type enable)
 {
 	return enable >= user_enabled;
 }
 
-static enum enable_type __init pci_realloc_detect(struct pci_bus *bus,
+static enum enable_type pci_realloc_detect(struct pci_bus *bus,
 			 enum enable_type enable_local)
 {
 #if defined(CONFIG_PCI_IOV) && defined(CONFIG_PCI_REALLOC_ENABLE_AUTO)
@@ -1442,8 +1442,7 @@ static unsigned long pci_bus_res_type_ma
  * second  and later try will clear small leaf bridge res
  * will stop till to the max  deepth if can not find good one
  */
-static void __init
-pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
+void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 {
 	LIST_HEAD(realloc_head); /* list of resources that
 					want additional resources */
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -535,7 +535,7 @@ static int acpi_pci_root_add(struct acpi
 
 	if (system_state != SYSTEM_BOOTING) {
 		pcibios_resource_survey_bus(root->bus);
-		pci_assign_unassigned_bus_resources(root->bus);
+		pci_assign_unassigned_root_bus_resources(root->bus);
 	}
 
 	pci_bus_add_devices(root->bus);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1002,6 +1002,7 @@ int pci_claim_resource(struct pci_dev *,
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pci_assign_unassigned_bus_resources(struct pci_bus *bus);
+void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus);
 void pdev_enable_device(struct pci_dev *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
