Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaJCDHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 23:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaJCDH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 23:07:27 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, sgrubb@redhat.com, aviro@redhat.com,
        pmoore@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH V5 2/5] audit: clean simple fsnotify implementation
Date: Thu,  2 Oct 2014 23:06:53 -0400
Message-Id: <349f663a92f5604f52515aa1cfb9da001a24620f.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

This is to be used to audit by executable rules, but audit watches
should be able to share this code eventually.

At the moment the audit watch code is a lot more complex, that code only
creates one fsnotify watch per parent directory.  That 'audit_parent' in
turn has a list of 'audit_watches' which contain the name, ino, dev of
the specific object we care about.  This just creates one fsnotify watch
per object we care about.  So if you watch 100 inodes in /etc this code
will create 100 fsnotify watches on /etc.  The audit_watch code will
instead create 1 fsnotify watch on /etc (the audit_parent) and then 100
individual watches chained from that fsnotify mark.

We should be able to convert the audit_watch code to do one fsnotify
mark per watch and simplify things/remove a whole lot of code.  After
that conversion we should be able to convert the audit_fsnotify code to
support that hierarchy if the optomization is necessary.

RGB: Move the access to the entry for audit_match_signal() to the beginning of
the function in case the entry found is the same one passed in.  This will
enable it to be used by audit_remove_mark_rule().
RGB: Rename several "watch" references to "mark".
RGB: Rename audit_remove_rule() to audit_remove_mark_rule().
RGB: Let audit_free_rule() take care of calling audit_remove_mark().
RGB: Put audit_alloc_mark() arguments in same order as watch, tree and inode.
RGB: Remove space from audit log value text in audit_remove_mark_rule().

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/Makefile         |    2 +-
 kernel/audit.h          |   29 ++++++
 kernel/audit_fsnotify.c |  245 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditfilter.c    |   10 +-
 4 files changed, 280 insertions(+), 6 deletions(-)
 create mode 100644 kernel/audit_fsnotify.c

diff --git a/kernel/Makefile b/kernel/Makefile
index 60def04..e82583f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -63,7 +63,7 @@ obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
-obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o audit_exe.o
+obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o audit_exe.o audit_fsnotify.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_KPROBES) += kprobes.o
diff --git a/kernel/audit.h b/kernel/audit.h
index 7825c7e..b8ecc06 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -56,6 +56,7 @@ enum audit_state {
 
 /* Rule lists */
 struct audit_watch;
+struct audit_fsnotify_mark;
 struct audit_exe;
 struct audit_tree;
 struct audit_chunk;
@@ -266,6 +267,7 @@ struct audit_net {
 extern int selinux_audit_rule_update(void);
 
 extern struct mutex audit_filter_mutex;
+extern int audit_del_rule(struct audit_entry *);
 extern void audit_free_rule_rcu(struct rcu_head *);
 extern struct list_head audit_filter_list[];
 
@@ -281,6 +283,11 @@ extern void audit_remove_watch_rule(struct audit_krule *krule);
 extern char *audit_watch_path(struct audit_watch *watch);
 extern int audit_watch_compare(struct audit_watch *watch, unsigned long ino, dev_t dev);
 
+struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pathname, int len);
+char *audit_mark_path(struct audit_fsnotify_mark *mark);
+void audit_remove_mark(struct audit_fsnotify_mark *audit_mark);
+int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev);
+
 int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op);
 void audit_remove_exe_rule(struct audit_krule *krule);
 char *audit_exe_path(struct audit_exe *exe);
@@ -296,6 +303,28 @@ int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe);
 #define audit_watch_path(w) ""
 #define audit_watch_compare(w, i, d) 0
 
+static inline struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pathname, int len)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline char *audit_mark_path(struct audit_fsnotify_mark *mark)
+{
+	BUG();
+	return "";
+}
+
+static inline void audit_remove_mark(struct audit_fsnotify_mark *audit_mark)
+{
+	BUG();
+}
+
+static inline int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev)
+{
+	BUG();
+	return 0;
+}
+
 static inline int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op)
 {
 	return -EINVAL;
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
new file mode 100644
index 0000000..f4b3e66
--- /dev/null
+++ b/kernel/audit_fsnotify.c
@@ -0,0 +1,245 @@
+/* audit_fsnotify.c -- tracking inodes
+ *
+ * Copyright 2003-2009 Red Hat, Inc.
+ * Copyright 2005 Hewlett-Packard Development Company, L.P.
+ * Copyright 2005 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/audit.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/fs.h>
+#include <linux/fsnotify_backend.h>
+#include <linux/namei.h>
+#include <linux/netlink.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include "audit.h"
+
+/*
+ * this mark lives on the parent directory of the inode in question.
+ * but dev, ino, and path are about the child
+ */
+struct audit_fsnotify_mark {
+	dev_t dev;		/* associated superblock device */
+	unsigned long ino;	/* associated inode number */
+	char *path;		/* insertion path */
+	struct fsnotify_mark mark; /* fsnotify mark on the inode */
+	struct audit_krule *rule;
+};
+
+/* fsnotify handle. */
+static struct fsnotify_group *audit_fsnotify_group;
+
+/* fsnotify events we care about. */
+#define AUDIT_FS_EVENTS (FS_MOVE | FS_CREATE | FS_DELETE | FS_DELETE_SELF |\
+			 FS_MOVE_SELF | FS_EVENT_ON_CHILD)
+
+static void audit_free_mark(struct audit_fsnotify_mark *audit_mark)
+{
+	kfree(audit_mark->path);
+	kfree(audit_mark);
+}
+
+static void audit_free_fsnotify_mark(struct fsnotify_mark *mark)
+{
+	struct audit_fsnotify_mark *audit_mark;
+
+	audit_mark = container_of(mark, struct audit_fsnotify_mark, mark);
+	audit_free_mark(audit_mark);
+}
+
+#if 0 /* not sure if we need these... */
+static void audit_get_mark(struct audit_fsnotify_mark *audit_mark)
+{
+	if (likely(audit_mark))
+		fsnotify_get_mark(&audit_mark->mark);
+}
+
+static void audit_put_mark(struct audit_fsnotify_mark *audit_mark)
+{
+	if (likely(audit_mark))
+		fsnotify_put_mark(&audit_mark->mark);
+}
+#endif
+
+char *audit_mark_path(struct audit_fsnotify_mark *mark)
+{
+	return mark->path;
+}
+
+int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev)
+{
+	if (mark->ino == (unsigned long)-1)
+		return 0;
+	return (mark->ino == ino) && (mark->dev == dev);
+}
+
+struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pathname, int len)
+{
+	struct audit_fsnotify_mark *audit_mark;
+	struct path path;
+	struct dentry *dentry;
+	struct inode *inode;
+	unsigned long ino;
+	char *local_pathname;
+	dev_t dev;
+	int ret;
+
+	if (pathname[0] != '/' || pathname[len-1] == '/')
+		return ERR_PTR(-EINVAL);
+
+	dentry = kern_path_locked(pathname, &path);
+	if (IS_ERR(dentry))
+		return (void *)dentry; /* returning an error */
+	inode = path.dentry->d_inode;
+	mutex_unlock(&inode->i_mutex);
+
+	if (!dentry->d_inode) {
+		ino = (unsigned long)-1;
+		dev = (unsigned)-1;
+	} else {
+		dev = dentry->d_inode->i_sb->s_dev;
+		ino = dentry->d_inode->i_ino;
+	}
+
+	audit_mark = ERR_PTR(-ENOMEM);
+	local_pathname = kstrdup(pathname, GFP_KERNEL);
+	if (!local_pathname)
+		goto out;
+
+	audit_mark = kzalloc(sizeof(*audit_mark), GFP_KERNEL);
+	if (unlikely(!audit_mark)) {
+		kfree(local_pathname);
+		goto out;
+	}
+
+	fsnotify_init_mark(&audit_mark->mark, audit_free_fsnotify_mark);
+	audit_mark->mark.mask = AUDIT_FS_EVENTS;
+	audit_mark->path = local_pathname;
+	audit_mark->ino = ino;
+	audit_mark->dev = dev;
+	audit_mark->rule = krule;
+
+	ret = fsnotify_add_mark(&audit_mark->mark, audit_fsnotify_group, inode, NULL, true);
+	if (ret < 0) {
+		audit_free_mark(audit_mark);
+		audit_mark = ERR_PTR(ret);
+	}
+out:
+	dput(dentry);
+	path_put(&path);
+	return audit_mark;
+}
+
+static void audit_mark_log_rule_change(struct audit_fsnotify_mark *audit_mark, char *op)
+{
+	struct audit_buffer *ab;
+	struct audit_krule *rule = audit_mark->rule;
+	if (!audit_enabled)
+		return;
+	ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab, "auid=%u ses=%u op=",
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 audit_get_sessionid(current));
+	audit_log_string(ab, op);
+	audit_log_format(ab, " path=");
+	audit_log_untrustedstring(ab, audit_mark->path);
+	audit_log_key(ab, rule->filterkey);
+	audit_log_format(ab, " list=%d res=1", rule->listnr);
+	audit_log_end(ab);
+}
+
+static int audit_update_mark(struct audit_fsnotify_mark *audit_mark,
+			     struct inode *inode)
+{
+	if (inode) {
+		audit_mark->dev = inode->i_sb->s_dev;
+		audit_mark->ino = inode->i_ino;
+	} else {
+		audit_mark->dev = (unsigned)-1;
+		audit_mark->ino = (unsigned long)-1;
+	}
+	return 0;
+}
+
+void audit_remove_mark(struct audit_fsnotify_mark *audit_mark)
+{
+	fsnotify_destroy_mark(&audit_mark->mark, audit_fsnotify_group);
+	fsnotify_put_mark(&audit_mark->mark);
+}
+
+static void audit_remove_mark_rule(struct audit_fsnotify_mark *audit_mark)
+{
+	struct audit_krule *rule = audit_mark->rule;
+	struct audit_entry *entry = container_of(rule, struct audit_entry, rule);
+
+	audit_mark_log_rule_change(audit_mark, "remove_rule");
+	audit_del_rule(entry);
+}
+
+/* Update mark data in audit rules based on fsnotify events. */
+static int audit_mark_handle_event(struct fsnotify_group *group,
+				    struct inode *to_tell,
+				    struct fsnotify_mark *inode_mark,
+				    struct fsnotify_mark *vfsmount_mark,
+				    u32 mask, void *data, int data_type,
+				    const unsigned char *dname, u32 cookie)
+{
+	struct audit_fsnotify_mark *audit_mark;
+	struct inode *inode = NULL;
+
+	audit_mark = container_of(inode_mark, struct audit_fsnotify_mark, mark);
+
+	BUG_ON(group != audit_fsnotify_group);
+
+	switch (data_type) {
+	case (FSNOTIFY_EVENT_PATH):
+		inode = ((struct path *)data)->dentry->d_inode;
+		break;
+	case (FSNOTIFY_EVENT_INODE):
+		inode = (struct inode *)data;
+		break;
+	default:
+		BUG();
+		return 0;
+	};
+
+	if (mask & (FS_CREATE|FS_MOVED_TO|FS_DELETE|FS_MOVED_FROM)) {
+		if (audit_compare_dname_path(dname, audit_mark->path, AUDIT_NAME_FULL))
+			return 0;
+		audit_update_mark(audit_mark, inode);
+	} else if (mask & (FS_DELETE_SELF|FS_UNMOUNT|FS_MOVE_SELF))
+		audit_remove_mark_rule(audit_mark);
+
+	return 0;
+}
+
+static const struct fsnotify_ops audit_mark_fsnotify_ops = {
+	.handle_event =	audit_mark_handle_event,
+};
+
+static int __init audit_fsnotify_init(void)
+{
+	audit_fsnotify_group = fsnotify_alloc_group(&audit_mark_fsnotify_ops);
+	if (IS_ERR(audit_fsnotify_group)) {
+		audit_fsnotify_group = NULL;
+		audit_panic("cannot create audit fsnotify group");
+	}
+	return 0;
+}
+device_initcall(audit_fsnotify_init);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index d9da99e..9eb29c0 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -97,6 +97,8 @@ static inline void audit_free_rule(struct audit_entry *e)
 	/* some rules don't have associated watches */
 	if (erule->watch)
 		audit_put_watch(erule->watch);
+	if (erule->exe)
+		audit_remove_mark(erule->exe);
 	if (erule->fields)
 		for (i = 0; i < erule->field_count; i++)
 			audit_free_lsm_field(&erule->fields[i]);
@@ -985,7 +987,7 @@ error:
 }
 
 /* Remove an existing rule from filterlist. */
-static inline int audit_del_rule(struct audit_entry *entry)
+int audit_del_rule(struct audit_entry *entry)
 {
 	struct audit_entry  *e;
 	struct audit_tree *tree = entry->rule.tree;
@@ -993,6 +995,7 @@ static inline int audit_del_rule(struct audit_entry *entry)
 	int ret = 0;
 #ifdef CONFIG_AUDITSYSCALL
 	int dont_count = 0;
+	int match = audit_match_signal(entry);
 
 	/* If either of these, don't count towards total */
 	if (entry->rule.listnr == AUDIT_FILTER_USER ||
@@ -1014,9 +1017,6 @@ static inline int audit_del_rule(struct audit_entry *entry)
 	if (e->rule.tree)
 		audit_remove_tree_rule(&e->rule);
 
-	if (e->rule.exe)
-		audit_remove_exe_rule(&e->rule);
-
 	list_del_rcu(&e->list);
 	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
@@ -1025,7 +1025,7 @@ static inline int audit_del_rule(struct audit_entry *entry)
 	if (!dont_count)
 		audit_n_rules--;
 
-	if (!audit_match_signal(entry))
+	if (!match)
 		audit_signals--;
 #endif
 	mutex_unlock(&audit_filter_mutex);
-- 
1.7.1

