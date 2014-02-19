Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaBSU7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:59:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaBSU7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:59:18 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, oleg@redhat.com, peterz@infradead.org,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH 4/5] audit: anchor all pid references in the initial pid namespace
Date: Wed, 19 Feb 2014 15:57:42 -0500
Message-Id: <f8777641433994e553fa774fc86eb26d081b2e4f.1392842865.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1392842865.git.rgb@redhat.com>
References: <cover.1392842865.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store and log all PIDs with reference to the initial PID namespace and
use the access functions task_pid_nr() and task_tgid_nr() for task->pid
and task->tgid.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
(informed by ebiederman's c776b5d2)
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 drivers/tty/tty_audit.c              |    3 ++-
 kernel/audit.c                       |    5 +++--
 kernel/auditfilter.c                 |   17 ++++++++++++++++-
 kernel/auditsc.c                     |   16 +++++++++-------
 security/integrity/integrity_audit.c |    2 +-
 security/lsm_audit.c                 |   11 +++++++----
 6 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index b0e5401..90ca082 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -65,6 +65,7 @@ static void tty_audit_log(const char *description, int major, int minor,
 {
 	struct audit_buffer *ab;
 	struct task_struct *tsk = current;
+	pid_t pid = task_pid_nr(tsk);
 	uid_t uid = from_kuid(&init_user_ns, task_uid(tsk));
 	uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(tsk));
 	unsigned int sessionid = audit_get_sessionid(tsk);
@@ -74,7 +75,7 @@ static void tty_audit_log(const char *description, int major, int minor,
 		char name[sizeof(tsk->comm)];
 
 		audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u major=%d"
-				 " minor=%d comm=", description, tsk->pid, uid,
+				 " minor=%d comm=", description, pid, uid,
 				 loginuid, sessionid, major, minor);
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
diff --git a/kernel/audit.c b/kernel/audit.c
index 015003c..6d33246 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -648,6 +648,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
 {
 	int rc = 0;
 	uid_t uid = from_kuid(&init_user_ns, current_uid());
+	pid_t pid = task_tgid_nr(current);
 
 	if (!audit_enabled && msg_type != AUDIT_USER_AVC) {
 		*ab = NULL;
@@ -657,7 +658,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
 	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
 	if (unlikely(!*ab))
 		return rc;
-	audit_log_format(*ab, "pid=%d uid=%u", task_tgid_vnr(current), uid);
+	audit_log_format(*ab, "pid=%d uid=%u", pid, uid);
 	audit_log_session_info(*ab);
 	audit_log_task_context(*ab);
 
@@ -1842,7 +1843,7 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 " euid=%u suid=%u fsuid=%u"
 			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
 			 task_ppid_nr(tsk),
-			 tsk->pid,
+			 task_pid_nr(tsk),
 			 from_kuid(&init_user_ns, audit_get_loginuid(tsk)),
 			 from_kuid(&init_user_ns, cred->uid),
 			 from_kgid(&init_user_ns, cred->gid),
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 3152d1a..2f2f69e 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -431,6 +431,19 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
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
+			f->val = pid_nr(pid);
+			rcu_read_unlock();
+		}
+
 		err = audit_field_valid(entry, f);
 		if (err)
 			goto exit_free;
@@ -1238,12 +1251,14 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
 
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
+		pid_t pid;
 		int result = 0;
 		u32 sid;
 
 		switch (f->type) {
 		case AUDIT_PID:
-			result = audit_comparator(task_pid_vnr(current), f->op, f->val);
+			pid = task_pid_nr(current);
+			result = audit_comparator(pid, f->op, f->val);
 			break;
 		case AUDIT_UID:
 			result = audit_uid_comparator(current_uid(), f->op, f->uid);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a747afb..f52379b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -453,10 +453,12 @@ static int audit_filter_rules(struct task_struct *tsk,
 		struct audit_field *f = &rule->fields[i];
 		struct audit_names *n;
 		int result = 0;
+		pid_t pid;
 
 		switch (f->type) {
 		case AUDIT_PID:
-			result = audit_comparator(tsk->pid, f->op, f->val);
+			pid = task_pid_nr(tsk);
+			result = audit_comparator(pid, f->op, f->val);
 			break;
 		case AUDIT_PPID:
 			if (ctx) {
@@ -1984,7 +1986,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	audit_log_format(ab, "pid=%d uid=%u"
 			 " old-auid=%u new-auid=%u old-ses=%u new-ses=%u"
 			 " res=%d",
-			 current->pid, uid,
+			 task_pid_nr(current), uid,
 			 oldloginuid, loginuid, oldsessionid, sessionid,
 			 !rc);
 	audit_log_end(ab);
@@ -2208,7 +2210,7 @@ void __audit_ptrace(struct task_struct *t)
 {
 	struct audit_context *context = current->audit_context;
 
-	context->target_pid = t->pid;
+	context->target_pid = task_pid_nr(t);
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
@@ -2233,7 +2235,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 
 	if (audit_pid && task_tgid(t) == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1 || sig == SIGUSR2) {
-			audit_sig_pid = tsk->pid;
+			audit_sig_pid = task_pid_nr(tsk);
 			if (uid_valid(tsk->loginuid))
 				audit_sig_uid = tsk->loginuid;
 			else
@@ -2247,7 +2249,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	/* optimize the common case by putting first signal recipient directly
 	 * in audit_context */
 	if (!ctx->target_pid) {
-		ctx->target_pid = t->tgid;
+		ctx->target_pid = task_tgid_nr(t);
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
@@ -2268,7 +2270,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	}
 	BUG_ON(axp->pid_count >= AUDIT_AUX_PIDS);
 
-	axp->target_pid[axp->pid_count] = t->tgid;
+	axp->target_pid[axp->pid_count] = task_tgid_nr(t);
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
@@ -2368,7 +2370,7 @@ static void audit_log_task(struct audit_buffer *ab)
 			 from_kgid(&init_user_ns, gid),
 			 sessionid);
 	audit_log_task_context(ab);
-	audit_log_format(ab, " pid=%d comm=", current->pid);
+	audit_log_format(ab, " pid=%d comm=", task_pid_nr(current));
 	audit_log_untrustedstring(ab, current->comm);
 	if (mm) {
 		down_read(&mm->mmap_sem);
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index d7efb30..85253b5 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -39,7 +39,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
-			 current->pid,
+			 task_pid_nr(current),
 			 from_kuid(&init_user_ns, current_cred()->uid),
 			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			 audit_get_sessionid(current));
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 9a62045..69fdf3b 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -220,7 +220,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	 */
 	BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
 
-	audit_log_format(ab, " pid=%d comm=", tsk->pid);
+	audit_log_format(ab, " pid=%d comm=", task_pid_nr(tsk));
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
+			pid_t pid = task_pid_nr(tsk);
+			if (pid) {
+				audit_log_format(ab, " pid=%d comm=", pid);
+				audit_log_untrustedstring(ab, tsk->comm);
+			}
 		}
 		break;
 	case LSM_AUDIT_DATA_NET:
-- 
1.7.1

