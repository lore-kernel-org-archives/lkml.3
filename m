Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaJUIIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:08:36 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:35392 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaJUIFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:07 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 3/5] iommu/vt-d: data types and functions used for kdump
Date: Tue, 21 Oct 2014 16:04:17 +0800
Message-Id: <1413878659-1383-4-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate it with support functions to copy iommu translation tables from
from the panicked kernel into the kdump kernel in the event of a crash.

Bill Sumner:
    Original version, the creation of the data types and functions.

Li, Zhenhua:
    Minor change: update the usage of context_get_* and context_put*,
    use context_* and context_set_* for replacement.

Signed-off-by: Bill Sumner 
Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel-iommu.c | 562 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 562 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 99fe408..73afed4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -378,6 +378,65 @@ struct domain_values_entry {
 					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
 };
 
+/*
+ * Lists of domain_values_entry to hold domain values found during the copy.
+ * One list for each iommu in g_number_of_iommus.
+ */
+static struct list_head *domain_values_list;
+
+
+/* ========================================================================
+ * Copy iommu translation tables from old kernel into new  kernel.
+ * Entry to this set of functions is: intel_iommu_copy_translation_tables()
+ * ------------------------------------------------------------------------
+ */
+#define RET_BADCOPY -1	/* Return-code: Cannot copy translate tables */
+
+/*
+ * Struct copy_page_addr_parms is used to allow copy_page_addr()
+ * to accumulate values across multiple calls and returns.
+ */
+struct copy_page_addr_parms {
+	u32 first;	/* flag: first-time  */
+	u32 last;	/* flag: last-time */
+	u32 bus;	/* last bus number we saw */
+	u32 devfn;	/* last devfn we saw */
+	u32 shift;	/* last shift we saw */
+	u64 pte;	/* Page Table Entry */
+	u64 next_addr;	/* next-expected page_addr */
+
+	u64 page_addr;	/* page_addr accumulating size */
+	u64 page_size;	/* page_size accumulated */
+
+	struct domain_values_entry *dve;	/* to accumulate iova ranges */
+};
+
+enum returns_from_copy_context_entry {
+RET_CCE_NOT_PRESENT = 1,
+RET_CCE_NEW_PAGE_TABLES,
+RET_CCE_PASS_THROUGH_1,
+RET_CCE_PASS_THROUGH_2,
+RET_CCE_RESERVED_VALUE,
+RET_CCE_PREVIOUS_DID
+};
+
+static int copy_context_entry(struct intel_iommu *iommu, u32 bus, u32 devfn,
+			      void *ppap, struct context_entry *ce);
+
+static int copy_context_entry_table(struct intel_iommu *iommu,
+				    u32 bus, void *ppap,
+				    struct context_entry **context_new_p,
+				    struct context_entry *context_old_phys);
+
+static int copy_root_entry_table(struct intel_iommu *iommu, void *ppap,
+				 struct root_entry  **root_new_virt_p,
+				 struct root_entry  *root_old_phys);
+
+static int intel_iommu_copy_translation_tables(struct dmar_drhd_unit *drhd,
+		struct root_entry **root_old_phys_p,
+		struct root_entry **root_new_virt_p,
+		int g_num_of_iommus);
+
 #endif /* CONFIG_CRASH_DUMP */
 
 /*
@@ -4669,3 +4728,506 @@ static void __init check_tylersburg_isoch(void)
 	printk(KERN_WARNING "DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set %d\n",
 	       vtisochctrl);
 }
+
+#ifdef CONFIG_CRASH_DUMP
+
+/*
+ * Copy memory from a physically-addressed area into a virtually-addressed area
+ */
+static int oldcopy(void *to, void *from, int size)
+{
+	size_t ret = 0;			/* Length copied */
+	unsigned long pfn;		/* Page Frame Number */
+	char *buf = to;			/* Adr(Output buffer) */
+	size_t csize = (size_t)size;	/* Num(bytes to copy) */
+	unsigned long offset;		/* Lower 12 bits of from */
+	int userbuf = 0;		/* to is in kernel space */
+
+
+	pfn = ((unsigned long) from) >> VTD_PAGE_SHIFT;
+	offset = ((unsigned long) from) & (~VTD_PAGE_MASK);
+	ret = copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+
+	return (int) ret;
+}
+
+
+/*
+ * constant for initializing instances of copy_page_addr_parms properly.
+ */
+static struct copy_page_addr_parms copy_page_addr_parms_init = {1, 0};
+
+
+
+/*
+ * Lowest-level function in the 'Copy Page Tables' set
+ * Called once for each page_addr present in an iommu page-address table.
+ *
+ * Because of the depth-first traversal of the page-tables by the
+ * higher-level functions that call 'copy_page_addr', all pages
+ * of a domain will be presented in ascending order of IO Virtual Address.
+ *
+ * This function accumulates each contiguous range of these IOVAs and
+ * reserves it within the proper domain in the crashdump kernel when a
+ * non-contiguous range is detected, as determined by any of the following:
+ * 1. a change in the bus or device owning the presented page
+ * 2. a change in the page-size of the presented page (parameter shift)
+ * 3. a change in the page-table entry of the presented page
+ * 4. a presented IOVA that does not match the expected next-page address
+ * 5. the 'last' flag is set, indicating that all IOVAs have been seen.
+ */
+static int copy_page_addr(u64 page_addr, u32 shift, u32 bus, u32 devfn,
+				u64 pte, struct domain_values_entry *dve,
+				void *parms)
+{
+	struct copy_page_addr_parms *ppap = parms;
+
+	u64 page_size = ((u64)1 << shift);	/* page_size */
+	u64 pfn_lo;				/* For reserving IOVA range */
+	u64 pfn_hi;				/* For reserving IOVA range */
+	struct iova *iova_p;			/* For reserving IOVA range */
+
+	if (!ppap) {
+		pr_err("ERROR: ppap is NULL: 0x%3.3x(%3.3d) DevFn: 0x%3.3x(%3.3d) Page: 0x%16.16llx Size: 0x%16.16llx(%lld)\n",
+			bus, bus, devfn, devfn,  page_addr,
+			page_size, page_size);
+		return 0;
+	}
+
+	/* If (only extending current addr range) */
+	if (ppap->first     == 0      &&
+	    ppap->last      == 0      &&
+	    ppap->bus       == bus    &&
+	    ppap->devfn     == devfn  &&
+	    ppap->shift     == shift  &&
+	    (ppap->pte & ~VTD_PAGE_MASK) == (pte & ~VTD_PAGE_MASK) &&
+	    ppap->next_addr == page_addr) {
+
+		/* Update page size and next-expected address */
+		ppap->next_addr += page_size;
+		ppap->page_size += page_size;
+		return 0;
+	}
+
+	if (!ppap->first) {
+		/* Close-out the accumulated IOVA address range */
+
+		if (!ppap->dve) {
+			pr_err("%s ERROR: ppap->dve is NULL -- needed to reserve range for B:D:F=%2.2x:%2.2x:%1.1x\n",
+				__func__,
+				ppap->bus, ppap->devfn >> 3, ppap->devfn & 0x7);
+			return RET_BADCOPY;
+		}
+		pfn_lo = IOVA_PFN(ppap->page_addr);
+		pfn_hi = IOVA_PFN(ppap->page_addr + ppap->page_size);
+		iova_p = reserve_iova(&ppap->dve->iovad, pfn_lo, pfn_hi);
+	}
+
+	/* Prepare for a new IOVA address range */
+	ppap->first     = 0;		/* Not first-time anymore */
+	ppap->bus       = bus;
+	ppap->devfn     = devfn;
+	ppap->shift     = shift;
+	ppap->pte       = pte;
+	ppap->next_addr = page_addr + page_size; /* Next-expected page_addr */
+
+	ppap->page_addr = page_addr;	/* Addr(new page) */
+	ppap->page_size = page_size;	/* Size(new page) */
+
+	ppap->dve	= dve;	/* adr(device_values_entry for new range) */
+
+	return 0;
+}
+
+/*
+ * Recursive function to copy the tree of page tables (max 6 recursions)
+ * Parameter 'shift' controls the recursion
+ */
+static int copy_page_table(struct dma_pte **dma_pte_new_p,
+			   struct dma_pte *dma_pte_phys,
+			   u32 shift, u64 page_addr,
+			   struct intel_iommu *iommu,
+			   u32 bus, u32 devfn,
+			   struct domain_values_entry *dve, void *ppap)
+{
+	int ret;			/* Integer return code */
+	struct dma_pte *p;		/* Physical adr(each entry) iterator */
+	struct dma_pte *pgt_new_virt;	/* Adr(dma_pte in new kernel) */
+	struct dma_pte *dma_pte_next;	/* Adr(next table down)  */
+	u64 u;				/* index(each entry in page_table) */
+
+
+	/* If (already done all levels -- problem) */
+	if (shift < 12) {
+		pr_err("ERROR %s shift < 12 %p\n", __func__, dma_pte_phys);
+		pr_err("shift %d, page_addr %16.16llu bus %3.3u devfn %3.3u\n",
+			shift, page_addr, bus, devfn);
+		return RET_BADCOPY;
+	}
+
+	/* allocate a page table in the new kernel
+	 * copy contents from old kernel
+	 * then update each entry in the table in the new kernel
+	 */
+
+	pgt_new_virt = (struct dma_pte *)alloc_pgtable_page(iommu->node);
+	if (!pgt_new_virt)
+		return -ENOMEM;
+
+	ret = oldcopy(pgt_new_virt, dma_pte_phys, VTD_PAGE_SIZE);
+	if (ret <= 0)
+		return ret;
+
+	for (u = 0, p = pgt_new_virt; u < 512; u++, p++) {
+
+		if (((p->val & DMA_PTE_READ) == 0) &&
+		    ((p->val & DMA_PTE_WRITE) == 0))
+			continue;
+
+		if (dma_pte_superpage(p) || (shift == 12)) {
+
+			ret = copy_page_addr(page_addr | (u << shift),
+				shift, bus, devfn, p->val, dve, ppap);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		ret = copy_page_table(&dma_pte_next,
+				(struct dma_pte *)(p->val & VTD_PAGE_MASK),
+				shift-9, page_addr | (u << shift),
+				iommu, bus, devfn, dve, ppap);
+		if (ret)
+			return ret;
+
+		p->val &= ~VTD_PAGE_MASK;	/* Clear old and set new pgd */
+		p->val |= ((u64)dma_pte_next & VTD_PAGE_MASK);
+	}
+
+	*dma_pte_new_p = (struct dma_pte *)virt_to_phys(pgt_new_virt);
+	__iommu_flush_cache(iommu, pgt_new_virt, VTD_PAGE_SIZE);
+
+	return 0;
+}
+
+
+/*
+ * Called once for each context_entry found in a copied context_entry_table
+ * Each context_entry represents one PCIe device handled by the IOMMU.
+ *
+ * The 'domain_values_list' contains one 'domain_values_entry' for each
+ * unique domain-id found while copying the context entries for each iommu.
+ *
+ * The Intel-iommu spec. requires that every context_entry that contains
+ * the same domain-id point to the same set of page translation tables.
+ * The hardware uses this to improve the use of its translation cache.
+ * In order to insure that the copied translate tables abide by this
+ * requirement, this function keeps a list of domain-ids (dids) that
+ * have already been seen for this iommu. This function checks each entry
+ * already on the list for a domain-id that matches the domain-id in this
+ * context_entry.  If found, this function places the address of the previous
+ * context's tree of page translation tables into this context_entry.
+ * If a matching previous entry is not found, a new 'domain_values_entry'
+ * structure is created for the domain-id in this context_entry and
+ * copy_page_table is called to duplicate its tree of page tables.
+ */
+static int copy_context_entry(struct intel_iommu *iommu, u32 bus, u32 devfn,
+			      void *ppap, struct context_entry *ce)
+{
+	int ret = 0;			/* Integer Return Code */
+	u32 shift = 0;			/* bits to shift page_addr  */
+	u64 page_addr = 0;		/* Address of translated page */
+	struct dma_pte *pgt_old_phys;	/* Adr(page_table in the old kernel) */
+	struct dma_pte *pgt_new_phys;	/* Adr(page_table in the new kernel) */
+	u8  t;				/* Translation-type from context */
+	u8  aw;				/* Address-width from context */
+	u32 aw_shift[8] = {
+		12+9+9,		/* [000b] 30-bit AGAW (2-level page table) */
+		12+9+9+9,	/* [001b] 39-bit AGAW (3-level page table) */
+		12+9+9+9+9,	/* [010b] 48-bit AGAW (4-level page table) */
+		12+9+9+9+9+9,	/* [011b] 57-bit AGAW (5-level page table) */
+		12+9+9+9+9+9+9,	/* [100b] 64-bit AGAW (6-level page table) */
+		0,		/* [111b] Reserved */
+		0,		/* [110b] Reserved */
+		0,		/* [111b] Reserved */
+	};
+
+	struct domain_values_entry *dve = NULL;
+
+
+	if (!context_present(ce)) {	/* If (context not present) */
+		ret = RET_CCE_NOT_PRESENT;		/* Skip it */
+		goto exit;
+	}
+
+	t = context_translation_type(ce);
+
+	/* If we have seen this domain-id before on this iommu,
+	 * give this context the same page-tables and we are done.
+	 */
+	list_for_each_entry(dve, &domain_values_list[iommu->seq_id], link) {
+		if (dve->did == (int) context_domain_id(ce)) {
+			switch (t) {
+			case 0:	/* page tables */
+			case 1:	/* page tables */
+				context_set_address_root(ce,
+						virt_to_phys(dve->pgd));
+				ret = RET_CCE_PREVIOUS_DID;
+				break;
+
+			case 2:	/* Pass through */
+				if (dve->pgd == NULL)
+					ret =  RET_CCE_PASS_THROUGH_2;
+				else
+					ret = RET_BADCOPY;
+				break;
+
+			default: /* Bad value of 't'*/
+				ret = RET_BADCOPY;
+				break;
+			}
+			goto exit;
+		}
+	}
+
+	/* Since we now know that this is a new domain-id for this iommu,
+	 * create a new entry, add it to the list, and handle its
+	 * page tables.
+	 */
+
+	dve = kcalloc(1, sizeof(struct domain_values_entry), GFP_KERNEL);
+	if (!dve) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	dve->did = (int) context_domain_id(ce);
+	dve->gaw = (int) agaw_to_width(context_address_width(ce));
+	dve->pgd = NULL;
+	init_iova_domain(&dve->iovad, DMA_32BIT_PFN);
+
+	list_add(&dve->link, &domain_values_list[iommu->seq_id]);
+
+
+	if (t == 0 || t == 1) {		/* If (context has page tables) */
+		aw = context_address_width(ce);
+		shift = aw_shift[aw];
+
+		pgt_old_phys = (struct dma_pte *)
+				(context_address_root(ce) << VTD_PAGE_SHIFT);
+
+		ret = copy_page_table(&pgt_new_phys, pgt_old_phys,
+			shift-9, page_addr, iommu, bus, devfn, dve, ppap);
+
+		if (ret)		/* if (problem) bail out */
+			goto exit;
+
+		context_set_address_root(ce, (unsigned long)(pgt_new_phys));
+		dve->pgd = phys_to_virt((unsigned long)pgt_new_phys);
+		ret = RET_CCE_NEW_PAGE_TABLES;
+		goto exit;
+	}
+
+	if (t == 2) {		/* If (Identity mapped pass-through) */
+		ret = RET_CCE_PASS_THROUGH_1;	/* REVISIT: Skip for now */
+		goto exit;
+	}
+
+	ret = RET_CCE_RESERVED_VALUE;	/* Else ce->t is a Reserved value */
+	/* Note fall-through */
+
+exit:	/* all returns come through here to insure good clean-up */
+	return ret;
+}
+
+
+/*
+ * Called once for each context_entry_table found in the root_entry_table
+ */
+static int copy_context_entry_table(struct intel_iommu *iommu,
+				    u32 bus, void *ppap,
+				    struct context_entry **context_new_p,
+				    struct context_entry *context_old_phys)
+{
+	int ret = 0;				/* Integer return code */
+	struct context_entry *ce;		/* Iterator */
+	struct context_entry *context_new_phys;	/* adr(table in new kernel) */
+	struct context_entry *context_new_virt;	/* adr(table in new kernel) */
+	u32 devfn = 0;				/* PCI Device & function */
+
+	/* allocate a context-entry table in the new kernel
+	 * copy contents from old kernel
+	 * then update each entry in the table in the new kernel
+	 */
+	context_new_virt =
+		(struct context_entry *)alloc_pgtable_page(iommu->node);
+	if (!context_new_virt)
+		return -ENOMEM;
+
+	context_new_phys =
+		(struct context_entry *)virt_to_phys(context_new_virt);
+
+	oldcopy(context_new_virt, context_old_phys, VTD_PAGE_SIZE);
+
+	for (devfn = 0, ce = context_new_virt; devfn < 256; devfn++, ce++) {
+
+		if (!context_present(ce))	/* If (context not present) */
+			continue;		/* Skip it */
+
+		ret = copy_context_entry(iommu, bus, devfn, ppap, ce);
+		if (ret < 0)		/* if (problem) */
+			return RET_BADCOPY;
+
+		switch (ret) {
+		case RET_CCE_NOT_PRESENT:
+			continue;
+		case RET_CCE_NEW_PAGE_TABLES:
+			continue;
+		case RET_CCE_PASS_THROUGH_1:
+			continue;
+		case RET_CCE_PASS_THROUGH_2:
+			continue;
+		case RET_CCE_RESERVED_VALUE:
+			return RET_BADCOPY;
+		case RET_CCE_PREVIOUS_DID:
+			continue;
+		default:
+			return RET_BADCOPY;
+		};
+	}
+
+	*context_new_p = context_new_phys;
+	__iommu_flush_cache(iommu, context_new_virt, VTD_PAGE_SIZE);
+	return 0;
+}
+
+
+/*
+ * Highest-level function in the 'copy translation tables' set of functions
+ */
+static int copy_root_entry_table(struct intel_iommu *iommu, void *ppap,
+				 struct root_entry  **root_new_virt_p,
+				 struct root_entry  *root_old_phys)
+{
+	int ret = 0;				/* Integer return code */
+	u32 bus;				/* Index: root-entry-table */
+	struct root_entry  *re;			/* Virt(iterator: new table) */
+	struct root_entry  *root_new_virt;	/* Virt(table in new kernel) */
+	struct context_entry *context_old_phys;	/* Phys(context table entry) */
+	struct context_entry *context_new_phys;	/* Phys(new context_entry) */
+
+	/*
+	 * allocate a root-entry table in the new kernel
+	 * copy contents from old kernel
+	 * then update each entry in the table in the new kernel
+	 */
+
+	root_new_virt = (struct root_entry *)alloc_pgtable_page(iommu->node);
+	if (!root_new_virt)
+		return -ENOMEM;
+
+	oldcopy(root_new_virt, root_old_phys, VTD_PAGE_SIZE);
+
+	for (bus = 0, re = root_new_virt; bus < 256; bus += 1, re += 1) {
+
+		if (!root_present(re))
+			continue;
+
+		context_old_phys = get_context_phys_from_root(re);
+
+		if (!context_old_phys)
+			continue;
+
+		ret = copy_context_entry_table(iommu, bus, ppap,
+						&context_new_phys,
+						context_old_phys);
+		if (ret)
+			return ret;
+
+		re->val &= ~VTD_PAGE_MASK;
+		set_root_value(re, (unsigned long)context_new_phys);
+	}
+
+	*root_new_virt_p = root_new_virt;
+	__iommu_flush_cache(iommu, root_new_virt, VTD_PAGE_SIZE);
+	return 0;
+}
+
+/*
+ * Interface to the "copy translation tables" set of functions
+ * from mainline code.
+ */
+static int intel_iommu_copy_translation_tables(struct dmar_drhd_unit *drhd,
+		struct root_entry **root_old_phys_p,
+		struct root_entry **root_new_virt_p,
+		int g_num_of_iommus)
+{
+	struct intel_iommu *iommu;	/* Virt(iommu hardware registers) */
+	unsigned long long q;		/* quadword scratch */
+	struct root_entry *root_phys;	/* Phys(table in old kernel) */
+	struct root_entry *root_new;	/* Virt(table in new kernel) */
+	int ret = 0;			/* Integer return code */
+	int i = 0;			/* Loop index */
+
+	/* Structure so copy_page_addr() can accumulate things
+	 * over multiple calls and returns
+	 */
+	struct copy_page_addr_parms ppa_parms = copy_page_addr_parms_init;
+	struct copy_page_addr_parms *ppap = &ppa_parms;
+
+
+	iommu = drhd->iommu;
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+
+	if (!q)
+		return -1;
+
+	*root_old_phys_p = (struct root_entry *)q;	/* Returned to caller */
+
+	/* If (list needs initializing) do it here */
+	if (!domain_values_list) {
+		domain_values_list =
+			 kcalloc(g_num_of_iommus, sizeof(struct list_head),
+					GFP_KERNEL);
+
+		if (!domain_values_list) {
+			pr_err("Allocation failed for domain_values_list array\n");
+			return -ENOMEM;
+		}
+		for (i = 0; i < g_num_of_iommus; i++)
+			INIT_LIST_HEAD(&domain_values_list[i]);
+	}
+
+	/* Copy the root-entry table from the old kernel
+	 * foreach context_entry_table in root_entry
+	 *    foreach context_entry in context_entry_table
+	 *       foreach level-1 page_table_entry in context_entry
+	 *          foreach level-2 page_table_entry in level 1 page_table_entry
+	 *             Above pattern continues up to 6 levels of page tables
+	 *                Sanity-check the entry
+	 *                Process the bus, devfn, page_address, page_size
+	 */
+
+	root_phys = (struct root_entry *)q;
+	ret = copy_root_entry_table(iommu, ppap, &root_new, root_phys);
+	if (ret)
+		return ret;
+
+
+	ppa_parms.last = 1;
+	copy_page_addr(0, 0, 0, 0, 0, NULL, ppap);
+	*root_new_virt_p = root_new;			/* Returned to caller */
+
+	/* The translation tables in the new kernel should now contain
+	 * the same translations as the tables in the old kernel.
+	 * This will allow us to update the iommu hdw to use the new tables.
+	 *
+	 * NOTE: Neither the iommu hardware nor the iommu->root_entry
+	 *       struct-value is updated herein.
+	 *       These are left for the caller to do.
+	 */
+
+	return 0;
+}
+
+#endif /* CONFIG_CRASH_DUMP */
-- 
2.0.0-rc0

