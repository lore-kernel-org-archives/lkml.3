Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3JXHgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:36:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab3JXHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:04 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847743"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 03/20] audit: make audit_skb_queue per audit namespace
Date: Thu, 24 Oct 2013 15:31:48 +0800
Message-Id: <1382599925-25143-4-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:28,
	Serialize complete at 2013/10/24 15:28:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes audit_skb_queue per audit namespace,
Since we haven't finished the preparations, only
allow user to attach/detach skb to the queue of
init_audit_ns.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h |  3 +++
 kernel/audit.c                  | 18 +++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index ac22649..65acab1 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -4,11 +4,13 @@
 #include <linux/audit.h>
 #include <linux/atomic.h>
 #include <linux/slab.h>
+#include <linux/skbuff.h>
 #include <linux/user_namespace.h>
 
 struct audit_namespace {
 	atomic_t count;
 	struct user_namespace *user_ns;
+	struct sk_buff_head queue;
 };
 
 extern struct audit_namespace init_audit_ns;
@@ -26,6 +28,7 @@ void put_audit_ns(struct audit_namespace *ns)
 {
 	if (atomic_dec_and_test(&ns->count)) {
 		put_user_ns(ns->user_ns);
+		skb_queue_purge(&ns->queue);
 		kfree(ns);
 	}
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index 468950b..f3c2150 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -64,6 +64,7 @@
 #include <linux/freezer.h>
 #include <linux/tty.h>
 #include <linux/pid_namespace.h>
+#include <linux/audit_namespace.h>
 
 #include "audit.h"
 
@@ -133,7 +134,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static struct sk_buff_head audit_skb_queue;
 /* queue of skbs to send to auditd when/if it comes back */
 static struct sk_buff_head audit_skb_hold_queue;
 static struct task_struct *kauditd_task;
@@ -446,7 +446,7 @@ static int kauditd_thread(void *dummy)
 
 		flush_hold_queue();
 
-		skb = skb_dequeue(&audit_skb_queue);
+		skb = skb_dequeue(&init_audit_ns.queue);
 		wake_up(&audit_backlog_wait);
 		if (skb) {
 			if (audit_pid)
@@ -458,7 +458,7 @@ static int kauditd_thread(void *dummy)
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&kauditd_wait, &wait);
 
-		if (!skb_queue_len(&audit_skb_queue)) {
+		if (!skb_queue_len(&init_audit_ns.queue)) {
 			try_to_freeze();
 			schedule();
 		}
@@ -665,7 +665,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		status_set.rate_limit	 = audit_rate_limit;
 		status_set.backlog_limit = audit_backlog_limit;
 		status_set.lost		 = atomic_read(&audit_lost);
-		status_set.backlog	 = skb_queue_len(&audit_skb_queue);
+		status_set.backlog	 = skb_queue_len(&init_audit_ns.queue);
 		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
 				 &status_set, sizeof(status_set));
 		break;
@@ -911,7 +911,7 @@ static int __init audit_init(void)
 	else
 		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 
-	skb_queue_head_init(&audit_skb_queue);
+	skb_queue_head_init(&init_audit_ns.queue);
 	skb_queue_head_init(&audit_skb_hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
 	audit_enabled = audit_default;
@@ -1066,7 +1066,7 @@ static void wait_for_auditd(unsigned long sleep_time)
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
-	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
+	    skb_queue_len(&init_audit_ns.queue) > audit_backlog_limit)
 		schedule_timeout(sleep_time);
 
 	__set_current_state(TASK_RUNNING);
@@ -1117,7 +1117,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 				entries over the normal backlog limit */
 
 	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
+	       && skb_queue_len(&init_audit_ns.queue) > audit_backlog_limit + reserve) {
 		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
 			unsigned long sleep_time;
 
@@ -1132,7 +1132,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			printk(KERN_WARNING
 			       "audit: audit_backlog=%d > "
 			       "audit_backlog_limit=%d\n",
-			       skb_queue_len(&audit_skb_queue),
+			       skb_queue_len(&init_audit_ns.queue),
 			       audit_backlog_limit);
 		audit_log_lost("backlog limit exceeded");
 		audit_backlog_wait_time = audit_backlog_wait_overflow;
@@ -1677,7 +1677,7 @@ void audit_log_end(struct audit_buffer *ab)
 		nlh->nlmsg_len = ab->skb->len - NLMSG_HDRLEN;
 
 		if (audit_pid) {
-			skb_queue_tail(&audit_skb_queue, ab->skb);
+			skb_queue_tail(&init_audit_ns.queue, ab->skb);
 			wake_up_interruptible(&kauditd_wait);
 		} else {
 			audit_printk_skb(ab->skb);
-- 
1.8.3.1

