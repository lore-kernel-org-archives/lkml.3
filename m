Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaEZNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:43:17 -0400
Received: from numidia.opendz.org ([98.142.220.152]:33465 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaEZNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:43:15 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 3/9] procfs: add proc_read_from_buffer() and pid_entry_read() helpers
Date: Mon, 26 May 2014 14:27:24 +0100
Message-Id: <1401110850-3552-4-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation, it adds a couple of helpers to read data and
to get the cached permission checks during that ->read().

Currently INF entries share the same code, they do not implement
specific ->open(), only ->read() coupled with callback calls. Doing
permission checks during ->open() will not work and will only disturb
the INF entries that do not need permission checks. Yes not all the INF
entries need checks, the ones that need protections are listed below:
/proc/<pid>/wchan
/proc/<pid>/syscall
/proc/<pid>/{auxv,io}  (will be handled in next patches).

So to have proper permission checks convert this INF entries to REG
entries and use their open() and read() handlers to implement these
checks. To achieve this we add the following helpers:

* proc_read_from_buffer() a wrapper around simple_read_from_buffer(), it
  makes sure that count <= PROC_BLOCK_SIZE (3*1024)

* pid_entry_read(): it will get a free page and pass it to the specific
  /proc/<pid>/$entry handler (callback). The handler is of the same
  types of the previous INF handlers, it will only receive an extra
  "permitted" argument that contains the cached permission check that
  was performed during ->open().

  The handler is of type:
  typedef int (*proc_read_fn_t)(char *page,
                               struct task_struct *task, int permitted);

So the converted code for example: /proc/pid/wchan will be:

  Before:
  static int proc_pid_wchan(struct task_struct *task, char *buffer)

  After:
  static int proc_pid_wchan(char *buffer,
			    struct task_struct *task, int permitted)

The extra "permitted" can be used by the handler to allow/deny reads.

And the whole read() of /proc/pid/wchan will be:

static ssize_t wchan_read(struct file *file, char __user *buf,
			  size_t count, loff_t *ppos)
{
	ssize_t length;
	unsigned long page = 0UL;

	length = pid_entry_read(file, &page, proc_pid_wchan);
	if (length >= 0) {
		length = proc_read_from_buffer(buf, count, ppos,
					       (char *)page, length);
		free_page(page);
	}

	return length;
}

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c     | 53 +++++++++++++++++++++++++++++++++++++++++++++++------
 fs/proc/internal.h |  3 +++
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e442784..efe2a11 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -139,6 +139,50 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
+/* 4K page size but our output routines use some slack for overruns */
+#define PROC_BLOCK_SIZE	(3*1024)
+
+static ssize_t proc_read_from_buffer(void __user *to, size_t count,
+				     loff_t *ppos, const void *from,
+				     size_t available)
+{
+	if (count > PROC_BLOCK_SIZE)
+		count = PROC_BLOCK_SIZE;
+
+	return simple_read_from_buffer(to, count, ppos, from, available);
+}
+
+static ssize_t pid_entry_read(struct file *file, unsigned long *page,
+			      proc_read_fn_t proc_read)
+{
+	unsigned long addr;
+	ssize_t length = -ESRCH;
+	struct task_struct *task;
+	struct inode *inode = file_inode(file);
+	int permitted = (unsigned long)(void *)file->private_data;
+
+	task = get_proc_task(inode);
+	if (!task)
+		goto out_no_task;
+
+	length = -ENOMEM;
+	addr = __get_free_page(GFP_TEMPORARY);
+	if (!addr)
+		goto out;
+
+	length = proc_read((char *)addr, task, permitted);
+	if (length < 0) {
+		free_page(addr);
+		goto out;
+	}
+
+	*page = addr;
+out:
+	put_task_struct(task);
+out_no_task:
+	return length;
+}
+
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
@@ -598,8 +642,6 @@ static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
-
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
@@ -612,9 +654,6 @@ static ssize_t proc_info_read(struct file * file, char __user * buf,
 	if (!task)
 		goto out_no_task;
 
-	if (count > PROC_BLOCK_SIZE)
-		count = PROC_BLOCK_SIZE;
-
 	length = -ENOMEM;
 	if (!(page = __get_free_page(GFP_TEMPORARY)))
 		goto out;
@@ -622,7 +661,9 @@ static ssize_t proc_info_read(struct file * file, char __user * buf,
 	length = PROC_I(inode)->op.proc_read(task, (char*)page);
 
 	if (length >= 0)
-		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
+		length = proc_read_from_buffer(buf, count, ppos,
+					       (char *)page, length);
+
 	free_page(page);
 out:
 	put_task_struct(task);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 4f828fa..f5c452c 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -78,6 +78,9 @@ struct proc_inode {
 	struct inode vfs_inode;
 };
 
+typedef int (*proc_read_fn_t)(char *page,
+			      struct task_struct *task, int permitted);
+
 /*
  * General functions
  */
-- 
1.7.11.7

