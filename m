Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab3EGPcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:32:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:57152 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757511Ab3EGPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:32:29 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: robherring2@gmail.com
Cc: benh@kernel.crashing.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, jgunthorpe@obsidianresearch.com,
        linux@arm.linux.org.uk, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jg1.han@samsung.com, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        bhelgaas@google.com, suren.reddy@samsung.com,
        linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        paulus@samba.org, thomas.petazzoni@free-electrons.com,
        thierry.reding@avionic-design.de, thomas.abraham@linaro.org,
        arnd@arndb.de, linus.walleij@linaro.org, juhosg@openwrt.org,
        grant.likely@linaro.org, Andrew Murray <Andrew.Murray@arm.com>
Subject: [PATCH v9 3/3] of/pci: microblaze: convert to common of_pci_range_parser
Date: Tue,  7 May 2013 16:31:14 +0100
Message-Id: <1367940674-11987-4-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1367940674-11987-1-git-send-email-Andrew.Murray@arm.com>
References: <1367940674-11987-1-git-send-email-Andrew.Murray@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the pci_load_of_ranges function to use the new common
of_pci_range_parser.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/microblaze/pci/pci-common.c |  106 ++++++++++++++------------------------
 1 files changed, 38 insertions(+), 68 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9ea521e..ba9e4a1 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -658,67 +658,42 @@ void pci_resource_to_user(const struct pci_dev *dev, int bar,
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
 
 	pr_info("PCI host bridge %s %s ranges:\n",
 	       dev->full_name, primary ? "(primary)" : "");
 
-	/* Get ranges property */
-	ranges = of_get_property(dev, "ranges", &rlen);
-	if (ranges == NULL)
+	/* Check for ranges property */
+	if (of_pci_range_parser_init(&parser, dev))
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
 		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
-				pci_space, pci_addr);
+				range.pci_space, range.pci_addr);
 		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
-					cpu_addr, size);
-
-		ranges += np;
+					range.cpu_addr, range.size);
 
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
+		switch (range.flags & IORESOURCE_TYPE_BITS) {
+		case IORESOURCE_IO:
 			pr_info("  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr);
+				range.cpu_addr, range.cpu_addr + range.size - 1,
+				range.pci_addr);
 
 			/* We support only one IO range */
 			if (hose->pci_io_size) {
@@ -726,11 +701,12 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 				continue;
 			}
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
@@ -739,19 +715,20 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
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
+			range.cpu_addr = range.pci_addr;
+
 			break;
-		case 2:		/* PCI Memory space */
-		case 3:		/* PCI 64 bits Memory space */
+		case IORESOURCE_MEM:
 			pr_info(" MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
-			       cpu_addr, cpu_addr + size - 1, pci_addr,
-			       (pci_space & 0x40000000) ? "Prefetch" : "");
+				range.cpu_addr, range.cpu_addr + range.size - 1,
+				range.pci_addr,
+				(range.pci_space & 0x40000000) ?
+				"Prefetch" : "");
 
 			/* We support only 3 memory ranges */
 			if (memno >= 3) {
@@ -759,13 +736,13 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
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
@@ -773,30 +750,23 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			 * hole. If they don't match, bugger.
 			 */
 			if (memno == 0 ||
-			    (isa_hole >= 0 && pci_addr != 0 &&
+			    (isa_hole >= 0 && range.pci_addr != 0 &&
 			     hose->pci_mem_offset == isa_mb))
-				hose->pci_mem_offset = cpu_addr - pci_addr;
-			else if (pci_addr != 0 &&
-				 hose->pci_mem_offset != cpu_addr - pci_addr) {
+				hose->pci_mem_offset = range.cpu_addr -
+							range.pci_addr;
+			else if (range.pci_addr != 0 &&
+				 hose->pci_mem_offset != range.cpu_addr -
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
 			break;
 		}
-		if (res != NULL) {
-			res->name = dev->full_name;
-			res->end = res->start + size - 1;
-			res->parent = NULL;
-			res->sibling = NULL;
-			res->child = NULL;
-		}
+		if (res != NULL)
+			of_pci_range_to_resource(&range, dev, res);
 	}
 
 	/* If there's an ISA hole and the pci_mem_offset is -not- matching
-- 
1.7.0.4

