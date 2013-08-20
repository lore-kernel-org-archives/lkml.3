Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3HTVdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3HTVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:33 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 06/12] audit: Simplify and correct audit_log_capset
Date: Tue, 20 Aug 2013 17:31:58 -0400
Message-Id: <9d47399caeaff9a12e9163dddbb9ae9a6491d382.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

- Always report the current process as capset now always only works on
  the current process.  This prevents reporting 0 or a random pid in
  a random pid namespace.

- Don't bother to pass the pid as is available.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
(cherry picked from commit bcc85f0af31af123e32858069eb2ad8f39f90e67)
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    6 +++---
 kernel/auditsc.c      |    6 ++----
 kernel/capability.c   |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index a3af0fa..49223a6 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -218,7 +218,7 @@ extern void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 				  const struct cred *new,
 				  const struct cred *old);
-extern void __audit_log_capset(pid_t pid, const struct cred *new, const struct cred *old);
+extern void __audit_log_capset(const struct cred *new, const struct cred *old);
 extern void __audit_mmap_fd(int fd, int flags);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
@@ -284,11 +284,11 @@ static inline int audit_log_bprm_fcaps(struct linux_binprm *bprm,
 	return 0;
 }
 
-static inline void audit_log_capset(pid_t pid, const struct cred *new,
+static inline void audit_log_capset(const struct cred *new,
 				   const struct cred *old)
 {
 	if (unlikely(!audit_dummy_context()))
-		__audit_log_capset(pid, new, old);
+		__audit_log_capset(new, old);
 }
 
 static inline void audit_mmap_fd(int fd, int flags)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 74a0748..60a966d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2316,18 +2316,16 @@ int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 
 /**
  * __audit_log_capset - store information about the arguments to the capset syscall
- * @pid: target pid of the capset call
  * @new: the new credentials
  * @old: the old (current) credentials
  *
  * Record the aguments userspace sent to sys_capset for later printing by the
  * audit system if applicable
  */
-void __audit_log_capset(pid_t pid,
-		       const struct cred *new, const struct cred *old)
+void __audit_log_capset(const struct cred *new, const struct cred *old)
 {
 	struct audit_context *context = current->audit_context;
-	context->capset.pid = pid;
+	context->capset.pid = task_pid_nr_init_ns(current);
 	context->capset.cap.effective   = new->cap_effective;
 	context->capset.cap.inheritable = new->cap_effective;
 	context->capset.cap.permitted   = new->cap_permitted;
diff --git a/kernel/capability.c b/kernel/capability.c
index f6c2ce5..7f60311 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -277,7 +277,7 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 	if (ret < 0)
 		goto error;
 
-	audit_log_capset(pid, new, current_cred());
+	audit_log_capset(new, current_cred());
 
 	return commit_creds(new);
 
-- 
1.7.1

