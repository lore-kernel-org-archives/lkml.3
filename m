Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3HTVev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3HTVdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:38 -0400
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
Subject: [PATCH 07/12] audit: store audit_pid as a struct pid pointer
Date: Tue, 20 Aug 2013 17:31:59 -0400
Message-Id: <4a5eb957dff8388db8fe7c953469a3c36e42c2b0.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
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
 kernel/audit.c   |   25 +++++++++++++++++++------
 kernel/audit.h   |    4 ++--
 kernel/auditsc.c |    6 +++---
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 75b0989..fa1d5f5 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -93,7 +93,7 @@ static int	audit_failure = AUDIT_FAIL_PRINTK;
  * contains the pid of the auditd process and audit_nlk_portid contains
  * the portid to use to send netlink messages to that process.
  */
-int		audit_pid;
+struct pid	*audit_pid;
 static __u32	audit_nlk_portid;
 
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
@@ -388,9 +388,11 @@ static void kauditd_send_skb(struct sk_buff *skb)
 	err = netlink_unicast(audit_sock, skb, audit_nlk_portid, 0);
 	if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
-		printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
+		pr_err("audit: *NO* daemon at audit_pid=%d\n"
+		       , pid_nr_init_ns(audit_pid));
 		audit_log_lost("auditd disappeared\n");
-		audit_pid = 0;
+		put_pid(audit_pid);
+		audit_pid = NULL;
 		/* we might get lucky and get this in the next auditd */
 		audit_hold_skb(skb);
 	} else
@@ -661,7 +663,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_GET:
 		status_set.enabled	 = audit_enabled;
 		status_set.failure	 = audit_failure;
-		status_set.pid		 = audit_pid;
+		status_set.pid		 = pid_vnr(audit_pid);
 		status_set.rate_limit	 = audit_rate_limit;
 		status_set.backlog_limit = audit_backlog_limit;
 		status_set.lost		 = atomic_read(&audit_lost);
@@ -684,10 +686,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				return err;
 		}
 		if (status_get->mask & AUDIT_STATUS_PID) {
-			int new_pid = status_get->pid;
+			struct pid *new_pid = find_get_pid(status_get->pid);
+			if (status_get->pid && !new_pid)
+				return -ESRCH;
+
+			/* check that non-zero pid it is trying to set is its
+			 * own*/
+			if (status_get->pid &&
+			    (status_get->pid != task_pid_vnr(current)))
+				return -EPERM;
 
 			if (audit_enabled != AUDIT_OFF)
-				audit_log_config_change("audit_pid", new_pid, audit_pid, 1);
+				audit_log_config_change("audit_pid",
+							pid_nr_init_ns(new_pid),
+							pid_nr_init_ns(audit_pid),
+							1);
 			audit_pid = new_pid;
 			audit_nlk_portid = NETLINK_CB(skb).portid;
 		}
diff --git a/kernel/audit.h b/kernel/audit.h
index 36edcf5..3932a3b 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -218,7 +218,7 @@ extern void audit_log_name(struct audit_context *context,
 			   struct audit_names *n, struct path *path,
 			   int record_num, int *call_panic);
 
-extern int audit_pid;
+extern struct pid *audit_pid;
 
 #define AUDIT_INODE_BUCKETS	32
 extern struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
@@ -310,7 +310,7 @@ extern u32 audit_sig_sid;
 extern int __audit_signal_info(int sig, struct task_struct *t);
 static inline int audit_signal_info(int sig, struct task_struct *t)
 {
-	if (unlikely((audit_pid && t->tgid == audit_pid) ||
+	if (unlikely((audit_pid && task_tgid(t) == audit_pid) ||
 		     (audit_signals && !audit_dummy_context())))
 		return __audit_signal_info(sig, t);
 	return 0;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 60a966d..2dcf67d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -739,7 +739,7 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 	struct audit_entry *e;
 	enum audit_state state;
 
-	if (audit_pid && tsk->tgid == audit_pid)
+	if (audit_pid && task_tgid(tsk) == audit_pid)
 		return AUDIT_DISABLED;
 
 	rcu_read_lock();
@@ -800,7 +800,7 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 {
 	struct audit_names *n;
 
-	if (audit_pid && tsk->tgid == audit_pid)
+	if (audit_pid && task_tgid(tsk) == audit_pid)
 		return;
 
 	rcu_read_lock();
@@ -2220,7 +2220,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	struct audit_context *ctx = tsk->audit_context;
 	kuid_t uid = current_uid(), t_uid = task_uid(t);
 
-	if (audit_pid && t->tgid == audit_pid) {
+	if (audit_pid && task_tgid(t) == audit_pid) {
 		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1 || sig == SIGUSR2) {
 			audit_sig_pid = tsk->pid;
 			if (uid_valid(tsk->loginuid))
-- 
1.7.1

