Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab3BMMEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:04:52 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55503 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3BMMEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:04:48 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 3/5] metag: hugetlb: convert to vm_unmapped_area()
Date: Wed, 13 Feb 2013 12:03:47 +0000
Message-ID: <1360757029-28868-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_12_04_47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert hugetlb_get_unmapped_area_new_pmd() to use vm_unmapped_area()
rather than searching the virtual address space itself. This fixes the
following errors in linux-next due to the specified members being
removed after other architectures have already been converted:

arch/metag/mm/hugetlbpage.c: In function 'hugetlb_get_unmapped_area_new_pmd':
arch/metag/mm/hugetlbpage.c:199: error: 'struct mm_struct' has no member named 'cached_hole_size'
arch/metag/mm/hugetlbpage.c:200: error: 'struct mm_struct' has no member named 'free_area_cache'
arch/metag/mm/hugetlbpage.c:215: error: 'struct mm_struct' has no member named 'cached_hole_size'

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Michel Lespinasse <walken@google.com>
---
 arch/metag/mm/hugetlbpage.c |   52 ++++++++----------------------------------
 1 files changed, 10 insertions(+), 42 deletions(-)

diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
index 24ceed4..3c52fa6 100644
--- a/arch/metag/mm/hugetlbpage.c
+++ b/arch/metag/mm/hugetlbpage.c
@@ -192,43 +192,15 @@ new_search:
 static unsigned long
 hugetlb_get_unmapped_area_new_pmd(unsigned long len)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long start_addr, addr;
-
-	if (ALIGN_HUGEPT(len) > mm->cached_hole_size)
-		start_addr = mm->free_area_cache;
-	else
-		start_addr = TASK_UNMAPPED_BASE;
-
-new_search:
-	addr = ALIGN_HUGEPT(start_addr);
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		if (TASK_SIZE - len < addr) {
-			/*
-			 * Start a new search - just in case we missed
-			 * some holes.
-			 */
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				start_addr = TASK_UNMAPPED_BASE;
-				mm->cached_hole_size = 0;
-				goto new_search;
-			}
-			return 0;
-		}
-		/* skip ahead if we've aligned right over some vmas */
-		if (vma && vma->vm_end <= addr)
-			continue;
-		if (!vma || ALIGN_HUGEPT(addr + len) <= vma->vm_start) {
-#if HPAGE_SHIFT < HUGEPT_SHIFT
-			if (len & HUGEPT_MASK)
-				mm->context.part_huge = addr + len;
-#endif
-			return addr;
-		}
-		addr = ALIGN_HUGEPT(vma->vm_end);
-	}
+	struct vm_unmapped_area_info info;
+
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & HUGEPT_MASK;
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 unsigned long
@@ -266,11 +238,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	 * Find an unmapped naturally aligned set of 4MB blocks that we can use
 	 * for huge pages.
 	 */
-	addr = hugetlb_get_unmapped_area_new_pmd(len);
-	if (likely(addr))
-		return addr;
-
-	return -EINVAL;
+	return hugetlb_get_unmapped_area_new_pmd(len);
 }
 
 #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
-- 
1.7.7.6


