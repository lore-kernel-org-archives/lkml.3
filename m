Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaBSU7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:59:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaBSU7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:59:12 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, oleg@redhat.com, peterz@infradead.org,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH 3/5] audit: store audit_pid as a struct pid pointer
Date: Wed, 19 Feb 2014 15:57:41 -0500
Message-Id: <3c74674ff5a51662799d33774b6cc1ba7f785642.1392842865.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1392842865.git.rgb@redhat.com>
References: <cover.1392842865.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- PID will be reported in the relevant querying PID namespace.

- Refuse to change the current audit_pid if the new value does not
  point to an existing process.

- Refuse to set the current audit_pid if the new value is not its own PID
  (unless it is being unset).

- Convert audit_pid into the initial pid namespace for reports

(informed by ebiederman's 5bf431da)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c   |   40 ++++++++++++++++++++++++++++++----------
 kernel/audit.h   |    4 ++--
 kernel/auditsc.c |    6 +++---
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index f5ea718..015003c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -95,7 +95,7 @@ static u32	audit_failure = AUDIT_FAIL_PRINTK;
  * contains the pid of the auditd process and audit_nlk_portid contains
  * the portid to use to send netlink messages to that process.
  */
-int		audit_pid;
+struct pid	*audit_pid;
 static __u32	audit_nlk_portid;
 
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
@@ -411,9 +411,12 @@ static void kauditd_send_skb(struct sk_buff *skb)
 	if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		if (audit_pid) {
-			pr_err("*NO* daemon at audit_pid=%d\n", audit_pid);
+			struct pid *temp_pid = audit_pid;
+			pr_err("*NO* daemon at audit_pid=%d\n", pid_nr(audit_pid));
 			audit_log_lost("auditd disappeared\n");
-			audit_pid = 0;
+			audit_pid = NULL;
+			smp_mb();
+			put_pid(temp_pid);
 			audit_sock = NULL;
 		}
 		/* we might get lucky and get this in the next auditd */
@@ -787,7 +790,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		memset(&s, 0, sizeof(s));
 		s.enabled		= audit_enabled;
 		s.failure		= audit_failure;
-		s.pid			= audit_pid;
+		s.pid			= pid_vnr(audit_pid);
 		s.rate_limit		= audit_rate_limit;
 		s.backlog_limit		= audit_backlog_limit;
 		s.lost			= atomic_read(&audit_lost);
@@ -814,12 +817,29 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				return err;
 		}
 		if (s.mask & AUDIT_STATUS_PID) {
-			int new_pid = s.pid;
-
-			if ((!new_pid) && (task_tgid_vnr(current) != audit_pid))
-				return -EACCES;
+			struct pid *new_pid = NULL;
+
+			if (s.pid) {
+				rcu_read_lock();
+				new_pid = get_pid(task_tgid(find_task_by_vpid(s.pid)));
+				rcu_read_unlock();
+				if (!new_pid)
+					return -ESRCH;
+				/* check that non-zero pid it is trying to set
+ 				 * is its own*/          
+				if (new_pid != task_tgid(current)) {
+					put_pid(new_pid);
+					return -EPERM;
+				}
+			} else {
+				/* check that it isn't orphaning another process */
+				if (task_pid_vnr(current) != pid_vnr(audit_pid))
+					return -EACCES;
+			}
 			if (audit_enabled != AUDIT_OFF)
-				audit_log_config_change("audit_pid", new_pid, audit_pid, 1);
+				audit_log_config_change("audit_pid", pid_nr(new_pid),
+							pid_nr(audit_pid), 1);
+			put_pid(audit_pid);
 			audit_pid = new_pid;
 			audit_nlk_portid = NETLINK_CB(skb).portid;
 			audit_sock = skb->sk;
@@ -1316,7 +1336,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 		return NULL;
 
 	if (gfp_mask & __GFP_WAIT) {
-		if (audit_pid && audit_pid == current->pid)
+		if (audit_pid == task_tgid(current))
 			gfp_mask &= ~__GFP_WAIT;
 		else
 			reserve = 0;
diff --git a/kernel/audit.h b/kernel/audit.h
index 57cc64d..e0924bc 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -221,7 +221,7 @@ extern void audit_log_name(struct audit_context *context,
 			   struct audit_names *n, struct path *path,
 			   int record_num, int *call_panic);
 
-extern int audit_pid;
+extern struct pid *audit_pid;
 
 #define AUDIT_INODE_BUCKETS	32
 extern struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
@@ -318,7 +318,7 @@ extern u32 audit_sig_sid;
 extern int __audit_signal_info(int sig, struct task_struct *t);
 static inline int audit_signal_info(int sig, struct task_struct *t)
 {
-	if (unlikely((audit_pid && t->tgid == audit_pid) ||
+	if (unlikely((audit_pid && task_tgid(t) == audit_pid) ||
 		     (audit_signals && !audit_dummy_context())))
 		return __audit_signal_info(sig, t);
 	return 0;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b909715..a747afb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -734,7 +734,7 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 	struct audit_entry *e;
 	enum audit_state state;
 
-	if (audit_pid && tsk->tgid == audit_pid)
+	if (audit_pid && task_tgid(tsk) == audit_pid)
 		return AUDIT_DISABLED;
 
 	rcu_read_lock();
@@ -795,7 +795,7 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 {
 	struct audit_names *n;
 
-	if (audit_pid && tsk->tgid == audit_pid)
+	if (audit_pid && task_tgid(tsk) == audit_pid)
 		return;
 
 	rcu_read_lock();
@@ -2231,7 +2231,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	struct audit_context *ctx = tsk->audit_context;
 	kuid_t uid = current_uid(), t_uid = task_uid(t);
 
-	if (audit_pid && t->tgid == audit_pid) {
+	if (audit_pid && task_tgid(t) == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1 || sig == SIGUSR2) {
 			audit_sig_pid = tsk->pid;
 			if (uid_valid(tsk->loginuid))
-- 
1.7.1

