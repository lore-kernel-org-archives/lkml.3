Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3KFLsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:21 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:60838 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab3KFLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:17 -0500
Message-Id: <20131106114812.591636205@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/7] procfs: Introduce sequential fdinfo engine
References: <20131106114742.988532945@openvz.org>
Content-Disposition: inline; filename=0001-procfs-fdinfo-new-6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At moment the fdinfo operations (ie the output from /proc/$pid/fdinfo/$fd)
are generating output in one pass, allocating one page buffer as a maximum.
But in case of lots of event polls watchees (75 and more) read procedure
will fail because one page is not enough to provide all information
associated with watch descriptors.

Instead, provide proc_fdinfo structure where each file hook own seq_operations
for fdinfo output and the seq-file engine will be able to traverse over the all
records and provide the reader complete information increasing buffer size if
needed.

Once all fdinfo callers are converted (addressed in next patches) the former
@show_fdinfo member will be removed.

Note the patch doesn't change current output it's rather preparing
the ground for next patches.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/fd.c       |  141 ++++++++++++++++++++++++++++++++++++++++-------------
 include/linux/fs.h |    1 
 2 files changed, 109 insertions(+), 33 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -14,60 +14,135 @@
 #include "internal.h"
 #include "fd.h"
 
+struct proc_fdinfo {
+	struct seq_file		seq;	/* Make sure it's first */
+	struct seq_operations	*op;
+	struct file		*f_file;
+	unsigned int		f_flags;
+};
+
+#define seq_info(m)	(container_of(m, struct proc_fdinfo, seq))
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo *info = seq_info(m);
+
+	if (*pos == 0)
+		seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
+			   (long long)info->f_file->f_pos, info->f_flags);
+
+	return info->op ? info->op->start(m, pos) : NULL + (*pos == 0);
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo *info = seq_info(m);
+
+	if (info->op)
+		info->op->stop(m, v);
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo *info = seq_info(m);
+
+	if (info->op)
+		return info->op->next(m, p, pos);
+
+	++*pos;
+	return NULL;
+}
+
 static int seq_show(struct seq_file *m, void *v)
 {
+	struct proc_fdinfo *info = seq_info(m);
+
+	if (info->op)
+		return info->op->show(m, v);
+
+	/* Legacy interface */
+	if (info->f_file->f_op->show_fdinfo)
+		return info->f_file->f_op->show_fdinfo(m, info->f_file);
+
+	return 0;
+}
+
+static const struct seq_operations fdinfo_seq_ops = {
+	.start	= seq_start,
+	.stop	= seq_stop,
+	.next	= seq_next,
+	.show	= seq_show,
+};
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
 	struct files_struct *files = NULL;
-	int f_flags = 0, ret = -ENOENT;
-	struct file *file = NULL;
+	struct proc_fdinfo *info;
 	struct task_struct *task;
+	int ret;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	file->private_data = &info->seq;
+
+	ret = seq_open(file, &fdinfo_seq_ops);
+	if (!ret) {
+		ret = -ENOENT;
 
-	task = get_proc_task(m->private);
-	if (!task)
-		return -ENOENT;
-
-	files = get_files_struct(task);
-	put_task_struct(task);
-
-	if (files) {
-		int fd = proc_fd(m->private);
-
-		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
-		if (file) {
-			struct fdtable *fdt = files_fdtable(files);
-
-			f_flags = file->f_flags;
-			if (close_on_exec(fd, fdt))
-				f_flags |= O_CLOEXEC;
+		task = get_proc_task(inode);
+		if (task) {
+			files = get_files_struct(task);
+			put_task_struct(task);
+		}
 
-			get_file(file);
-			ret = 0;
+		if (files) {
+			struct seq_file *m = file->private_data;
+			int fd = proc_fd(inode);
+
+			spin_lock(&files->file_lock);
+			info->f_file = fcheck_files(files, fd);
+			if (info->f_file) {
+				struct fdtable *fdt = files_fdtable(files);
+
+				info->f_flags = info->f_file->f_flags & ~O_CLOEXEC;
+				if (close_on_exec(fd, fdt))
+					info->f_flags |= O_CLOEXEC;
+				info->op = info->f_file->f_op->fdinfo_op;
+				m->private = info->f_file;
+
+				get_file(info->f_file);
+				ret = 0;
+			}
+			spin_unlock(&files->file_lock);
+			put_files_struct(files);
 		}
-		spin_unlock(&files->file_lock);
-		put_files_struct(files);
 	}
 
-	if (!ret) {
-                seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
-			   (long long)file->f_pos, f_flags);
-		if (file->f_op->show_fdinfo)
-			ret = file->f_op->show_fdinfo(m, file);
-		fput(file);
+	if (ret) {
+		if (info->f_file)
+			fput(info->f_file);
+		file->private_data = NULL;
+		kfree(info);
 	}
 
 	return ret;
 }
 
-static int seq_fdinfo_open(struct inode *inode, struct file *file)
+static int seq_fdinfo_release(struct inode *inode, struct file *file)
 {
-	return single_open(file, seq_show, inode);
+	struct seq_file *m = file->private_data;
+	struct proc_fdinfo *info = seq_info(m);
+
+	fput(info->f_file);
+	return seq_release(inode, file);
 }
 
 static const struct file_operations proc_fdinfo_file_operations = {
 	.open		= seq_fdinfo_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_fdinfo_release,
 };
 
 static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -1552,6 +1552,7 @@ struct file_operations {
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
+	struct seq_operations *fdinfo_op;
 };
 
 struct inode_operations {

