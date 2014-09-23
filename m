Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbaIWUPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:15:06 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52325 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751735AbaIWUPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:15:04 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH v12 09/12] OF: PCI: Add support for parsing PCI host bridge resources from DT
Date: Tue, 23 Sep 2014 20:01:11 +0100
Message-Id: <1411498874-9864-10-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to parse the PCI DT ranges that can be used to
create a pci_host_bridge structure together with its associated
bus.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
[make io_base parameter optional]
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 drivers/of/of_pci.c    | 115 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_pci.h |  11 +++++
 2 files changed, 126 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 82d172f..c2285aa 100644
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
@@ -114,6 +116,119 @@ int of_get_pci_domain_nr(struct device_node *node)
 }
 EXPORT_SYMBOL_GPL(of_get_pci_domain_nr);
 
+/**
+ * of_pci_get_host_bridge_resources - Parse PCI host bridge resources from DT
+ * @dev: device node of the host bridge having the range property
+ * @busno: bus number associated with the bridge root bus
+ * @bus_max: maximum number of busses for this bridge
+ * @resources: list where the range of resources will be added after DT parsing
+ * @io_base: pointer to a variable that will contain on return the physical
+ * address for the start of the I/O range. Can be NULL if the caller doesn't
+ * expect IO ranges to be present in the device tree.
+ *
+ * It is the callers job to free the @resources list.
+ *
+ * This function will parse the "ranges" property of a PCI host bridge device
+ * node and setup the resource mapping based on its content. It is expected
+ * that the property conforms with the Power ePAPR document.
+ *
+ * It returns zero if the range parsing has been successful or a standard error
+ * value if it failed.
+ */
+int of_pci_get_host_bridge_resources(struct device_node *dev,
+			unsigned char busno, unsigned char bus_max,
+			struct list_head *resources, resource_size_t *io_base)
+{
+	struct resource *res;
+	struct resource *bus_range;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	char range_type[4];
+	int err;
+
+	if (io_base)
+		*io_base = (resource_size_t)OF_BAD_ADDR;
+
+	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
+	if (!bus_range)
+		return -ENOMEM;
+
+	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
+
+	err = of_pci_parse_bus_range(dev, bus_range);
+	if (err) {
+		bus_range->start = busno;
+		bus_range->end = bus_max;
+		bus_range->flags = IORESOURCE_BUS;
+		pr_info("  No bus range found for %s, using %pR\n",
+			dev->full_name, bus_range);
+	} else {
+		if (bus_range->end > bus_range->start + bus_max)
+			bus_range->end = bus_range->start + bus_max;
+	}
+	pci_add_resource(resources, bus_range);
+
+	/* Check for ranges property */
+	err = of_pci_range_parser_init(&parser, dev);
+	if (err)
+		goto parse_failed;
+
+	pr_debug("Parsing ranges property...\n");
+	for_each_of_pci_range(&parser, &range) {
+		/* Read next ranges element */
+		if ((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO)
+			snprintf(range_type, 4, " IO");
+		else if ((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_MEM)
+			snprintf(range_type, 4, "MEM");
+		else
+			snprintf(range_type, 4, "err");
+		pr_info("  %s %#010llx..%#010llx -> %#010llx\n", range_type,
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
+		if (!res) {
+			err = -ENOMEM;
+			goto parse_failed;
+		}
+
+		err = of_pci_range_to_resource(&range, dev, res);
+		if (err)
+			goto conversion_failed;
+
+		if (resource_type(res) == IORESOURCE_IO) {
+			if (!io_base) {
+				pr_err("I/O range found for %s. Please provide an io_base pointer to save CPU base address\n",
+					dev->full_name);
+				err = -EINVAL;
+				goto conversion_failed;
+			}
+			if (*io_base != (resource_size_t)OF_BAD_ADDR)
+				pr_warn("More than one I/O resource converted for %s. CPU base address for old range lost!\n",
+					dev->full_name);
+			*io_base = range.cpu_addr;
+		}
+
+		pci_add_resource_offset(resources, res,	res->start - range.pci_addr);
+	}
+
+	return 0;
+
+conversion_failed:
+	kfree(res);
+parse_failed:
+	pci_free_resource_list(resources);
+	return err;
+}
+EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
+
 #ifdef CONFIG_PCI_MSI
 
 static LIST_HEAD(of_pci_msi_chip_list);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 71062e9..9ff818a 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -16,6 +16,10 @@ int of_pci_get_devfn(struct device_node *np);
 int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 int of_get_pci_domain_nr(struct device_node *node);
+int of_pci_get_host_bridge_resources(struct device_node *dev,
+			unsigned char busno, unsigned char bus_max,
+			struct list_head *resources, resource_size_t *io_base);
+
 #else
 static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
@@ -50,6 +54,13 @@ of_get_pci_domain_nr(struct device_node *node)
 {
 	return -1;
 }
+
+int of_pci_get_host_bridge_resources(struct device_node *dev,
+			unsigned char busno, unsigned char bus_max,
+			struct list_head *resources, resource_size_t *io_base);
+{
+	return -EINVAL;
+}
 #endif
 
 #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
-- 
2.1.0

