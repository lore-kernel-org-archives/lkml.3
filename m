Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab3DYBIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 21:08:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58769 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664Ab3DYBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 21:07:42 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-31-517881d8f14f
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 5/6] mm: Support address range reclaim
Date: Thu, 25 Apr 2013 10:07:21 +0900
Message-Id: <1366852043-12511-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1366852043-12511-1-git-send-email-minchan@kernel.org>
References: <1366852043-12511-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds address range reclaim of a process.
The requirement is following as,

Like webkit1, it uses a address space for handling multi tabs.
IOW, it uses *one* process model so all tabs shares address space
of the process. In such scenario, per-process reclaim is rather
coarse-grained so this patch supports more fine-grained reclaim
for being able to reclaim target address range of the process.
For reclaim target range, you should use following format.

	echo [addr] [size-byte] > /proc/pid/reclaim

The addr should be page-aligned.

So now reclaim konb's interface is following as.

echo file > /proc/pid/reclaim
	reclaim file-backed pages only

echo anon > /proc/pid/reclaim
	reclaim anonymous pages only

echo all > /proc/pid/reclaim
	reclaim all pages

echo 0x100000 8K > /proc/pid/reclaim
	reclaim pages in (0x100000 - 0x102000)

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/proc/task_mmu.c | 85 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 70 insertions(+), 15 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 79b674e..9835028 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
+#include <linux/ctype.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
@@ -1239,11 +1240,14 @@ static ssize_t reclaim_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF];
+	char buffer[200];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum reclaim_type type;
 	char *type_buf;
+	struct mm_walk reclaim_walk = {};
+	unsigned long start = 0;
+	unsigned long end = 0;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -1259,42 +1263,93 @@ static ssize_t reclaim_write(struct file *file, const char __user *buf,
 		type = RECLAIM_ANON;
 	else if (!strcmp(type_buf, "all"))
 		type = RECLAIM_ALL;
+	else if (isdigit(*type_buf))
+		type = RECLAIM_RANGE;
 	else
-		return -EINVAL;
+		goto out_err;
+
+	if (type == RECLAIM_RANGE) {
+		char *token;
+		unsigned long long len, len_in, tmp;
+		token = strsep(&type_buf, " ");
+		if (!token)
+			goto out_err;
+		tmp = memparse(token, &token);
+		if (tmp & ~PAGE_MASK || tmp > ULONG_MAX)
+			goto out_err;
+		start = tmp;
+
+		token = strsep(&type_buf, " ");
+		if (!token)
+			goto out_err;
+		len_in = memparse(token, &token);
+		len = (len_in + ~PAGE_MASK) & PAGE_MASK;
+		if (len > ULONG_MAX)
+			goto out_err;
+		/*
+		 * Check to see whether len was rounded up from small -ve
+		 * to zero.
+		 */
+		if (len_in && !len)
+			goto out_err;
+
+		end = start + len;
+		if (end < start)
+			goto out_err;
+	}
 
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
 
 	mm = get_task_mm(task);
-	if (mm) {
-		struct mm_walk reclaim_walk = {
-			.pmd_entry = reclaim_pte_range,
-			.mm = mm,
-		};
+	if (!mm)
+		goto out;
 
-		down_read(&mm->mmap_sem);
-		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			reclaim_walk.private = vma;
+	reclaim_walk.mm = mm;
+	reclaim_walk.pmd_entry = reclaim_pte_range;
 
+	down_read(&mm->mmap_sem);
+	if (type == RECLAIM_RANGE) {
+		vma = find_vma(mm, start);
+		while (vma) {
+			if (vma->vm_start > end)
+				break;
+			if (is_vm_hugetlb_page(vma))
+				continue;
+
+			reclaim_walk.private = vma;
+			walk_page_range(max(vma->vm_start, start),
+					min(vma->vm_end, end),
+					&reclaim_walk);
+			vma = vma->vm_next;
+		}
+	} else {
+		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			if (is_vm_hugetlb_page(vma))
 				continue;
 
 			if (type == RECLAIM_ANON && vma->vm_file)
 				continue;
+
 			if (type == RECLAIM_FILE && !vma->vm_file)
 				continue;
 
+			reclaim_walk.private = vma;
 			walk_page_range(vma->vm_start, vma->vm_end,
-					&reclaim_walk);
+				&reclaim_walk);
 		}
-		flush_tlb_mm(mm);
-		up_read(&mm->mmap_sem);
-		mmput(mm);
 	}
-	put_task_struct(task);
 
+	flush_tlb_mm(mm);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+out:
+	put_task_struct(task);
 	return count;
+
+out_err:
+	return -EINVAL;
 }
 
 const struct file_operations proc_reclaim_operations = {
-- 
1.8.2

