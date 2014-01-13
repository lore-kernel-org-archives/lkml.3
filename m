Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaAMQWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:22:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaAMQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 153/208] mm: fix TLB flush race between migration, and change_protection_range
Date: Mon, 13 Jan 2014 15:59:54 +0000
Message-Id: <1389628849-1614-154-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@redhat.com>

commit 20841405940e7be0617612d521e206e4b6b325db upstream.

There are a few subtle races, between change_protection_range (used by
mprotect and change_prot_numa) on one side, and NUMA page migration and
compaction on the other side.

The basic race is that there is a time window between when the PTE gets
made non-present (PROT_NONE or NUMA), and the TLB is flushed.

During that time, a CPU may continue writing to the page.

This is fine most of the time, however compaction or the NUMA migration
code may come in, and migrate the page away.

When that happens, the CPU may continue writing, through the cached
translation, to what is no longer the current memory location of the
process.

This only affects x86, which has a somewhat optimistic pte_accessible.
All other architectures appear to be safe, and will either always flush,
or flush whenever there is a valid mapping, even with no permissions
(SPARC).

The basic race looks like this:

CPU A			CPU B			CPU C

						load TLB entry
make entry PTE/PMD_NUMA
			fault on entry
						read/write old page
			start migrating page
			change PTE/PMD to new page
						read/write old page [*]
flush TLB
						reload TLB from new entry
						read/write new page
						lose data

[*] the old page may belong to a new user at this point!

The obvious fix is to flush remote TLB entries, by making sure that
pte_accessible aware of the fact that PROT_NONE and PROT_NUMA memory may
still be accessible if there is a TLB flush pending for the mm.

This should fix both NUMA migration and compaction.

[mgorman@suse.de: fix build]
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h |  4 ++--
 arch/x86/include/asm/pgtable.h      | 11 ++++++++--
 include/asm-generic/pgtable.h       |  2 +-
 include/linux/mm_types.h            | 44 +++++++++++++++++++++++++++++++++++++
 kernel/fork.c                       |  1 +
 mm/huge_memory.c                    |  7 ++++++
 mm/mprotect.c                       |  2 ++
 mm/pgtable-generic.c                |  5 +++--
 8 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 3676031..90f289f 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -616,7 +616,7 @@ static inline unsigned long pte_present(pte_t pte)
 }
 
 #define pte_accessible pte_accessible
-static inline unsigned long pte_accessible(pte_t a)
+static inline unsigned long pte_accessible(struct mm_struct *mm, pte_t a)
 {
 	return pte_val(a) & _PAGE_VALID;
 }
@@ -806,7 +806,7 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 	 * SUN4V NOTE: _PAGE_VALID is the same value in both the SUN4U
 	 *             and SUN4V pte layout, so this inline test is fine.
 	 */
-	if (likely(mm != &init_mm) && pte_accessible(orig))
+	if (likely(mm != &init_mm) && pte_accessible(mm, orig))
 		tlb_batch_add(mm, addr, ptep, orig, fullmm);
 }
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1c00631..90cf8db4 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -465,9 +465,16 @@ static inline int pte_present(pte_t a)
 }
 
 #define pte_accessible pte_accessible
-static inline int pte_accessible(pte_t a)
+static inline bool pte_accessible(struct mm_struct *mm, pte_t a)
 {
-	return pte_flags(a) & _PAGE_PRESENT;
+	if (pte_flags(a) & _PAGE_PRESENT)
+		return true;
+
+	if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &&
+			mm_tlb_flush_pending(mm))
+		return true;
+
+	return false;
 }
 
 static inline int pte_hidden(pte_t pte)
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 0807ddf..380acce 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -221,7 +221,7 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 #endif
 
 #ifndef pte_accessible
-# define pte_accessible(pte)		((void)(pte),1)
+# define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
 #ifndef flush_tlb_fix_spurious_fault
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index faf4b7c..ef9dc52 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -434,6 +434,14 @@ struct mm_struct {
 	 */
 	int first_nid;
 #endif
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+	/*
+	 * An operation with batched TLB flushing is going on. Anything that
+	 * can move process memory needs to flush the TLB when moving a
+	 * PROT_NONE or PROT_NUMA mapped page.
+	 */
+	bool tlb_flush_pending;
+#endif
 	struct uprobes_state uprobes_state;
 };
 
@@ -454,4 +462,40 @@ static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 	return mm->cpu_vm_mask_var;
 }
 
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+/*
+ * Memory barriers to keep this state in sync are graciously provided by
+ * the page table locks, outside of which no page table modifications happen.
+ * The barriers below prevent the compiler from re-ordering the instructions
+ * around the memory barriers that are already present in the code.
+ */
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	barrier();
+	return mm->tlb_flush_pending;
+}
+static inline void set_tlb_flush_pending(struct mm_struct *mm)
+{
+	mm->tlb_flush_pending = true;
+	barrier();
+}
+/* Clearing is done after a TLB flush, which also provides a barrier. */
+static inline void clear_tlb_flush_pending(struct mm_struct *mm)
+{
+	barrier();
+	mm->tlb_flush_pending = false;
+}
+#else
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	return false;
+}
+static inline void set_tlb_flush_pending(struct mm_struct *mm)
+{
+}
+static inline void clear_tlb_flush_pending(struct mm_struct *mm)
+{
+}
+#endif
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 200a7a2..f1f82cf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -540,6 +540,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	clear_tlb_flush_pending(mm);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 31950d6..37a8cd8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1372,6 +1372,13 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/*
+	 * The page_table_lock above provides a memory barrier
+	 * with change_protection_range.
+	 */
+	if (mm_tlb_flush_pending(mm))
+		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+
+	/*
 	 * Migrate the THP to the requested node, returns with page unlocked
 	 * and pmd_numa cleared.
 	 */
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 00edb75..7651a57 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -216,6 +216,7 @@ static unsigned long change_protection_range(struct vm_area_struct *vma,
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
 	flush_cache_range(vma, addr, end);
+	set_tlb_flush_pending(mm);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
@@ -227,6 +228,7 @@ static unsigned long change_protection_range(struct vm_area_struct *vma,
 	/* Only flush the TLB if we actually modified any entries: */
 	if (pages)
 		flush_tlb_range(vma, start, end);
+	clear_tlb_flush_pending(mm);
 
 	return pages;
 }
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 0e083c5..683f476 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -86,9 +86,10 @@ int pmdp_clear_flush_young(struct vm_area_struct *vma,
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
 		       pte_t *ptep)
 {
+	struct mm_struct *mm = (vma)->vm_mm;
 	pte_t pte;
-	pte = ptep_get_and_clear((vma)->vm_mm, address, ptep);
-	if (pte_accessible(pte))
+	pte = ptep_get_and_clear(mm, address, ptep);
+	if (pte_accessible(mm, pte))
 		flush_tlb_page(vma, address);
 	return pte;
 }
-- 
1.8.3.2

