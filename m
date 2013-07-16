Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab3GPUPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133Ab3GPUPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:15:46 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] audit: listen in all network namespaces
Date: Tue, 16 Jul 2013 16:15:14 -0400
Message-Id: <1374005714-6958-1-git-send-email-rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert audit from only listening in init_net to use register_pernet_subsys()
to dynamically manage the netlink socket list.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++---------
 kernel/audit.h |    4 +++
 2 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..06e2676 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -64,6 +64,7 @@
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/pid_namespace.h>
+#include <net/netns/generic.h>
 
 #include "audit.h"
 
@@ -122,6 +123,7 @@ static atomic_t    audit_lost = ATOMIC_INIT(0);
 
 /* The netlink socket. */
 static struct sock *audit_sock;
+int audit_net_id;
 
 /* Hash for inode-based rules */
 struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
@@ -391,6 +393,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
 		printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
 		audit_log_lost("auditd disappeared\n");
 		audit_pid = 0;
+		audit_sock = NULL;
 		/* we might get lucky and get this in the next auditd */
 		audit_hold_skb(skb);
 	} else
@@ -474,13 +477,15 @@ int audit_send_list(void *_dest)
 	struct audit_netlink_list *dest = _dest;
 	int pid = dest->pid;
 	struct sk_buff *skb;
+	struct net *net = get_net_ns_by_pid(pid);
+	struct audit_net *aunet = net_generic(net, audit_net_id);
 
 	/* wait for parent to finish and send an ACK */
 	mutex_lock(&audit_cmd_mutex);
 	mutex_unlock(&audit_cmd_mutex);
 
 	while ((skb = __skb_dequeue(&dest->q)) != NULL)
-		netlink_unicast(audit_sock, skb, pid, 0);
+		netlink_unicast(aunet->nlsk, skb, pid, 0);
 
 	kfree(dest);
 
@@ -515,13 +520,15 @@ out_kfree_skb:
 static int audit_send_reply_thread(void *arg)
 {
 	struct audit_reply *reply = (struct audit_reply *)arg;
+	struct net *net = get_net_ns_by_pid(reply->pid);
+	struct audit_net *aunet = net_generic(net, audit_net_id);
 
 	mutex_lock(&audit_cmd_mutex);
 	mutex_unlock(&audit_cmd_mutex);
 
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
-	netlink_unicast(audit_sock, reply->skb, reply->pid, 0);
+	netlink_unicast(aunet->nlsk , reply->skb, reply->pid, 0);
 	kfree(reply);
 	return 0;
 }
@@ -690,6 +697,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_config_change("audit_pid", new_pid, audit_pid, 1);
 			audit_pid = new_pid;
 			audit_nlk_portid = NETLINK_CB(skb).portid;
+			audit_sock = NETLINK_CB(skb).sk;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(status_get->rate_limit);
@@ -886,24 +894,58 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }
 
-/* Initialize audit support at boot time. */
-static int __init audit_init(void)
+static int __net_init audit_net_init(struct net *net)
 {
-	int i;
 	struct netlink_kernel_cfg cfg = {
 		.input	= audit_receive,
 	};
 
+	struct audit_net *aunet = net_generic(net, audit_net_id);
+
+	pr_info("audit: initializing netlink socket in namespace\n");
+
+	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
+	if (aunet->nlsk == NULL)
+		return -ENOMEM;
+	if (!aunet->nlsk)
+		audit_panic("cannot initialize netlink socket in namespace");
+	else
+		aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
+	return 0;
+}
+
+static void __net_exit audit_net_exit(struct net *net)
+{
+	struct audit_net *aunet = net_generic(net, audit_net_id);
+	struct sock *sock = aunet->nlsk;
+	if (sock == audit_sock) {
+		audit_pid = 0;
+		audit_sock = NULL;
+	}
+
+	rcu_assign_pointer(aunet->nlsk, NULL);
+	synchronize_net();
+	netlink_kernel_release(sock);
+}
+
+static struct pernet_operations __net_initdata audit_net_ops = {
+	.init = audit_net_init,
+	.exit = audit_net_exit,
+	.id = &audit_net_id,
+	.size = sizeof(struct audit_net),
+};
+
+/* Initialize audit support at boot time. */
+static int __init audit_init(void)
+{
+	int i;
+
 	if (audit_initialized == AUDIT_DISABLED)
 		return 0;
 
-	printk(KERN_INFO "audit: initializing netlink socket (%s)\n",
+	pr_info("audit: initializing netlink subsys (%s)\n",
 	       audit_default ? "enabled" : "disabled");
-	audit_sock = netlink_kernel_create(&init_net, NETLINK_AUDIT, &cfg);
-	if (!audit_sock)
-		audit_panic("cannot initialize netlink socket");
-	else
-		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
+	register_pernet_subsys(&audit_net_ops);
 
 	skb_queue_head_init(&audit_skb_queue);
 	skb_queue_head_init(&audit_skb_hold_queue);
diff --git a/kernel/audit.h b/kernel/audit.h
index 123c9b7..b7cc537 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -249,6 +249,10 @@ struct audit_netlink_list {
 
 int audit_send_list(void *);
 
+struct audit_net {
+	struct sock *nlsk;
+};
+
 extern int selinux_audit_rule_update(void);
 
 extern struct mutex audit_filter_mutex;
-- 
1.7.1

