Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbbAOEcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:32:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21404 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbAOEcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:32:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 01/10] PCI: clip firmware assigned resource under parent bridge's
Date: Wed, 14 Jan 2015 20:31:28 -0800
Message-Id: <1421296297-6371-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

This one is core part, arch changes will be in following patches.

-v2: add pci_claim_bridge_resource to core according to Bjorn.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c       | 39 ++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h       |  1 +
 drivers/pci/setup-bus.c | 56 ++++++++++++++++++++++++++++++++++++++-----------
 include/linux/pci.h     |  1 +
 4 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 73aef51..a1943c3 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -228,6 +228,45 @@ int pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 }
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 
+bool pci_bus_clip_resource(struct pci_dev *dev, int idx)
+{
+	struct pci_bus *bus = dev->bus;
+	struct resource *res = &dev->resource[idx];
+	struct resource orig_res = *res;
+	struct resource *r;
+	int i;
+
+	pci_bus_for_each_resource(bus, r, i) {
+		resource_size_t start, end;
+
+		if (!r)
+			continue;
+
+		if (resource_type(res) != resource_type(r))
+			continue;
+
+		start = max(r->start, res->start);
+		end = min(r->end, res->end);
+
+		/* no overlap ? */
+		if (start > end)
+			continue;
+
+		if (res->start == start && res->end == end)
+			return false;
+
+		/* changed */
+		res->start = start;
+		res->end = end;
+		dev_printk(KERN_DEBUG, &dev->dev, "%pR ==> %pR\n",
+				 &orig_res, res);
+
+		return true;
+	}
+
+	return false;
+}
+
 void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 8aff29a..d54632a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -208,6 +208,7 @@ void __pci_bus_size_bridges(struct pci_bus *bus,
 void __pci_bus_assign_resources(const struct pci_bus *bus,
 				struct list_head *realloc_head,
 				struct list_head *fail_head);
+bool pci_bus_clip_resource(struct pci_dev *dev, int idx);
 
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 0482235..0b1b9ea 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -530,9 +530,8 @@ EXPORT_SYMBOL(pci_setup_cardbus);
    config space writes, so it's quite possible that an I/O window of
    the bridge will have some undesirable address (e.g. 0) after the
    first write. Ditto 64-bit prefetchable MMIO.  */
-static void pci_setup_bridge_io(struct pci_bus *bus)
+static void pci_setup_bridge_io(struct pci_dev *bridge)
 {
-	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
 	unsigned long io_mask;
@@ -545,7 +544,7 @@ static void pci_setup_bridge_io(struct pci_bus *bus)
 		io_mask = PCI_IO_1K_RANGE_MASK;
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
-	res = bus->resource[0];
+	res = &bridge->resource[PCI_BRIDGE_RESOURCES];
 	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_IO) {
 		pci_read_config_word(bridge, PCI_IO_BASE, &l);
@@ -568,15 +567,14 @@ static void pci_setup_bridge_io(struct pci_bus *bus)
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
 }
 
-static void pci_setup_bridge_mmio(struct pci_bus *bus)
+static void pci_setup_bridge_mmio(struct pci_dev *bridge)
 {
-	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
 	u32 l;
 
 	/* Set up the top and bottom of the PCI Memory segment for this bus. */
-	res = bus->resource[1];
+	res = &bridge->resource[PCI_BRIDGE_RESOURCES + 1];
 	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
@@ -588,9 +586,8 @@ static void pci_setup_bridge_mmio(struct pci_bus *bus)
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
 }
 
-static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
+static void pci_setup_bridge_mmio_pref(struct pci_dev *bridge)
 {
-	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
 	u32 l, bu, lu;
@@ -602,7 +599,7 @@ static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
 
 	/* Set up PREF base/limit. */
 	bu = lu = 0;
-	res = bus->resource[2];
+	res = &bridge->resource[PCI_BRIDGE_RESOURCES + 2];
 	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
@@ -630,13 +627,13 @@ static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
 		 &bus->busn_res);
 
 	if (type & IORESOURCE_IO)
-		pci_setup_bridge_io(bus);
+		pci_setup_bridge_io(bridge);
 
 	if (type & IORESOURCE_MEM)
-		pci_setup_bridge_mmio(bus);
+		pci_setup_bridge_mmio(bridge);
 
 	if (type & IORESOURCE_PREFETCH)
-		pci_setup_bridge_mmio_pref(bus);
+		pci_setup_bridge_mmio_pref(bridge);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }
@@ -649,6 +646,41 @@ void pci_setup_bridge(struct pci_bus *bus)
 	__pci_setup_bridge(bus, type);
 }
 
+
+int pci_claim_bridge_resource(struct pci_dev *bridge, int i)
+{
+	if (i < PCI_BRIDGE_RESOURCES || i > PCI_BRIDGE_RESOURCE_END)
+		return 0;
+
+	if (pci_claim_resource(bridge, i) == 0)
+		return 0;	/* claimed the window */
+
+	if ((bridge->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return 0;
+
+	if (!pci_bus_clip_resource(bridge, i))
+		return -EINVAL;	/* clipping didn't change anything */
+
+	switch (i - PCI_BRIDGE_RESOURCES) {
+	case 0:
+		pci_setup_bridge_io(bridge);
+		break;
+	case 1:
+		pci_setup_bridge_mmio(bridge);
+		break;
+	case 2:
+		pci_setup_bridge_mmio_pref(bridge);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (pci_claim_resource(bridge, i) == 0)
+		return 0;         /* claimed a smaller window */
+
+	return -EINVAL;
+}
+
 /* Check whether the bridge supports optional I/O and
    prefetchable memory ranges. If not, the respective
    base/limit registers must be read-only and read as 0. */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 360a966..8e84393 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1065,6 +1065,7 @@ resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
+int pci_claim_bridge_resource(struct pci_dev *bridge, int i);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pci_assign_unassigned_bus_resources(struct pci_bus *bus);
-- 
1.8.4.5

