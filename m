Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaIWUC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:02:57 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54803 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756577AbaIWUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:02:53 -0400
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v12 11/12] PCI: Introduce pci_remap_iospace() for remapping PCI I/O bus resources into CPU space
Date: Tue, 23 Sep 2014 20:01:13 +0100
Message-Id: <1411498874-9864-12-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a default implementation for remapping PCI bus I/O resources
onto the CPU address space. Architectures with special needs may
provide their own version, but most should be able to use this one.

This function is useful for PCI host bridge drivers that need to map
the PCI I/O resources into virtual memory space.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/pci.c             | 34 ++++++++++++++++++++++++++++++++++
 include/asm-generic/pgtable.h |  4 ++++
 include/linux/pci.h           |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d36f35f..ad046a2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2704,6 +2704,40 @@ int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
 }
 EXPORT_SYMBOL(pci_request_regions_exclusive);
 
+/**
+ *	pci_remap_iospace - Remap the memory mapped I/O space
+ *	@res: Resource describing the I/O space
+ *	@phys_addr: physical address where the range will be mapped.
+ *
+ *	Remap the memory mapped I/O space described by the @res
+ *	and the CPU physical address @phys_addr into virtual address space.
+ *	Only architectures that have memory mapped IO functions defined
+ *	(and the PCI_IOBASE value defined) should call this function.
+ */
+int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
+{
+	int err = -ENODEV;
+
+#if defined(PCI_IOBASE) && defined(CONFIG_MMU)
+	unsigned long vaddr = (unsigned long)PCI_IOBASE + res->start;
+
+	if (!(res->flags & IORESOURCE_IO))
+		return -EINVAL;
+
+	if (res->end > IO_SPACE_LIMIT)
+		return -EINVAL;
+
+	err = ioremap_page_range(vaddr, vaddr + resource_size(res),
+				phys_addr, pgprot_device(PAGE_KERNEL));
+#else
+	/* this architecture does not have memory mapped I/O space,
+	   so this function should never be called */
+	WARN_ONCE(1, "This architecture does not support memory mapped I/O\n");
+#endif
+
+	return err;
+}
+
 static void __pci_set_master(struct pci_dev *dev, bool enable)
 {
 	u16 old_cmd, cmd;
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 53b2acc..977e545 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -249,6 +249,10 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 #define pgprot_writecombine pgprot_noncached
 #endif
 
+#ifndef pgprot_device
+#define pgprot_device pgprot_noncached
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 150da2d..b4995fd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1100,6 +1100,9 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 						  resource_size_t),
 			void *alignf_data);
 
+
+int pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr);
+
 static inline dma_addr_t pci_bus_address(struct pci_dev *pdev, int bar)
 {
 	struct pci_bus_region region;
-- 
2.1.0

