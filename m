Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbaIWUL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:11:58 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51667 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756582AbaIWULz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:11:55 -0400
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
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v12 04/12] PCI: OF: Move of_pci_range_to_resources() into address.c
Date: Tue, 23 Sep 2014 20:01:06 +0100
Message-Id: <1411498874-9864-5-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ranges property for a host bridge controller in DT describes
the mapping between the PCI bus address and the CPU physical address.
The resources framework however expects that the IO resources start
at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
The conversion from pci ranges to resources failed to take that into account.

In preparation for fixing this of_pci_range_to_resources(), move it into
drivers/of/address.c.

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/of/address.c       | 10 ++++++++++
 include/linux/of_address.h | 19 ++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 758d4f0..86c1055 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -956,3 +956,13 @@ bool of_dma_is_coherent(struct device_node *np)
 	return false;
 }
 EXPORT_SYMBOL_GPL(of_dma_is_coherent);
+
+void of_pci_range_to_resource(struct of_pci_range *range,
+	struct device_node *np,	struct resource *res)
+{
+	res->flags = range->flags;
+	res->start = range->cpu_addr;
+	res->end = range->cpu_addr + range->size - 1;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+}
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index f8cc7da..ac28338 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -23,17 +23,6 @@ struct of_pci_range {
 #define for_each_of_pci_range(parser, range) \
 	for (; of_pci_range_parser_one(parser, range);)
 
-static inline void of_pci_range_to_resource(struct of_pci_range *range,
-					    struct device_node *np,
-					    struct resource *res)
-{
-	res->flags = range->flags;
-	res->start = range->cpu_addr;
-	res->end = range->cpu_addr + range->size - 1;
-	res->parent = res->child = res->sibling = NULL;
-	res->name = np->full_name;
-}
-
 /* Translate a DMA address from device space to CPU space */
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const __be32 *in_addr);
@@ -42,6 +31,9 @@ extern u64 of_translate_dma_address(struct device_node *dev,
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
+extern void of_pci_range_to_resource(struct of_pci_range *range,
+		struct device_node *np, struct resource *res);
+
 extern struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
@@ -68,6 +60,11 @@ extern int of_dma_get_range(struct device_node *np, u64 *dma_addr,
 				u64 *paddr, u64 *size);
 extern bool of_dma_is_coherent(struct device_node *np);
 #else /* CONFIG_OF_ADDRESS */
+static inline void of_pci_range_to_resource(struct of_pci_range *range,
+		struct device_node *np, struct resource *res)
+{
+}
+
 static inline struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
-- 
2.1.0

