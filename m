Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaDQSHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:07:52 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60670 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbaDQSF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:05:29 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 2/3] seccomp: move no_new_privs into seccomp
Date: Thu, 17 Apr 2014 11:05:03 -0700
Message-Id: <1397757904-30665-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397757904-30665-1-git-send-email-keescook@chromium.org>
References: <1397757904-30665-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since seccomp transitions between threads requires updates to the
no_new_privs flag to be atomic, this creates accessors for it. In the
case of seccomp being built into the kernel, the flag is moved it into
seccomp struct where it can be updated safely.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c                  |    4 ++--
 include/linux/sched.h      |   22 ++++++++++++++++++++++
 include/linux/seccomp.h    |    4 ++++
 kernel/seccomp.c           |    2 +-
 kernel/sys.c               |    4 ++--
 security/apparmor/domain.c |    4 ++--
 6 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 476f3ebf437e..c72f9f6f66f3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1233,7 +1233,7 @@ static void check_unsafe_exec(struct linux_binprm *bprm)
 	 * This isn't strictly necessary, but it makes it harder for LSMs to
 	 * mess up.
 	 */
-	if (current->no_new_privs)
+	if (task_no_new_privs(current))
 		bprm->unsafe |= LSM_UNSAFE_NO_NEW_PRIVS;
 
 	t = p;
@@ -1271,7 +1271,7 @@ int prepare_binprm(struct linux_binprm *bprm)
 	bprm->cred->egid = current_egid();
 
 	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
-	    !current->no_new_privs &&
+	    !task_no_new_privs(current) &&
 	    kuid_has_mapping(bprm->cred->user_ns, inode->i_uid) &&
 	    kgid_has_mapping(bprm->cred->user_ns, inode->i_gid)) {
 		/* Set-uid? */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50a21e527eb2..cd8e59bb62a5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1259,8 +1259,10 @@ struct task_struct {
 				 * execve */
 	unsigned in_iowait:1;
 
+#ifndef CONFIG_SECCOMP
 	/* task may not gain privileges */
 	unsigned no_new_privs:1;
+#endif
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
@@ -2493,9 +2495,29 @@ static inline void seccomp_unlock(struct task_struct *p)
 {
 	spin_unlock(&p->seccomp.lock);
 }
+
+static inline bool task_no_new_privs(struct task_struct *p)
+{
+	return test_bit(SECCOMP_FLAG_NO_NEW_PRIVS, &p->seccomp.flags);
+}
+
+static inline int task_set_no_new_privs(struct task_struct *p)
+{
+	set_bit(SECCOMP_FLAG_NO_NEW_PRIVS, &p->seccomp.flags);
+	return 0;
+}
 #else
 static inline void seccomp_lock(struct task_struct *p) { }
 static inline void seccomp_unlock(struct task_struct *p) { }
+static inline bool task_no_new_privs(struct task_struct *p)
+{
+	return p->no_new_privs;
+}
+static inline int task_set_no_new_privs(struct task_struct *p)
+{
+	p->no_new_privs = 1;
+	return 0;
+}
 #endif
 
 extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index c47be00e8ffb..d05f1f1b8b10 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -17,6 +17,7 @@ struct seccomp_filter;
  * @lock:  held when making changes to avoid thread races.
  * @filter: must always point to a valid seccomp-filter or NULL as it is
  *          accessed without locking during system call entry.
+ * @flags: flags under write lock
  *
  *          @filter must only be accessed from the context of current as there
  *          is no locking.
@@ -25,8 +26,11 @@ struct seccomp {
 	int mode;
 	spinlock_t lock;
 	struct seccomp_filter *filter;
+	unsigned long flags;
 };
 
+#define SECCOMP_FLAG_NO_NEW_PRIVS	0
+
 extern int __secure_computing(int);
 static inline int secure_computing(int this_syscall)
 {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 6d61a0b5080c..8761ce47a8bd 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -225,7 +225,7 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	 * This avoids scenarios where unprivileged tasks can affect the
 	 * behavior of privileged children.
 	 */
-	if (!current->no_new_privs &&
+	if (!task_no_new_privs(current) &&
 	    security_capable_noaudit(current_cred(), current_user_ns(),
 				     CAP_SYS_ADMIN) != 0)
 		return -EACCES;
diff --git a/kernel/sys.c b/kernel/sys.c
index fba0f29401ea..262919a8a7ac 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1990,12 +1990,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 != 1 || arg3 || arg4 || arg5)
 			return -EINVAL;
 
-		current->no_new_privs = 1;
+		error = task_set_no_new_privs(current);
 		break;
 	case PR_GET_NO_NEW_PRIVS:
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
-		return current->no_new_privs ? 1 : 0;
+		return task_no_new_privs(current) ? 1 : 0;
 	case PR_GET_THP_DISABLE:
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 452567d3a08e..d97cba3e3849 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -621,7 +621,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 	 * There is no exception for unconfined as change_hat is not
 	 * available.
 	 */
-	if (current->no_new_privs)
+	if (task_no_new_privs(current))
 		return -EPERM;
 
 	/* released below */
@@ -776,7 +776,7 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
 	 * no_new_privs is set because this aways results in a reduction
 	 * of permissions.
 	 */
-	if (current->no_new_privs && !unconfined(profile)) {
+	if (task_no_new_privs(current) && !unconfined(profile)) {
 		put_cred(cred);
 		return -EPERM;
 	}
-- 
1.7.9.5

