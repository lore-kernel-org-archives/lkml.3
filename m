Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaHLQ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:28:29 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54767 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753823AbaHLQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:26:56 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 10/12] OF: PCI: Add support for creating a generic host_bridge from DT
Date: Tue, 12 Aug 2014 17:25:23 +0100
Message-Id: <1407860725-25202-11-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to parse the PCI DT ranges and use it to
create a pci_host_bridge structure together with its associated
bus. Scan all the child busses and add the devices found.

This is the OF equivalent of pci_scan_root_bus() where all the
resources needed for creating the root bus are discovered from
information passed in the device tree.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/of/of_pci.c       | 159 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/host-bridge.c |  15 +++++
 include/linux/of_pci.h    |  13 ++++
 include/linux/pci.h       |   6 ++
 4 files changed, 193 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index a107edb..895b59f 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -1,7 +1,9 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_pci.h>
+#include <linux/slab.h>
 
 static inline int __of_pci_pci_compare(struct device_node *node,
 				       unsigned int data)
@@ -123,6 +125,163 @@ int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
 }
 EXPORT_SYMBOL_GPL(of_pci_get_domain_nr);
 
+/**
+ * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
+ * @dev: device node of the host bridge having the range property
+ * @resources: list where the range of resources will be added after DT parsing
+ * @io_base: pointer to a variable that will contain on return the physical
+ * address for the start of the I/O range.
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
+		pr_info(" %s %#010llx..%#010llx -> %#010llx\n",
+			((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO) ? " IO" : "MEM",
+			range.cpu_addr, range.cpu_addr + range.size - 1,
+			range.pci_addr);
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
+		if (err) {
+			kfree(res);
+			return err;
+		}
+
+		if (resource_type(res) == IORESOURCE_IO) {
+			if (*io_base)
+				pr_warn("More than one I/O resource converted. CPU offset for old range lost!\n");
+			*io_base = range.cpu_addr;
+		}
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
+ * @busno: bus number associated with the bridge root bus.
+ * @bus_max: maximum number of busses for this bridge.
+ * @ops: pci_ops associated with the host controller
+ * @setup: setup function used by host controller driver to prepare the bridge.
+ * @host_data: opaque data structure used by the host controller.
+ *
+ * Returns zero if successful or a negative error value if the call failed.
+ */
+int of_create_pci_host_bridge(struct device *parent, unsigned char busno,
+			unsigned char bus_max, struct pci_ops *ops,
+			int (*setup)(struct pci_host_bridge *, resource_size_t),
+			void *host_data)
+{
+	int err, max;
+	struct resource *bus_range;
+	struct pci_bus *root_bus;
+	struct pci_host_bridge *bridge = NULL;
+	resource_size_t io_base = 0;	/* physical address for the start of I/O area */
+	LIST_HEAD(res);
+
+	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
+	if (!bus_range)
+		return -ENOMEM;
+
+	err = of_pci_parse_bus_range(parent->of_node, bus_range);
+	if (err) {
+		bus_range->start = busno;
+		bus_range->end = bus_max;
+		bus_range->flags = IORESOURCE_BUS;
+		dev_info(parent, "No bus range found for %s, using %pR\n",
+			parent->of_node->full_name, &bus_range);
+	} else {
+		if (bus_range->end > bus_range->start + bus_max)
+			bus_range->end = bus_range->start + bus_max;
+	}
+	pci_add_resource(&res, bus_range);
+
+	/* now parse the rest of host bridge bus ranges */
+	err = pci_host_bridge_of_get_ranges(parent->of_node, &res, &io_base);
+	if (err)
+		goto err_create;
+
+	/* then create the root bus */
+	root_bus = pci_create_root_bus(parent, busno, ops, host_data, &res);
+	if (!root_bus) {
+		err = -ENXIO;
+		goto err_create;
+	}
+
+	bridge = to_pci_host_bridge(root_bus->bridge);
+
+	/* give control to the host controller driver to finish setup */
+	if (setup) {
+		err = setup(bridge, io_base);
+		if (err)
+			goto err_setup;
+	}
+
+	max = pci_scan_child_bus(root_bus);
+	pci_bus_update_busn_res_end(root_bus, max);
+
+	if (!pci_has_flag(PCI_PROBE_ONLY))
+		pci_assign_unassigned_bus_resources(root_bus);
+
+	pci_bus_add_devices(root_bus);
+
+	return 0;
+
+err_setup:
+	pci_remove_bus(root_bus);
+	put_device(&bridge->dev);
+	device_unregister(&bridge->dev);
+	kfree(root_bus);
+	kfree(bridge);
+
+err_create:
+	pci_free_resource_list(&res);
+	return err;
+}
+EXPORT_SYMBOL_GPL(of_create_pci_host_bridge);
+
 #ifdef CONFIG_PCI_MSI
 
 static LIST_HEAD(of_pci_msi_chip_list);
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 0e5f3c9..3b22f93 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -82,3 +82,18 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
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
index 3a3824c..f58a1cb 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -16,6 +16,11 @@ int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing);
+int of_create_pci_host_bridge(struct device *parent, unsigned char busno,
+			unsigned char bus_max, struct pci_ops *ops,
+			int (*setup)(struct pci_host_bridge *, resource_size_t),
+			void *host_data);
+
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
@@ -50,6 +55,14 @@ of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
 {
 	return -1;
 }
+
+int of_create_pci_host_bridge(struct device *parent, unsigned char busno,
+			unsigned char bus_max, struct pci_ops *ops,
+			int (*setup)(struct pci_host_bridge *, resource_size_t),
+			void *host_data)
+{
+	return -EINVAL;
+}
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1d0e0b5..e1e0d80 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1821,6 +1821,12 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 	return bus ? bus->dev.of_node : NULL;
 }
 
+/*
+ * Used by architecture code to apply any quirks to the list of
+ * pci_host_bridge resource ranges before they are being used
+ * by of_create_pci_host_bridge()
+ */
+int pcibios_fixup_bridge_ranges(struct list_head *resources);
 #else /* CONFIG_OF */
 static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
-- 
2.0.4

