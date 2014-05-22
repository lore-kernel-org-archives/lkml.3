Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaEVXGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:06:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53417 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbaEVXGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:06:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v5 4/6] seccomp: move no_new_privs into seccomp
Date: Thu, 22 May 2014 16:05:34 -0700
Message-Id: <1400799936-26499-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400799936-26499-1-git-send-email-keescook@chromium.org>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since seccomp transitions between threads requires updates to the
no_new_privs flag to be atomic, changes must be atomic. This moves the nnp
flag into the seccomp field as a separate unsigned long for atomic access.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c                  |    4 ++--
 include/linux/sched.h      |   13 ++++++++++---
 include/linux/seccomp.h    |    8 +++++++-
 kernel/seccomp.c           |    2 +-
 kernel/sys.c               |    4 ++--
 security/apparmor/domain.c |    4 ++--
 6 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 238b7aa26f68..614fcb993739 100644
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
index 71a6cb66a3f3..d2a72deba43b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1259,9 +1259,6 @@ struct task_struct {
 				 * execve */
 	unsigned in_iowait:1;
 
-	/* task may not gain privileges */
-	unsigned no_new_privs:1;
-
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
@@ -2480,6 +2477,16 @@ static inline void task_unlock(struct task_struct *p)
 	spin_unlock(&p->alloc_lock);
 }
 
+static inline bool task_no_new_privs(struct task_struct *p)
+{
+	return test_bit(SECCOMP_FLAG_NO_NEW_PRIVS, &p->seccomp.flags);
+}
+
+static inline void task_set_no_new_privs(struct task_struct *p)
+{
+	set_bit(SECCOMP_FLAG_NO_NEW_PRIVS, &p->seccomp.flags);
+}
+
 #ifdef CONFIG_SECCOMP
 /*
  * Protects changes to ->seccomp
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index c47be00e8ffb..ed86b298f3b2 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -3,6 +3,8 @@
 
 #include <uapi/linux/seccomp.h>
 
+#define SECCOMP_FLAG_NO_NEW_PRIVS	0	/* task may not gain privs */
+
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
@@ -17,6 +19,7 @@ struct seccomp_filter;
  * @lock:  held when making changes to avoid thread races.
  * @filter: must always point to a valid seccomp-filter or NULL as it is
  *          accessed without locking during system call entry.
+ * @flags: flags under write lock
  *
  *          @filter must only be accessed from the context of current as there
  *          is no locking.
@@ -25,6 +28,7 @@ struct seccomp {
 	int mode;
 	spinlock_t lock;
 	struct seccomp_filter *filter;
+	unsigned long flags;
 };
 
 extern int __secure_computing(int);
@@ -53,7 +57,9 @@ static inline int seccomp_mode(struct seccomp *s)
 
 #include <linux/errno.h>
 
-struct seccomp { };
+struct seccomp {
+	unsigned long flags;
+};
 struct seccomp_filter { };
 
 static inline int secure_computing(int this_syscall) { return 0; }
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index d200029728ca..e7238f5708d4 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -219,7 +219,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 	 * This avoids scenarios where unprivileged tasks can affect the
 	 * behavior of privileged children.
 	 */
-	if (!current->no_new_privs &&
+	if (!task_no_new_privs(current) &&
 	    security_capable_noaudit(current_cred(), current_user_ns(),
 				     CAP_SYS_ADMIN) != 0)
 		return ERR_PTR(-EACCES);
diff --git a/kernel/sys.c b/kernel/sys.c
index fba0f29401ea..d3b4af60a411 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1990,12 +1990,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 != 1 || arg3 || arg4 || arg5)
 			return -EINVAL;
 
-		current->no_new_privs = 1;
+		task_set_no_new_privs(current);
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

