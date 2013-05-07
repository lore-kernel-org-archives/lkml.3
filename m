Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab3EGCTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:19:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760000Ab3EGCTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201751"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 05/48] Audit: make audit_skb_hold_queue per user namespace
Date: Tue, 7 May 2013 10:20:26 +0800
Message-Id: <1367893269-9308-6-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:26,
	Serialize complete at 2013/05/07 10:18:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch, ervery user namespace has one
audit_skb_hold_queue. Since we havn't finish the
preparations, only allow user to operate the skb
hold queue of init user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  1 +
 kernel/audit.c                 | 16 +++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index e322f20..53420a4 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -22,6 +22,7 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 struct audit_ctrl {
 	struct sock		*sock;
 	struct sk_buff_head	queue;
+	struct sk_buff_head	hold_queue;
 };
 #endif
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 2a727af..61562c5 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -129,8 +129,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-/* queue of skbs to send to auditd when/if it comes back */
-static struct sk_buff_head audit_skb_hold_queue;
 static struct task_struct *kauditd_task;
 static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
@@ -370,9 +368,11 @@ static int audit_set_failure(int state, kuid_t loginuid, u32 sessionid, u32 sid)
  */
 static void audit_hold_skb(struct sk_buff *skb)
 {
+	struct sk_buff_head *list = &init_user_ns.audit.hold_queue;
+
 	if (audit_default &&
-	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
-		skb_queue_tail(&audit_skb_hold_queue, skb);
+	    skb_queue_len(list) < audit_backlog_limit)
+		skb_queue_tail(list, skb);
 	else
 		kfree_skb(skb);
 }
@@ -419,6 +419,7 @@ static int kauditd_thread(void *dummy)
 {
 	struct sk_buff *skb;
 	struct sk_buff_head *queue = &init_user_ns.audit.queue;
+	struct sk_buff_head *hold_queue = &init_user_ns.audit.hold_queue;
 
 	set_freezable();
 	while (!kthread_should_stop()) {
@@ -436,11 +437,11 @@ static int kauditd_thread(void *dummy)
 		 * note and still have no friggin idea what i'm thinking today.
 		 */
 		if (audit_default && audit_pid) {
-			skb = skb_dequeue(&audit_skb_hold_queue);
+			skb = skb_dequeue(hold_queue);
 			if (unlikely(skb)) {
 				while (skb && audit_pid) {
 					kauditd_send_skb(skb);
-					skb = skb_dequeue(&audit_skb_hold_queue);
+					skb = skb_dequeue(hold_queue);
 				}
 			}
 		}
@@ -998,7 +999,6 @@ static int __init audit_init(void)
 		return -1;
 
 	audit_set_user_ns(&init_user_ns);
-	skb_queue_head_init(&audit_skb_hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
@@ -1599,6 +1599,7 @@ void audit_set_user_ns(struct user_namespace *ns)
 		return;
 
 	skb_queue_head_init(&ns->audit.queue);
+	skb_queue_head_init(&ns->audit.hold_queue);
 }
 
 void audit_free_user_ns(struct user_namespace *ns)
@@ -1613,6 +1614,7 @@ void audit_free_user_ns(struct user_namespace *ns)
 	}
 
 	skb_queue_purge(&ns->audit.queue);
+	skb_queue_purge(&ns->audit.hold_queue);
 }
 
 EXPORT_SYMBOL(audit_log_start);
-- 
1.8.1.4

