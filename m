Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaGHVkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:40:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56182 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGHVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:40:43 -0400
Date: Wed, 9 Jul 2014 00:40:41 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH 1/2] proc: add and remove /proc entry create checks
Message-ID: <20140708214041.GA2256@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove proc_create(NULL, ...) check, let it oops

* warn about proc_create("", ...) and proc_create("very very long name", ...)
  proc code keeps length as u8, no 256+ name length possible

* warn about proc_create("123", ...)
  /proc/$PID and /proc/misc namespaces are separate things,
  but dumb module might create funky a-la $PID entry.

* remove post mortem strchr('/') check
  Triggering it implies either strchr() is buggy or memory corruption.
  It should be VFS check anyway.

In reality, none of these checks will ever trigger,
it is preparation for the next patch.

Based on patch from Al Viro.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c     |    4 ++--
 fs/proc/fd.c       |    2 +-
 fs/proc/generic.c  |   30 +++++++++++++++---------------
 fs/proc/internal.h |    6 +++---
 4 files changed, 21 insertions(+), 21 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2785,7 +2785,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	unsigned tgid;
 	struct pid_namespace *ns;
 
-	tgid = name_to_int(dentry);
+	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
 		goto out;
 
@@ -3033,7 +3033,7 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	if (!leader)
 		goto out_no_task;
 
-	tid = name_to_int(dentry);
+	tid = name_to_int(&dentry->d_name);
 	if (tid == ~0U)
 		goto out;
 
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -206,7 +206,7 @@ static struct dentry *proc_lookupfd_common(struct inode *dir,
 {
 	struct task_struct *task = get_proc_task(dir);
 	int result = -ENOENT;
-	unsigned fd = name_to_int(dentry);
+	unsigned fd = name_to_int(&dentry->d_name);
 
 	if (!task)
 		goto out_no_task;
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -330,28 +330,28 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 					  nlink_t nlink)
 {
 	struct proc_dir_entry *ent = NULL;
-	const char *fn = name;
-	unsigned int len;
-
-	/* make sure name is valid */
-	if (!name || !strlen(name))
-		goto out;
+	const char *fn;
+	struct qstr qstr;
 
 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
+	qstr.name = fn;
+	qstr.len = strlen(fn);
+	if (qstr.len == 0 || qstr.len >= 256) {
+		WARN(1, "name len %u\n", qstr.len);
+		return NULL;
+	}
+	if (*parent == &proc_root && name_to_int(&qstr) != ~0U) {
+		WARN(1, "create '/proc/%s' by hand\n", qstr.name);
+		return NULL;
+	}
 
-	/* At this point there must not be any '/' characters beyond *fn */
-	if (strchr(fn, '/'))
-		goto out;
-
-	len = strlen(fn);
-
-	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
+	ent = kzalloc(sizeof(struct proc_dir_entry) + qstr.len + 1, GFP_KERNEL);
 	if (!ent)
 		goto out;
 
-	memcpy(ent->name, fn, len + 1);
-	ent->namelen = len;
+	memcpy(ent->name, fn, qstr.len + 1);
+	ent->namelen = qstr.len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -112,10 +112,10 @@ static inline int task_dumpable(struct task_struct *task)
 	return 0;
 }
 
-static inline unsigned name_to_int(struct dentry *dentry)
+static inline unsigned name_to_int(const struct qstr *qstr)
 {
-	const char *name = dentry->d_name.name;
-	int len = dentry->d_name.len;
+	const char *name = qstr->name;
+	int len = qstr->len;
 	unsigned n = 0;
 
 	if (len > 1 && *name == '0')
