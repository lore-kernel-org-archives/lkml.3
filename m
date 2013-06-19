Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab3FSByM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:54:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934000Ab3FSBxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596287"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 07/22] Audit: make audit_skb_hold_queue per user namespace
Date: Wed, 19 Jun 2013 09:53:39 +0800
Message-Id: <1371606834-5802-8-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:00,
	Serialize complete at 2013/06/19 09:52:00
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
index e2f6366..75325f0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -131,8 +131,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-/* queue of skbs to send to auditd when/if it comes back */
-static struct sk_buff_head audit_skb_hold_queue;
 static struct task_struct *kauditd_task;
 static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
@@ -351,9 +349,11 @@ static int audit_set_failure(int state)
  */
 static void audit_hold_skb(struct sk_buff *skb)
 {
+	struct sk_buff_head *hold_queue = &init_user_ns.audit.hold_queue;
+
 	if (audit_default &&
-	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
-		skb_queue_tail(&audit_skb_hold_queue, skb);
+	    skb_queue_len(hold_queue) < audit_backlog_limit)
+		skb_queue_tail(hold_queue, skb);
 	else
 		kfree_skb(skb);
 }
@@ -414,17 +414,18 @@ static void kauditd_send_skb(struct sk_buff *skb)
 static void flush_hold_queue(void)
 {
 	struct sk_buff *skb;
+	struct sk_buff_head *hold_queue = &init_user_ns.audit.hold_queue;
 
 	if (!audit_default || !audit_pid || !init_user_ns.audit.sock)
 		return;
 
-	skb = skb_dequeue(&audit_skb_hold_queue);
+	skb = skb_dequeue(hold_queue);
 	if (likely(!skb))
 		return;
 
 	while (skb && audit_pid) {
 		kauditd_send_skb(skb);
-		skb = skb_dequeue(&audit_skb_hold_queue);
+		skb = skb_dequeue(hold_queue);
 	}
 
 	/*
@@ -956,7 +957,6 @@ static int __init audit_init(void)
 		return -1;
 
 	audit_set_user_ns(&init_user_ns);
-	skb_queue_head_init(&audit_skb_hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
@@ -1784,6 +1784,7 @@ void audit_set_user_ns(struct user_namespace *ns)
 		return;
 
 	skb_queue_head_init(&ns->audit.queue);
+	skb_queue_head_init(&ns->audit.hold_queue);
 }
 
 void audit_free_user_ns(struct user_namespace *ns)
@@ -1798,6 +1799,7 @@ void audit_free_user_ns(struct user_namespace *ns)
 	}
 
 	skb_queue_purge(&ns->audit.queue);
+	skb_queue_purge(&ns->audit.hold_queue);
 }
 
 EXPORT_SYMBOL(audit_log_start);
-- 
1.8.1.4

