Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbbAUP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:56:16 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:57790 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbbAUPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:55:58 -0500
X-TM-IMSS-Message-ID: <13ad446600020357@nsa.gov>
From: Stephen Smalley <sds@tycho.nsa.gov>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, arve@android.com, nnk@google.com,
        paul@paul-moore.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH] Add security hooks to binder and implement the hooks for SELinux.
Date: Wed, 21 Jan 2015 10:54:10 -0500
Message-Id: <1421855650-22522-1-git-send-email-sds@tycho.nsa.gov>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add security hooks to the binder and implement the hooks for SELinux.
The security hooks enable security modules such as SELinux to implement
controls over binder IPC.  The security hooks include support for
controlling what process can become the binder context manager
(binder_set_context_mgr), controlling the ability of a process
to invoke a binder transaction/IPC to another process (binder_transaction),
controlling the ability of a process to transfer a binder reference to
another process (binder_transfer_binder), and controlling the ability
of a process to transfer an open file to another process (binder_transfer_file).

These hooks have been included in the Android kernel trees since Android 4.3.

(Updated to reflect upstream relocation and changes to the binder driver,
changes to the LSM audit data structures, coding style cleanups, and
to add inline documentation for the hooks).

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
---
 drivers/android/binder.c            | 26 +++++++++++++
 include/linux/security.h            | 58 +++++++++++++++++++++++++++++
 security/capability.c               | 27 ++++++++++++++
 security/security.c                 | 23 ++++++++++++
 security/selinux/hooks.c            | 73 +++++++++++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +
 6 files changed, 209 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 8c43521..33b09b6 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/pid_namespace.h>
+#include <linux/security.h>
 
 #ifdef CONFIG_ANDROID_BINDER_IPC_32BIT
 #define BINDER_IPC_32BIT 1
@@ -1400,6 +1401,11 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error = BR_DEAD_REPLY;
 			goto err_dead_binder;
 		}
+		if (security_binder_transaction(proc->tsk,
+						target_proc->tsk) < 0) {
+			return_error = BR_FAILED_REPLY;
+			goto err_invalid_target_handle;
+		}
 		if (!(tr->flags & TF_ONE_WAY) && thread->transaction_stack) {
 			struct binder_transaction *tmp;
 
@@ -1551,6 +1557,11 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_for_node_failed;
 			}
+			if (security_binder_transfer_binder(proc->tsk,
+							    target_proc->tsk)) {
+				return_error = BR_FAILED_REPLY;
+				goto err_binder_get_ref_for_node_failed;
+			}
 			ref = binder_get_ref_for_node(target_proc, node);
 			if (ref == NULL) {
 				return_error = BR_FAILED_REPLY;
@@ -1581,6 +1592,11 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_failed;
 			}
+			if (security_binder_transfer_binder(proc->tsk,
+							    target_proc->tsk)) {
+				return_error = BR_FAILED_REPLY;
+				goto err_binder_get_ref_failed;
+			}
 			if (ref->node->proc == target_proc) {
 				if (fp->type == BINDER_TYPE_HANDLE)
 					fp->type = BINDER_TYPE_BINDER;
@@ -1638,6 +1654,13 @@ static void binder_transaction(struct binder_proc *proc,
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
 			}
+			if (security_binder_transfer_file(proc->tsk,
+							  target_proc->tsk,
+							  file) < 0) {
+				fput(file);
+				return_error = BR_FAILED_REPLY;
+				goto err_get_unused_fd_failed;
+			}
 			target_fd = task_get_unused_fd_flags(target_proc, O_CLOEXEC);
 			if (target_fd < 0) {
 				fput(file);
@@ -2675,6 +2698,9 @@ static int binder_ioctl_set_ctx_mgr(struct file *filp)
 		ret = -EBUSY;
 		goto out;
 	}
+	ret = security_binder_set_context_mgr(proc->tsk);
+	if (ret < 0)
+		goto out;
 	if (uid_valid(binder_context_mgr_uid)) {
 		if (!uid_eq(binder_context_mgr_uid, curr_euid)) {
 			pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
diff --git a/include/linux/security.h b/include/linux/security.h
index ba96471..a1b7dbd 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1281,6 +1281,25 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@alter contains the flag indicating whether changes are to be made.
  *	Return 0 if permission is granted.
  *
+ * @binder_set_context_mgr
+ *	Check whether @mgr is allowed to be the binder context manager.
+ *	@mgr contains the task_struct for the task being registered.
+ *	Return 0 if permission is granted.
+ * @binder_transaction
+ *	Check whether @from is allowed to invoke a binder transaction call
+ *	to @to.
+ *	@from contains the task_struct for the sending task.
+ *	@to contains the task_struct for the receiving task.
+ * @binder_transfer_binder
+ *	Check whether @from is allowed to transfer a binder reference to @to.
+ *	@from contains the task_struct for the sending task.
+ *	@to contains the task_struct for the receiving task.
+ * @binder_transfer_file
+ *	Check whether @from is allowed to transfer @file to @to.
+ *	@from contains the task_struct for the sending task.
+ *	@file contains the struct file being transferred.
+ *	@to contains the task_struct for the receiving task.
+ *
  * @ptrace_access_check:
  *	Check permission before allowing the current process to trace the
  *	@child process.
@@ -1441,6 +1460,14 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
+	int (*binder_set_context_mgr) (struct task_struct *mgr);
+	int (*binder_transaction) (struct task_struct *from,
+				   struct task_struct *to);
+	int (*binder_transfer_binder) (struct task_struct *from,
+				       struct task_struct *to);
+	int (*binder_transfer_file) (struct task_struct *from,
+				     struct task_struct *to, struct file *file);
+
 	int (*ptrace_access_check) (struct task_struct *child, unsigned int mode);
 	int (*ptrace_traceme) (struct task_struct *parent);
 	int (*capget) (struct task_struct *target,
@@ -1739,6 +1766,13 @@ extern void __init security_fixup_ops(struct security_operations *ops);
 
 
 /* Security operations */
+int security_binder_set_context_mgr(struct task_struct *mgr);
+int security_binder_transaction(struct task_struct *from,
+				struct task_struct *to);
+int security_binder_transfer_binder(struct task_struct *from,
+				    struct task_struct *to);
+int security_binder_transfer_file(struct task_struct *from,
+				  struct task_struct *to, struct file *file);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
@@ -1927,6 +1961,30 @@ static inline int security_init(void)
 	return 0;
 }
 
+static inline int security_binder_set_context_mgr(struct task_struct *mgr)
+{
+	return 0;
+}
+
+static inline int security_binder_transaction(struct task_struct *from,
+					      struct task_struct *to)
+{
+	return 0;
+}
+
+static inline int security_binder_transfer_binder(struct task_struct *from,
+						  struct task_struct *to)
+{
+	return 0;
+}
+
+static inline int security_binder_transfer_file(struct task_struct *from,
+						struct task_struct *to,
+						struct file *file)
+{
+	return 0;
+}
+
 static inline int security_ptrace_access_check(struct task_struct *child,
 					     unsigned int mode)
 {
diff --git a/security/capability.c b/security/capability.c
index d68c57a..070dd46 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -12,6 +12,29 @@
 
 #include <linux/security.h>
 
+static int cap_binder_set_context_mgr(struct task_struct *mgr)
+{
+	return 0;
+}
+
+static int cap_binder_transaction(struct task_struct *from,
+				  struct task_struct *to)
+{
+	return 0;
+}
+
+static int cap_binder_transfer_binder(struct task_struct *from,
+				      struct task_struct *to)
+{
+	return 0;
+}
+
+static int cap_binder_transfer_file(struct task_struct *from,
+				    struct task_struct *to, struct file *file)
+{
+	return 0;
+}
+
 static int cap_syslog(int type)
 {
 	return 0;
@@ -930,6 +953,10 @@ static void cap_audit_rule_free(void *lsmrule)
 
 void __init security_fixup_ops(struct security_operations *ops)
 {
+	set_to_cap_if_null(ops, binder_set_context_mgr);
+	set_to_cap_if_null(ops, binder_transaction);
+	set_to_cap_if_null(ops, binder_transfer_binder);
+	set_to_cap_if_null(ops, binder_transfer_file);
 	set_to_cap_if_null(ops, ptrace_access_check);
 	set_to_cap_if_null(ops, ptrace_traceme);
 	set_to_cap_if_null(ops, capget);
diff --git a/security/security.c b/security/security.c
index 18b35c6..b196de3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -135,6 +135,29 @@ int __init register_security(struct security_operations *ops)
 
 /* Security operations */
 
+int security_binder_set_context_mgr(struct task_struct *mgr)
+{
+	return security_ops->binder_set_context_mgr(mgr);
+}
+
+int security_binder_transaction(struct task_struct *from,
+				struct task_struct *to)
+{
+	return security_ops->binder_transaction(from, to);
+}
+
+int security_binder_transfer_binder(struct task_struct *from,
+				    struct task_struct *to)
+{
+	return security_ops->binder_transfer_binder(from, to);
+}
+
+int security_binder_transfer_file(struct task_struct *from,
+				  struct task_struct *to, struct file *file)
+{
+	return security_ops->binder_transfer_file(from, to, file);
+}
+
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 #ifdef CONFIG_SECURITY_YAMA_STACKED
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6da7532..9d984bf 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1933,6 +1933,74 @@ static inline u32 open_file_to_av(struct file *file)
 
 /* Hook functions begin here. */
 
+static int selinux_binder_set_context_mgr(struct task_struct *mgr)
+{
+	u32 mysid = current_sid();
+	u32 mgrsid = task_sid(mgr);
+
+	return avc_has_perm(mysid, mgrsid, SECCLASS_BINDER,
+			    BINDER__SET_CONTEXT_MGR, NULL);
+}
+
+static int selinux_binder_transaction(struct task_struct *from,
+				      struct task_struct *to)
+{
+	u32 mysid = current_sid();
+	u32 fromsid = task_sid(from);
+	u32 tosid = task_sid(to);
+	int rc;
+
+	if (mysid != fromsid) {
+		rc = avc_has_perm(mysid, fromsid, SECCLASS_BINDER,
+				  BINDER__IMPERSONATE, NULL);
+		if (rc)
+			return rc;
+	}
+
+	return avc_has_perm(fromsid, tosid, SECCLASS_BINDER, BINDER__CALL,
+			    NULL);
+}
+
+static int selinux_binder_transfer_binder(struct task_struct *from,
+					  struct task_struct *to)
+{
+	u32 fromsid = task_sid(from);
+	u32 tosid = task_sid(to);
+
+	return avc_has_perm(fromsid, tosid, SECCLASS_BINDER, BINDER__TRANSFER,
+			    NULL);
+}
+
+static int selinux_binder_transfer_file(struct task_struct *from,
+					struct task_struct *to,
+					struct file *file)
+{
+	u32 sid = task_sid(to);
+	struct file_security_struct *fsec = file->f_security;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode_security_struct *isec = inode->i_security;
+	struct common_audit_data ad;
+	int rc;
+
+	ad.type = LSM_AUDIT_DATA_PATH;
+	ad.u.path = file->f_path;
+
+	if (sid != fsec->sid) {
+		rc = avc_has_perm(sid, fsec->sid,
+				  SECCLASS_FD,
+				  FD__USE,
+				  &ad);
+		if (rc)
+			return rc;
+	}
+
+	if (unlikely(IS_PRIVATE(inode)))
+		return 0;
+
+	return avc_has_perm(sid, isec->sid, isec->sclass, file_to_av(file),
+			    &ad);
+}
+
 static int selinux_ptrace_access_check(struct task_struct *child,
 				     unsigned int mode)
 {
@@ -5810,6 +5878,11 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 static struct security_operations selinux_ops = {
 	.name =				"selinux",
 
+	.binder_set_context_mgr =	selinux_binder_set_context_mgr,
+	.binder_transaction =		selinux_binder_transaction,
+	.binder_transfer_binder =	selinux_binder_transfer_binder,
+	.binder_transfer_file =		selinux_binder_transfer_file,
+
 	.ptrace_access_check =		selinux_ptrace_access_check,
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index be491a7..eccd61b 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -151,5 +151,7 @@ struct security_class_mapping secclass_map[] = {
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, "attach_queue", NULL } },
+	{ "binder", { "impersonate", "call", "set_context_mgr", "transfer",
+		      NULL } },
 	{ NULL }
   };
-- 
1.9.3

