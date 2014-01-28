Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaA1GDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:03:21 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54144 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaA1GDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:03:20 -0500
From: William Roberts <bill.c.roberts@gmail.com>
To: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        sds@tycho.nsa.gov
Cc: William Roberts <wroberts@tresys.com>
Subject: [PATCH v4 1/3] mm: Create utility function for accessing a tasks commandline value
Date: Mon, 27 Jan 2014 22:03:21 -0800
Message-Id: <1390889003-5058-1-git-send-email-wroberts@tresys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce get_cmdline() for retreiving the value of a processes
proc/self/cmdline value.

Signed-off-by: William Roberts <wroberts@tresys.com>
---
 include/linux/mm.h |    1 +
 mm/util.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f28f46e..db89a94 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1175,6 +1175,7 @@ void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
+int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 
 /* Is the vma a continuation of the stack vma above it? */
 static inline int vma_growsdown(struct vm_area_struct *vma, unsigned long addr)
diff --git a/mm/util.c b/mm/util.c
index a24aa22..8122710 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -445,6 +445,54 @@ unsigned long vm_commit_limit(void)
 	return allowed;
 }
 
+/**
+ * get_cmdline() - copy the cmdline value to a buffer.
+ * @task:     the task whose cmdline value to copy.
+ * @buffer:   the buffer to copy to.
+ * @buflen:   the length of the buffer. Larger cmdline values are truncated
+ *            to this length.
+ * Returns the size of the cmdline field copied. Note that the copy does
+ * not guarantee an ending NULL byte.
+ */
+int get_cmdline(struct task_struct *task, char *buffer, int buflen)
+{
+	int res = 0;
+	unsigned int len;
+	struct mm_struct *mm = get_task_mm(task);
+	if (!mm)
+		goto out;
+	if (!mm->arg_end)
+		goto out_mm;	/* Shh! No looking before we're done */
+
+	len = mm->arg_end - mm->arg_start;
+
+	if (len > buflen)
+		len = buflen;
+
+	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
+
+	/*
+	 * If the nul at the end of args has been overwritten, then
+	 * assume application is using setproctitle(3).
+	 */
+	if (res > 0 && buffer[res-1] != '\0' && len < buflen) {
+		len = strnlen(buffer, res);
+		if (len < res) {
+			res = len;
+		} else {
+			len = mm->env_end - mm->env_start;
+			if (len > buflen - res)
+				len = buflen - res;
+			res += access_process_vm(task, mm->env_start,
+						 buffer+res, len, 0);
+			res = strnlen(buffer, res);
+		}
+	}
+out_mm:
+	mmput(mm);
+out:
+	return res;
+}
 
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
-- 
1.7.9.5

