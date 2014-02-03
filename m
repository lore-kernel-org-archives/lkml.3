Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaBCSfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:35:23 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54710 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912AbaBCSfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:35:19 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: [PATCH] pci: Add support for creating a generic host_bridge from device tree
Date: Mon,  3 Feb 2014 18:33:48 +0000
Message-Id: <1391452428-22917-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several platforms use a rather generic version of parsing
the device tree to find the host bridge ranges. Move that
into the generic PCI code and use it to create a pci_host_bridge
structure that can be used by arch code.

Based on early attempts by Andrew Murray to unify the code.
Used powerpc and microblaze PCI code as starting point.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>
---
 drivers/pci/host-bridge.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c       | 11 ++++++
 include/linux/pci.h       | 14 ++++++++
 3 files changed, 117 insertions(+)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 06ace62..9d11deb 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
 
 #include "pci.h"
 
@@ -91,3 +92,94 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 	res->end = region->end + offset;
 }
 EXPORT_SYMBOL(pcibios_bus_to_resource);
+
+/**
+ * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
+ * @dev: device node of the host bridge having the range property
+ * @resources: list where the range of resources will be added after DT parsing
+ *
+ * This function will parse the "ranges" property of a PCI host bridge device
+ * node and setup the resource mapping based on its content. It is expected
+ * that the property conforms with the Power ePAPR document.
+ *
+ * Each architecture will then apply their filtering based on the limitations
+ * of each platform. One general restriction seems to be the number of IO space
+ * ranges, the PCI framework makes intensive use of struct resource management,
+ * and for IORESOURCE_IO types they can only be requested if they are contained
+ * within the global ioport_resource, so that should be limited to one IO space
+ * range.
+ */
+static int pci_host_bridge_of_get_ranges(struct device_node *dev,
+					struct list_head *resources)
+{
+	struct resource *res;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	int err;
+
+	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
+
+	/* Check for ranges property */
+	err = of_pci_range_parser_init(&parser, dev);
+	if (err)
+		return err;
+
+	pr_debug("Parsing ranges property...\n");
+	for_each_of_pci_range(&parser, &range) {
+		/* Read next ranges element */
+		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
+				range.pci_space, range.pci_addr);
+		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
+					range.cpu_addr, range.size);
+
+		/* If we failed translation or got a zero-sized region
+		 * (some FW try to feed us with non sensical zero sized regions
+		 * such as power3 which look like some kind of attempt
+		 * at exposing the VGA memory hole) then skip this range
+		 */
+		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
+			continue;
+
+		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+		if (!res) {
+			err = -ENOMEM;
+			goto bridge_ranges_nomem;
+		}
+
+		of_pci_range_to_resource(&range, dev, res);
+
+		pci_add_resource_offset(resources, res,
+				range.cpu_addr - range.pci_addr);
+	}
+
+	/* Apply architecture specific fixups for the ranges */
+	pcibios_fixup_bridge_ranges(resources);
+
+	return 0;
+
+bridge_ranges_nomem:
+	pci_free_resource_list(resources);
+	return err;
+}
+
+struct pci_host_bridge *
+pci_host_bridge_of_init(struct device *parent, int busno, struct pci_ops *ops,
+			void *host_data, struct list_head *resources)
+{
+	struct pci_bus *root_bus;
+	struct pci_host_bridge *bridge;
+
+	/* first parse the host bridge bus ranges */
+	if (pci_host_bridge_of_get_ranges(parent->of_node, resources))
+		return NULL;
+
+	/* then create the root bus */
+	root_bus = pci_create_root_bus(parent, busno, ops, host_data, resources);
+	if (!root_bus)
+		return NULL;
+
+	bridge = to_pci_host_bridge(root_bus->bridge);
+
+	return bridge;
+}
+EXPORT_SYMBOL(pci_host_bridge_of_init);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6e34498..16febae 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1787,6 +1787,17 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	list_for_each_entry_safe(window, n, resources, list) {
 		list_move_tail(&window->list, &bridge->windows);
 		res = window->res;
+		/*
+		 * IO resources are stored in the kernel with a CPU start
+		 * address of zero. Adjust the data accordingly and remember
+		 * the offset
+		 */
+		if (resource_type(res) == IORESOURCE_IO) {
+			bridge->io_offset = res->start;
+			res->end -= res->start;
+			window->offset -= res->start;
+			res->start = 0;
+		}
 		offset = window->offset;
 		if (res->flags & IORESOURCE_BUS)
 			pci_bus_insert_busn_res(b, bus, res->end);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fb57c89..8953997 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -394,6 +394,8 @@ struct pci_host_bridge_window {
 struct pci_host_bridge {
 	struct device dev;
 	struct pci_bus *bus;		/* root bus */
+	resource_size_t io_offset;	/* CPU address offset for io resources */
+	int domain_nr;
 	struct list_head windows;	/* pci_host_bridge_windows */
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
@@ -1762,11 +1764,23 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 	return bus ? bus->dev.of_node : NULL;
 }
 
+struct pci_host_bridge *
+pci_host_bridge_of_init(struct device *parent, int busno, struct pci_ops *ops,
+			void *host_data, struct list_head *resources);
+
+void pcibios_fixup_bridge_ranges(struct list_head *resources);
 #else /* CONFIG_OF */
 static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
 static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
 static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
+
+static inline struct pci_host_bridge *
+pci_host_bridge_of_init(struct device *parent, struct pci_ops *ops,
+			void *host_data, struct list_head *resources)
+{
+	return NULL;
+}
 #endif  /* CONFIG_OF */
 
 #ifdef CONFIG_EEH
-- 
1.8.5.3

