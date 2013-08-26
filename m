Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3HZIwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:52:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21068 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3HZIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:52:39 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: David Howells <dhowells@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 2/2] proc: change return values while get_proc_task err
Date: Mon, 26 Aug 2013 16:51:52 +0800
Message-ID: <1377507112-48288-2-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1377507112-48288-1-git-send-email-rui.xiang@huawei.com>
References: <1377507112-48288-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While getting proc task fails, it shoule return -ESRCH.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 fs/proc/base.c       | 25 +++++++++++++++----------
 fs/proc/fd.c         |  8 +++++---
 fs/proc/namespaces.c | 12 ++++++++----
 fs/proc_namespace.c  |  2 +-
 4 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..65f78a9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -174,9 +174,10 @@ static int get_task_root(struct task_struct *task, struct path *root)
 static int proc_cwd_link(struct dentry *dentry, struct path *path)
 {
 	struct task_struct *task = get_proc_task(dentry->d_inode);
-	int result = -ENOENT;
+	int result = -ESRCH;
 
 	if (task) {
+		result = -ENOENT;
 		task_lock(task);
 		if (task->fs) {
 			get_fs_pwd(task->fs, path);
@@ -191,7 +192,7 @@ static int proc_cwd_link(struct dentry *dentry, struct path *path)
 static int proc_root_link(struct dentry *dentry, struct path *path)
 {
 	struct task_struct *task = get_proc_task(dentry->d_inode);
-	int result = -ENOENT;
+	int result = -ESRCH;
 
 	if (task) {
 		result = get_task_root(task, path);
@@ -1438,11 +1439,11 @@ static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
 
 	task = get_proc_task(dentry->d_inode);
 	if (!task)
-		return -ENOENT;
+		return -ECHILD;
 	mm = get_task_mm(task);
 	put_task_struct(task);
 	if (!mm)
-		return -ENOENT;
+		return -EINVAL;
 	exe_file = get_mm_exe_file(mm);
 	mmput(mm);
 	if (exe_file) {
@@ -1799,11 +1800,12 @@ static int proc_map_files_get_link(struct dentry *dentry, struct path *path)
 	struct mm_struct *mm;
 	int rc;
 
-	rc = -ENOENT;
+	rc = -ESRCH;
 	task = get_proc_task(dentry->d_inode);
 	if (!task)
 		goto out;
 
+	rc = -EINVAL;
 	mm = get_task_mm(task);
 	put_task_struct(task);
 	if (!mm)
@@ -1934,7 +1936,7 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
-	ret = -ENOENT;
+	ret = -ESRCH;
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		goto out;
@@ -2161,11 +2163,12 @@ static struct dentry *proc_pident_lookup(struct inode *dir,
 	struct task_struct *task = get_proc_task(dir);
 	const struct pid_entry *p, *last;
 
-	error = -ENOENT;
+	error = -ESRCH;
 
 	if (!task)
 		goto out_no_task;
 
+	error = -ENOENT;
 	/*
 	 * Yes, it does not scale. And it should not. Don't add
 	 * new entries into /proc/<tgid>/ without very good reasons.
@@ -2194,7 +2197,7 @@ static int proc_pident_readdir(struct file *file, struct dir_context *ctx,
 	const struct pid_entry *p;
 
 	if (!task)
-		return -ENOENT;
+		return -ESRCH;
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
@@ -3047,8 +3050,10 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	unsigned tid;
 	struct pid_namespace *ns;
 
-	if (!leader)
+	if (!leader) {
+		result = -ESRCH;
 		goto out_no_task;
+	}
 
 	tid = name_to_int(dentry);
 	if (tid == ~0U)
@@ -3152,7 +3157,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	int tid;
 
 	if (!task)
-		return -ENOENT;
+		return -ESRCH;
 	rcu_read_lock();
 	if (pid_alive(task)) {
 		leader = task->group_leader;
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 0ff80f9..c951a84 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -23,7 +23,7 @@ static int seq_show(struct seq_file *m, void *v)
 
 	task = get_proc_task(m->private);
 	if (!task)
-		return -ENOENT;
+		return -ESRCH;
 
 	files = get_files_struct(task);
 	put_task_struct(task);
@@ -206,8 +206,10 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 	int result = -ENOENT;
 	unsigned fd = name_to_int(dentry);
 
-	if (!task)
+	if (!task) {
+		result = -ESRCH;
 		goto out_no_task;
+	}
 	if (fd == ~0U)
 		goto out;
 
@@ -226,7 +228,7 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 	unsigned int fd;
 
 	if (!p)
-		return -ENOENT;
+		return -ESRCH;
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 49a7fff..cedb02b 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -119,12 +119,13 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct proc_inode *ei = PROC_I(inode);
 	struct task_struct *task;
 	struct path ns_path;
-	void *error = ERR_PTR(-EACCES);
+	void *error = ERR_PTR(-ESRCH);
 
 	task = get_proc_task(inode);
 	if (!task)
 		goto out;
 
+	error = ERR_PTR(-EACCES);
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
@@ -152,12 +153,13 @@ static int proc_ns_readlink(struct dentry *dentry, char __user *buffer, int bufl
 	struct task_struct *task;
 	void *ns;
 	char name[50];
-	int len = -EACCES;
+	int len = -ESRCH;
 
 	task = get_proc_task(inode);
 	if (!task)
 		goto out;
 
+	len = -EACCES;
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
@@ -218,7 +220,7 @@ static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
 	const struct proc_ns_operations **entry, **last;
 
 	if (!task)
-		return -ENOENT;
+		return -ESRCH;
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
@@ -254,8 +256,10 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
 
 	error = -ENOENT;
 
-	if (!task)
+	if (!task) {
+		error = -ESRCH;
 		goto out_no_task;
+	}
 
 	last = &ns_entries[ARRAY_SIZE(ns_entries)];
 	for (entry = ns_entries; entry < last; entry++) {
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5fe34c3..ce978b3 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -230,7 +230,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	int ret = -EINVAL;
 
 	if (!task)
-		goto err;
+		return -ESRCH;
 
 	rcu_read_lock();
 	nsp = task_nsproxy(task);
-- 
1.8.2.2


