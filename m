Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaIJXYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:24:52 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:47706 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIJXYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:24:50 -0400
From: Peter Feiner <pfeiner@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: softdirty: unmapped addresses between VMAs are clean
Date: Wed, 10 Sep 2014 16:24:46 -0700
Message-Id: <1410391486-9106-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a /proc/pid/pagemap read spans a [VMA, an unmapped region, then a
VM_SOFTDIRTY VMA], the virtual pages in the unmapped region are reported
as softdirty. Here's a program to demonstrate the bug:

int main() {
	const uint64_t PAGEMAP_SOFTDIRTY = 1ul << 55;
	uint64_t pme[3];
	int fd = open("/proc/self/pagemap", O_RDONLY);;
	char *m = mmap(NULL, 3 * getpagesize(), PROT_READ,
	               MAP_ANONYMOUS | MAP_SHARED, -1, 0);
	munmap(m + getpagesize(), getpagesize());
	pread(fd, pme, 24, (unsigned long) m / getpagesize() * 8);
	assert(pme[0] & PAGEMAP_SOFTDIRTY);    /* passes */
	assert(!(pme[1] & PAGEMAP_SOFTDIRTY)); /* fails */
	assert(pme[2] & PAGEMAP_SOFTDIRTY);    /* passes */
	return 0;
}

(Note that all pages in new VMAs are softdirty until cleared).

Tested:
	Used the program given above. I'm going to include this code in
	a selftest in the future.

Signed-off-by: Peter Feiner <pfeiner@google.com>
---
 fs/proc/task_mmu.c | 61 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dfc791c..eb92a8c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1020,7 +1020,6 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	spinlock_t *ptl;
 	pte_t *pte;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
@@ -1034,6 +1033,7 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
+			pagemap_entry_t pme;
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
@@ -1048,32 +1048,51 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
-	for (; addr != end; addr += PAGE_SIZE) {
-		int flags2;
-
-		/* check to see if we've left 'vma' behind
-		 * and need a new, higher one */
-		if (vma && (addr >= vma->vm_end)) {
-			vma = find_vma(walk->mm, addr);
-			if (vma && (vma->vm_flags & VM_SOFTDIRTY))
-				flags2 = __PM_SOFT_DIRTY;
-			else
-				flags2 = 0;
-			pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
+
+	while (1) {
+		unsigned long vm_start = end;
+		unsigned long vm_end = end;
+		unsigned long vm_flags = 0;
+
+		if (vma) {
+			/*
+			 * We can't possibly be in a hugetlb VMA. In general,
+			 * for a mm_walk with a pmd_entry and a hugetlb_entry,
+			 * the pmd_entry can only be called on addresses in a
+			 * hugetlb if the walk starts in a non-hugetlb VMA and
+			 * spans a hugepage VMA. Since pagemap_read walks are
+			 * PMD-sized and PMD-aligned, this will never be true.
+			 */
+			BUG_ON(is_vm_hugetlb_page(vma));
+			vm_start = vma->vm_start;
+			vm_end = min(end, vma->vm_end);
+			vm_flags = vma->vm_flags;
+		}
+
+		/* Addresses before the VMA. */
+		for (; addr < vm_start; addr += PAGE_SIZE) {
+			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				return err;
 		}
 
-		/* check that 'vma' actually covers this address,
-		 * and that it isn't a huge page vma */
-		if (vma && (vma->vm_start <= addr) &&
-		    !is_vm_hugetlb_page(vma)) {
+		/* Addresses in the VMA. */
+		for (; addr < vm_end; addr += PAGE_SIZE) {
+			pagemap_entry_t pme;
 			pte = pte_offset_map(pmd, addr);
 			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			/* unmap before userspace copy */
 			pte_unmap(pte);
+			err = add_to_pagemap(addr, &pme, pm);
+			if (err)
+				return err;
 		}
-		err = add_to_pagemap(addr, &pme, pm);
-		if (err)
-			return err;
+
+		if (addr == end)
+			break;
+
+		vma = find_vma(walk->mm, addr);
 	}
 
 	cond_resched();
-- 
2.1.0.rc2.206.gedb03e5

