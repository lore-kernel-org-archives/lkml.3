Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3JaPiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab3JaPhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:37:54 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <onestero@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/4][v2] audit: call audit_bprm() only once to add AUDIT_EXECVE information
Date: Thu, 31 Oct 2013 11:37:12 -0400
Message-Id: <c44c50439dcf85d9024c96219a803c43bb23d036.1383233534.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
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
reference is necessary.

Reported-by: Oleg Nesterov <onestero@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/exec.c             |    5 +----
 include/linux/audit.h |    9 +++------
 kernel/audit.h        |    1 -
 kernel/auditsc.c      |    4 ----
 4 files changed, 4 insertions(+), 15 deletions(-)

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
index fffefbd..a757e6c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -236,11 +236,10 @@ static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid
 	if (unlikely(!audit_dummy_context()))
 		__audit_ipc_set_perm(qbytes, uid, gid, mode);
 }
-static inline int audit_bprm(struct linux_binprm *bprm)
+static inline void audit_bprm(struct linux_binprm *bprm)
 {
 	if (unlikely(!audit_dummy_context()))
 		__audit_bprm(bprm);
-	return 0;
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
index e7b94ab..b779642 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -199,7 +199,6 @@ struct audit_context {
 		} mmap;
 		struct {
 			int			argc;
-			struct mm_struct	*mm;
 		} execve;
 	};
 	int fds[2];
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index eabe76a..dc1adee 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1145,9 +1145,6 @@ static void audit_log_execve_info(struct audit_context *context,
 	const char __user *p;
 	char *buf;
 
-	if (context->execve.mm != current->mm)
-		return; /* execve failed, no additional info */
-
 	p = (const char __user *)current->mm->arg_start;
 
 	audit_log_format(*ab, "argc=%d", context->execve.argc);
@@ -2118,7 +2115,6 @@ void __audit_bprm(struct linux_binprm *bprm)
 
 	context->type = AUDIT_EXECVE;
 	context->execve.argc = bprm->argc;
-	context->execve.mm = bprm->mm;
 }
 
 
-- 
1.7.1

