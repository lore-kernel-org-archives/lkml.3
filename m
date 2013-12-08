Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090Ab3LHXyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 18:54:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23126 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091Ab3LHXya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 18:54:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] PCI: pcibus address to resource converting take bus instead of dev
Date: Sun,  8 Dec 2013 15:54:28 -0800
Message-Id: <1386546869-31900-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For allocating resource under bus path, we do not have dev to pass along,
and we only have bus to use instead.

-v2: drop pcibios_bus_addr_to_resource().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/host-bridge.c | 34 +++++++++++++++++++++-------------
 include/linux/pci.h       |  5 +++++
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index a68dc61..c988a30 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -9,22 +9,19 @@
 
 #include "pci.h"
 
-static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
+static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
 {
-	struct pci_bus *bus;
-
-	bus = dev->bus;
 	while (bus->parent)
 		bus = bus->parent;
 
 	return bus;
 }
 
-static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
+static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
 {
-	struct pci_bus *bus = find_pci_root_bus(dev);
+	struct pci_bus *root_bus = find_pci_root_bus(bus);
 
-	return to_pci_host_bridge(bus->bridge);
+	return to_pci_host_bridge(root_bus->bridge);
 }
 
 void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
@@ -40,10 +37,11 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
 	return res1->start <= res2->start && res1->end >= res2->end;
 }
 
-void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
-			     struct resource *res)
+void __pcibios_resource_to_bus(struct pci_bus *bus,
+				      struct pci_bus_region *region,
+				      struct resource *res)
 {
-	struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
 	struct pci_host_bridge_window *window;
 	resource_size_t offset = 0;
 
@@ -60,6 +58,11 @@ void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
 	region->start = res->start - offset;
 	region->end = res->end - offset;
 }
+void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+			     struct resource *res)
+{
+	__pcibios_resource_to_bus(dev->bus, region, res);
+}
 EXPORT_SYMBOL(pcibios_resource_to_bus);
 
 static bool region_contains(struct pci_bus_region *region1,
@@ -68,10 +71,10 @@ static bool region_contains(struct pci_bus_region *region1,
 	return region1->start <= region2->start && region1->end >= region2->end;
 }
 
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
-			     struct pci_bus_region *region)
+void __pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
+				      struct pci_bus_region *region)
 {
-	struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
 	struct pci_host_bridge_window *window;
 	resource_size_t offset = 0;
 
@@ -93,4 +96,9 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 	res->start = region->start + offset;
 	res->end = region->end + offset;
 }
+void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+			     struct pci_bus_region *region)
+{
+	__pcibios_bus_to_resource(dev->bus, res, region);
+}
 EXPORT_SYMBOL(pcibios_bus_to_resource);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1084a15..5c2cf8e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -737,8 +737,13 @@ void pci_fixup_cardbus(struct pci_bus *);
 
 /* Generic PCI functions used internally */
 
+void __pcibios_resource_to_bus(struct pci_bus *bus,
+			       struct pci_bus_region *region,
+			       struct resource *res);
 void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
 			     struct resource *res);
+void __pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
+				      struct pci_bus_region *region);
 void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			     struct pci_bus_region *region);
 void pcibios_scan_specific_bus(int busn);
-- 
1.8.4

