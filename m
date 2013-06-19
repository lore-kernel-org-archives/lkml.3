Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191Ab3FSBxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:53:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934090Ab3FSBxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596295"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 16/22] Audit: make kauditd_wait per user namespace
Date: Wed, 19 Jun 2013 09:53:48 +0800
Message-Id: <1371606834-5802-17-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:01,
	Serialize complete at 2013/06/19 09:52:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kauditd_task is added to the wait queue kaudit_wait when
there is no audit message being generated in user namespace,
so the kaudit_wait should be per user namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  1 +
 kernel/audit.c                 | 36 ++++++++++++++++++------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index c665569..28938f3 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -28,6 +28,7 @@ struct audit_ctrl {
 	struct sk_buff_head	queue;
 	struct sk_buff_head	hold_queue;
 	struct task_struct	*kauditd_task;
+	wait_queue_head_t	kauditd_wait;
 	bool			ever_enabled;
 };
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index 297ac6e..e3d7da7 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -119,7 +119,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
 
 /* Serialize requests from userspace. */
@@ -345,9 +344,9 @@ static int audit_set_failure(int state)
  * This only holds messages is audit_default is set, aka booting with audit=1
  * or building your kernel that way.
  */
-static void audit_hold_skb(struct sk_buff *skb)
+static void audit_hold_skb(struct user_namespace *ns, struct sk_buff *skb)
 {
-	struct sk_buff_head *hold_queue = &init_user_ns.audit.hold_queue;
+	struct sk_buff_head *hold_queue = &ns->audit.hold_queue;
 
 	if (audit_default &&
 	    skb_queue_len(hold_queue) < audit_backlog_limit)
@@ -360,7 +359,7 @@ static void audit_hold_skb(struct sk_buff *skb)
  * For one reason or another this nlh isn't getting delivered to the userspace
  * audit daemon, just send it to printk.
  */
-static void audit_printk_skb(struct sk_buff *skb)
+static void audit_printk_skb(struct user_namespace *ns, struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(skb);
 	char *data = nlmsg_data(nlh);
@@ -372,24 +371,24 @@ static void audit_printk_skb(struct sk_buff *skb)
 			audit_log_lost("printk limit exceeded\n");
 	}
 
-	audit_hold_skb(skb);
+	audit_hold_skb(ns, skb);
 }
 
-static void kauditd_send_skb(struct sk_buff *skb)
+static void kauditd_send_skb(struct user_namespace *ns, struct sk_buff *skb)
 {
 	int err;
 	/* take a reference in case we can't send it and we want to hold it */
 	skb_get(skb);
-	err = netlink_unicast(init_user_ns.audit.sock, skb,
-			      init_user_ns.audit.portid, 0);
+	err = netlink_unicast(ns->audit.sock, skb,
+			      ns->audit.portid, 0);
 	if (err < 0) {
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n",
-		       init_user_ns.audit.pid);
+		       ns->audit.pid);
 		audit_log_lost("auditd disappeared\n");
-		init_user_ns.audit.pid = 0;
+		ns->audit.pid = 0;
 		/* we might get lucky and get this in the next auditd */
-		audit_hold_skb(skb);
+		audit_hold_skb(ns, skb);
 	} else
 		/* drop the extra reference if sent ok */
 		consume_skb(skb);
@@ -423,7 +422,7 @@ static void flush_hold_queue(struct user_namespace *ns)
 		return;
 
 	while (skb && ns->audit.pid) {
-		kauditd_send_skb(skb);
+		kauditd_send_skb(ns, skb);
 		skb = skb_dequeue(hold_queue);
 	}
 
@@ -457,13 +456,13 @@ static int kauditd_thread(void *dummy)
 		wake_up(&audit_backlog_wait);
 		if (skb) {
 			if (ns->audit.pid && ns->audit.sock)
-				kauditd_send_skb(skb);
+				kauditd_send_skb(ns, skb);
 			else
-				audit_printk_skb(skb);
+				audit_printk_skb(ns, skb);
 			continue;
 		}
 		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&kauditd_wait, &wait);
+		add_wait_queue(&ns->audit.kauditd_wait, &wait);
 
 		if (!skb_queue_len(queue)) {
 			try_to_freeze();
@@ -471,7 +470,7 @@ static int kauditd_thread(void *dummy)
 		}
 
 		__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&kauditd_wait, &wait);
+		remove_wait_queue(&ns->audit.kauditd_wait, &wait);
 	}
 
 	put_user_ns(ns);
@@ -1728,9 +1727,9 @@ void audit_log_end(struct audit_buffer *ab)
 
 		if (init_user_ns.audit.pid && init_user_ns.audit.sock) {
 			skb_queue_tail(&init_user_ns.audit.queue, ab->skb);
-			wake_up_interruptible(&kauditd_wait);
+			wake_up_interruptible(&init_user_ns.audit.kauditd_wait);
 		} else {
-			audit_printk_skb(ab->skb);
+			audit_printk_skb(&init_user_ns, ab->skb);
 		}
 		ab->skb = NULL;
 	}
@@ -1799,6 +1798,7 @@ void audit_set_user_ns(struct user_namespace *ns)
 	skb_queue_head_init(&ns->audit.hold_queue);
 	ns->audit.enabled = audit_default;
 	ns->audit.ever_enabled |= !!audit_default;
+	init_waitqueue_head(&ns->audit.kauditd_wait);
 
 	ns->audit.initialized = AUDIT_INITIALIZED;
 }
-- 
1.8.1.4

