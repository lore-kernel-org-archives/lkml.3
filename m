Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3HTVdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3HTVdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:42 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 08/12] audit: anchor all pid references in the initial pid namespace
Date: Tue, 20 Aug 2013 17:32:00 -0400
Message-Id: <dd23ba34a08fa47ecb0c8de7c3aff51c66977823.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store and log all PIDs with reference to the initial PID namespace and
deprecate the use of the error-prone duplicity of task->pid and task->tgid.

Still only permit the audit logging daemon and control to operate from the
initial PID namespace, but allow processes to log from another PID namespace.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
(informed by ebiederman's c776b5d2)

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 drivers/tty/tty_audit.c              |    3 ++-
 kernel/audit.c                       |   15 ++++++++++-----
 kernel/auditfilter.c                 |   17 ++++++++++++++++-
 kernel/auditsc.c                     |   16 +++++++++-------
 security/apparmor/audit.c            |    2 +-
 security/integrity/integrity_audit.c |    2 +-
 security/lsm_audit.c                 |   11 +++++++----
 security/tomoyo/audit.c              |    2 +-
 8 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index a4fdce7..a0ae01f 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -65,6 +65,7 @@ static void tty_audit_log(const char *description, int major, int minor,
 {
 	struct audit_buffer *ab;
 	struct task_struct *tsk = current;
+	pid_t pid = task_pid_nr_init_ns(tsk);
 	uid_t uid = from_kuid(&init_user_ns, task_uid(tsk));
 	uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(tsk));
 	u32 sessionid = audit_get_sessionid(tsk);
@@ -74,7 +75,7 @@ static void tty_audit_log(const char *description, int major, int minor,
 		char name[sizeof(tsk->comm)];
 
 		audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u major=%d"
-				 " minor=%d comm=", description, tsk->pid, uid,
+				 " minor=%d comm=", description, pid, uid,
 				 loginuid, sessionid, major, minor);
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
diff --git a/kernel/audit.c b/kernel/audit.c
index fa1d5f5..8e4958b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -574,9 +574,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 {
 	int err = 0;
 
-	/* Only support the initial namespaces for now. */
-	if ((current_user_ns() != &init_user_ns) ||
-	    (task_active_pid_ns(current) != &init_pid_ns))
+	/* Only support initial user namespace for now. */
+	if ((current_user_ns() != &init_user_ns))
 		return -EPERM;
 
 	switch (msg_type) {
@@ -594,6 +593,11 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
 	case AUDIT_MAKE_EQUIV:
+		/* Only support auditd and auditctl in initial pid namespace
+		 * for now. */
+		if ((task_active_pid_ns(current) != &init_pid_ns))
+			return -EPERM;
+
 		if (!capable(CAP_AUDIT_CONTROL))
 			err = -EPERM;
 		break;
@@ -614,6 +618,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
 {
 	int rc = 0;
 	uid_t uid = from_kuid(&init_user_ns, current_uid());
+	pid_t pid = task_tgid_nr_init_ns(current);
 
 	if (!audit_enabled) {
 		*ab = NULL;
@@ -623,7 +628,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
 	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
 	if (unlikely(!*ab))
 		return rc;
-	audit_log_format(*ab, "pid=%d uid=%u", task_tgid_vnr(current), uid);
+	audit_log_format(*ab, "pid=%d uid=%u", pid, uid);
 	audit_log_session_info(*ab);
 	audit_log_task_context(*ab);
 
@@ -1605,7 +1610,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 " euid=%u suid=%u fsuid=%u"
 			 " egid=%u sgid=%u fsgid=%u ses=%u tty=%s",
 			 task_ppid_nr_init_ns(tsk),
-			 tsk->pid,
+			 task_pid_nr_init_ns(tsk),
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
 			 from_kuid(&init_user_ns, cred->uid),
 			 from_kgid(&init_user_ns, cred->gid),
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 381d3de..2a60455 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -428,6 +428,19 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			f->val = 0;
 		}
 
+		if ((f->type == AUDIT_PID) || (f->type == AUDIT_PPID)) {
+			struct pid *pid;
+			rcu_read_lock();
+			pid = find_vpid(f->val);
+			if (!pid) {
+				rcu_read_unlock();
+				err = -ESRCH;
+				goto exit_free;
+			}
+			f->val = pid_nr_init_ns(pid);
+			rcu_read_unlock();
+		}
+
 		err = audit_field_valid(entry, f);
 		if (err)
 			goto exit_free;
@@ -1223,12 +1236,14 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
 
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
+		pid_t pid;
 		int result = 0;
 		u32 sid;
 
 		switch (f->type) {
 		case AUDIT_PID:
-			result = audit_comparator(task_pid_vnr(current), f->op, f->val);
+			pid = task_pid_nr_init_ns(current);
+			result = audit_comparator(pid, f->op, f->val);
 			break;
 		case AUDIT_UID:
 			result = audit_uid_comparator(current_uid(), f->op, f->uid);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2dcf67d..5cde81c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -458,10 +458,12 @@ static int audit_filter_rules(struct task_struct *tsk,
 		struct audit_field *f = &rule->fields[i];
 		struct audit_names *n;
 		int result = 0;
+		pid_t pid;
 
 		switch (f->type) {
 		case AUDIT_PID:
-			result = audit_comparator(tsk->pid, f->op, f->val);
+			pid = task_pid_nr_init_ns(tsk);
+			result = audit_comparator(pid, f->op, f->val);
 			break;
 		case AUDIT_PPID:
 			if (ctx) {
@@ -1989,7 +1991,7 @@ int audit_set_loginuid(kuid_t loginuid)
 			audit_log_format(ab, "login pid=%d uid=%u "
 				"old auid=%u new auid=%u"
 				" old ses=%u new ses=%u",
-				task->pid,
+				task_pid_nr_init_ns(task),
 				from_kuid(&init_user_ns, task_uid(task)),
 				from_kuid(&init_user_ns, task->loginuid),
 				from_kuid(&init_user_ns, loginuid),
@@ -2197,7 +2199,7 @@ void __audit_ptrace(struct task_struct *t)
 {
 	struct audit_context *context = current->audit_context;
 
-	context->target_pid = t->pid;
+	context->target_pid = task_pid_nr_init_ns(t);
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
@@ -2222,7 +2224,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 
 	if (audit_pid && task_tgid(t) == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1 || sig == SIGUSR2) {
-			audit_sig_pid = tsk->pid;
+			audit_sig_pid = task_pid_nr_init_ns(tsk);
 			if (uid_valid(tsk->loginuid))
 				audit_sig_uid = tsk->loginuid;
 			else
@@ -2236,7 +2238,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	/* optimize the common case by putting first signal recipient directly
 	 * in audit_context */
 	if (!ctx->target_pid) {
-		ctx->target_pid = t->tgid;
+		ctx->target_pid = task_tgid_nr_init_ns(t);
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
@@ -2257,7 +2259,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	}
 	BUG_ON(axp->pid_count >= AUDIT_AUX_PIDS);
 
-	axp->target_pid[axp->pid_count] = t->tgid;
+	axp->target_pid[axp->pid_count] = task_tgid_nr_init_ns(t);
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
@@ -2356,7 +2358,7 @@ static void audit_log_task(struct audit_buffer *ab)
 			 from_kgid(&init_user_ns, gid),
 			 sessionid);
 	audit_log_task_context(ab);
-	audit_log_format(ab, " pid=%d comm=", current->pid);
+	audit_log_format(ab, " pid=%d comm=", task_pid_nr_init_ns(current));
 	audit_log_untrustedstring(ab, current->comm);
 }
 
diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index 497b306..afe71f5 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -148,7 +148,7 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
 	}
 
 	if (sa->aad->tsk) {
-		audit_log_format(ab, " pid=%d comm=", tsk->pid);
+		audit_log_format(ab, " pid=%d comm=", task_pid_nr_init_ns(tsk));
 		audit_log_untrustedstring(ab, tsk->comm);
 	}
 
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index d7efb30..1e7291a 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -39,7 +39,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
-			 current->pid,
+			 task_pid_nr_init_ns(current),
 			 from_kuid(&init_user_ns, current_cred()->uid),
 			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			 audit_get_sessionid(current));
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 8d8d97d..4f43488 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -220,7 +220,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	 */
 	BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
 
-	audit_log_format(ab, " pid=%d comm=", tsk->pid);
+	audit_log_format(ab, " pid=%d comm=", task_pid_nr_init_ns(tsk));
 	audit_log_untrustedstring(ab, tsk->comm);
 
 	switch (a->type) {
@@ -278,9 +278,12 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	}
 	case LSM_AUDIT_DATA_TASK:
 		tsk = a->u.tsk;
-		if (tsk && tsk->pid) {
-			audit_log_format(ab, " pid=%d comm=", tsk->pid);
-			audit_log_untrustedstring(ab, tsk->comm);
+		if (tsk) {
+			pid_t pid = task_pid_nr_init_ns(tsk);
+			if (pid) {
+				audit_log_format(ab, " pid=%d comm=", pid);
+				audit_log_untrustedstring(ab, tsk->comm);
+			}
 		}
 		break;
 	case LSM_AUDIT_DATA_NET:
diff --git a/security/tomoyo/audit.c b/security/tomoyo/audit.c
index c1b0037..6657607 100644
--- a/security/tomoyo/audit.c
+++ b/security/tomoyo/audit.c
@@ -147,7 +147,7 @@ static inline const char *tomoyo_filetype(const umode_t mode)
 static char *tomoyo_print_header(struct tomoyo_request_info *r)
 {
 	struct tomoyo_time stamp;
-	const pid_t gpid = task_pid_nr(current);
+	const pid_t gpid = task_pid_nr_init_ns(current);
 	struct tomoyo_obj_info *obj = r->obj;
 	static const int tomoyo_buffer_len = 4096;
 	char *buffer = kmalloc(tomoyo_buffer_len, GFP_NOFS);
-- 
1.7.1

