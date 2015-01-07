Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbbAGRIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:08:09 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65305 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbbAGRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:08:08 -0500
From: Petr Cermak <petrcermak@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>,
        Petr Cermak <petrcermak@chromium.org>
Subject: [PATCH v2 2/2] task_mmu: Add user-space support for resetting mm->hiwater_rss (peak RSS)
Date: Wed,  7 Jan 2015 17:06:54 +0000
Message-Id: <be6c14c9ac4551e94b814c5789242b4874a25dd3.1420643264.git.petrcermak@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <cover.1420643264.git.petrcermak@chromium.org>
References: <cover.1420643264.git.petrcermak@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peak resident size of a process can be reset by writing "5" to
/proc/pid/clear_refs. The driving use-case for this would be getting the
peak RSS value, which can be retrieved from the VmHWM field in
/proc/pid/status, per benchmark iteration or test scenario.

Signed-off-by: Petr Cermak <petrcermak@chromium.org>
---
 Documentation/filesystems/proc.txt |  3 +++
 fs/proc/task_mmu.c                 | 15 ++++++++++++++-
 include/linux/mm.h                 |  5 +++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index aae9dd1..7a3c689 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -488,6 +488,9 @@ To clear the bits for the file mapped pages associated with the process
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
+To reset the peak resident set size ("high water mark") to the current value
+    > echo 5 > /proc/PID/clear_refs
+
 Any other value written to /proc/PID/clear_refs will have no effect.
 
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 500d310..881a708 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -747,6 +747,7 @@ enum clear_refs_types {
 	CLEAR_REFS_ANON,
 	CLEAR_REFS_MAPPED,
 	CLEAR_REFS_SOFT_DIRTY,
+	CLEAR_REFS_MM_HIWATER_RSS,
 	CLEAR_REFS_LAST,
 };
 
@@ -857,6 +858,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	if (!mm)
 		goto out_task;
 
+	if (type == CLEAR_REFS_MM_HIWATER_RSS) {
+		/*
+		 * Writing 5 to /proc/pid/clear_refs resets the peak resident
+		 * set size to the current value.
+		 */
+		down_write(&mm->mmap_sem);
+		reset_mm_hiwater_rss(mm);
+		up_write(&mm->mmap_sem);
+		goto out_mm;
+	}
+
 	cp = (struct clear_refs_private) {
 		.type = type
 	};
@@ -906,8 +918,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		mmu_notifier_invalidate_range_end(mm, 0, -1);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
-	mmput(mm);
 
+out_mm:
+	mmput(mm);
 out_task:
 	put_task_struct(task);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f80d019..dabb6cd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1366,6 +1366,11 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
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

