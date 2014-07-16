Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaGPVi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:38:26 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:44953 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaGPViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:38:21 -0400
Date: Thu, 17 Jul 2014 00:38:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] proc: remove INF macro
Message-ID: <20140716213816.GI21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're applying this patch, all /proc/$PID/* files were converted
to seq_file interface and this code became unused.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c     |   41 -----------------------------------------
 fs/proc/internal.h |    1 -
 2 files changed, 42 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -130,10 +130,6 @@ struct pid_entry {
 		{ .proc_get_link = get_link } )
 #define REG(NAME, MODE, fops)				\
 	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {})
-#define INF(NAME, MODE, read)				\
-	NOD(NAME, (S_IFREG|(MODE)), 			\
-		NULL, &proc_info_file_operations,	\
-		{ .proc_read = read } )
 #define ONE(NAME, MODE, show)				\
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_single_file_operations,	\
@@ -605,43 +601,6 @@ static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
-
-static ssize_t proc_info_read(struct file * file, char __user * buf,
-			  size_t count, loff_t *ppos)
-{
-	struct inode * inode = file_inode(file);
-	unsigned long page;
-	ssize_t length;
-	struct task_struct *task = get_proc_task(inode);
-
-	length = -ESRCH;
-	if (!task)
-		goto out_no_task;
-
-	if (count > PROC_BLOCK_SIZE)
-		count = PROC_BLOCK_SIZE;
-
-	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_TEMPORARY)))
-		goto out;
-
-	length = PROC_I(inode)->op.proc_read(task, (char*)page);
-
-	if (length >= 0)
-		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
-	free_page(page);
-out:
-	put_task_struct(task);
-out_no_task:
-	return length;
-}
-
-static const struct file_operations proc_info_file_operations = {
-	.read		= proc_info_read,
-	.llseek		= generic_file_llseek,
-};
-
 static int proc_single_show(struct seq_file *m, void *v)
 {
 	struct inode *inode = m->private;
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -52,7 +52,6 @@ struct proc_dir_entry {
 
 union proc_op {
 	int (*proc_get_link)(struct dentry *, struct path *);
-	int (*proc_read)(struct task_struct *task, char *page);
 	int (*proc_show)(struct seq_file *m,
 		struct pid_namespace *ns, struct pid *pid,
 		struct task_struct *task);
