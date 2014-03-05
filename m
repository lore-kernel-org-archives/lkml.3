Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaCELxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:53:00 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51492 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755203AbaCELti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:49:38 -0500
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
Subject: [PATCH v6 2/6] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Wed,  5 Mar 2014 11:48:53 +0000
Message-Id: <1394020137-1830-3-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ranges property for a host bridge controller in DT describes
the mapping between the PCI bus address and the CPU physical address.
The resources framework however expects that the IO resources start
at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
The conversion from pci ranges to resources failed to take that into account.

In the process move the function into drivers/of/address.c as it
now depends on pci_address_to_pio() code.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Tested-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/of/address.c       | 34 ++++++++++++++++++++++++++++++++++
 include/linux/of_address.h | 13 ++-----------
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index d1bb30f..d595d98 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -724,3 +724,37 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
+
+/**
+ * of_pci_range_to_resource - Create a resource from an of_pci_range
+ * @range:	the PCI range that describes the resource
+ * @np:		device node where the range belongs to
+ * @res:	pointer to a valid resource that will be updated to
+ *              reflect the values contained in the range.
+ * Note that if the range is an IO range, the resource will be converted
+ * using pci_address_to_pio() which can fail if it is called too early or
+ * if the range cannot be matched to any host bridge IO space (our case here).
+ * To guard against that we try to register the IO range first.
+ * If that fails we know that pci_address_to_pio() will do too.
+ */
+void of_pci_range_to_resource(struct of_pci_range *range,
+	struct device_node *np, struct resource *res)
+{
+	res->flags = range->flags;
+	if (res->flags & IORESOURCE_IO) {
+		unsigned long port = -1;
+		if (!pci_register_io_range(range->cpu_addr, range->size))
+			port = pci_address_to_pio(range->cpu_addr);
+		if (port == (unsigned long)-1) {
+			res->start = (resource_size_t)OF_BAD_ADDR;
+			res->end = (resource_size_t)OF_BAD_ADDR;
+			return;
+		}
+		res->start = port;
+	} else {
+		res->start = range->cpu_addr;
+	}
+	res->end = res->start + range->size - 1;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+}
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 40c418d..3fe500a 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -23,17 +23,8 @@ struct of_pci_range {
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
+extern void of_pci_range_to_resource(struct of_pci_range *range,
+		struct device_node *np, struct resource *res);
 /* Translate a DMA address from device space to CPU space */
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const __be32 *in_addr);
-- 
1.9.0

