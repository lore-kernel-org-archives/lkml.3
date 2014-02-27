Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaB0NHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:07:16 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52788 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751550AbaB0NHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:07:13 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 4/4] pci: Add support for creating a generic host_bridge from device tree
Date: Thu, 27 Feb 2014 13:06:42 +0000
Message-Id: <1393506402-11474-5-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several platforms use a rather generic version of parsing
the device tree to find the host bridge ranges. Move the common code
into the generic PCI code and use it to create a pci_host_bridge
structure that can be used by arch code.

Based on early attempts by Andrew Murray to unify the code.
Used powerpc and microblaze PCI code as starting point.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 06ace62..feb8436 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -6,9 +6,13 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
 
 #include "pci.h"
 
+static int domain_nr;
+
 static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
 {
 	while (bus->parent)
@@ -91,3 +95,133 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 	res->end = region->end + offset;
 }
 EXPORT_SYMBOL(pcibios_bus_to_resource);
+
+/**
+ * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
+ * @dev: device node of the host bridge having the range property
+ * @resources: list where the range of resources will be added after DT parsing
+ * @io_base: pointer to a variable that will contain the physical address for
+ * the start of the I/O range.
+ *
+ * If this function returns an error then the @resources list will be freed.
+ *
+ * This function will parse the "ranges" property of a PCI host bridge device
+ * node and setup the resource mapping based on its content. It is expected
+ * that the property conforms with the Power ePAPR document.
+ *
+ * Each architecture is then offered the chance of applying their own
+ * filtering of pci_host_bridge_windows based on their own restrictions by
+ * calling pcibios_fixup_bridge_ranges(). The filtered list of windows
+ * can then be used when creating a pci_host_bridge structure.
+ */
+static int pci_host_bridge_of_get_ranges(struct device_node *dev,
+		struct list_head *resources, resource_size_t *io_base)
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
+		/*
+		 * If we failed translation or got a zero-sized region
+		 * then skip this range
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
+		if (resource_type(res) == IORESOURCE_IO)
+			*io_base = range.cpu_addr;
+
+		pci_add_resource_offset(resources, res,
+				res->start - range.pci_addr);
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
+/**
+ * of_create_pci_host_bridge - Create a PCI host bridge structure using
+ * information passed in the DT.
+ * @parent: device owning this host bridge
+ * @ops: pci_ops associated with the host controller
+ * @host_data: opaque data structure used by the host controller.
+ *
+ * returns a pointer to the newly created pci_host_bridge structure, or
+ * NULL if the call failed.
+ *
+ * This function will try to obtain the host bridge domain number by
+ * using of_alias_get_id() call with "pci-domain" as a stem. If that
+ * fails, a local allocator will be used that will put each host bridge
+ * in a new domain.
+ */
+struct pci_host_bridge *
+of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host_data)
+{
+	int err, domain, busno;
+	struct resource bus_range;
+	struct pci_bus *root_bus;
+	struct pci_host_bridge *bridge;
+	resource_size_t io_base;
+	LIST_HEAD(res);
+
+	domain = of_alias_get_id(parent->of_node, "pci-domain");
+	if (domain == -ENODEV)
+		domain = domain_nr++;
+
+	err = of_pci_parse_bus_range(parent->of_node, &bus_range);
+	if (err) {
+		dev_info(parent, "No bus range for %s, using default [0-255]\n",
+			parent->of_node->full_name);
+		bus_range.start = 0;
+		bus_range.end = 255;
+		bus_range.flags = IORESOURCE_BUS;
+	}
+	busno = bus_range.start;
+	pci_add_resource(&res, &bus_range);
+
+	/* now parse the rest of host bridge bus ranges */
+	if (pci_host_bridge_of_get_ranges(parent->of_node, &res, &io_base))
+		return NULL;
+
+	/* then create the root bus */
+	root_bus = pci_create_root_bus_in_domain(parent, domain, busno,
+						ops, host_data, &res);
+	if (!root_bus)
+		return NULL;
+
+	bridge = to_pci_host_bridge(root_bus->bridge);
+	bridge->io_base = io_base;
+
+	return bridge;
+}
+EXPORT_SYMBOL_GPL(of_create_pci_host_bridge);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1eed009..0c5e269 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -395,6 +395,7 @@ struct pci_host_bridge {
 	struct device dev;
 	struct pci_bus *bus;		/* root bus */
 	int domain_nr;
+	resource_size_t io_base;	/* physical address for the start of I/O area */
 	struct list_head windows;	/* pci_host_bridge_windows */
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
@@ -1786,11 +1787,23 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 	return bus ? bus->dev.of_node : NULL;
 }
 
+struct pci_host_bridge *
+of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
+			void *host_data);
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
+			void *host_data)
+{
+	return NULL;
+}
 #endif  /* CONFIG_OF */
 
 #ifdef CONFIG_EEH
-- 
1.9.0

