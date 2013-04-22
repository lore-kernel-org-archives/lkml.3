Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3DVKnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:43:10 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56209 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751570Ab3DVKnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:43:07 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
Cc: rob.herring@calxeda.com, jgunthorpe@obsidianresearch.com,
        linux@arm.linux.org.uk, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jg1.han@samsung.com, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        bhelgaas@google.com, suren.reddy@samsung.com,
        linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        benh@kernel.crashing.org, paulus@samba.org, grant.likely@secretlab.ca,
        thomas.petazzoni@free-electrons.com, thierry.reding@avionic-design.de,
        thomas.abraham@linaro.org, arnd@arndb.de, linus.walleij@linaro.org,
        juhosg@openwrt.org, Andrew Murray <Andrew.Murray@arm.com>
Subject: [PATCH v8 3/3] of/pci: mips: convert to common of_pci_range_parser
Date: Mon, 22 Apr 2013 11:41:35 +0100
Message-Id: <1366627295-16964-4-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1366627295-16964-1-git-send-email-Andrew.Murray@arm.com>
References: <1366627295-16964-1-git-send-email-Andrew.Murray@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the pci_load_of_ranges function to use the new common
of_pci_range_parser.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Reviewed-by: Rob Herring <rob.herring@calxeda.com>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/mips/pci/pci.c |   51 +++++++++++++++++++--------------------------------
 1 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 0872f12..4b09ca8 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -122,51 +122,38 @@ static void pcibios_scanbus(struct pci_controller *hose)
 #ifdef CONFIG_OF
 void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
 {
-	const __be32 *ranges;
-	int rlen;
-	int pna = of_n_addr_cells(node);
-	int np = pna + 5;
+	struct of_pci_range range;
+	struct of_pci_range_parser parser;
+	u32 res_type;
 
 	pr_info("PCI host bridge %s ranges:\n", node->full_name);
-	ranges = of_get_property(node, "ranges", &rlen);
-	if (ranges == NULL)
-		return;
 	hose->of_node = node;
 
-	while ((rlen -= np * 4) >= 0) {
-		u32 pci_space;
+	if (of_pci_range_parser_init(&parser, node))
+		return;
+
+	for_each_of_pci_range(&parser, &range) {
 		struct resource *res = NULL;
-		u64 addr, size;
-
-		pci_space = be32_to_cpup(&ranges[0]);
-		addr = of_translate_address(node, ranges + 3);
-		size = of_read_number(ranges + pna + 3, 2);
-		ranges += np;
-		switch ((pci_space >> 24) & 0x3) {
-		case 1:		/* PCI IO space */
+
+		switch (range.flags & IORESOURCE_TYPE_BITS) {
+		case IORESOURCE_IO:
 			pr_info("  IO 0x%016llx..0x%016llx\n",
-					addr, addr + size - 1);
+				range.cpu_addr,
+				range.cpu_addr + range.size - 1);
 			hose->io_map_base =
-				(unsigned long)ioremap(addr, size);
+				(unsigned long)ioremap(range.cpu_addr,
+						       range.size);
 			res = hose->io_resource;
-			res->flags = IORESOURCE_IO;
 			break;
-		case 2:		/* PCI Memory space */
-		case 3:		/* PCI 64 bits Memory space */
+		case IORESOURCE_MEM:
 			pr_info(" MEM 0x%016llx..0x%016llx\n",
-					addr, addr + size - 1);
+				range.cpu_addr,
+				range.cpu_addr + range.size - 1);
 			res = hose->mem_resource;
-			res->flags = IORESOURCE_MEM;
 			break;
 		}
-		if (res != NULL) {
-			res->start = addr;
-			res->name = node->full_name;
-			res->end = res->start + size - 1;
-			res->parent = NULL;
-			res->sibling = NULL;
-			res->child = NULL;
-		}
+		if (res != NULL)
+			of_pci_range_to_resource(&range, node, res);
 	}
 }
 #endif
-- 
1.7.0.4

