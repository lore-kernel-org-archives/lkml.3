Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbaLORQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:16:43 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63264 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaLORQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:16:40 -0500
From: Petr Cermak <petrcermak@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Petr Cermak <petrcermak@chromium.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>
Subject: [PATCH 2/2] task_mmu: Add user-space support for resetting mm->hiwater_rss (peak RSS)
Date: Mon, 15 Dec 2014 17:15:33 +0000
Message-Id: <1418663733-15949-1-git-send-email-petrcermak@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
References: <1418223544-11382-1-git-send-email-petrcermak@chromium.org>
In-Reply-To: <1418223544-11382-1-git-send-email-petrcermak@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peak resident size of a process can be reset by writing "5" to
/proc/pid/clear_refs. The driving use-case for this would be getting the
peak RSS value, which can be retrieved from the VmHWM field in
/proc/pid/status, per benchmark iteration or test scenario.

Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Primiano Tucci <primiano@chromium.org>
Cc: Petr Cermak <petrcermak@chromium.org>
Signed-off-by: Petr Cermak <petrcermak@chromium.org>
---
 Documentation/filesystems/proc.txt |  3 +++
 fs/proc/task_mmu.c                 | 15 ++++++++++++++-
 include/linux/mm.h                 |  5 +++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index aae9dd1..eab62e3 100644
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
index 3ee8541..7967535 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -747,6 +747,7 @@ enum clear_refs_types {
 	CLEAR_REFS_ANON,
 	CLEAR_REFS_MAPPED,
 	CLEAR_REFS_SOFT_DIRTY,
+	CLEAR_REFS_MM_HIWATER_RSS,
 	CLEAR_REFS_LAST,
 };
 
@@ -855,6 +856,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	if (!mm)
 		goto out_task;
 
+	if (type == CLEAR_REFS_MM_HIWATER_RSS) {
+		/*
+		 * Writing 5 to /proc/pid/clear_refs resets the peak resident
+		 * set size.
+		 */
+		down_write(&mm->mmap_sem);
+		reset_mm_hiwater_rss(mm);
+		up_write(&mm->mmap_sem);
+		goto out_mm;
+	}
+
 	struct clear_refs_private cp = {
 		.type = type,
 	};
@@ -904,8 +916,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		mmu_notifier_invalidate_range_end(mm, 0, -1);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
-	mmput(mm);
 
+out_mm:
+	mmput(mm);
 out_task:
 	put_task_struct(task);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c0a67b8..f3f6cee 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1368,6 +1368,11 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
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

