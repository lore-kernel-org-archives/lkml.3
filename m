Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaCELtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:49:41 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51459 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754821AbaCELth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:49:37 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 6/6] pci: Add support for creating a generic host_bridge from device tree
Date: Wed,  5 Mar 2014 11:48:57 +0000
Message-Id: <1394020137-1830-7-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
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
Tested-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/pci/host-bridge.c | 156 ++++++++++++++++++++++++++++++++++++
 include/linux/pci.h       |  13 +++
 2 files changed, 169 insertions(+)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 8708b652..db9f51a 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -6,9 +6,14 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/slab.h>
 
 #include "pci.h"
 
+static atomic_t domain_nr = ATOMIC_INIT(-1);
+
 static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
 {
 	while (bus->parent)
@@ -92,3 +97,154 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 	res->end = region->end + offset;
 }
 EXPORT_SYMBOL(pcibios_bus_to_resource);
+
+#ifdef CONFIG_OF
+/**
+ * Simple version of the platform specific code for filtering the list
+ * of resources obtained from the ranges declaration in DT.
+ *
+ * Platforms can override this function in order to impose stronger
+ * constraints onto the list of resources that a host bridge can use.
+ * The filtered list will then be used to create a root bus and associate
+ * it with the host bridge.
+ *
+ */
+int __weak pcibios_fixup_bridge_ranges(struct list_head *resources)
+{
+	return 0;
+}
+
+/**
+ * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
+ * @dev: device node of the host bridge having the range property
+ * @resources: list where the range of resources will be added after DT parsing
+ * @io_base: pointer to a variable that will contain the physical address for
+ * the start of the I/O range.
+ *
+ * It is the callers job to free the @resources list if an error is returned.
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
+		if (!res)
+			return -ENOMEM;
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
+	return pcibios_fixup_bridge_ranges(resources);
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
+	struct resource *bus_range;
+	struct pci_bus *root_bus;
+	struct pci_host_bridge *bridge;
+	resource_size_t io_base;
+	LIST_HEAD(res);
+
+	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
+	if (!bus_range)
+		return ERR_PTR(-ENOMEM);
+
+	domain = of_alias_get_id(parent->of_node, "pci-domain");
+	if (domain == -ENODEV)
+		domain = atomic_inc_return(&domain_nr);
+
+	err = of_pci_parse_bus_range(parent->of_node, bus_range);
+	if (err) {
+		dev_info(parent, "No bus range for %s, using default [0-255]\n",
+			parent->of_node->full_name);
+		bus_range->start = 0;
+		bus_range->end = 255;
+		bus_range->flags = IORESOURCE_BUS;
+	}
+	busno = bus_range->start;
+	pci_add_resource(&res, bus_range);
+
+	/* now parse the rest of host bridge bus ranges */
+	err = pci_host_bridge_of_get_ranges(parent->of_node, &res, &io_base);
+	if (err)
+		goto err_create;
+
+	/* then create the root bus */
+	root_bus = pci_create_root_bus_in_domain(parent, domain, busno,
+						ops, host_data, &res);
+	if (IS_ERR(root_bus)) {
+		err = PTR_ERR(root_bus);
+		goto err_create;
+	}
+
+	bridge = to_pci_host_bridge(root_bus->bridge);
+	bridge->io_base = io_base;
+
+	return bridge;
+
+err_create:
+	pci_free_resource_list(&res);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(of_create_pci_host_bridge);
+
+#endif /* CONFIG_OF */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1eed009..40ddd3d 100644
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
+int pcibios_fixup_bridge_ranges(struct list_head *resources);
 #else /* CONFIG_OF */
 static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
 static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
 static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
+
+static inline struct pci_host_bridge *
+of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
+			void *host_data)
+{
+	return NULL;
+}
 #endif  /* CONFIG_OF */
 
 #ifdef CONFIG_EEH
-- 
1.9.0

