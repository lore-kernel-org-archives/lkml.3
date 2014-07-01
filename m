Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbaGASqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:46:12 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50170 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932447AbaGASof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:35 -0400
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
Subject: [PATCH v8 4/9] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Tue,  1 Jul 2014 19:43:29 +0100
Message-Id: <1404240214-9804-5-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ranges property for a host bridge controller in DT describes
the mapping between the PCI bus address and the CPU physical address.
The resources framework however expects that the IO resources start
at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
The conversion from pci ranges to resources failed to take that into account.

In the process move the function into drivers/of/address.c as it now
depends on pci_address_to_pio() code and make it return an error message.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Tested-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/of/address.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_address.h | 13 ++-----------
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 1345733..cbbaed2 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -872,3 +872,50 @@ bool of_dma_is_coherent(struct device_node *np)
 	return false;
 }
 EXPORT_SYMBOL_GPL(of_dma_is_coherent);
+
+/*
+ * of_pci_range_to_resource - Create a resource from an of_pci_range
+ * @range:	the PCI range that describes the resource
+ * @np:		device node where the range belongs to
+ * @res:	pointer to a valid resource that will be updated to
+ *              reflect the values contained in the range.
+ *
+ * Returns EINVAL if the range cannot be converted to resource.
+ *
+ * Note that if the range is an IO range, the resource will be converted
+ * using pci_address_to_pio() which can fail if it is called too early or
+ * if the range cannot be matched to any host bridge IO space (our case here).
+ * To guard against that we try to register the IO range first.
+ * If that fails we know that pci_address_to_pio() will do too.
+ */
+int of_pci_range_to_resource(struct of_pci_range *range,
+	struct device_node *np, struct resource *res)
+{
+	int err;
+	res->flags = range->flags;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+
+	if (res->flags & IORESOURCE_IO) {
+		unsigned long port = -1;
+		err = pci_register_io_range(range->cpu_addr, range->size);
+		if (err)
+			goto invalid_range;
+		port = pci_address_to_pio(range->cpu_addr);
+		if (port == (unsigned long)-1) {
+			err = -EINVAL;
+			goto invalid_range;
+		}
+		res->start = port;
+	} else {
+		res->start = range->cpu_addr;
+	}
+	res->end = res->start + range->size - 1;
+	return 0;
+
+invalid_range:
+	res->start = (resource_size_t)OF_BAD_ADDR;
+	res->end = (resource_size_t)OF_BAD_ADDR;
+	return err;
+}
+
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index ac4aac4..33c0420 100644
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
+extern int of_pci_range_to_resource(struct of_pci_range *range,
+		struct device_node *np, struct resource *res);
 /* Translate a DMA address from device space to CPU space */
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const __be32 *in_addr);
-- 
2.0.0

