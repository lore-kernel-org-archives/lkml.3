Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3EVGkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:40:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28783 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3EVGkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:40:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 4/8] PCI: Split pci_assign_unassigned_resources to per root bus
Date: Tue, 21 May 2013 23:38:44 -0700
Message-Id: <1369204728-11165-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
References: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to split pci_assign_unassiged_resource to every root bus, so in
next patch we can stop early for root bus without ioport range, and still
continue to retry on buses that do have ioport range.

Also later we could let root bus hot add and booting path use same code.

-v2: separate enable_local and pci_release_bridge_resources to
     other patches requested by Bjorn.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   62 +++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

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
@@ -1405,10 +1390,9 @@ static enum enable_type __init pci_reall
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
@@ -1419,17 +1403,17 @@ pci_assign_unassigned_resources(void)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	int pci_try_num = 1;
-	enum enable_type enable_local = pci_realloc_enable;
-
-	list_for_each_entry(bus, &pci_root_buses, node)
-		enable_local = pci_realloc_detect(bus, enable_local);
+	enum enable_type enable_local;
 
+	/* don't realloc if asked to do so */
+	enable_local = pci_realloc_detect(bus, pci_realloc_enable);
 	if (pci_realloc_enabled(enable_local)) {
-		int max_depth = pci_get_max_depth();
+		int max_depth = pci_bus_get_depth(bus);
 
 		pci_try_num = max_depth + 1;
-		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-			 max_depth, pci_try_num);
+		dev_printk(KERN_DEBUG, &bus->dev,
+			   "max bus depth: %d pci_try_num: %d\n",
+			   max_depth, pci_try_num);
 	}
 
 again:
@@ -1441,12 +1425,10 @@ again:
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
@@ -1457,16 +1439,16 @@ again:
 
 	if (tried_times >= pci_try_num) {
 		if (enable_local == undefined)
-			printk(KERN_INFO "Some PCI device resources are unassigned, try booting with pci=realloc\n");
+			dev_info(&bus->dev, "Some PCI device resources are unassigned, try booting with pci=realloc\n");
 		else if (enable_local == auto_enabled)
-			printk(KERN_INFO "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");
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
@@ -1497,12 +1479,18 @@ again:
 
 enable_and_dump:
 	/* Depth last, update the hardware. */
-	list_for_each_entry(bus, &pci_root_buses, node)
-		pci_enable_bridges(bus);
+	pci_enable_bridges(bus);
 
 	/* dump the resource on buses */
-	list_for_each_entry(bus, &pci_root_buses, node)
-		pci_bus_dump_resources(bus);
+	pci_bus_dump_resources(bus);
+}
+
+void __init pci_assign_unassigned_resources(void)
+{
+	struct pci_bus *root_bus;
+
+	list_for_each_entry(root_bus, &pci_root_buses, node)
+		pci_assign_unassigned_root_bus_resources(root_bus);
 }
 
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
