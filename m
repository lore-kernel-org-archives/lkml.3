Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab3EFXQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:16:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40889 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722Ab3EFXQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:16:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/2] PCI: Skip IORESOURCE_IO size and allocation for root bus without ioport range
Date: Mon,  6 May 2013 16:15:30 -0700
Message-Id: <1367882130-19452-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367882130-19452-1-git-send-email-yinghai@kernel.org>
References: <1367882130-19452-1-git-send-email-yinghai@kernel.org>
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

We should not fall into retry in this case, as root bus does
not io port range.

We check if the root bus has ioport range, and set bus_res_type_mask,
and pass it to __bus_size_bridges and skip io port resources.

For the retry failing, we could allocate mmio-non-pref bottom-up
and mmio-pref will be top-down, but that could not be material for v3.10.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1045,7 +1045,8 @@ handle_done:
 }
 
 static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
-			struct list_head *realloc_head)
+			struct list_head *realloc_head,
+			unsigned long res_type_mask)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -1063,7 +1064,7 @@ static void __ref __pci_bus_size_bridges
 
 		case PCI_CLASS_BRIDGE_PCI:
 		default:
-			__pci_bus_size_bridges(b, realloc_head);
+			__pci_bus_size_bridges(b, realloc_head, res_type_mask);
 			break;
 		}
 	}
@@ -1087,8 +1088,9 @@ static void __ref __pci_bus_size_bridges
 		 * Follow thru
 		 */
 	default:
-		pbus_size_io(bus, realloc_head ? 0 : additional_io_size,
-			     additional_io_size, realloc_head);
+		if (res_type_mask & IORESOURCE_IO)
+			pbus_size_io(bus, realloc_head ? 0 : additional_io_size,
+				     additional_io_size, realloc_head);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -1111,7 +1113,10 @@ static void __ref __pci_bus_size_bridges
 
 void __ref pci_bus_size_bridges(struct pci_bus *bus)
 {
-	__pci_bus_size_bridges(bus, NULL);
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	__pci_bus_size_bridges(bus, NULL, type_mask);
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
@@ -1376,6 +1381,21 @@ static enum enable_type __init pci_reall
 	return enable_local;
 }
 
+static unsigned int __init pci_bus_res_type_mask(struct pci_bus *bus)
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
@@ -1395,6 +1415,7 @@ pci_assign_unassigned_root_bus_resources
 				  IORESOURCE_PREFETCH;
 	int pci_try_num = 1;
 	enum enable_type enable_local;
+	unsigned long bus_res_type_mask = pci_bus_res_type_mask(bus);
 
 	/* don't realloc if asked to do so */
 	enable_local = pci_realloc_detect(bus, pci_realloc_enable);
@@ -1416,7 +1437,7 @@ again:
 		add_list = &realloc_head;
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
-	__pci_bus_size_bridges(bus, add_list);
+	__pci_bus_size_bridges(bus, add_list, bus_res_type_mask);
 
 	/* Depth last, allocate resources and update the hardware. */
 	__pci_bus_assign_resources(bus, add_list, &fail_head);
@@ -1496,9 +1517,10 @@ void pci_assign_unassigned_bridge_resour
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
+	unsigned long bus_res_type_mask = pci_bus_res_type_mask(bridge->bus);
 
 again:
-	__pci_bus_size_bridges(parent, &add_list);
+	__pci_bus_size_bridges(parent, &add_list, bus_res_type_mask);
 	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
 	BUG_ON(!list_empty(&add_list));
 	tried_times++;
@@ -1554,6 +1576,7 @@ void pci_assign_unassigned_bus_resources
 	struct pci_dev *dev;
 	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
+	unsigned long bus_res_type_mask = pci_bus_res_type_mask(bus);
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
@@ -1561,7 +1584,7 @@ void pci_assign_unassigned_bus_resources
 		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 			if (dev->subordinate)
 				__pci_bus_size_bridges(dev->subordinate,
-							 &add_list);
+						 &add_list, bus_res_type_mask);
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
