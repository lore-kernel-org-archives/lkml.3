Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbbAIKej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:34:39 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44598 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757504AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Bob Liu <bob.liu@oracle.com>, Christoph Lameter <cl@gentwo.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 78/78] mm: let mm_find_pmd fix buggy race with THP fault
Date: Fri,  9 Jan 2015 11:32:27 +0100
Message-Id: <e1c34dac913e87ee8d03c06d7a328a7c2137cafb.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f72e7dcdd25229446b102e587ef2f826f76bff28 upstream.

Trinity has reported:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
    IP: __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
    CPU: 6 PID: 16173 Comm: trinity-c364 Tainted: G        W
                            3.15.0-rc1-next-20140415-sasha-00020-gaa90d09 #398
    lock_acquire (arch/x86/include/asm/current.h:14
                  kernel/locking/lockdep.c:3602)
    _raw_spin_lock (include/linux/spinlock_api_smp.h:143
                    kernel/locking/spinlock.c:151)
    remove_migration_pte (mm/migrate.c:137)
    rmap_walk (mm/rmap.c:1628 mm/rmap.c:1699)
    remove_migration_ptes (mm/migrate.c:224)
    migrate_pages (mm/migrate.c:922 mm/migrate.c:960 mm/migrate.c:1126)
    migrate_misplaced_page (mm/migrate.c:1733)
    __handle_mm_fault (mm/memory.c:3762 mm/memory.c:3812 mm/memory.c:3925)
    handle_mm_fault (mm/memory.c:3948)
    __get_user_pages (mm/memory.c:1851)
    __mlock_vma_pages_range (mm/mlock.c:255)
    __mm_populate (mm/mlock.c:711)
    SyS_mlockall (include/linux/mm.h:1799 mm/mlock.c:817 mm/mlock.c:791)

I believe this comes about because, whereas collapsing and splitting THP
functions take anon_vma lock in write mode (which excludes concurrent
rmap walks), faulting THP functions (write protection and misplaced
NUMA) do not - and mostly they do not need to.

But they do use a pmdp_clear_flush(), set_pmd_at() sequence which, for
an instant (indeed, for a long instant, given the inter-CPU TLB flush in
there), leaves *pmd neither present not trans_huge.

Which can confuse a concurrent rmap walk, as when removing migration
ptes, seen in the dumped trace.  Although that rmap walk has a 4k page
to insert, anon_vmas containing THPs are in no way segregated from
4k-page anon_vmas, so the 4k-intent mm_find_pmd() does need to cope with
that instant when a trans_huge pmd is temporarily absent.

I don't think we need strengthen the locking at the THP end: it's easily
handled with an ACCESS_ONCE() before testing both conditions.

And since mm_find_pmd() had only one caller who wanted a THP rather than
a pmd, let's slightly repurpose it to fail when it hits a THP or
non-present pmd, and open code split_huge_page_address() again.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/huge_memory.c | 18 ++++++++++++------
 mm/ksm.c         |  1 -
 mm/migrate.c     |  2 --
 mm/rmap.c        | 12 ++++++++----
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e497843f5f65..04d17ba00893 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2408,8 +2408,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
 		goto out;
-	if (pmd_trans_huge(*pmd))
-		goto out;
 
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -2508,8 +2506,6 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
 		goto out;
-	if (pmd_trans_huge(*pmd))
-		goto out;
 
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
@@ -2863,12 +2859,22 @@ void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
 static void split_huge_page_address(struct mm_struct *mm,
 				    unsigned long address)
 {
+	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd;
 
 	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
 
-	pmd = mm_find_pmd(mm, address);
-	if (!pmd)
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
 		return;
 	/*
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
diff --git a/mm/ksm.c b/mm/ksm.c
index c78fff1e9eae..29cbd06c4884 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -945,7 +945,6 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	pmd = mm_find_pmd(mm, addr);
 	if (!pmd)
 		goto out;
-	BUG_ON(pmd_trans_huge(*pmd));
 
 	mmun_start = addr;
 	mmun_end   = addr + PAGE_SIZE;
diff --git a/mm/migrate.c b/mm/migrate.c
index d5c84b0a5243..fac5fa0813c4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -136,8 +136,6 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
 			goto out;
-		if (pmd_trans_huge(*pmd))
-			goto out;
 
 		ptep = pte_offset_map(pmd, addr);
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 5b8675ccc1ef..440c71c43b8d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -571,6 +571,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd = NULL;
+	pmd_t pmde;
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
@@ -581,7 +582,13 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 		goto out;
 
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	/*
+	 * Some THP functions use the sequence pmdp_clear_flush(), set_pmd_at()
+	 * without holding anon_vma lock for write.  So when looking for a
+	 * genuine pmde (in which to find pte), test present and !THP together.
+	 */
+	pmde = ACCESS_ONCE(*pmd);
+	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		pmd = NULL;
 out:
 	return pmd;
@@ -617,9 +624,6 @@ pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
 	if (!pmd)
 		return NULL;
 
-	if (pmd_trans_huge(*pmd))
-		return NULL;
-
 	pte = pte_offset_map(pmd, address);
 	/* Make a quick check before getting the lock */
 	if (!sync && !pte_present(*pte)) {
-- 
2.2.1

