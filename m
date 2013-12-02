Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3LBVLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:11:09 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:61462 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab3LBVKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:10:49 -0500
From: William Roberts <bill.c.roberts@gmail.com>
To: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk
Cc: sds@tycho.nsa.gov, William Roberts <wroberts@tresys.com>
Subject: [PATCH 1/3] mm: Create utility functions for accessing a tasks commandline value
Date: Mon,  2 Dec 2013 13:10:37 -0800
Message-Id: <1386018639-18916-2-git-send-email-wroberts@tresys.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
References: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two new functions to mm.h:
* copy_cmdline()
* get_cmdline_length()

Signed-off-by: William Roberts <wroberts@tresys.com>
---
 include/linux/mm.h |    7 +++++++
 mm/util.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1cedd00..b4d7c26 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1135,6 +1135,13 @@ int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
+extern int copy_cmdline(struct task_struct *task, struct mm_struct *mm,
+			char *buf, unsigned int buflen);
+static inline unsigned int get_cmdline_length(struct mm_struct *mm)
+{
+	return mm->arg_end ? mm->arg_end - mm->arg_start : 0;
+}
+
 /* Is the vma a continuation of the stack vma above it? */
 static inline int vma_growsdown(struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/util.c b/mm/util.c
index f7bc209..c8cad32 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -9,6 +9,7 @@
 #include <linux/swapops.h>
 #include <linux/mman.h>
 #include <linux/hugetlb.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 
@@ -410,6 +411,53 @@ unsigned long vm_commit_limit(void)
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 }
 
+/**
+ * copy_cmdline - Copy's the tasks commandline value to a buffer
+ * @task: The task whose command line to copy
+ * @mm: The mm struct refering to task with proper semaphores held
+ * @buf: The buffer to copy the value into
+ * @buflen: The length og the buffer. It trucates the value to
+ *           buflen.
+ * @return: The number of chars copied.
+ */
+int copy_cmdline(struct task_struct *task, struct mm_struct *mm,
+		 char *buf, unsigned int buflen)
+{
+	int res = 0;
+	unsigned int len;
+
+	if (!task || !mm || !buf)
+		return -1;
+
+	res = access_process_vm(task, mm->arg_start, buf, buflen, 0);
+	if (res <= 0)
+		return 0;
+
+	if (res > buflen)
+		res = buflen;
+	/*
+	 * If the nul at the end of args had been overwritten, then
+	 * assume application is using setproctitle(3).
+	 */
+	if (buf[res-1] != '\0') {
+		/* Nul between start and end of vm space?
+		   If so then truncate */
+		len = strnlen(buf, res);
+		if (len < res) {
+			res = len;
+		} else {
+			/* No nul, truncate buflen if to big */
+			len = mm->env_end - mm->env_start;
+			if (len > buflen - res)
+				len = buflen - res;
+			/* Copy any remaining data */
+			res += access_process_vm(task, mm->env_start, buf+res,
+						 len, 0);
+			res = strnlen(buf, res);
+		}
+	}
+	return res;
+}
 
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
-- 
1.7.9.5

