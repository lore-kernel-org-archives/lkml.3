Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaJCDHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 23:07:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaJCDH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 23:07:27 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, sgrubb@redhat.com, aviro@redhat.com,
        pmoore@redhat.com, rgb@redhat.com, pmoody@google.com
Subject: [PATCH V5 1/5] audit: implement audit by executable
Date: Thu,  2 Oct 2014 23:06:52 -0400
Message-Id: <3182e856965b97fa1c8b3d4c8e3fb552c3906f78.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

This patch implements the ability to filter on the executable.  It is
clearly incomplete!  This patch adds the inode/dev of the executable at
the moment the rule is loaded.  It does not update if the executable is
updated/moved/whatever.  That should be added.  But at this moment, this
patch works.

Based-on-user-interface-by: Richard Guy Briggs <rgb@redhat.com>
Cc: rgb@redhat.com
Based-on-idea-by: Peter Moody <pmoody@google.com>
Cc: pmoody@google.com
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h      |    1 +
 include/uapi/linux/audit.h |    2 +
 kernel/Makefile            |    2 +-
 kernel/audit.h             |   32 +++++++++++++
 kernel/audit_exe.c         |  109 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditfilter.c       |   44 ++++++++++++++++++
 kernel/auditsc.c           |   16 ++++++
 7 files changed, 205 insertions(+), 1 deletions(-)
 create mode 100644 kernel/audit_exe.c

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 36dffec..ce51204 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -59,6 +59,7 @@ struct audit_krule {
 	struct audit_field	*inode_f; /* quick access to an inode field */
 	struct audit_watch	*watch;	/* associated watch */
 	struct audit_tree	*tree;	/* associated watched tree */
+	struct audit_exe	*exe;
 	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
 	struct list_head	list;	/* for AUDIT_LIST* purposes only */
 	u64			prio;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 4d100c8..101d344 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -266,6 +266,8 @@
 #define AUDIT_OBJ_UID	109
 #define AUDIT_OBJ_GID	110
 #define AUDIT_FIELD_COMPARE	111
+#define AUDIT_EXE	112
+#define AUDIT_EXE_CHILDREN	113
 
 #define AUDIT_ARG0      200
 #define AUDIT_ARG1      (AUDIT_ARG0+1)
diff --git a/kernel/Makefile b/kernel/Makefile
index f2a8b62..60def04 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -63,7 +63,7 @@ obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
-obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o
+obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o audit_exe.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_KPROBES) += kprobes.o
diff --git a/kernel/audit.h b/kernel/audit.h
index 3cdffad..7825c7e 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -56,6 +56,7 @@ enum audit_state {
 
 /* Rule lists */
 struct audit_watch;
+struct audit_exe;
 struct audit_tree;
 struct audit_chunk;
 
@@ -279,6 +280,13 @@ extern int audit_add_watch(struct audit_krule *krule, struct list_head **list);
 extern void audit_remove_watch_rule(struct audit_krule *krule);
 extern char *audit_watch_path(struct audit_watch *watch);
 extern int audit_watch_compare(struct audit_watch *watch, unsigned long ino, dev_t dev);
+
+int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op);
+void audit_remove_exe_rule(struct audit_krule *krule);
+char *audit_exe_path(struct audit_exe *exe);
+int audit_dup_exe(struct audit_krule *new, struct audit_krule *old);
+int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe);
+
 #else
 #define audit_put_watch(w) {}
 #define audit_get_watch(w) {}
@@ -288,6 +296,30 @@ extern int audit_watch_compare(struct audit_watch *watch, unsigned long ino, dev
 #define audit_watch_path(w) ""
 #define audit_watch_compare(w, i, d) 0
 
+static inline int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op)
+{
+	return -EINVAL;
+}
+static inline void audit_remove_exe_rule(struct audit_krule *krule)
+{
+	BUG();
+	return 0;
+}
+static inline char *audit_exe_path(struct audit_exe *exe)
+{
+	BUG();
+	return "";
+}
+static inline int audit_dup_exe(struct audit_krule *new, struct audit_krule *old)
+{
+	BUG();
+	return -EINVAL
+}
+static inline int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe)
+{
+	BUG();
+	return 0;
+}
 #endif /* CONFIG_AUDIT_WATCH */
 
 #ifdef CONFIG_AUDIT_TREE
diff --git a/kernel/audit_exe.c b/kernel/audit_exe.c
new file mode 100644
index 0000000..ec3231b
--- /dev/null
+++ b/kernel/audit_exe.c
@@ -0,0 +1,109 @@
+/* audit_exe.c -- filtering of audit events
+ *
+ * Copyright 2014 Red Hat, Inc.
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/audit.h>
+#include <linux/mutex.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/slab.h>
+#include "audit.h"
+
+struct audit_exe {
+	char *pathname;
+	unsigned long ino;
+	dev_t dev;
+};
+
+/* Translate a watch string to kernel respresentation. */
+int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op)
+{
+	struct audit_exe *exe;
+	struct path path;
+	struct dentry *dentry;
+	unsigned long ino;
+	dev_t dev;
+
+	if (pathname[0] != '/' || pathname[len-1] == '/')
+		return -EINVAL;
+
+	dentry = kern_path_locked(pathname, &path);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	mutex_unlock(&path.dentry->d_inode->i_mutex);
+
+	if (!dentry->d_inode)
+		return -ENOENT;
+	dev = dentry->d_inode->i_sb->s_dev;
+	ino = dentry->d_inode->i_ino;
+	dput(dentry);
+
+	exe = kmalloc(sizeof(*exe), GFP_KERNEL);
+	if (!exe)
+		return -ENOMEM;
+	exe->ino = ino;
+	exe->dev = dev;
+	exe->pathname = pathname;
+	krule->exe = exe;
+
+	return 0;
+}
+
+void audit_remove_exe_rule(struct audit_krule *krule)
+{
+	struct audit_exe *exe;
+
+	exe = krule->exe;
+	krule->exe = NULL;
+	kfree(exe->pathname);
+	kfree(exe);
+}
+
+char *audit_exe_path(struct audit_exe *exe)
+{
+	return exe->pathname;
+}
+
+int audit_dup_exe(struct audit_krule *new, struct audit_krule *old)
+{
+	struct audit_exe *exe;
+
+	exe = kmalloc(sizeof(*exe), GFP_KERNEL);
+	if (!exe)
+		return -ENOMEM;
+
+	exe->pathname = kstrdup(old->exe->pathname, GFP_KERNEL);
+	if (!exe->pathname) {
+		kfree(exe);
+		return -ENOMEM;
+	}
+
+	exe->ino = old->exe->ino;
+	exe->dev = old->exe->dev;
+	new->exe = exe;
+
+	return 0;
+}
+
+int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe)
+{
+	if (tsk->mm->exe_file->f_inode->i_ino != exe->ino)
+		return 0;
+	if (tsk->mm->exe_file->f_inode->i_sb->s_dev != exe->dev)
+		return 0;
+	return 1;
+}
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 5675916..d9da99e 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -405,6 +405,13 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
 		if (f->val > AUDIT_MAX_FIELD_COMPARE)
 			return -EINVAL;
 		break;
+	case AUDIT_EXE:
+	case AUDIT_EXE_CHILDREN:
+		if (f->op != Audit_equal)
+			return -EINVAL;
+		if (entry->rule.listnr != AUDIT_FILTER_EXIT)
+			return -EINVAL;
+		break;
 	};
 	return 0;
 }
@@ -553,6 +560,23 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			entry->rule.buflen += f->val;
 			entry->rule.filterkey = str;
 			break;
+		case AUDIT_EXE:
+		case AUDIT_EXE_CHILDREN:
+			if (entry->rule.exe || f->val > PATH_MAX)
+				goto exit_free;
+			str = audit_unpack_string(&bufp, &remain, f->val);
+			if (IS_ERR(str)) {
+				err = PTR_ERR(str);
+				goto exit_free;
+			}
+			entry->rule.buflen += f->val;
+
+			err = audit_make_exe_rule(&entry->rule, str, f->val, f->op);
+			if (err) {
+				kfree(str);
+				goto exit_free;
+			}
+			break;
 		}
 	}
 
@@ -629,6 +653,11 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 			data->buflen += data->values[i] =
 				audit_pack_string(&bufp, krule->filterkey);
 			break;
+		case AUDIT_EXE:
+		case AUDIT_EXE_CHILDREN:
+			data->buflen += data->values[i] =
+				audit_pack_string(&bufp, audit_exe_path(krule->exe));
+			break;
 		default:
 			data->values[i] = f->val;
 		}
@@ -684,6 +713,13 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 			if (strcmp(a->filterkey, b->filterkey))
 				return 1;
 			break;
+		case AUDIT_EXE:
+		case AUDIT_EXE_CHILDREN:
+			/* both paths exist based on above type compare */
+			if (strcmp(audit_exe_path(a->exe),
+				   audit_exe_path(b->exe)))
+				return 1;
+			break;
 		case AUDIT_UID:
 		case AUDIT_EUID:
 		case AUDIT_SUID:
@@ -805,6 +841,11 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 				err = -ENOMEM;
 			else
 				new->filterkey = fk;
+			break;
+		case AUDIT_EXE:
+		case AUDIT_EXE_CHILDREN:
+			err = audit_dup_exe(new, old);
+			break;
 		}
 		if (err) {
 			audit_free_rule(entry);
@@ -973,6 +1014,9 @@ static inline int audit_del_rule(struct audit_entry *entry)
 	if (e->rule.tree)
 		audit_remove_tree_rule(&e->rule);
 
+	if (e->rule.exe)
+		audit_remove_exe_rule(&e->rule);
+
 	list_del_rcu(&e->list);
 	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8933572..9460336 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -48,6 +48,7 @@
 #include <asm/types.h>
 #include <linux/atomic.h>
 #include <linux/fs.h>
+#include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/mm.h>
 #include <linux/export.h>
@@ -71,6 +72,7 @@
 #include <linux/capability.h>
 #include <linux/fs_struct.h>
 #include <linux/compat.h>
+#include <linux/sched.h>
 #include <linux/ctype.h>
 
 #include "audit.h"
@@ -464,6 +466,20 @@ static int audit_filter_rules(struct task_struct *tsk,
 				result = audit_comparator(ctx->ppid, f->op, f->val);
 			}
 			break;
+		case AUDIT_EXE:
+			result = audit_exe_compare(tsk, rule->exe);
+			break;
+		case AUDIT_EXE_CHILDREN:
+		{
+			struct task_struct *ptsk;
+			for (ptsk = tsk; ptsk->parent->pid > 0; ptsk = find_task_by_vpid(ptsk->parent->pid)) {
+				if (audit_exe_compare(ptsk, rule->exe)) {
+					++result;
+					break;
+				}
+			}
+		}
+			break;
 		case AUDIT_UID:
 			result = audit_uid_comparator(cred->uid, f->op, f->uid);
 			break;
-- 
1.7.1

