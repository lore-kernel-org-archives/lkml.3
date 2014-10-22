Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaJVIaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:30:55 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49032 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaJVIat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:30:49 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>, kvm@vger.kernel.org,
        linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 1/4] s390/mm: recfactor global pgste updates
Date: Wed, 22 Oct 2014 10:30:21 +0200
Message-Id: <1413966624-12447-2-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413966624-12447-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1413966624-12447-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102208-0021-0000-0000-0000017DB44A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the s390 specific page table walker for the pgste updates
with a call to the common code walk_page_range function.
There are now two pte modification functions, one for the reset
of the CMMA state and another one for the initialization of the
storage keys.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/s390/include/asm/pgalloc.h |   2 -
 arch/s390/include/asm/pgtable.h |   1 +
 arch/s390/kvm/kvm-s390.c        |   2 +-
 arch/s390/mm/pgtable.c          | 153 ++++++++++++++--------------------------
 4 files changed, 56 insertions(+), 102 deletions(-)

diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index 9e18a61..120e126 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -22,8 +22,6 @@ unsigned long *page_table_alloc(struct mm_struct *, unsigned long);
 void page_table_free(struct mm_struct *, unsigned long *);
 void page_table_free_rcu(struct mmu_gather *, unsigned long *);
 
-void page_table_reset_pgste(struct mm_struct *, unsigned long, unsigned long,
-			    bool init_skey);
 int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 			  unsigned long key, bool nq);
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 5efb2fe..1e991f6a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1750,6 +1750,7 @@ extern int vmem_add_mapping(unsigned long start, unsigned long size);
 extern int vmem_remove_mapping(unsigned long start, unsigned long size);
 extern int s390_enable_sie(void);
 extern void s390_enable_skey(void);
+extern void s390_reset_cmma(struct mm_struct *mm);
 
 /*
  * No page table caches to initialise
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 81b0e11..7a33c11 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -281,7 +281,7 @@ static int kvm_s390_mem_control(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MEM_CLR_CMMA:
 		mutex_lock(&kvm->lock);
 		idx = srcu_read_lock(&kvm->srcu);
-		page_table_reset_pgste(kvm->arch.gmap->mm, 0, TASK_SIZE, false);
+		s390_reset_cmma(kvm->arch.gmap->mm);
 		srcu_read_unlock(&kvm->srcu, idx);
 		mutex_unlock(&kvm->lock);
 		ret = 0;
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 5404a62..ab55ba8 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -885,99 +885,6 @@ static inline void page_table_free_pgste(unsigned long *table)
 	__free_page(page);
 }
 
-static inline unsigned long page_table_reset_pte(struct mm_struct *mm, pmd_t *pmd,
-			unsigned long addr, unsigned long end, bool init_skey)
-{
-	pte_t *start_pte, *pte;
-	spinlock_t *ptl;
-	pgste_t pgste;
-
-	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-	pte = start_pte;
-	do {
-		pgste = pgste_get_lock(pte);
-		pgste_val(pgste) &= ~_PGSTE_GPS_USAGE_MASK;
-		if (init_skey) {
-			unsigned long address;
-
-			pgste_val(pgste) &= ~(PGSTE_ACC_BITS | PGSTE_FP_BIT |
-					      PGSTE_GR_BIT | PGSTE_GC_BIT);
-
-			/* skip invalid and not writable pages */
-			if (pte_val(*pte) & _PAGE_INVALID ||
-			    !(pte_val(*pte) & _PAGE_WRITE)) {
-				pgste_set_unlock(pte, pgste);
-				continue;
-			}
-
-			address = pte_val(*pte) & PAGE_MASK;
-			page_set_storage_key(address, PAGE_DEFAULT_KEY, 1);
-		}
-		pgste_set_unlock(pte, pgste);
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(start_pte, ptl);
-
-	return addr;
-}
-
-static inline unsigned long page_table_reset_pmd(struct mm_struct *mm, pud_t *pud,
-			unsigned long addr, unsigned long end, bool init_skey)
-{
-	unsigned long next;
-	pmd_t *pmd;
-
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
-		next = page_table_reset_pte(mm, pmd, addr, next, init_skey);
-	} while (pmd++, addr = next, addr != end);
-
-	return addr;
-}
-
-static inline unsigned long page_table_reset_pud(struct mm_struct *mm, pgd_t *pgd,
-			unsigned long addr, unsigned long end, bool init_skey)
-{
-	unsigned long next;
-	pud_t *pud;
-
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		next = page_table_reset_pmd(mm, pud, addr, next, init_skey);
-	} while (pud++, addr = next, addr != end);
-
-	return addr;
-}
-
-void page_table_reset_pgste(struct mm_struct *mm, unsigned long start,
-			    unsigned long end, bool init_skey)
-{
-	unsigned long addr, next;
-	pgd_t *pgd;
-
-	down_write(&mm->mmap_sem);
-	if (init_skey && mm_use_skey(mm))
-		goto out_up;
-	addr = start;
-	pgd = pgd_offset(mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		next = page_table_reset_pud(mm, pgd, addr, next, init_skey);
-	} while (pgd++, addr = next, addr != end);
-	if (init_skey)
-		current->mm->context.use_skey = 1;
-out_up:
-	up_write(&mm->mmap_sem);
-}
-EXPORT_SYMBOL(page_table_reset_pgste);
-
 int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 			  unsigned long key, bool nq)
 {
@@ -1044,11 +951,6 @@ static inline unsigned long *page_table_alloc_pgste(struct mm_struct *mm,
 	return NULL;
 }
 
-void page_table_reset_pgste(struct mm_struct *mm, unsigned long start,
-			    unsigned long end, bool init_skey)
-{
-}
-
 static inline void page_table_free_pgste(unsigned long *table)
 {
 }
@@ -1400,13 +1302,66 @@ EXPORT_SYMBOL_GPL(s390_enable_sie);
  * Enable storage key handling from now on and initialize the storage
  * keys with the default key.
  */
+static int __s390_enable_skey(pte_t *pte, unsigned long addr,
+			      unsigned long next, struct mm_walk *walk)
+{
+	unsigned long ptev;
+	pgste_t pgste;
+
+	pgste = pgste_get_lock(pte);
+	/* Clear storage key */
+	pgste_val(pgste) &= ~(PGSTE_ACC_BITS | PGSTE_FP_BIT |
+			      PGSTE_GR_BIT | PGSTE_GC_BIT);
+	ptev = pte_val(*pte);
+	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
+		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 1);
+	pgste_set_unlock(pte, pgste);
+	return 0;
+}
+
 void s390_enable_skey(void)
 {
-	page_table_reset_pgste(current->mm, 0, TASK_SIZE, true);
+	struct mm_walk walk = { .pte_entry = __s390_enable_skey };
+	struct mm_struct *mm = current->mm;
+
+	down_write(&mm->mmap_sem);
+	if (mm_use_skey(mm))
+		goto out_up;
+	walk.mm = mm;
+	walk_page_range(0, TASK_SIZE, &walk);
+	mm->context.use_skey = 1;
+
+out_up:
+	up_write(&mm->mmap_sem);
 }
 EXPORT_SYMBOL_GPL(s390_enable_skey);
 
 /*
+ * Reset CMMA state, make all pages stable again.
+ */
+static int __s390_reset_cmma(pte_t *pte, unsigned long addr,
+			     unsigned long next, struct mm_walk *walk)
+{
+	pgste_t pgste;
+
+	pgste = pgste_get_lock(pte);
+	pgste_val(pgste) &= ~_PGSTE_GPS_USAGE_MASK;
+	pgste_set_unlock(pte, pgste);
+	return 0;
+}
+
+void s390_reset_cmma(struct mm_struct *mm)
+{
+	struct mm_walk walk = { .pte_entry = __s390_reset_cmma };
+
+	down_write(&mm->mmap_sem);
+	walk.mm = mm;
+	walk_page_range(0, TASK_SIZE, &walk);
+	up_write(&mm->mmap_sem);
+}
+EXPORT_SYMBOL_GPL(s390_reset_cmma);
+
+/*
  * Test and reset if a guest page is dirty
  */
 bool gmap_test_and_clear_dirty(unsigned long address, struct gmap *gmap)
-- 
1.8.5.5

