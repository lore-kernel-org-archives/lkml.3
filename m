Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3J3UZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:25:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3J3UZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:25:06 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <onestero@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] audit: call audit_bprm() only once to add AUDIT_EXECVE information
Date: Wed, 30 Oct 2013 16:24:27 -0400
Message-Id: <cec3720007cb5fe30f4677d89e6ee52f50e62b45.1383162177.git.rgb@redhat.com>
In-Reply-To: <cover.1383162177.git.rgb@redhat.com>
References: <cover.1383162177.git.rgb@redhat.com>
In-Reply-To: <cover.1383162177.git.rgb@redhat.com>
References: <cover.1383162177.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the audit_bprm() call from search_binary_handler() to exec_binprm().  This
allows us to get rid of the mm member of struct audit_aux_data_execve since
bprm->mm will equal current->mm.

This also mitigates the issue that ->argc could be modified by the
load_binary() call in search_binary_handler().

audit_bprm() was being called to add an AUDIT_EXECVE record to the audit
context every time search_binary_handler() was recursively called.  Only one
reference is necessary.  Merge the remaining argc parameter into the union in
audit_context, removing a kmalloc.

Reported-by: Oleg Nesterov <onestero@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/exec.c             |    5 +----
 include/linux/audit.h |   13 +++++--------
 kernel/audit.h        |    3 +++
 kernel/auditsc.c      |   41 ++++++++++-------------------------------
 4 files changed, 19 insertions(+), 43 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8875dd1..47d7edb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1385,10 +1385,6 @@ int search_binary_handler(struct linux_binprm *bprm)
 	if (retval)
 		return retval;
 
-	retval = audit_bprm(bprm);
-	if (retval)
-		return retval;
-
 	retval = -ENOENT;
  retry:
 	read_lock(&binfmt_lock);
@@ -1436,6 +1432,7 @@ static int exec_binprm(struct linux_binprm *bprm)
 
 	ret = search_binary_handler(bprm);
 	if (ret >= 0) {
+		audit_bprm(bprm);
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 729a4d1..a757e6c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -207,7 +207,7 @@ static inline int audit_get_sessionid(struct task_struct *tsk)
 
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode);
-extern int __audit_bprm(struct linux_binprm *bprm);
+extern void __audit_bprm(struct linux_binprm *bprm);
 extern int __audit_socketcall(int nargs, unsigned long *args);
 extern int __audit_sockaddr(int len, void *addr);
 extern void __audit_fd_pair(int fd1, int fd2);
@@ -236,11 +236,10 @@ static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid
 	if (unlikely(!audit_dummy_context()))
 		__audit_ipc_set_perm(qbytes, uid, gid, mode);
 }
-static inline int audit_bprm(struct linux_binprm *bprm)
+static inline void audit_bprm(struct linux_binprm *bprm)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_bprm(bprm);
-	return 0;
+		__audit_bprm(bprm);
 }
 static inline int audit_socketcall(int nargs, unsigned long *args)
 {
@@ -367,10 +366,8 @@ static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid,
 					gid_t gid, umode_t mode)
 { }
-static inline int audit_bprm(struct linux_binprm *bprm)
-{
-	return 0;
-}
+static inline void audit_bprm(struct linux_binprm *bprm)
+{ }
 static inline int audit_socketcall(int nargs, unsigned long *args)
 {
 	return 0;
diff --git a/kernel/audit.h b/kernel/audit.h
index 123c9b7..b779642 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -197,6 +197,9 @@ struct audit_context {
 			int			fd;
 			int			flags;
 		} mmap;
+		struct {
+			int			argc;
+		} execve;
 	};
 	int fds[2];
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c9abaa0..dc1adee 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -95,12 +95,6 @@ struct audit_aux_data {
 /* Number of target pids per aux struct. */
 #define AUDIT_AUX_PIDS	16
 
-struct audit_aux_data_execve {
-	struct audit_aux_data	d;
-	int argc;
-	struct mm_struct *mm;
-};
-
 struct audit_aux_data_pids {
 	struct audit_aux_data	d;
 	pid_t			target_pid[AUDIT_AUX_PIDS];
@@ -1144,20 +1138,16 @@ static int audit_log_single_execve_arg(struct audit_context *context,
 }
 
 static void audit_log_execve_info(struct audit_context *context,
-				  struct audit_buffer **ab,
-				  struct audit_aux_data_execve *axi)
+				  struct audit_buffer **ab)
 {
 	int i, len;
 	size_t len_sent = 0;
 	const char __user *p;
 	char *buf;
 
-	if (axi->mm != current->mm)
-		return; /* execve failed, no additional info */
-
-	p = (const char __user *)axi->mm->arg_start;
+	p = (const char __user *)current->mm->arg_start;
 
-	audit_log_format(*ab, "argc=%d", axi->argc);
+	audit_log_format(*ab, "argc=%d", context->execve.argc);
 
 	/*
 	 * we need some kernel buffer to hold the userspace args.  Just
@@ -1171,7 +1161,7 @@ static void audit_log_execve_info(struct audit_context *context,
 		return;
 	}
 
-	for (i = 0; i < axi->argc; i++) {
+	for (i = 0; i < context->execve.argc; i++) {
 		len = audit_log_single_execve_arg(context, ab, i,
 						  &len_sent, p, buf);
 		if (len <= 0)
@@ -1274,6 +1264,9 @@ static void show_special(struct audit_context *context, int *call_panic)
 		audit_log_format(ab, "fd=%d flags=0x%x", context->mmap.fd,
 				 context->mmap.flags);
 		break; }
+	case AUDIT_EXECVE: {
+		audit_log_execve_info(context, &ab);
+		break; }
 	}
 	audit_log_end(ab);
 }
@@ -1320,11 +1313,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 		switch (aux->type) {
 
-		case AUDIT_EXECVE: {
-			struct audit_aux_data_execve *axi = (void *)aux;
-			audit_log_execve_info(context, &ab, axi);
-			break; }
-
 		case AUDIT_BPRM_FCAPS: {
 			struct audit_aux_data_bprm_fcaps *axs = (void *)aux;
 			audit_log_format(ab, "fver=%x", axs->fcap_ver);
@@ -2121,21 +2109,12 @@ void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mo
 	context->ipc.has_perm = 1;
 }
 
-int __audit_bprm(struct linux_binprm *bprm)
+void __audit_bprm(struct linux_binprm *bprm)
 {
-	struct audit_aux_data_execve *ax;
 	struct audit_context *context = current->audit_context;
 
-	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
-	if (!ax)
-		return -ENOMEM;
-
-	ax->argc = bprm->argc;
-	ax->mm = bprm->mm;
-	ax->d.type = AUDIT_EXECVE;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->type = AUDIT_EXECVE;
+	context->execve.argc = bprm->argc;
 }
 
 
-- 
1.7.1

