Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaCNPfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:35:18 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50998 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755524AbaCNPfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:35:15 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
Date: Fri, 14 Mar 2014 15:34:27 +0000
Message-Id: <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures do not share x86 simple view of the PCI I/O space
and instead use a range of addresses that map to bus addresses. For
some architectures these ranges will be expressed by OF bindings
in a device tree file.

Introduce a pci_register_io_range() helper function that can be used
by the architecture code to keep track of the I/O ranges described by the
PCI bindings. If the PCI_IOBASE macro is not defined that signals
lack of support for PCI and we return an error.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Acked-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/of/address.c       | 9 +++++++++
 include/linux/of_address.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 1a54f1f..be958ed 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -619,6 +619,15 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
 }
 EXPORT_SYMBOL(of_get_address);
 
+int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
+{
+#ifndef PCI_IOBASE
+	return -EINVAL;
+#else
+	return 0;
+#endif
+}
+
 unsigned long __weak pci_address_to_pio(phys_addr_t address)
 {
 	if (address > IO_SPACE_LIMIT)
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 5f6ed6b..40c418d 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -56,6 +56,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
 extern const __be32 *of_get_address(struct device_node *dev, int index,
 			   u64 *size, unsigned int *flags);
 
+extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
 extern unsigned long pci_address_to_pio(phys_addr_t addr);
 
 extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
-- 
1.9.0

