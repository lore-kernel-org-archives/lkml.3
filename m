Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3JaPhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:37:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab3JaPhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:37:50 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <onestero@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4][v2] audit: move audit_aux_data_execve contents into audit_context union
Date: Thu, 31 Oct 2013 11:37:11 -0400
Message-Id: <fe3109595c2dac17a55650b084a3c911f9e98597.1383233534.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_bprm() was being called to add an AUDIT_EXECVE record to the audit
context every time search_binary_handler() was recursively called.  Only one
reference is necessary, so just update it.  Move the the contents of
audit_aux_data_execve into the union in audit_context, removing dependence on a
kmalloc along the way.

Reported-by: Oleg Nesterov <onestero@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    4 ++--
 kernel/audit.h        |    4 ++++
 kernel/auditsc.c      |   41 ++++++++++++-----------------------------
 3 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 729a4d1..fffefbd 100644
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
@@ -239,7 +239,7 @@ static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid
 static inline int audit_bprm(struct linux_binprm *bprm)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_bprm(bprm);
+		__audit_bprm(bprm);
 	return 0;
 }
 static inline int audit_socketcall(int nargs, unsigned long *args)
diff --git a/kernel/audit.h b/kernel/audit.h
index 123c9b7..e7b94ab 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -197,6 +197,10 @@ struct audit_context {
 			int			fd;
 			int			flags;
 		} mmap;
+		struct {
+			int			argc;
+			struct mm_struct	*mm;
+		} execve;
 	};
 	int fds[2];
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c9abaa0..eabe76a 100644
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
@@ -1144,20 +1138,19 @@ static int audit_log_single_execve_arg(struct audit_context *context,
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
+	if (context->execve.mm != current->mm)
 		return; /* execve failed, no additional info */
 
-	p = (const char __user *)axi->mm->arg_start;
+	p = (const char __user *)current->mm->arg_start;
 
-	audit_log_format(*ab, "argc=%d", axi->argc);
+	audit_log_format(*ab, "argc=%d", context->execve.argc);
 
 	/*
 	 * we need some kernel buffer to hold the userspace args.  Just
@@ -1171,7 +1164,7 @@ static void audit_log_execve_info(struct audit_context *context,
 		return;
 	}
 
-	for (i = 0; i < axi->argc; i++) {
+	for (i = 0; i < context->execve.argc; i++) {
 		len = audit_log_single_execve_arg(context, ab, i,
 						  &len_sent, p, buf);
 		if (len <= 0)
@@ -1274,6 +1267,9 @@ static void show_special(struct audit_context *context, int *call_panic)
 		audit_log_format(ab, "fd=%d flags=0x%x", context->mmap.fd,
 				 context->mmap.flags);
 		break; }
+	case AUDIT_EXECVE: {
+		audit_log_execve_info(context, &ab);
+		break; }
 	}
 	audit_log_end(ab);
 }
@@ -1320,11 +1316,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 		switch (aux->type) {
 
-		case AUDIT_EXECVE: {
-			struct audit_aux_data_execve *axi = (void *)aux;
-			audit_log_execve_info(context, &ab, axi);
-			break; }
-
 		case AUDIT_BPRM_FCAPS: {
 			struct audit_aux_data_bprm_fcaps *axs = (void *)aux;
 			audit_log_format(ab, "fver=%x", axs->fcap_ver);
@@ -2121,21 +2112,13 @@ void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mo
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
+	context->execve.mm = bprm->mm;
 }
 
 
-- 
1.7.1

