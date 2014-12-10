Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbaLJO7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:59:47 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44190 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbaLJO7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:59:46 -0500
From: Petr Cermak <petrcermak@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Primiano Tucci <primiano@chromium.org>,
        Petr Cermak <petrcermak@chromium.org>
Subject: [RFC PATCH] Add user-space support for resetting mm->hiwater_rss (peak RSS)
Date: Wed, 10 Dec 2014 14:59:04 +0000
Message-Id: <1418223544-11382-1-git-send-email-petrcermak@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to reset mm->hiwater_rss (resident set size high water mark) from
user space would enable fine grained iterative memory profiling. I propose a
very short patch for doing so below. I would like to get some feedback on the
user-space interface to do this. Would it be best to:

  1. Add an extra value to /proc/PID/clear_refs to reset VmHWM? (The proposed
     patch uses this approach.)

  2. Add a new write-only pseudo-file for this purpose (e.g.,
     /proc/pid/reset_hwm)?

The driving use-case for this would be getting the peak RSS value, which can be
retrieved from the VmHWM field in /proc/pid/status, per benchmark iteration or
test scenario.

Signed-off-by: Petr Cermak <petrcermak@chromium.org>
---
 Documentation/filesystems/proc.txt |   3 ++
 fs/proc/task_mmu.c                 | 106 +++++++++++++++++++++----------------
 include/linux/mm.h                 |   5 ++
 3 files changed, 68 insertions(+), 46 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index eb8a10e..2c277e9 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -488,6 +488,9 @@ To clear the bits for the file mapped pages associated with the process
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
+To reset the peak resident set size ("high water mark")
+    > echo 5 > /proc/PID/clear_refs
+
 Any other value written to /proc/PID/clear_refs will have no effect.
 
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0388c..86b23b2 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -712,6 +712,7 @@ enum clear_refs_types {
 	CLEAR_REFS_ANON,
 	CLEAR_REFS_MAPPED,
 	CLEAR_REFS_SOFT_DIRTY,
+	CLEAR_REFS_MM_HIWATER_RSS,
 	CLEAR_REFS_LAST,
 };
 
@@ -818,56 +819,69 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
-		struct clear_refs_private cp = {
-			.type = type,
-		};
-		struct mm_walk clear_refs_walk = {
-			.pmd_entry = clear_refs_pte_range,
-			.mm = mm,
-			.private = &cp,
-		};
-		down_read(&mm->mmap_sem);
-		if (type == CLEAR_REFS_SOFT_DIRTY) {
-			for (vma = mm->mmap; vma; vma = vma->vm_next) {
-				if (!(vma->vm_flags & VM_SOFTDIRTY))
-					continue;
-				up_read(&mm->mmap_sem);
-				down_write(&mm->mmap_sem);
+		if (type == CLEAR_REFS_MM_HIWATER_RSS) {
+			/*
+			 * Writing 5 to /proc/pid/clear_refs resets the peak
+			 * resident set size.
+			 */
+			down_write(&mm->mmap_sem);
+			reset_mm_hiwater_rss(mm);
+			up_write(&mm->mmap_sem);
+		} else {
+			struct clear_refs_private cp = {
+				.type = type,
+			};
+			struct mm_walk clear_refs_walk = {
+				.pmd_entry = clear_refs_pte_range,
+				.mm = mm,
+				.private = &cp,
+			};
+			down_read(&mm->mmap_sem);
+			if (type == CLEAR_REFS_SOFT_DIRTY) {
 				for (vma = mm->mmap; vma; vma = vma->vm_next) {
-					vma->vm_flags &= ~VM_SOFTDIRTY;
-					vma_set_page_prot(vma);
+					if (!(vma->vm_flags & VM_SOFTDIRTY))
+						continue;
+					up_read(&mm->mmap_sem);
+					down_write(&mm->mmap_sem);
+					for (vma = mm->mmap; vma;
+					     vma = vma->vm_next) {
+						vma->vm_flags &= ~VM_SOFTDIRTY;
+						vma_set_page_prot(vma);
+					}
+					downgrade_write(&mm->mmap_sem);
+					break;
 				}
-				downgrade_write(&mm->mmap_sem);
-				break;
+				mmu_notifier_invalidate_range_start(mm, 0, -1);
 			}
-			mmu_notifier_invalidate_range_start(mm, 0, -1);
-		}
-		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			cp.vma = vma;
-			if (is_vm_hugetlb_page(vma))
-				continue;
-			/*
-			 * Writing 1 to /proc/pid/clear_refs affects all pages.
-			 *
-			 * Writing 2 to /proc/pid/clear_refs only affects
-			 * Anonymous pages.
-			 *
-			 * Writing 3 to /proc/pid/clear_refs only affects file
-			 * mapped pages.
-			 *
-			 * Writing 4 to /proc/pid/clear_refs affects all pages.
-			 */
-			if (type == CLEAR_REFS_ANON && vma->vm_file)
-				continue;
-			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
-				continue;
-			walk_page_range(vma->vm_start, vma->vm_end,
-					&clear_refs_walk);
+			for (vma = mm->mmap; vma; vma = vma->vm_next) {
+				cp.vma = vma;
+				if (is_vm_hugetlb_page(vma))
+					continue;
+				/*
+				 * Writing 1 to /proc/pid/clear_refs affects all
+				 * pages.
+				 *
+				 * Writing 2 to /proc/pid/clear_refs only
+				 * affects Anonymous pages.
+				 *
+				 * Writing 3 to /proc/pid/clear_refs only
+				 * affects file mapped pages.
+				 *
+				 * Writing 4 to /proc/pid/clear_refs affects all
+				 * pages.
+				 */
+				if (type == CLEAR_REFS_ANON && vma->vm_file)
+					continue;
+				if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
+					continue;
+				walk_page_range(vma->vm_start, vma->vm_end,
+						&clear_refs_walk);
+			}
+			if (type == CLEAR_REFS_SOFT_DIRTY)
+				mmu_notifier_invalidate_range_end(mm, 0, -1);
+			flush_tlb_mm(mm);
+			up_read(&mm->mmap_sem);
 		}
-		if (type == CLEAR_REFS_SOFT_DIRTY)
-			mmu_notifier_invalidate_range_end(mm, 0, -1);
-		flush_tlb_mm(mm);
-		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
 	put_task_struct(task);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b464611..8a51ef4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1350,6 +1350,11 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
 		mm->hiwater_vm = mm->total_vm;
 }
 
+static inline void reset_mm_hiwater_rss(struct mm_struct *mm)
+{
+	mm->hiwater_rss = get_mm_rss(mm);
+}
+
 static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
 					 struct mm_struct *mm)
 {
-- 
2.2.0.rc0.207.ga3a616c

