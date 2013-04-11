Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161653Ab3DKP2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:28:10 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47974 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936173Ab3DKP1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:27:10 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: rob.herring@calxeda.com
Cc: jgunthorpe@obsidianresearch.com, linux@arm.linux.org.uk,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        bhelgaas@google.com, suren.reddy@samsung.com,
        linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        benh@kernel.crashing.org, paulus@samba.org, grant.likely@secretlab.ca,
        thomas.petazzoni@free-electrons.com, thierry.reding@avionic-design.de,
        thomas.abraham@linaro.org, arnd@arndb.de, linus.walleij@linaro.org,
        Andrew Murray <Andrew.Murray@arm.com>
Subject: [PATCH v6 2/3] of/pci: Provide support for parsing PCI DT ranges property
Date: Thu, 11 Apr 2013 16:26:08 +0100
Message-Id: <1365693969-23907-3-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
References: <1365693969-23907-1-git-send-email-Andrew.Murray@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out common implementation patterns to reduce overall kernel
code and provide a means for host bridge drivers to directly obtain struct
resources from the DT's ranges property without relying on architecture specific
DT handling. This will make it easier to write archiecture independent host bridge
drivers and mitigate against further duplication of DT parsing code.

This patch can be used in the following way:

	struct of_pci_range_parser parser;
	struct of_pci_range range;

	if (of_pci_range_parser(&parser, np))
		; //no ranges property

	for_each_of_pci_range(&parser, &range) {

		/*
			directly access properties of the address range, e.g.:
			range.pci_space, range.pci_addr, range.cpu_addr,
			range.size, range.flags

			alternatively obtain a struct resource, e.g.:
			struct resource res;
			of_pci_range_to_resource(&range, np, &res);
		*/
	}

Additionally the implementation takes care of adjacent ranges and merges them
into a single range (as was the case with powerpc and microblaze).

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reviewed-by: Rob Herring <rob.herring@calxeda.com>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/of/address.c       |   66 ++++++++++++++++++++++++++
 drivers/of/of_pci.c        |  112 ++++++++++++++++----------------------------
 include/linux/of_address.h |   46 ++++++++++++++++++
 3 files changed, 152 insertions(+), 72 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 04da786..d3c4f2f 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -227,6 +227,72 @@ int of_pci_address_to_resource(struct device_node *dev, int bar,
 	return __of_address_to_resource(dev, addrp, size, flags, NULL, r);
 }
 EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
+
+int of_pci_range_parser(struct of_pci_range_parser *parser,
+			struct device_node *node)
+{
+	const int na = 3, ns = 2;
+	int rlen;
+
+	parser->node = node;
+	parser->pna = of_n_addr_cells(node);
+	parser->np = parser->pna + na + ns;
+
+	parser->range = of_get_property(node, "ranges", &rlen);
+	if (parser->range == NULL)
+		return -ENOENT;
+
+	parser->end = parser->range + rlen / sizeof(__be32);
+
+	return 0;
+}
+
+struct of_pci_range *of_pci_process_ranges(struct of_pci_range_parser *parser,
+						struct of_pci_range *range)
+{
+	const int na = 3, ns = 2;
+
+	if (!range)
+		return NULL;
+
+	if (!parser->range || parser->range + parser->np > parser->end)
+		return NULL;
+
+	range->pci_space = parser->range[0];
+	range->flags = of_bus_pci_get_flags(parser->range);
+	range->pci_addr = of_read_number(parser->range + 1, ns);
+	range->cpu_addr = of_translate_address(parser->node,
+				parser->range + na);
+	range->size = of_read_number(parser->range + parser->pna + na, ns);
+
+	parser->range += parser->np;
+
+	/* Now consume following elements while they are contiguous */
+	while (parser->range + parser->np <= parser->end) {
+		u32 flags, pci_space;
+		u64 pci_addr, cpu_addr, size;
+
+		pci_space = be32_to_cpup(parser->range);
+		flags = of_bus_pci_get_flags(parser->range);
+		pci_addr = of_read_number(parser->range + 1, ns);
+		cpu_addr = of_translate_address(parser->node,
+				parser->range + na);
+		size = of_read_number(parser->range + parser->pna + na, ns);
+
+		if (flags != range->flags)
+			break;
+		if (pci_addr != range->pci_addr + range->size ||
+		    cpu_addr != range->cpu_addr + range->size)
+			break;
+
+		range->size += size;
+		parser->range += parser->np;
+	}
+
+	return range;
+}
+EXPORT_SYMBOL_GPL(of_pci_process_ranges);
+
 #endif /* CONFIG_PCI */
 
 /*
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 1626172..3e428a1 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -82,67 +82,43 @@ EXPORT_SYMBOL_GPL(of_pci_find_child_device);
 void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				  struct device_node *dev, int primary)
 {
-	const u32 *ranges;
-	int rlen;
-	int pna = of_n_addr_cells(dev);
-	int np = pna + 5;
 	int memno = 0, isa_hole = -1;
-	u32 pci_space;
-	unsigned long long pci_addr, cpu_addr, pci_next, cpu_next, size;
 	unsigned long long isa_mb = 0;
 	struct resource *res;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	u32 res_type;
 
 	pr_info("PCI host bridge %s %s ranges:\n",
 	       dev->full_name, primary ? "(primary)" : "");
 
-	/* Get ranges property */
-	ranges = of_get_property(dev, "ranges", &rlen);
-	if (ranges == NULL)
+	/* Check for ranges property */
+	if (of_pci_range_parser(&parser, dev))
 		return;
 
-	/* Parse it */
 	pr_debug("Parsing ranges property...\n");
-	while ((rlen -= np * 4) >= 0) {
+	for_each_of_pci_range(&parser, &range) {
 		/* Read next ranges element */
-		pci_space = ranges[0];
-		pci_addr = of_read_number(ranges + 1, 2);
-		cpu_addr = of_translate_address(dev, ranges + 3);
-		size = of_read_number(ranges + pna + 3, 2);
-
-		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
-				pci_space, pci_addr);
-		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
-					cpu_addr, size);
-
-		ranges += np;
+		pr_debug("pci_space: 0x%08x pci_addr: 0x%016llx ",
+				range.pci_space, range.pci_addr);
+		pr_debug("cpu_addr: 0x%016llx size: 0x%016llx\n",
+				range.cpu_addr, range.size);
 
 		/* If we failed translation or got a zero-sized region
 		 * (some FW try to feed us with non sensical zero sized regions
 		 * such as power3 which look like some kind of attempt
 		 * at exposing the VGA memory hole)
 		 */
-		if (cpu_addr == OF_BAD_ADDR || size == 0)
+		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
 			continue;
 
-		/* Now consume following elements while they are contiguous */
-		for (; rlen >= np * sizeof(u32);
-		     ranges += np, rlen -= np * 4) {
-			if (ranges[0] != pci_space)
-				break;
-			pci_next = of_read_number(ranges + 1, 2);
-			cpu_next = of_translate_address(dev, ranges + 3);
-			if (pci_next != pci_addr + size ||
-			    cpu_next != cpu_addr + size)
-				break;
-			size += of_read_number(ranges + pna + 3, 2);
-		}
-
 		/* Act based on address space type */
 		res = NULL;
-		switch ((pci_space >> 24) & 0x3) {
-		case 1:		/* PCI IO space */
+		res_type = range.flags & IORESOURCE_TYPE_BITS;
+		if (res_type == IORESOURCE_IO) {
 			pr_info("  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr);
+				range.cpu_addr, range.cpu_addr + range.size - 1,
+				range.pci_addr);
 
 			/* We support only one IO range */
 			if (hose->pci_io_size) {
@@ -151,11 +127,12 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			}
 #if (!IS_ENABLED(CONFIG_64BIT))
 			/* On 32 bits, limit I/O space to 16MB */
-			if (size > 0x01000000)
-				size = 0x01000000;
+			if (range.size > 0x01000000)
+				range.size = 0x01000000;
 
 			/* 32 bits needs to map IOs here */
-			hose->io_base_virt = ioremap(cpu_addr, size);
+			hose->io_base_virt = ioremap(range.cpu_addr,
+						range.size);
 
 			/* Expect trouble if pci_addr is not 0 */
 			if (primary)
@@ -165,19 +142,18 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			/* pci_io_size and io_base_phys always represent IO
 			 * space starting at 0 so we factor in pci_addr
 			 */
-			hose->pci_io_size = pci_addr + size;
-			hose->io_base_phys = cpu_addr - pci_addr;
+			hose->pci_io_size = range.pci_addr + range.size;
+			hose->io_base_phys = range.cpu_addr - range.pci_addr;
 
 			/* Build resource */
 			res = &hose->io_resource;
-			res->flags = IORESOURCE_IO;
-			res->start = pci_addr;
-			break;
-		case 2:		/* PCI Memory space */
-		case 3:		/* PCI 64 bits Memory space */
+			range.cpu_addr = range.pci_addr;
+		} else if (res_type == IORESOURCE_MEM) {
 			pr_info(" MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr,
-			       (pci_space & 0x40000000) ? "Prefetch" : "");
+				range.cpu_addr, range.cpu_addr + range.size - 1,
+				range.pci_addr,
+				(range.pci_space & 0x40000000) ?
+				"Prefetch" : "");
 
 			/* We support only 3 memory ranges */
 			if (memno >= 3) {
@@ -185,13 +161,13 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				continue;
 			}
 			/* Handles ISA memory hole space here */
-			if (pci_addr == 0) {
-				isa_mb = cpu_addr;
+			if (range.pci_addr == 0) {
+				isa_mb = range.cpu_addr;
 				isa_hole = memno;
 				if (primary || isa_mem_base == 0)
-					isa_mem_base = cpu_addr;
-				hose->isa_mem_phys = cpu_addr;
-				hose->isa_mem_size = size;
+					isa_mem_base = range.cpu_addr;
+				hose->isa_mem_phys = range.cpu_addr;
+				hose->isa_mem_size = range.size;
 			}
 
 			/* We get the PCI/Mem offset from the first range or
@@ -199,30 +175,22 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			 * hole. If they don't match, bugger.
 			 */
 			if (memno == 0 ||
-			    (isa_hole >= 0 && pci_addr != 0 &&
+			(isa_hole >= 0 && range.pci_addr != 0 &&
 			     hose->pci_mem_offset == isa_mb))
-				hose->pci_mem_offset = cpu_addr - pci_addr;
-			else if (pci_addr != 0 &&
-				 hose->pci_mem_offset != cpu_addr - pci_addr) {
+				hose->pci_mem_offset = range.cpu_addr -
+							range.pci_addr;
+			else if (range.pci_addr != 0 &&
+				hose->pci_mem_offset != range.cpu_addr -
+							range.pci_addr) {
 				pr_info(" \\--> Skipped (offset mismatch) !\n");
 				continue;
 			}
 
 			/* Build resource */
 			res = &hose->mem_resources[memno++];
-			res->flags = IORESOURCE_MEM;
-			if (pci_space & 0x40000000)
-				res->flags |= IORESOURCE_PREFETCH;
-			res->start = cpu_addr;
-			break;
-		}
-		if (res != NULL) {
-			res->name = dev->full_name;
-			res->end = res->start + size - 1;
-			res->parent = NULL;
-			res->sibling = NULL;
-			res->child = NULL;
 		}
+		if (res != NULL)
+			of_pci_range_to_resource(&range, dev, res);
 	}
 
 	/* If there's an ISA hole and the pci_mem_offset is -not- matching
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 0506eb5..9702255 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -4,6 +4,36 @@
 #include <linux/errno.h>
 #include <linux/of.h>
 
+struct of_pci_range_parser {
+	struct device_node *node;
+	const __be32 *range;
+	const __be32 *end;
+	int np;
+	int pna;
+};
+
+struct of_pci_range {
+	u32 pci_space;
+	u64 pci_addr;
+	u64 cpu_addr;
+	u64 size;
+	u32 flags;
+};
+
+#define for_each_of_pci_range(parser, range) \
+	for (; of_pci_process_ranges(parser, range);)
+
+static inline void of_pci_range_to_resource(struct of_pci_range *range,
+					    struct device_node *np,
+					    struct resource *res)
+{
+	res->flags = range->flags;
+	res->start = range->cpu_addr;
+	res->end = range->cpu_addr + range->size - 1;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+}
+
 #ifdef CONFIG_OF_ADDRESS
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern bool of_can_translate_address(struct device_node *dev);
@@ -27,6 +57,10 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #define pci_address_to_pio pci_address_to_pio
 #endif
 
+int of_pci_range_parser(struct of_pci_range_parser *parser,
+			struct device_node *node);
+struct of_pci_range *of_pci_process_ranges(struct of_pci_range_parser *parser,
+						struct of_pci_range *range);
 #else /* CONFIG_OF_ADDRESS */
 #ifndef of_address_to_resource
 static inline int of_address_to_resource(struct device_node *dev, int index,
@@ -53,6 +87,18 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
 {
 	return NULL;
 }
+
+int of_pci_range_parser(struct of_pci_range_parser *parser,
+			struct device_noed *node)
+{
+	return -1;
+}
+
+struct of_pci_range *of_pci_process_ranges(struct of_pci_range_parser *parser,
+						struct of_pci_range *range)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF_ADDRESS */
 
 
-- 
1.7.0.4

