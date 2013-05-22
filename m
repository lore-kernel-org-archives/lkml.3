Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3EVGjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:39:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3EVGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:39:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 5/8] PCI: Skip IORESOURCE_IO allocation for root bus without ioport range
Date: Tue, 21 May 2013 23:38:45 -0700
Message-Id: <1369204728-11165-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
References: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BenH reported that there is some assign unassigned resource problem
in powerpc.

It turns out after
| commit 0c5be0cb0edfe3b5c4b62eac68aa2aa15ec681af
| Date:   Thu Feb 23 19:23:29 2012 -0800
|
|    PCI: Retry on IORESOURCE_IO type allocations

even the root bus does not have io port range, it will keep retrying
to realloc with mmio.

Current retry logic is : try with must+optional at first, and if
it fails will try must then try to extend must with optional.
That will fail as mmio-non-pref and mmio-pref for bridge will
be next to each other. So we have no chance to extend mmio-non-pref.

This will be become more often when we have x86 8 sockets or 32 sockets
system, and those system will have one root bus per socket.
They will have some root buses do not have ioport range.

We should not fall into retry in this case, as root bus does
not io port range.

We check if the root bus has ioport range, and set bus_res_type_mask,
and pass it to assign_resources and don't add ioport res to failed list
for root bus that does not have ioport range.
So even BIOS set wrong value to pci devices and bridges will still
get cleared.

For the retry failing, we could allocate mmio-non-pref bottom-up
and mmio-pref will be top-down, but that is not easy and could not be
material for v3.10.

-v2: remove wrong __init with pci_bus_res_type_mask()
     don't check bridge size/flags, and clear bus io resources.
-v3: change to skip adding to failed_list instead.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   86 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -272,7 +272,8 @@ out:
  * requests that could not satisfied to the failed_list.
  */
 static void assign_requested_resources_sorted(struct list_head *head,
-				 struct list_head *fail_head)
+				 struct list_head *fail_head,
+				 unsigned long bus_res_type_mask)
 {
 	struct resource *res;
 	struct pci_dev_resource *dev_res;
@@ -288,8 +289,19 @@ static void assign_requested_resources_s
 				 * if the failed res is for ROM BAR, and it will
 				 * be enabled later, don't add it to the list
 				 */
-				if (!((idx == PCI_ROM_RESOURCE) &&
-				      (!(res->flags & IORESOURCE_ROM_ENABLE))))
+				bool is_rom_res_not_enabled =
+					 (idx == PCI_ROM_RESOURCE) &&
+					 (!(res->flags & IORESOURCE_ROM_ENABLE));
+				/*
+				 * if the failed res is io port, but bus does
+				 * not have io port support, don't add it
+				 */
+				bool is_ioport_res_without_bus_support =
+					 (!(bus_res_type_mask & IORESOURCE_IO)) &&
+					 (res->flags & IORESOURCE_IO);
+
+				if (!is_rom_res_not_enabled &&
+				    !is_ioport_res_without_bus_support)
 					add_to_list(fail_head,
 						    dev_res->dev, res,
 						    0 /* dont care */,
@@ -302,7 +314,8 @@ static void assign_requested_resources_s
 
 static void __assign_resources_sorted(struct list_head *head,
 				 struct list_head *realloc_head,
-				 struct list_head *fail_head)
+				 struct list_head *fail_head,
+				 unsigned long bus_res_type_mask)
 {
 	/*
 	 * Should not assign requested resources at first.
@@ -336,7 +349,8 @@ static void __assign_resources_sorted(st
 							dev_res->res);
 
 	/* Try updated head list with add_size added */
-	assign_requested_resources_sorted(head, &local_fail_head);
+	assign_requested_resources_sorted(head, &local_fail_head,
+					  bus_res_type_mask);
 
 	/* all assigned with add_size ? */
 	if (list_empty(&local_fail_head)) {
@@ -365,7 +379,8 @@ static void __assign_resources_sorted(st
 
 requested_and_reassign:
 	/* Satisfy the must-have resource requests */
-	assign_requested_resources_sorted(head, fail_head);
+	assign_requested_resources_sorted(head, fail_head,
+					  bus_res_type_mask);
 
 	/* Try to satisfy any additional optional resource
 		requests */
@@ -376,18 +391,21 @@ requested_and_reassign:
 
 static void pdev_assign_resources_sorted(struct pci_dev *dev,
 				 struct list_head *add_head,
-				 struct list_head *fail_head)
+				 struct list_head *fail_head,
+				 unsigned long bus_res_type_mask)
 {
 	LIST_HEAD(head);
 
 	__dev_sort_resources(dev, &head);
-	__assign_resources_sorted(&head, add_head, fail_head);
+	__assign_resources_sorted(&head, add_head, fail_head,
+					bus_res_type_mask);
 
 }
 
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 					 struct list_head *realloc_head,
-					 struct list_head *fail_head)
+					 struct list_head *fail_head,
+					 unsigned long bus_res_type_mask)
 {
 	struct pci_dev *dev;
 	LIST_HEAD(head);
@@ -395,7 +413,8 @@ static void pbus_assign_resources_sorted
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		__dev_sort_resources(dev, &head);
 
-	__assign_resources_sorted(&head, realloc_head, fail_head);
+	__assign_resources_sorted(&head, realloc_head, fail_head,
+					bus_res_type_mask);
 }
 
 void pci_setup_cardbus(struct pci_bus *bus)
@@ -1117,19 +1136,22 @@ EXPORT_SYMBOL(pci_bus_size_bridges);
 
 static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 					 struct list_head *realloc_head,
-					 struct list_head *fail_head)
+					 struct list_head *fail_head,
+					 unsigned long bus_res_type_mask)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
 
-	pbus_assign_resources_sorted(bus, realloc_head, fail_head);
+	pbus_assign_resources_sorted(bus, realloc_head, fail_head,
+					bus_res_type_mask);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		b = dev->subordinate;
 		if (!b)
 			continue;
 
-		__pci_bus_assign_resources(b, realloc_head, fail_head);
+		__pci_bus_assign_resources(b, realloc_head, fail_head,
+						 bus_res_type_mask);
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
@@ -1151,24 +1173,28 @@ static void __ref __pci_bus_assign_resou
 
 void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 {
-	__pci_bus_assign_resources(bus, NULL, NULL);
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	__pci_bus_assign_resources(bus, NULL, NULL, type_mask);
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 					 struct list_head *add_head,
-					 struct list_head *fail_head)
+					 struct list_head *fail_head,
+					 unsigned long bus_res_type_mask)
 {
 	struct pci_bus *b;
 
 	pdev_assign_resources_sorted((struct pci_dev *)bridge,
-					 add_head, fail_head);
+				     add_head, fail_head, bus_res_type_mask);
 
 	b = bridge->subordinate;
 	if (!b)
 		return;
 
-	__pci_bus_assign_resources(b, add_head, fail_head);
+	__pci_bus_assign_resources(b, add_head, fail_head, bus_res_type_mask);
 
 	switch (bridge->class >> 8) {
 	case PCI_CLASS_BRIDGE_PCI:
@@ -1385,6 +1411,21 @@ static enum enable_type __init pci_reall
 }
 #endif
 
+static unsigned long pci_bus_res_type_mask(struct pci_bus *bus)
+{
+	int i;
+	struct resource *r;
+	unsigned long mask = 0;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	pci_bus_for_each_resource(bus, r, i)
+		if (r)
+			mask |= r->flags & type_mask;
+
+	return mask;
+}
+
 /*
  * first try will not touch pci bridge res
  * second  and later try will clear small leaf bridge res
@@ -1404,6 +1445,7 @@ pci_assign_unassigned_root_bus_resources
 				  IORESOURCE_PREFETCH;
 	int pci_try_num = 1;
 	enum enable_type enable_local;
+	unsigned long bus_res_type_mask = pci_bus_res_type_mask(bus);
 
 	/* don't realloc if asked to do so */
 	enable_local = pci_realloc_detect(bus, pci_realloc_enable);
@@ -1428,7 +1470,8 @@ again:
 	__pci_bus_size_bridges(bus, add_list);
 
 	/* Depth last, allocate resources and update the hardware. */
-	__pci_bus_assign_resources(bus, add_list, &fail_head);
+	__pci_bus_assign_resources(bus, add_list, &fail_head,
+				   bus_res_type_mask);
 	if (add_list)
 		BUG_ON(!list_empty(add_list));
 	tried_times++;
@@ -1504,10 +1547,12 @@ void pci_assign_unassigned_bridge_resour
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
+	unsigned long bus_res_type_mask = pci_bus_res_type_mask(bridge->bus);
 
 again:
 	__pci_bus_size_bridges(parent, &add_list);
-	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
+	__pci_bridge_assign_resources(bridge, &add_list, &fail_head,
+					bus_res_type_mask);
 	BUG_ON(!list_empty(&add_list));
 	tried_times++;
 
@@ -1562,6 +1607,7 @@ void pci_assign_unassigned_bus_resources
 	struct pci_dev *dev;
 	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
+	unsigned long bus_res_type_mask = pci_bus_res_type_mask(bus);
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
@@ -1571,6 +1617,6 @@ void pci_assign_unassigned_bus_resources
 				__pci_bus_size_bridges(dev->subordinate,
 							 &add_list);
 	up_read(&pci_bus_sem);
-	__pci_bus_assign_resources(bus, &add_list, NULL);
+	__pci_bus_assign_resources(bus, &add_list, NULL, bus_res_type_mask);
 	BUG_ON(!list_empty(&add_list));
 }
