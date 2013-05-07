Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3EGWSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:18:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21158 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3EGWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:18:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 1/5] PCI: Split pci_assign_unassigned_resources to per root bus
Date: Tue,  7 May 2013 15:17:30 -0700
Message-Id: <1367965054-9013-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
References: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

Before that we need to split pci_assign_unassiged_resource
to every root bus, so we can stop early for root bus without ioport
range, and still continue to retry on buses that do have ioport range.

Also later we could let root bus hot add and booting path use same code.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |  101 +++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 52 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1315,21 +1315,6 @@ static int __init pci_bus_get_depth(stru
 
 	return depth;
 }
-static int __init pci_get_max_depth(void)
-{
-	int depth = 0;
-	struct pci_bus *bus;
-
-	list_for_each_entry(bus, &pci_root_buses, node) {
-		int ret;
-
-		ret = pci_bus_get_depth(bus);
-		if (ret > depth)
-			depth = ret;
-	}
-
-	return depth;
-}
 
 /*
  * -1: undefined, will auto detect later
@@ -1354,34 +1339,41 @@ void __init pci_realloc_get_opt(char *st
 	else if (!strncmp(str, "on", 2))
 		pci_realloc_enable = user_enabled;
 }
-static bool __init pci_realloc_enabled(void)
+static bool __init pci_realloc_enabled(enum enable_type enable)
 {
-	return pci_realloc_enable >= user_enabled;
+	return enable >= user_enabled;
 }
 
-static void __init pci_realloc_detect(void)
+static enum enable_type __init pci_realloc_detect(struct pci_bus *bus,
+			 enum enable_type enable_local)
 {
 #if defined(CONFIG_PCI_IOV) && defined(CONFIG_PCI_REALLOC_ENABLE_AUTO)
-	struct pci_dev *dev = NULL;
+	struct pci_dev *dev;
 
-	if (pci_realloc_enable != undefined)
-		return;
+	if (enable_local != undefined)
+		return enable_local;
 
-	for_each_pci_dev(dev) {
+	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
 
 		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
 			struct resource *r = &dev->resource[i];
 
 			/* Not assigned, or rejected by kernel ? */
-			if (r->flags && !r->start) {
-				pci_realloc_enable = auto_enabled;
-
-				return;
-			}
+			if (r->flags && !r->start)
+				return auto_enabled;
 		}
 	}
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		struct pci_bus *child = dev->subordinate;
+
+		if (child &&
+		    pci_realloc_detect(child, enable_local) == auto_enabled)
+			return auto_enabled;
+	}
 #endif
+	return enable_local;
 }
 
 /*
@@ -1389,10 +1381,9 @@ static void __init pci_realloc_detect(vo
  * second  and later try will clear small leaf bridge res
  * will stop till to the max  deepth if can not find good one
  */
-void __init
-pci_assign_unassigned_resources(void)
+static void __init
+pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 {
-	struct pci_bus *bus;
 	LIST_HEAD(realloc_head); /* list of resources that
 					want additional resources */
 	struct list_head *add_list = NULL;
@@ -1403,15 +1394,17 @@ pci_assign_unassigned_resources(void)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	int pci_try_num = 1;
+	enum enable_type enable_local;
 
 	/* don't realloc if asked to do so */
-	pci_realloc_detect();
-	if (pci_realloc_enabled()) {
-		int max_depth = pci_get_max_depth();
+	enable_local = pci_realloc_detect(bus, pci_realloc_enable);
+	if (pci_realloc_enabled(enable_local)) {
+		int max_depth = pci_bus_get_depth(bus);
 
 		pci_try_num = max_depth + 1;
-		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-			 max_depth, pci_try_num);
+		dev_printk(KERN_DEBUG, &bus->dev,
+			   "max bus depth: %d pci_try_num: %d\n",
+			   max_depth, pci_try_num);
 	}
 
 again:
@@ -1423,12 +1416,10 @@ again:
 		add_list = &realloc_head;
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
-	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_size_bridges(bus, add_list);
+	__pci_bus_size_bridges(bus, add_list);
 
 	/* Depth last, allocate resources and update the hardware. */
-	list_for_each_entry(bus, &pci_root_buses, node)
-		__pci_bus_assign_resources(bus, add_list, &fail_head);
+	__pci_bus_assign_resources(bus, add_list, &fail_head);
 	if (add_list)
 		BUG_ON(!list_empty(add_list));
 	tried_times++;
@@ -1438,17 +1429,17 @@ again:
 		goto enable_and_dump;
 
 	if (tried_times >= pci_try_num) {
-		if (pci_realloc_enable == undefined)
-			printk(KERN_INFO "Some PCI device resources are unassigned, try booting with pci=realloc\n");
-		else if (pci_realloc_enable == auto_enabled)
-			printk(KERN_INFO "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");
+		if (enable_local == undefined)
+			dev_info(&bus->dev, "Some PCI device resources are unassigned, try booting with pci=realloc\n");
+		else if (enable_local == auto_enabled)
+			dev_info(&bus->dev, "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");
 
 		free_list(&fail_head);
 		goto enable_and_dump;
 	}
 
-	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
-			 tried_times + 1);
+	dev_printk(KERN_DEBUG, &bus->dev,
+		   "No. %d try to assign unassigned res\n", tried_times + 1);
 
 	/* third times and later will not check if it is leaf */
 	if ((tried_times + 1) > 2)
@@ -1458,12 +1449,11 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	list_for_each_entry(fail_res, &fail_head, list) {
-		bus = fail_res->dev->bus;
-		pci_bus_release_bridge_resources(bus,
+	list_for_each_entry(fail_res, &fail_head, list)
+		pci_bus_release_bridge_resources(fail_res->dev->bus,
 						 fail_res->flags & type_mask,
 						 rel_type);
-	}
+
 	/* restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res = fail_res->res;
@@ -1480,12 +1470,19 @@ again:
 
 enable_and_dump:
 	/* Depth last, update the hardware. */
-	list_for_each_entry(bus, &pci_root_buses, node)
-		pci_enable_bridges(bus);
+	pci_enable_bridges(bus);
 
 	/* dump the resource on buses */
+	pci_bus_dump_resources(bus);
+}
+
+void __init
+pci_assign_unassigned_resources(void)
+{
+	struct pci_bus *bus;
+
 	list_for_each_entry(bus, &pci_root_buses, node)
-		pci_bus_dump_resources(bus);
+		pci_assign_unassigned_root_bus_resources(bus);
 }
 
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
