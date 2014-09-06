Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaIFTjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:39:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51372 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaIFTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:39:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 3/3] mm: use VM_BUG_ON_MM where possible
Date: Sat,  6 Sep 2014 15:38:46 -0400
Message-Id: <1410032326-4380-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410032326-4380-1-git-send-email-sasha.levin@oracle.com>
References: <1410032326-4380-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dump the contents of the relevant struct_mm when we hit the
bug condition.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/fork.c    |    3 +--
 kernel/sys.c     |    2 +-
 mm/huge_memory.c |    2 +-
 mm/mlock.c       |    2 +-
 mm/mmap.c        |    7 ++++---
 mm/pagewalk.c    |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..7953519 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -601,9 +601,8 @@ static void check_mm(struct mm_struct *mm)
 			printk(KERN_ALERT "BUG: Bad rss-counter state "
 					  "mm:%p idx:%d val:%ld\n", mm, i, x);
 	}
-
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
-	VM_BUG_ON(mm->pmd_huge_pte);
+	VM_BUG_ON_MM(mm->pmd_huge_pte, mm);
 #endif
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index b59294d..037fd76 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1642,7 +1642,7 @@ static int prctl_set_mm_exe_file_locked(struct mm_struct *mm, unsigned int fd)
 	struct inode *inode;
 	int err;
 
-	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
 	exe = fdget(fd);
 	if (!exe.file)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d81f8ba..ba5dc2f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2045,7 +2045,7 @@ int __khugepaged_enter(struct mm_struct *mm)
 		return -ENOMEM;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON(khugepaged_test_exit(mm));
+	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
diff --git a/mm/mlock.c b/mm/mlock.c
index d5d09d0..03aa851 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -235,7 +235,7 @@ long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	VM_BUG_ON(end   & ~PAGE_MASK);
 	VM_BUG_ON_VMA(start < vma->vm_start, vma);
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
-	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
 	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
 	/*
diff --git a/mm/mmap.c b/mm/mmap.c
index 9351482..d2f1a0a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -408,8 +408,9 @@ static void validate_mm_rb(struct rb_root *root, struct vm_area_struct *ignore)
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
-		BUG_ON(vma != ignore &&
-		       vma->rb_subtree_gap != vma_compute_subtree_gap(vma));
+		VM_BUG_ON_VMA(vma != ignore &&
+			vma->rb_subtree_gap != vma_compute_subtree_gap(vma),
+			vma);
 	}
 }
 
@@ -443,7 +444,7 @@ static void validate_mm(struct mm_struct *mm)
 		pr_info("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
-	BUG_ON(bug);
+	VM_BUG_ON_MM(bug, mm);
 }
 #else
 #define validate_mm_rb(root, ignore) do { } while (0)
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 2beeabf..ad83195 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -177,7 +177,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	if (!walk->mm)
 		return -EINVAL;
 
-	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	VM_BUG_ON_MM(!rwsem_is_locked(&walk->mm->mmap_sem), walk->mm);
 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-- 
1.7.10.4

