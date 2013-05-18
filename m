Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3ERCRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:17:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3ERCQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:56 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HmGoik7ngY4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yaV_b6-T-GUA:10 a=1XWaLZrsAAAA:8 a=7CQSdrXTAAAA:8 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=L39TJNLReejVW93jx54A:9 a=UTB_XpHje0EA:10 a=ESTKKtUg-DoA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=LX5jkCuKAR98L6lJ:21 a=Z3o3qp4haZxdfioz:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021648.841787160@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 044/136 ] mm: allow arch code to control the user page table ceiling
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0044-mm-allow-arch-code-to-control-the-user-page-table-ce.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 6ee8630e02be6dd89926ca0fbc21af68b23dc087 ]

On architectures where a pgd entry may be shared between user and kernel
(e.g.  ARM+LPAE), freeing page tables needs a ceiling other than 0.
This patch introduces a generic USER_PGTABLES_CEILING that arch code can
override.  It is the responsibility of the arch code setting the ceiling
to ensure the complete freeing of the page tables (usually in
pgd_free()).

[catalin.marinas@arm.com: commit log; shift_arg_pages(), asm-generic/pgtables.h changes]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: <stable@vger.kernel.org>	[3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/exec.c                     |    4 ++--
 include/asm-generic/pgtable.h |   10 ++++++++++
 mm/mmap.c                     |    4 ++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index fab2c6d..5b0d397 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -623,7 +623,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * when the old and new regions overlap clear from new_end.
 		 */
 		free_pgd_range(&tlb, new_end, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	} else {
 		/*
 		 * otherwise, clean from old_start; this is done to not touch
@@ -632,7 +632,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * for the others its just a little faster.
 		 */
 		free_pgd_range(&tlb, old_start, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	}
 	tlb_finish_mmu(&tlb, new_end, old_end);
 
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index ff4947b..0084135 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -7,6 +7,16 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/mm/mmap.c b/mm/mmap.c
index cf6434e..3ddb799 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1912,7 +1912,7 @@ static void unmap_region(struct mm_struct *mm,
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : 0);
+				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);
 }
 
@@ -2294,7 +2294,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, 0, -1);
 
 	/*
-- 
1.7.10.4


