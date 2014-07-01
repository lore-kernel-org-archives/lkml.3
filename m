Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbaGASrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:47:16 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50162 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932410AbaGASod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:33 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 8/9] pci: Add support for creating a generic host_bridge from device tree
Date: Tue,  1 Jul 2014 19:43:33 +0100
Message-Id: <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
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
 drivers/of/of_pci.c       | 135 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/host-bridge.c |  18 +++++++
 include/linux/of_pci.h    |  10 ++++
 include/linux/pci.h       |   8 +++
 4 files changed, 171 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 8481996..55d8320 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -89,6 +89,141 @@ int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
 }
 EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
 
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
+		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx cpu_addr:0x%016llx size:0x%016llx\n",
+			range.pci_space, range.pci_addr, range.cpu_addr, range.size);
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
+		err = of_pci_range_to_resource(&range, dev, res);
+		if (err)
+			return err;
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
+static atomic_t domain_nr = ATOMIC_INIT(-1);
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
 #ifdef CONFIG_PCI_MSI
 
 static LIST_HEAD(of_pci_msi_chip_list);
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 36c669e..cfee5d1 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -5,6 +5,9 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/slab.h>
 
 #include "pci.h"
 
@@ -83,3 +86,18 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 	res->end = region->end + offset;
 }
 EXPORT_SYMBOL(pcibios_bus_to_resource);
+
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
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index dde3a4a..71e36d0 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -15,6 +15,9 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
+struct pci_host_bridge *of_create_pci_host_bridge(struct device *parent,
+					struct pci_ops *ops, void *host_data);
+
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
@@ -43,6 +46,13 @@ of_pci_parse_bus_range(struct device_node *node, struct resource *res)
 {
 	return -EINVAL;
 }
+
+static inline struct pci_host_bridge *
+of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
+			void *host_data)
+{
+	return NULL;
+}
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7e7b939..556dc5f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -402,6 +402,7 @@ struct pci_host_bridge {
 	struct device dev;
 	struct pci_bus *bus;		/* root bus */
 	int domain_nr;
+	resource_size_t io_base;	/* physical address for the start of I/O area */
 	struct list_head windows;	/* pci_host_bridge_windows */
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
@@ -1809,8 +1810,15 @@ static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
 static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
 static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
+
 #endif  /* CONFIG_OF */
 
+/* Used by architecture code to apply any quirks to the list of
+ * pci_host_bridge resource ranges before they are being used
+ * by of_create_pci_host_bridge()
+ */
+extern int pcibios_fixup_bridge_ranges(struct list_head *resources);
+
 #ifdef CONFIG_EEH
 static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
 {
-- 
2.0.0

