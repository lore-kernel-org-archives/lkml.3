Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaJCDHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 23:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaJCDH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 23:07:28 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, sgrubb@redhat.com, aviro@redhat.com,
        pmoore@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH V5 3/5] audit: convert audit_exe to audit_fsnotify
Date: Thu,  2 Oct 2014 23:06:54 -0400
Message-Id: <7e5a93dc4487984762f74ed5659eeff8bd4a3494.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
In-Reply-To: <cover.1412303728.git.rgb@redhat.com>
References: <cover.1412303728.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Instead of just hard coding the ino and dev of the executable we care
about at the moment the rule is inserted into the kernel, use the new
audit_fsnotify infrastructure.  This means that if the inode in question
is unlinked and creat'd (aka updated) the rule will just continue to
work.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    2 +-
 kernel/audit.h        |   32 +++---------------
 kernel/audit_exe.c    |   87 +++++++------------------------------------------
 kernel/auditfilter.c  |   15 +++++---
 4 files changed, 27 insertions(+), 109 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index ce51204..0ffa268 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -59,7 +59,7 @@ struct audit_krule {
 	struct audit_field	*inode_f; /* quick access to an inode field */
 	struct audit_watch	*watch;	/* associated watch */
 	struct audit_tree	*tree;	/* associated watched tree */
-	struct audit_exe	*exe;
+	struct audit_fsnotify_mark	*exe;
 	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
 	struct list_head	list;	/* for AUDIT_LIST* purposes only */
 	u64			prio;
diff --git a/kernel/audit.h b/kernel/audit.h
index b8ecc06..9821732 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -57,7 +57,6 @@ enum audit_state {
 /* Rule lists */
 struct audit_watch;
 struct audit_fsnotify_mark;
-struct audit_exe;
 struct audit_tree;
 struct audit_chunk;
 
@@ -288,11 +287,8 @@ char *audit_mark_path(struct audit_fsnotify_mark *mark);
 void audit_remove_mark(struct audit_fsnotify_mark *audit_mark);
 int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev);
 
-int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op);
-void audit_remove_exe_rule(struct audit_krule *krule);
-char *audit_exe_path(struct audit_exe *exe);
 int audit_dup_exe(struct audit_krule *new, struct audit_krule *old);
-int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe);
+int audit_exe_compare(struct task_struct *tsk, struct audit_fsnotify_mark *mark);
 
 #else
 #define audit_put_watch(w) {}
@@ -319,36 +315,18 @@ static inline void audit_remove_mark(struct audit_fsnotify_mark *audit_mark)
 	BUG();
 }
 
-static inline int audit_mark_compare(struct audit_fsnotify_mark *mark, unsigned long ino, dev_t dev)
+static inline int audit_exe_compare(struct task_struct *tsk, struct audit_fsnotify_mark *mark)
 {
 	BUG();
-	return 0;
-}
-
-static inline int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op)
-{
 	return -EINVAL;
 }
-static inline void audit_remove_exe_rule(struct audit_krule *krule)
-{
-	BUG();
-	return 0;
-}
-static inline char *audit_exe_path(struct audit_exe *exe)
-{
-	BUG();
-	return "";
-}
+
 static inline int audit_dup_exe(struct audit_krule *new, struct audit_krule *old)
 {
 	BUG();
-	return -EINVAL
-}
-static inline int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe)
-{
-	BUG();
-	return 0;
+	return -EINVAL;
 }
+
 #endif /* CONFIG_AUDIT_WATCH */
 
 #ifdef CONFIG_AUDIT_TREE
diff --git a/kernel/audit_exe.c b/kernel/audit_exe.c
index ec3231b..0c7ee8d 100644
--- a/kernel/audit_exe.c
+++ b/kernel/audit_exe.c
@@ -17,93 +17,30 @@
 
 #include <linux/kernel.h>
 #include <linux/audit.h>
-#include <linux/mutex.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
 #include "audit.h"
 
-struct audit_exe {
-	char *pathname;
-	unsigned long ino;
-	dev_t dev;
-};
-
-/* Translate a watch string to kernel respresentation. */
-int audit_make_exe_rule(struct audit_krule *krule, char *pathname, int len, u32 op)
-{
-	struct audit_exe *exe;
-	struct path path;
-	struct dentry *dentry;
-	unsigned long ino;
-	dev_t dev;
-
-	if (pathname[0] != '/' || pathname[len-1] == '/')
-		return -EINVAL;
-
-	dentry = kern_path_locked(pathname, &path);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	mutex_unlock(&path.dentry->d_inode->i_mutex);
-
-	if (!dentry->d_inode)
-		return -ENOENT;
-	dev = dentry->d_inode->i_sb->s_dev;
-	ino = dentry->d_inode->i_ino;
-	dput(dentry);
-
-	exe = kmalloc(sizeof(*exe), GFP_KERNEL);
-	if (!exe)
-		return -ENOMEM;
-	exe->ino = ino;
-	exe->dev = dev;
-	exe->pathname = pathname;
-	krule->exe = exe;
-
-	return 0;
-}
-
-void audit_remove_exe_rule(struct audit_krule *krule)
-{
-	struct audit_exe *exe;
-
-	exe = krule->exe;
-	krule->exe = NULL;
-	kfree(exe->pathname);
-	kfree(exe);
-}
-
-char *audit_exe_path(struct audit_exe *exe)
-{
-	return exe->pathname;
-}
-
 int audit_dup_exe(struct audit_krule *new, struct audit_krule *old)
 {
-	struct audit_exe *exe;
-
-	exe = kmalloc(sizeof(*exe), GFP_KERNEL);
-	if (!exe)
-		return -ENOMEM;
+	struct audit_fsnotify_mark *audit_mark;
+	char *pathname;
 
-	exe->pathname = kstrdup(old->exe->pathname, GFP_KERNEL);
-	if (!exe->pathname) {
-		kfree(exe);
-		return -ENOMEM;
-	}
+	pathname = audit_mark_path(old->exe);
 
-	exe->ino = old->exe->ino;
-	exe->dev = old->exe->dev;
-	new->exe = exe;
+	audit_mark = audit_alloc_mark(new, pathname, strlen(pathname));
+	if (IS_ERR(audit_mark))
+		return PTR_ERR(audit_mark);
+	new->exe = audit_mark;
 
 	return 0;
 }
 
-int audit_exe_compare(struct task_struct *tsk, struct audit_exe *exe)
+int audit_exe_compare(struct task_struct *tsk, struct audit_fsnotify_mark *mark)
 {
-	if (tsk->mm->exe_file->f_inode->i_ino != exe->ino)
-		return 0;
-	if (tsk->mm->exe_file->f_inode->i_sb->s_dev != exe->dev)
-		return 0;
-	return 1;
+	unsigned long ino = tsk->mm->exe_file->f_inode->i_ino;
+	dev_t dev = tsk->mm->exe_file->f_inode->i_sb->s_dev;
+
+	return audit_mark_compare(mark, ino, dev);
 }
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 9eb29c0..fff92cf 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -428,6 +428,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 	size_t remain = datasz - sizeof(struct audit_rule_data);
 	int i;
 	char *str;
+	struct audit_fsnotify_mark *audit_mark;
 
 	entry = audit_to_entry_common(data);
 	if (IS_ERR(entry))
@@ -573,11 +574,13 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			}
 			entry->rule.buflen += f->val;
 
-			err = audit_make_exe_rule(&entry->rule, str, f->val, f->op);
-			if (err) {
-				kfree(str);
+			audit_mark = audit_alloc_mark(&entry->rule, str, f->val);
+			kfree(str);
+			if (IS_ERR(audit_mark)) {
+				err = PTR_ERR(audit_mark);
 				goto exit_free;
 			}
+			entry->rule.exe = audit_mark;
 			break;
 		}
 	}
@@ -658,7 +661,7 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 		case AUDIT_EXE:
 		case AUDIT_EXE_CHILDREN:
 			data->buflen += data->values[i] =
-				audit_pack_string(&bufp, audit_exe_path(krule->exe));
+				audit_pack_string(&bufp, audit_mark_path(krule->exe));
 			break;
 		default:
 			data->values[i] = f->val;
@@ -718,8 +721,8 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 		case AUDIT_EXE:
 		case AUDIT_EXE_CHILDREN:
 			/* both paths exist based on above type compare */
-			if (strcmp(audit_exe_path(a->exe),
-				   audit_exe_path(b->exe)))
+			if (strcmp(audit_mark_path(a->exe),
+				   audit_mark_path(b->exe)))
 				return 1;
 			break;
 		case AUDIT_UID:
-- 
1.7.1

