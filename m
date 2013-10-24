Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3JXHbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:31:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab3JXHbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:06 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847748"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 07/20] aduit: make audit_nlk_portid per audit namespace
Date: Thu, 24 Oct 2013 15:31:52 +0800
Message-Id: <1382599925-25143-8-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:29,
	Serialize complete at 2013/10/24 15:28:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use audit_nlk_portid to decide to send
audit netlink message to which auditd processes.
it should be per audit namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h |  2 ++
 kernel/audit.c                  | 14 ++++----------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index 2c0eede..a9e6a40 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -11,6 +11,8 @@ struct audit_namespace {
 	atomic_t count;
 	/* pid of the auditd process */
 	int pid;
+	/* portid of the auditd process's netlink socket */
+	int portid;
 	struct user_namespace *user_ns;
 	struct sk_buff_head queue;
 	/* queue of skbs to send to auditd when/if it comes back */
diff --git a/kernel/audit.c b/kernel/audit.c
index ceb1cbd..37375fb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -89,13 +89,6 @@ static int	audit_default;
 /* If auditing cannot proceed, audit_failure selects what happens. */
 static int	audit_failure = AUDIT_FAIL_PRINTK;
 
-/*
- * If audit records are to be written to the netlink socket, audit_pid
- * contains the pid of the auditd process and audit_nlk_portid contains
- * the portid to use to send netlink messages to that process.
- */
-static int	audit_nlk_portid;
-
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
  * to that number per second.  This prevents DoS attacks, but results in
  * audit records being dropped. */
@@ -381,7 +374,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
 	int err;
 	/* take a reference in case we can't send it and we want to hold it */
 	skb_get(skb);
-	err = netlink_unicast(audit_sock, skb, audit_nlk_portid, 0);
+	err = netlink_unicast(audit_sock, skb, init_audit_ns.portid, 0);
 	if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", init_audit_ns.pid);
@@ -645,7 +638,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
 	char			*ctx = NULL;
-	struct audit_namespace	*ns = current_audit_ns();
+	struct audit_namespace	*ns = current->nsproxy->audit_ns;
 	u32			len;
 
 	err = audit_netlink_ok(skb, msg_type);
@@ -721,7 +714,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			init_audit_ns.pid = new_pid;
 			rcu_read_unlock();
 
-			audit_nlk_portid = NETLINK_CB(skb).portid;
+			init_audit_ns.portid = NETLINK_CB(skb).portid;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(status_get->rate_limit);
@@ -944,6 +937,7 @@ static int __init audit_init(void)
 		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 
 	init_audit_ns.pid = 0;
+	init_audit_ns.portid = 0;
 	init_audit_ns.kauditd_task = NULL;
 	skb_queue_head_init(&init_audit_ns.queue);
 	skb_queue_head_init(&init_audit_ns.hold_queue);
-- 
1.8.3.1

