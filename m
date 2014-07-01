Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964970AbaGASrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:47:42 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50160 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932392AbaGASob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:31 -0400
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
Subject: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Tue,  1 Jul 2014 19:43:28 +0100
Message-Id: <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures do not have a simple view of the PCI I/O space
and instead use a range of CPU addresses that map to bus addresses. For
some architectures these ranges will be expressed by OF bindings
in a device tree file.

Introduce a pci_register_io_range() helper function with a generic
implementation that can be used by such architectures to keep track
of the I/O ranges described by the PCI bindings. If the PCI_IOBASE
macro is not defined that signals lack of support for PCI and we
return an error.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/of/address.c       | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_address.h |  1 +
 2 files changed, 62 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 5edfcb0..1345733 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/pci_regs.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 /* Max address size we deal with */
@@ -601,12 +602,72 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
 }
 EXPORT_SYMBOL(of_get_address);
 
+struct io_range {
+	struct list_head list;
+	phys_addr_t start;
+	resource_size_t size;
+};
+
+static LIST_HEAD(io_range_list);
+
+/*
+ * Record the PCI IO range (expressed as CPU physical address + size).
+ * Return a negative value if an error has occured, zero otherwise
+ */
+int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
+{
+#ifdef PCI_IOBASE
+	struct io_range *res;
+	resource_size_t allocated_size = 0;
+
+	/* check if the range hasn't been previously recorded */
+	list_for_each_entry(res, &io_range_list, list) {
+		if (addr >= res->start && addr + size <= res->start + size)
+			return 0;
+		allocated_size += res->size;
+	}
+
+	/* range not registed yet, check for available space */
+	if (allocated_size + size - 1 > IO_SPACE_LIMIT)
+		return -E2BIG;
+
+	/* add the range to the list */
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	res->start = addr;
+	res->size = size;
+
+	list_add_tail(&res->list, &io_range_list);
+
+	return 0;
+#else
+	return -EINVAL;
+#endif
+}
+
 unsigned long __weak pci_address_to_pio(phys_addr_t address)
 {
+#ifdef PCI_IOBASE
+	struct io_range *res;
+	resource_size_t offset = 0;
+
+	list_for_each_entry(res, &io_range_list, list) {
+		if (address >= res->start &&
+			address < res->start + res->size) {
+			return res->start - address + offset;
+		}
+		offset += res->size;
+	}
+
+	return (unsigned long)-1;
+#else
 	if (address > IO_SPACE_LIMIT)
 		return (unsigned long)-1;
 
 	return (unsigned long) address;
+#endif
 }
 
 static int __of_address_to_resource(struct device_node *dev,
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index c13b878..ac4aac4 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -55,6 +55,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
 extern const __be32 *of_get_address(struct device_node *dev, int index,
 			   u64 *size, unsigned int *flags);
 
+extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
 extern unsigned long pci_address_to_pio(phys_addr_t addr);
 
 extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
-- 
2.0.0

