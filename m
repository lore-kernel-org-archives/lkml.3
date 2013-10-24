Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3JXHgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:36:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab3JXHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:04 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847742"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 06/20] audit: make kauditd_task per audit namespace
Date: Thu, 24 Oct 2013 15:31:51 +0800
Message-Id: <1382599925-25143-7-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:28,
	Serialize complete at 2013/10/24 15:28:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kauditd_task is used to send audit netlink messages
to the user space auditd process. Because the netlink
messages are per audit namespace, we should make
kaudit_task per auditns to operate the right netlink
skb.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h | 12 +++++++++++
 kernel/audit.c                  | 47 +++++++++++++++++++++++++++--------------
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index fdbb6c1..2c0eede 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -15,6 +15,7 @@ struct audit_namespace {
 	struct sk_buff_head queue;
 	/* queue of skbs to send to auditd when/if it comes back */
 	struct sk_buff_head hold_queue;
+	struct task_struct *kauditd_task;
 };
 
 extern struct audit_namespace init_audit_ns;
@@ -35,6 +36,17 @@ void put_audit_ns(struct audit_namespace *ns)
 		skb_queue_purge(&ns->queue);
 		skb_queue_purge(&ns->hold_queue);
 		kfree(ns);
+	} else if (atomic_read(&ns->count) == 1) {
+		/* If the last user of audit namespace is kauditd,
+		 * we should wake up kauditd and let it kill itself,
+		 * Then this audit namespace will be destroyed. */
+		struct task_struct *task;
+
+		rcu_read_lock();
+		task = ACCESS_ONCE(ns->kauditd_task);
+		if (task)
+			wake_up_process(task);
+		rcu_read_unlock();
 	}
 }
 #else
diff --git a/kernel/audit.c b/kernel/audit.c
index e5e8cb1..ceb1cbd 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -133,7 +133,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static struct task_struct *kauditd_task;
 static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
 
@@ -410,20 +409,20 @@ static void kauditd_send_skb(struct sk_buff *skb)
  * in 5 years when I want to play with this again I'll see this
  * note and still have no friggin idea what i'm thinking today.
  */
-static void flush_hold_queue(void)
+static void flush_hold_queue(struct audit_namespace *ns)
 {
 	struct sk_buff *skb;
 
-	if (!audit_default || !init_audit_ns.pid)
+	if (!audit_default || !ns->pid)
 		return;
 
-	skb = skb_dequeue(&init_audit_ns.hold_queue);
+	skb = skb_dequeue(&ns->hold_queue);
 	if (likely(!skb))
 		return;
 
-	while (skb && init_audit_ns.pid) {
+	while (skb && ns->pid) {
 		kauditd_send_skb(skb);
-		skb = skb_dequeue(&init_audit_ns.hold_queue);
+		skb = skb_dequeue(&ns->hold_queue);
 	}
 
 	/*
@@ -436,17 +435,25 @@ static void flush_hold_queue(void)
 
 static int kauditd_thread(void *dummy)
 {
+	struct audit_namespace *ns = (struct audit_namespace *)dummy;
+
 	set_freezable();
 	while (!kthread_should_stop()) {
 		struct sk_buff *skb;
 		DECLARE_WAITQUEUE(wait, current);
 
-		flush_hold_queue();
+		/* Ok, We are the last user of this audit namespace,
+		 * it's time to go. Kill kauditd thread and release
+		 * the audit namespace. */
+		if (atomic_read(&ns->count) == 1)
+			break;
+
+		flush_hold_queue(ns);
 
-		skb = skb_dequeue(&init_audit_ns.queue);
+		skb = skb_dequeue(&ns->queue);
 		wake_up(&audit_backlog_wait);
 		if (skb) {
-			if (init_audit_ns.pid)
+			if (ns->pid)
 				kauditd_send_skb(skb);
 			else
 				audit_printk_skb(skb);
@@ -455,7 +462,7 @@ static int kauditd_thread(void *dummy)
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&kauditd_wait, &wait);
 
-		if (!skb_queue_len(&init_audit_ns.queue)) {
+		if (!skb_queue_len(&ns->queue)) {
 			try_to_freeze();
 			schedule();
 		}
@@ -463,6 +470,9 @@ static int kauditd_thread(void *dummy)
 		__set_current_state(TASK_RUNNING);
 		remove_wait_queue(&kauditd_wait, &wait);
 	}
+
+	ns->kauditd_task = NULL;
+	put_audit_ns(ns);
 	return 0;
 }
 
@@ -635,6 +645,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u16			msg_type = nlh->nlmsg_type;
 	struct audit_sig_info   *sig_data;
 	char			*ctx = NULL;
+	struct audit_namespace	*ns = current_audit_ns();
 	u32			len;
 
 	err = audit_netlink_ok(skb, msg_type);
@@ -643,13 +654,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	/* As soon as there's any sign of userspace auditd,
 	 * start kauditd to talk to it */
-	if (!kauditd_task) {
-		kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
-		if (IS_ERR(kauditd_task)) {
-			err = PTR_ERR(kauditd_task);
-			kauditd_task = NULL;
-			return err;
+	if (!ns->kauditd_task) {
+		struct task_struct *tsk;
+		tsk = kthread_run(kauditd_thread,
+				  get_audit_ns(ns), "kauditd");
+		if (IS_ERR(tsk)) {
+			put_audit_ns(ns);
+			return PTR_ERR(tsk);
 		}
+
+		ns->kauditd_task = tsk;
 	}
 	seq  = nlh->nlmsg_seq;
 	data = nlmsg_data(nlh);
@@ -930,6 +944,7 @@ static int __init audit_init(void)
 		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 
 	init_audit_ns.pid = 0;
+	init_audit_ns.kauditd_task = NULL;
 	skb_queue_head_init(&init_audit_ns.queue);
 	skb_queue_head_init(&init_audit_ns.hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
-- 
1.8.3.1

