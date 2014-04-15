Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaDOXJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:09:38 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:44332 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaDOXJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:31 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 3/8] Create intel-iommu-private.h
Date: Tue, 15 Apr 2014 17:09:04 -0600
Message-Id: <1397603349-30930-4-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
References: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Move the single block of #define, static inline ... ; struct definitions
 to intel-iommu-private.h from intel-iommu.c
 Replace them with #include "intel-iommu-private.h"


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu-private.h | 351 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c         | 328 +--------------------------------
 2 files changed, 352 insertions(+), 327 deletions(-)
 create mode 100644 drivers/iommu/intel-iommu-private.h

diff --git a/drivers/iommu/intel-iommu-private.h b/drivers/iommu/intel-iommu-private.h
new file mode 100644
index 0000000..73dabec
--- /dev/null
+++ b/drivers/iommu/intel-iommu-private.h
@@ -0,0 +1,351 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ *
+ *
+ *
+ *
+ * Copyright (C) 2006-2008 Intel Corporation
+ * Author: Ashok Raj <ashok.raj@intel.com>
+ * Author: Shaohua Li <shaohua.li@intel.com>
+ * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ * Author: Fenghua Yu <fenghua.yu@intel.com>
+ */
+
+
+#define ROOT_SIZE		VTD_PAGE_SIZE
+#define CONTEXT_SIZE		VTD_PAGE_SIZE
+
+#define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
+#define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
+#define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
+
+#define IOAPIC_RANGE_START	(0xfee00000)
+#define IOAPIC_RANGE_END	(0xfeefffff)
+#define IOVA_START_ADDR		(0x1000)
+
+#define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
+
+#define MAX_AGAW_WIDTH 64
+#define MAX_AGAW_PFN_WIDTH	(MAX_AGAW_WIDTH - VTD_PAGE_SHIFT)
+
+#define __DOMAIN_MAX_PFN(gaw)  ((((uint64_t)1) << (gaw-VTD_PAGE_SHIFT)) - 1)
+#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << gaw) - 1)
+
+/* We limit DOMAIN_MAX_PFN to fit in an unsigned long, and DOMAIN_MAX_ADDR
+   to match. That way, we can use 'unsigned long' for PFNs with impunity. */
+#define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
+				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
+#define DOMAIN_MAX_ADDR(gaw)	(((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
+
+#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
+#define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
+#define DMA_64BIT_PFN		IOVA_PFN(DMA_BIT_MASK(64))
+
+/* page table handling */
+#define LEVEL_STRIDE		(9)
+#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
+
+/*
+ * This bitmap is used to advertise the page sizes our hardware support
+ * to the IOMMU core, which will then use this information to split
+ * physically contiguous memory regions it is mapping into page sizes
+ * that we support.
+ *
+ * Traditionally the IOMMU core just handed us the mappings directly,
+ * after making sure the size is an order of a 4KiB page and that the
+ * mapping has natural alignment.
+ *
+ * To retain this behavior, we currently advertise that we support
+ * all page sizes that are an order of 4KiB.
+ *
+ * If at some point we'd like to utilize the IOMMU core's new behavior,
+ * we could change this to advertise the real page sizes we support.
+ */
+#define INTEL_IOMMU_PGSIZES	(~0xFFFUL)
+
+static inline int agaw_to_level(int agaw)
+{
+	return agaw + 2;
+}
+
+static inline int agaw_to_width(int agaw)
+{
+	return min_t(int, 30 + agaw * LEVEL_STRIDE, MAX_AGAW_WIDTH);
+}
+
+static inline int width_to_agaw(int width)
+{
+	return DIV_ROUND_UP(width - 30, LEVEL_STRIDE);
+}
+
+static inline unsigned int level_to_offset_bits(int level)
+{
+	return (level - 1) * LEVEL_STRIDE;
+}
+
+static inline int pfn_level_offset(unsigned long pfn, int level)
+{
+	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
+}
+
+static inline unsigned long level_mask(int level)
+{
+	return -1UL << level_to_offset_bits(level);
+}
+
+static inline unsigned long level_size(int level)
+{
+	return 1UL << level_to_offset_bits(level);
+}
+
+static inline unsigned long align_to_level(unsigned long pfn, int level)
+{
+	return (pfn + level_size(level) - 1) & level_mask(level);
+}
+
+static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
+{
+	return  1 << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
+}
+
+/* VT-d pages must always be _smaller_ than MM pages. Otherwise things
+   are never going to work. */
+static inline unsigned long dma_to_mm_pfn(unsigned long dma_pfn)
+{
+	return dma_pfn >> (PAGE_SHIFT - VTD_PAGE_SHIFT);
+}
+
+static inline unsigned long mm_to_dma_pfn(unsigned long mm_pfn)
+{
+	return mm_pfn << (PAGE_SHIFT - VTD_PAGE_SHIFT);
+}
+static inline unsigned long page_to_dma_pfn(struct page *pg)
+{
+	return mm_to_dma_pfn(page_to_pfn(pg));
+}
+static inline unsigned long virt_to_dma_pfn(void *p)
+{
+	return page_to_dma_pfn(virt_to_page(p));
+}
+
+
+/*
+ * 0: Present
+ * 1-11: Reserved
+ * 12-63: Context Ptr (12 - (haw-1))
+ * 64-127: Reserved
+ */
+struct root_entry {
+	u64	val;
+	u64	rsvd1;
+};
+#define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
+static inline bool root_present(struct root_entry *root)
+{
+	return root->val & 1;
+}
+static inline void set_root_present(struct root_entry *root)
+{
+	root->val |= 1;
+}
+static inline void set_root_value(struct root_entry *root, unsigned long value)
+{
+	root->val |= value & VTD_PAGE_MASK;
+}
+
+static inline struct context_entry *
+get_context_addr_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root)?phys_to_virt(
+		root->val & VTD_PAGE_MASK) :
+		NULL);
+}
+
+/*
+ * low 64 bits:
+ * 0: present
+ * 1: fault processing disable
+ * 2-3: translation type
+ * 12-63: address space root
+ * high 64 bits:
+ * 0-2: address width
+ * 3-6: aval
+ * 8-23: domain id
+ */
+struct context_entry {
+	u64 lo;
+	u64 hi;
+};
+
+static inline bool context_present(struct context_entry *context)
+{
+	return context->lo & 1;
+}
+static inline void context_set_present(struct context_entry *context)
+{
+	context->lo |= 1;
+}
+
+static inline void context_set_fault_enable(struct context_entry *context)
+{
+	context->lo &= (((u64)-1) << 2) | 1;
+}
+
+static inline void context_set_translation_type(struct context_entry *context,
+						unsigned long value)
+{
+	context->lo &= (((u64)-1) << 4) | 3;
+	context->lo |= (value & 3) << 2;
+}
+
+static inline void context_set_address_root(struct context_entry *context,
+					    unsigned long value)
+{
+	context->lo |= value & VTD_PAGE_MASK;
+}
+
+static inline void context_set_address_width(struct context_entry *context,
+					     unsigned long value)
+{
+	context->hi |= value & 7;
+}
+
+static inline void context_set_domain_id(struct context_entry *context,
+					 unsigned long value)
+{
+	context->hi |= (value & ((1 << 16) - 1)) << 8;
+}
+
+static inline void context_clear_entry(struct context_entry *context)
+{
+	context->lo = 0;
+	context->hi = 0;
+}
+
+/*
+ * 0: readable
+ * 1: writable
+ * 2-6: reserved
+ * 7: super page
+ * 8-10: available
+ * 11: snoop behavior
+ * 12-63: Host physcial address
+ */
+struct dma_pte {
+	u64 val;
+};
+
+static inline void dma_clear_pte(struct dma_pte *pte)
+{
+	pte->val = 0;
+}
+
+static inline u64 dma_pte_addr(struct dma_pte *pte)
+{
+#ifdef CONFIG_64BIT
+	return pte->val & VTD_PAGE_MASK;
+#else
+	/* Must have a full atomic 64-bit read */
+	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
+#endif
+}
+
+static inline bool dma_pte_present(struct dma_pte *pte)
+{
+	return (pte->val & 3) != 0;
+}
+
+static inline bool dma_pte_superpage(struct dma_pte *pte)
+{
+	return pte->val & (1 << 7);
+}
+
+static inline int first_pte_in_page(struct dma_pte *pte)
+{
+	return !((unsigned long)pte & ~VTD_PAGE_MASK);
+}
+
+/* devices under the same p2p bridge are owned in one domain */
+#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
+
+/* domain represents a virtual machine, more than one devices
+ * across iommus may be owned in one domain, e.g. kvm guest.
+ */
+#define DOMAIN_FLAG_VIRTUAL_MACHINE	(1 << 1)
+
+/* si_domain contains mulitple devices */
+#define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
+
+/* define the limit of IOMMUs supported in each domain */
+#ifdef	CONFIG_X86
+# define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
+#else
+# define	IOMMU_UNITS_SUPPORTED	64
+#endif
+
+struct dmar_domain {
+	int	id;			/* domain id */
+	int	nid;			/* node id */
+	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
+					/* bitmap of iommus this domain uses*/
+
+	struct list_head devices;	/* all devices' list */
+	struct iova_domain iovad;	/* iova's that belong to this domain */
+
+	struct dma_pte	*pgd;		/* virtual address */
+	int		gaw;		/* max guest address width */
+
+	/* adjusted guest address width, 0 is level 2 30-bit */
+	int		agaw;
+
+	int		flags;		/* flags to find out type of domain */
+
+	int		iommu_coherency;/* indicate coherency of iommu access */
+	int		iommu_snooping; /* indicate snooping control feature*/
+	int		iommu_count;	/* reference count of iommu */
+	int		iommu_superpage;/* Level of superpages supported:
+					   0 == 4KiB (no superpages), 1 == 2MiB,
+					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
+	spinlock_t	iommu_lock;	/* protect iommu set in domain */
+	u64		max_addr;	/* maximum mapped address */
+};
+
+/* PCI domain-device relationship */
+struct device_domain_info {
+	struct list_head link;	/* link to domain siblings */
+	struct list_head global; /* link to global list */
+	int segment;		/* PCI domain */
+	u8 bus;			/* PCI bus number */
+	u8 devfn;		/* PCI devfn number */
+	struct pci_dev *dev; /* it's NULL for PCIe-to-PCI bridge */
+	struct intel_iommu *iommu; /* IOMMU used by this device */
+	struct dmar_domain *domain; /* pointer to domain */
+};
+
+static inline void *alloc_pgtable_page(int node)
+{
+	struct page *page;
+	void *vaddr = NULL;
+
+	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
+	if (page)
+		vaddr = page_address(page);
+	return vaddr;
+}
+
+static inline void free_pgtable_page(void *vaddr)
+{
+	free_page((unsigned long)vaddr);
+}
+
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 22298e9..4352731 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -48,333 +48,7 @@
 
 #include "irq_remapping.h"
 #include "pci.h"
-
-#define ROOT_SIZE		VTD_PAGE_SIZE
-#define CONTEXT_SIZE		VTD_PAGE_SIZE
-
-#define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
-#define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
-#define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
-
-#define IOAPIC_RANGE_START	(0xfee00000)
-#define IOAPIC_RANGE_END	(0xfeefffff)
-#define IOVA_START_ADDR		(0x1000)
-
-#define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
-
-#define MAX_AGAW_WIDTH 64
-#define MAX_AGAW_PFN_WIDTH	(MAX_AGAW_WIDTH - VTD_PAGE_SHIFT)
-
-#define __DOMAIN_MAX_PFN(gaw)  ((((uint64_t)1) << (gaw-VTD_PAGE_SHIFT)) - 1)
-#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << gaw) - 1)
-
-/* We limit DOMAIN_MAX_PFN to fit in an unsigned long, and DOMAIN_MAX_ADDR
-   to match. That way, we can use 'unsigned long' for PFNs with impunity. */
-#define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
-				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
-#define DOMAIN_MAX_ADDR(gaw) (((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
-
-#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
-#define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
-#define DMA_64BIT_PFN		IOVA_PFN(DMA_BIT_MASK(64))
-
-/* page table handling */
-#define LEVEL_STRIDE		(9)
-#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
-
-/*
- * This bitmap is used to advertise the page sizes our hardware support
- * to the IOMMU core, which will then use this information to split
- * physically contiguous memory regions it is mapping into page sizes
- * that we support.
- *
- * Traditionally the IOMMU core just handed us the mappings directly,
- * after making sure the size is an order of a 4KiB page and that the
- * mapping has natural alignment.
- *
- * To retain this behavior, we currently advertise that we support
- * all page sizes that are an order of 4KiB.
- *
- * If at some point we'd like to utilize the IOMMU core's new behavior,
- * we could change this to advertise the real page sizes we support.
- */
-#define INTEL_IOMMU_PGSIZES	(~0xFFFUL)
-
-static inline int agaw_to_level(int agaw)
-{
-	return agaw + 2;
-}
-
-static inline int agaw_to_width(int agaw)
-{
-	return min_t(int, 30 + agaw * LEVEL_STRIDE, MAX_AGAW_WIDTH);
-}
-
-static inline int width_to_agaw(int width)
-{
-	return DIV_ROUND_UP(width - 30, LEVEL_STRIDE);
-}
-
-static inline unsigned int level_to_offset_bits(int level)
-{
-	return (level - 1) * LEVEL_STRIDE;
-}
-
-static inline int pfn_level_offset(unsigned long pfn, int level)
-{
-	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
-}
-
-static inline unsigned long level_mask(int level)
-{
-	return -1UL << level_to_offset_bits(level);
-}
-
-static inline unsigned long level_size(int level)
-{
-	return 1UL << level_to_offset_bits(level);
-}
-
-static inline unsigned long align_to_level(unsigned long pfn, int level)
-{
-	return (pfn + level_size(level) - 1) & level_mask(level);
-}
-
-static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
-{
-	return  1 << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
-}
-
-/* VT-d pages must always be _smaller_ than MM pages. Otherwise things
-   are never going to work. */
-static inline unsigned long dma_to_mm_pfn(unsigned long dma_pfn)
-{
-	return dma_pfn >> (PAGE_SHIFT - VTD_PAGE_SHIFT);
-}
-
-static inline unsigned long mm_to_dma_pfn(unsigned long mm_pfn)
-{
-	return mm_pfn << (PAGE_SHIFT - VTD_PAGE_SHIFT);
-}
-static inline unsigned long page_to_dma_pfn(struct page *pg)
-{
-	return mm_to_dma_pfn(page_to_pfn(pg));
-}
-static inline unsigned long virt_to_dma_pfn(void *p)
-{
-	return page_to_dma_pfn(virt_to_page(p));
-}
-
-
-/*
- * 0: Present
- * 1-11: Reserved
- * 12-63: Context Ptr (12 - (haw-1))
- * 64-127: Reserved
- */
-struct root_entry {
-	u64	val;
-	u64	rsvd1;
-};
-#define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
-static inline bool root_present(struct root_entry *root)
-{
-	return root->val & 1;
-}
-static inline void set_root_present(struct root_entry *root)
-{
-	root->val |= 1;
-}
-static inline void set_root_value(struct root_entry *root, unsigned long value)
-{
-	root->val |= value & VTD_PAGE_MASK;
-}
-
-static inline struct context_entry *
-get_context_addr_from_root(struct root_entry *root)
-{
-	return (struct context_entry *)
-		(root_present(root)?phys_to_virt(
-		root->val & VTD_PAGE_MASK) :
-		NULL);
-}
-
-/*
- * low 64 bits:
- * 0: present
- * 1: fault processing disable
- * 2-3: translation type
- * 12-63: address space root
- * high 64 bits:
- * 0-2: address width
- * 3-6: aval
- * 8-23: domain id
- */
-struct context_entry {
-	u64 lo;
-	u64 hi;
-};
-
-static inline bool context_present(struct context_entry *context)
-{
-	return context->lo & 1;
-}
-static inline void context_set_present(struct context_entry *context)
-{
-	context->lo |= 1;
-}
-
-static inline void context_set_fault_enable(struct context_entry *context)
-{
-	context->lo &= (((u64)-1) << 2) | 1;
-}
-
-static inline void context_set_translation_type(struct context_entry *context,
-						unsigned long value)
-{
-	context->lo &= (((u64)-1) << 4) | 3;
-	context->lo |= (value & 3) << 2;
-}
-
-static inline void context_set_address_root(struct context_entry *context,
-					    unsigned long value)
-{
-	context->lo |= value & VTD_PAGE_MASK;
-}
-
-static inline void context_set_address_width(struct context_entry *context,
-					     unsigned long value)
-{
-	context->hi |= value & 7;
-}
-
-static inline void context_set_domain_id(struct context_entry *context,
-					 unsigned long value)
-{
-	context->hi |= (value & ((1 << 16) - 1)) << 8;
-}
-
-static inline void context_clear_entry(struct context_entry *context)
-{
-	context->lo = 0;
-	context->hi = 0;
-}
-
-/*
- * 0: readable
- * 1: writable
- * 2-6: reserved
- * 7: super page
- * 8-10: available
- * 11: snoop behavior
- * 12-63: Host physcial address
- */
-struct dma_pte {
-	u64 val;
-};
-
-static inline void dma_clear_pte(struct dma_pte *pte)
-{
-	pte->val = 0;
-}
-
-static inline u64 dma_pte_addr(struct dma_pte *pte)
-{
-#ifdef CONFIG_64BIT
-	return pte->val & VTD_PAGE_MASK;
-#else
-	/* Must have a full atomic 64-bit read */
-	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
-#endif
-}
-
-static inline bool dma_pte_present(struct dma_pte *pte)
-{
-	return (pte->val & 3) != 0;
-}
-
-static inline bool dma_pte_superpage(struct dma_pte *pte)
-{
-	return pte->val & (1 << 7);
-}
-
-static inline int first_pte_in_page(struct dma_pte *pte)
-{
-	return !((unsigned long)pte & ~VTD_PAGE_MASK);
-}
-
-/* devices under the same p2p bridge are owned in one domain */
-#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
-
-/* domain represents a virtual machine, more than one devices
- * across iommus may be owned in one domain, e.g. kvm guest.
- */
-#define DOMAIN_FLAG_VIRTUAL_MACHINE	(1 << 1)
-
-/* si_domain contains mulitple devices */
-#define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
-
-/* define the limit of IOMMUs supported in each domain */
-#ifdef	CONFIG_X86
-# define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
-#else
-# define	IOMMU_UNITS_SUPPORTED	64
-#endif
-
-struct dmar_domain {
-	int	id;			/* domain id */
-	int	nid;			/* node id */
-	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
-					/* bitmap of iommus this domain uses*/
-
-	struct list_head devices;	/* all devices' list */
-	struct iova_domain iovad;	/* iova's that belong to this domain */
-
-	struct dma_pte	*pgd;		/* virtual address */
-	int		gaw;		/* max guest address width */
-
-	/* adjusted guest address width, 0 is level 2 30-bit */
-	int		agaw;
-
-	int		flags;		/* flags to find out type of domain */
-
-	int		iommu_coherency;/* indicate coherency of iommu access */
-	int		iommu_snooping; /* indicate snooping control feature*/
-	int		iommu_count;	/* reference count of iommu */
-	int		iommu_superpage;/* Level of superpages supported:
-					   0 == 4KiB (no superpages), 1 == 2MiB,
-					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
-	spinlock_t	iommu_lock;	/* protect iommu set in domain */
-	u64		max_addr;	/* maximum mapped address */
-};
-
-/* PCI domain-device relationship */
-struct device_domain_info {
-	struct list_head link;	/* link to domain siblings */
-	struct list_head global; /* link to global list */
-	int segment;		/* PCI domain */
-	u8 bus;			/* PCI bus number */
-	u8 devfn;		/* PCI devfn number */
-	struct pci_dev *dev; /* it's NULL for PCIe-to-PCI bridge */
-	struct intel_iommu *iommu; /* IOMMU used by this device */
-	struct dmar_domain *domain; /* pointer to domain */
-};
-
-static inline void *alloc_pgtable_page(int node)
-{
-	struct page *page;
-	void *vaddr = NULL;
-
-	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
-	if (page)
-		vaddr = page_address(page);
-	return vaddr;
-}
-
-static inline void free_pgtable_page(void *vaddr)
-{
-	free_page((unsigned long)vaddr);
-}
+#include "intel-iommu-private.h"
 
 
 static void __init check_tylersburg_isoch(void);
-- 
Bill Sumner <bill.sumner@hp.com>

