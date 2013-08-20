Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3HTVd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3HTVdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:23 -0400
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
Subject: [PATCH 02/12] audit: fix netlink portid naming and types
Date: Tue, 20 Aug 2013 17:31:54 -0400
Message-Id: <f9afd052f64d78de168f109ee6ce1bf626269128.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, netlink ports use the PID of the userspace process as the port ID.
If the PID is already in use by a port, the kernel will allocate another port
ID to avoid conflict.  Re-name all references to netlink ports from pid to
portid to reflect this reality and avoid confusion with actual PIDs.  Ports
use the __u32 type, so re-type all portids accordingly.

(This patch is very similar to ebiederman's 5deadd69)

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |    2 +-
 kernel/audit.c        |   32 ++++++++++++++++----------------
 kernel/audit.h        |    8 ++++----
 kernel/auditfilter.c  |   18 ++++++++++--------
 4 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 729a4d1..a3af0fa 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -462,7 +462,7 @@ extern int		    audit_update_lsm_rules(void);
 				/* Private API (for audit.c only) */
 extern int audit_filter_user(int type);
 extern int audit_filter_type(int type);
-extern int  audit_receive_filter(int type, int pid, int seq,
+extern int  audit_receive_filter(int type, __u32 portid, int seq,
 				void *data, size_t datasz);
 extern int audit_enabled;
 #else /* CONFIG_AUDIT */
diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..2476334 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -94,7 +94,7 @@ static int	audit_failure = AUDIT_FAIL_PRINTK;
  * the portid to use to send netlink messages to that process.
  */
 int		audit_pid;
-static int	audit_nlk_portid;
+static __u32	audit_nlk_portid;
 
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
  * to that number per second.  This prevents DoS attacks, but results in
@@ -165,15 +165,15 @@ struct audit_buffer {
 };
 
 struct audit_reply {
-	int pid;
+	__u32 portid;
 	struct sk_buff *skb;
 };
 
-static void audit_set_pid(struct audit_buffer *ab, pid_t pid)
+static void audit_set_portid(struct audit_buffer *ab, __u32 portid)
 {
 	if (ab) {
 		struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
-		nlh->nlmsg_pid = pid;
+		nlh->nlmsg_pid = portid;
 	}
 }
 
@@ -472,7 +472,7 @@ static int kauditd_thread(void *dummy)
 int audit_send_list(void *_dest)
 {
 	struct audit_netlink_list *dest = _dest;
-	int pid = dest->pid;
+	__u32 portid = dest->portid;
 	struct sk_buff *skb;
 
 	/* wait for parent to finish and send an ACK */
@@ -480,14 +480,14 @@ int audit_send_list(void *_dest)
 	mutex_unlock(&audit_cmd_mutex);
 
 	while ((skb = __skb_dequeue(&dest->q)) != NULL)
-		netlink_unicast(audit_sock, skb, pid, 0);
+		netlink_unicast(audit_sock, skb, portid, 0);
 
 	kfree(dest);
 
 	return 0;
 }
 
-struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
+struct sk_buff *audit_make_reply(__u32 portid, int seq, int type, int done,
 				 int multi, const void *payload, int size)
 {
 	struct sk_buff	*skb;
@@ -500,7 +500,7 @@ struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
 	if (!skb)
 		return NULL;
 
-	nlh	= nlmsg_put(skb, pid, seq, t, size, flags);
+	nlh	= nlmsg_put(skb, portid, seq, t, size, flags);
 	if (!nlh)
 		goto out_kfree_skb;
 	data = nlmsg_data(nlh);
@@ -521,13 +521,13 @@ static int audit_send_reply_thread(void *arg)
 
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
-	netlink_unicast(audit_sock, reply->skb, reply->pid, 0);
+	netlink_unicast(audit_sock, reply->skb, reply->portid, 0);
 	kfree(reply);
 	return 0;
 }
 /**
  * audit_send_reply - send an audit reply message via netlink
- * @pid: process id to send reply to
+ * @portid: netlink port to which to send reply
  * @seq: sequence number
  * @type: audit message type
  * @done: done (last) flag
@@ -535,11 +535,11 @@ static int audit_send_reply_thread(void *arg)
  * @payload: payload data
  * @size: payload size
  *
- * Allocates an skb, builds the netlink message, and sends it to the pid.
+ * Allocates an skb, builds the netlink message, and sends it to the port id.
  * No failure notifications.
  */
-static void audit_send_reply(int pid, int seq, int type, int done, int multi,
-			     const void *payload, int size)
+static void audit_send_reply(__u32 portid, int seq, int type, int done,
+			     int multi, const void *payload, int size)
 {
 	struct sk_buff *skb;
 	struct task_struct *tsk;
@@ -549,11 +549,11 @@ static void audit_send_reply(int pid, int seq, int type, int done, int multi,
 	if (!reply)
 		return;
 
-	skb = audit_make_reply(pid, seq, type, done, multi, payload, size);
+	skb = audit_make_reply(portid, seq, type, done, multi, payload, size);
 	if (!skb)
 		goto out;
 
-	reply->pid = pid;
+	reply->portid = portid;
 	reply->skb = skb;
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
@@ -727,7 +727,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					size--;
 				audit_log_n_untrustedstring(ab, data, size);
 			}
-			audit_set_pid(ab, NETLINK_CB(skb).portid);
+			audit_set_portid(ab, NETLINK_CB(skb).portid);
 			audit_log_end(ab);
 		}
 		break;
diff --git a/kernel/audit.h b/kernel/audit.h
index 123c9b7..36edcf5 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -237,13 +237,13 @@ extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
 extern int parent_len(const char *path);
 extern int audit_compare_dname_path(const char *dname, const char *path, int plen);
-extern struct sk_buff *	    audit_make_reply(int pid, int seq, int type,
-					     int done, int multi,
-					     const void *payload, int size);
+extern struct sk_buff *audit_make_reply(__u32 portid, int seq, int type,
+					int done, int multi,
+					const void *payload, int size);
 extern void		    audit_panic(const char *message);
 
 struct audit_netlink_list {
-	int pid;
+	__u32 portid;
 	struct sk_buff_head q;
 };
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f7aee8b..381d3de 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -971,7 +971,7 @@ out:
 }
 
 /* List rules using struct audit_rule_data. */
-static void audit_list_rules(int pid, int seq, struct sk_buff_head *q)
+static void audit_list_rules(__u32 portid, int seq, struct sk_buff_head *q)
 {
 	struct sk_buff *skb;
 	struct audit_krule *r;
@@ -986,14 +986,15 @@ static void audit_list_rules(int pid, int seq, struct sk_buff_head *q)
 			data = audit_krule_to_data(r);
 			if (unlikely(!data))
 				break;
-			skb = audit_make_reply(pid, seq, AUDIT_LIST_RULES, 0, 1,
-					 data, sizeof(*data) + data->buflen);
+			skb = audit_make_reply(portid, seq, AUDIT_LIST_RULES,
+					       0, 1, data,
+					       sizeof(*data) + data->buflen);
 			if (skb)
 				skb_queue_tail(q, skb);
 			kfree(data);
 		}
 	}
-	skb = audit_make_reply(pid, seq, AUDIT_LIST_RULES, 1, 1, NULL, 0);
+	skb = audit_make_reply(portid, seq, AUDIT_LIST_RULES, 1, 1, NULL, 0);
 	if (skb)
 		skb_queue_tail(q, skb);
 }
@@ -1023,12 +1024,13 @@ static void audit_log_rule_change(char *action, struct audit_krule *rule, int re
 /**
  * audit_receive_filter - apply all rules to the specified message type
  * @type: audit message type
- * @pid: target pid for netlink audit messages
+ * @portid: target port id for netlink audit messages
  * @seq: netlink audit message sequence (serial) number
  * @data: payload data
  * @datasz: size of payload data
  */
-int audit_receive_filter(int type, int pid, int seq, void *data, size_t datasz)
+int audit_receive_filter(int type, __u32 portid, int seq, void *data,
+			 size_t datasz)
 {
 	struct task_struct *tsk;
 	struct audit_netlink_list *dest;
@@ -1046,11 +1048,11 @@ int audit_receive_filter(int type, int pid, int seq, void *data, size_t datasz)
 		dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
 		if (!dest)
 			return -ENOMEM;
-		dest->pid = pid;
+		dest->portid = portid;
 		skb_queue_head_init(&dest->q);
 
 		mutex_lock(&audit_filter_mutex);
-		audit_list_rules(pid, seq, &dest->q);
+		audit_list_rules(portid, seq, &dest->q);
 		mutex_unlock(&audit_filter_mutex);
 
 		tsk = kthread_run(audit_send_list, dest, "audit_send_list");
-- 
1.7.1

