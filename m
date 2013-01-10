Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3AQBEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:04:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49339 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3AQBEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:04:10 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RFC PATCH v1 2/3] vmcore: map vmcore memory in direct mapping region
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 20:59:45 +0900
Message-ID: <20130110115945.645.76872.stgit@localhost6.localdomain6>
In-Reply-To: <20130110115615.645.56499.stgit@localhost6.localdomain6>
References: <20130110115615.645.56499.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map memory map regions represented by vmcore in direct mapping region,
where as much memory as possible are mapped using 1G or 4M pages to
reduce memory consumption for page tables.

I resued large part of init_memory_mapping. In fact, I first tried to
use it but I have faced some page-fault related bug that seems to be
caused by this additional mapping. I have not figured out the cause
yet so I wrote part of making page tables from scratch like Cliff's
patch.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |  292 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 292 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 405b5e2..aa14570 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -21,6 +21,8 @@
 #include <linux/list.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 /* List representing chunks of contiguous memory areas and their offsets in
  * vmcore file.
@@ -220,6 +222,290 @@ oldmem_merge_vmcore_list(struct list_head *vc_list, struct list_head *om_list)
 	return 0;
 }
 
+enum {
+        NR_RANGE_MR = 5,
+};
+
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+static int save_mr(struct map_range *mr, int nr_range,
+		   unsigned long start_pfn, unsigned long end_pfn,
+		   unsigned long page_size_mask)
+{
+	if (start_pfn < end_pfn) {
+		if (nr_range >= NR_RANGE_MR)
+			panic("run out of range for init_memory_mapping\n");
+		mr[nr_range].start = start_pfn<<PAGE_SHIFT;
+		mr[nr_range].end   = end_pfn<<PAGE_SHIFT;
+		mr[nr_range].page_size_mask = page_size_mask;
+		nr_range++;
+	}
+
+	return nr_range;
+}
+
+static int
+oldmem_align_maps_in_page_size(struct map_range *mr,
+			       unsigned long start,
+			       unsigned long end)
+{
+        unsigned long page_size_mask = 0;
+        unsigned long start_pfn, end_pfn;
+        unsigned long pos;
+        int use_pse, use_gbpages;
+        int i, nr_range;
+
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	use_pse = use_gbpages = 0;
+#else
+	use_pse = cpu_has_pse;
+	use_gbpages = direct_gbpages;
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+
+	if (use_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (use_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+
+	/* head if not big page alignment ? */
+	start_pfn = start >> PAGE_SHIFT;
+	pos = start_pfn << PAGE_SHIFT;
+#ifdef CONFIG_X86_32
+	/*
+	 * Don't use a large page for the first 2/4MB of memory
+	 * because there are often fixed size MTRRs in there
+	 * and overlapping MTRRs into large pages can cause
+	 * slowdowns.
+	 */
+	if (pos == 0)
+		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
+	else
+		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+				 << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
+	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
+			<< (PMD_SHIFT - PAGE_SHIFT);
+#endif
+	if (end_pfn > (end >> PAGE_SHIFT))
+		end_pfn = end >> PAGE_SHIFT;
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+	/* big page (2M) range */
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+#ifdef CONFIG_X86_32
+	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
+	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+#endif
+
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+#ifdef CONFIG_X86_64
+	/* big page (1G) range */
+	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask &
+				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+	/* tail is not big page (1G) alignment */
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+#endif
+
+	/* tail is not big page (2M) alignment */
+	start_pfn = pos>>PAGE_SHIFT;
+	end_pfn = end>>PAGE_SHIFT;
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+
+	/* try to merge same page size and continuous */
+	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
+		unsigned long old_start;
+		if (mr[i].end != mr[i+1].start ||
+		    mr[i].page_size_mask != mr[i+1].page_size_mask)
+			continue;
+		/* move it */
+		old_start = mr[i].start;
+		memmove(&mr[i], &mr[i+1],
+			(nr_range - 1 - i) * sizeof(struct map_range));
+		mr[i--].start = old_start;
+		nr_range--;
+	}
+
+	return nr_range;
+}
+
+static int
+oldmem_physical_mapping_init(unsigned long start, unsigned long end,
+			     unsigned long page_size_mask)
+{
+	unsigned long paddr, vaddr, hpagesize;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	pgprot_t prot;
+	unsigned long pages_1G, pages_2M, pages_4K;
+	unsigned long pages_PUD, pages_PMD, pages_PTE;
+
+	if (page_size_mask & (1 << PG_LEVEL_1G)) {
+		hpagesize = PUD_SIZE;
+		prot = PAGE_KERNEL_LARGE;
+	} else if (page_size_mask & (1 << PG_LEVEL_2M)) {
+		hpagesize = PMD_SIZE;
+		prot = PAGE_KERNEL_LARGE;
+	} else {
+		hpagesize = PAGE_SIZE;
+		prot = PAGE_KERNEL;
+	}
+
+	paddr = start;
+	vaddr = (unsigned long)__va(start);
+
+	pages_1G = 0;
+	pages_2M = 0;
+	pages_4K = 0;
+
+	pages_PUD = 0;
+	pages_PMD = 0;
+	pages_PTE = 0;
+
+	while (paddr < end) {
+		pgd = pgd_offset_k(vaddr);
+		if (!pgd_present(*pgd)) {
+			pud = pud_alloc_one(&init_mm, vaddr);
+			set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+			pages_PUD++;
+		}
+		pud = pud_offset(pgd, vaddr);
+		if (page_size_mask & (1 << PG_LEVEL_1G)) {
+			set_pud(pud, __pud(paddr | pgprot_val(prot)));
+			pages_1G++;
+		} else {
+			if (!pud_present(*pud)) {
+				pmd = pmd_alloc_one(&init_mm, vaddr);
+				set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+				pages_PMD++;
+			}
+			pmd = pmd_offset(pud, vaddr);
+			if (page_size_mask & (1 << PG_LEVEL_2M)) {
+				set_pmd(pmd, __pmd(paddr | pgprot_val(prot)));
+				pages_2M++;
+			} else {
+				if (!pmd_present(*pmd)) {
+					pte = pte_alloc_one_kernel(&init_mm, vaddr);
+					set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+					pages_PTE++;
+				}
+				pte = pte_offset_kernel(pmd, vaddr);
+				set_pte(pte, __pte(paddr | pgprot_val(prot)));
+				pages_4K++;
+			}
+		}
+		if (end - paddr < hpagesize)
+			break;
+		paddr += hpagesize;
+		vaddr += hpagesize;
+	}
+
+	update_page_count(PG_LEVEL_1G, pages_1G);
+	update_page_count(PG_LEVEL_2M, pages_2M);
+	update_page_count(PG_LEVEL_4K, pages_4K);
+
+	printk("vmcore: PUD pages: %lu\n", pages_PUD);
+	printk("vmcore: PMD pages: %lu\n", pages_PMD);
+	printk("vmcore: PTE pages: %lu\n", pages_PTE);
+
+	__flush_tlb_all();
+
+	return 0;
+}
+
+static void init_old_memory_mapping(unsigned long start, unsigned long end)
+{
+	struct map_range mr[NR_RANGE_MR];
+	int i, ret, nr_range;
+
+	nr_range = oldmem_align_maps_in_page_size(mr, start, end);
+
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
+		       mr[i].start, mr[i].end - 1,
+		       (mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
+			       (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
+
+	for (i = 0; i < nr_range; i++)
+		ret = oldmem_physical_mapping_init(mr[i].start,
+						   mr[i].end,
+						   mr[i].page_size_mask);
+
+	__flush_tlb_all();
+}
+
+static int oldmem_init(struct list_head *vc_list, struct list_head *om_list)
+{
+	struct vmcore *m;
+	int ret;
+
+	ret = oldmem_merge_vmcore_list(vc_list, om_list);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(m, om_list, list) {
+		unsigned long start, end;
+
+		start = (m->paddr >> PAGE_SHIFT) << PAGE_SHIFT;
+		end = ((m->paddr + m->size + PAGE_SIZE - 1) >> PAGE_SHIFT) << PAGE_SHIFT;
+
+		init_old_memory_mapping(start, end);
+	}
+
+	return 0;
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -777,6 +1063,12 @@ static int __init vmcore_init(void)
 		return rc;
 	}
 
+	rc = oldmem_init(&vmcore_list, &oldmem_list);
+	if (rc) {
+		printk(KERN_WARNING "Kdump: failed to map vmcore\n");
+		return rc;
+	}
+
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;

