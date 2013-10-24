Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3JXHe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:34:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab3JXHbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:05 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847745"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 04/20] audit: make audit_skb_hold_queue per audit namespace
Date: Thu, 24 Oct 2013 15:31:49 +0800
Message-Id: <1382599925-25143-5-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:29,
	Serialize complete at 2013/10/24 15:28:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes audit_skb_hold_queue per audit namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h |  3 +++
 kernel/audit.c                  | 12 +++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index 65acab1..9b7b4c5 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -11,6 +11,8 @@ struct audit_namespace {
 	atomic_t count;
 	struct user_namespace *user_ns;
 	struct sk_buff_head queue;
+	/* queue of skbs to send to auditd when/if it comes back */
+	struct sk_buff_head hold_queue;
 };
 
 extern struct audit_namespace init_audit_ns;
@@ -29,6 +31,7 @@ void put_audit_ns(struct audit_namespace *ns)
 	if (atomic_dec_and_test(&ns->count)) {
 		put_user_ns(ns->user_ns);
 		skb_queue_purge(&ns->queue);
+		skb_queue_purge(&ns->hold_queue);
 		kfree(ns);
 	}
 }
diff --git a/kernel/audit.c b/kernel/audit.c
index f3c2150..51ee701 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -134,8 +134,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-/* queue of skbs to send to auditd when/if it comes back */
-static struct sk_buff_head audit_skb_hold_queue;
 static struct task_struct *kauditd_task;
 static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
@@ -355,8 +353,8 @@ static int audit_set_failure(int state)
 static void audit_hold_skb(struct sk_buff *skb)
 {
 	if (audit_default &&
-	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
-		skb_queue_tail(&audit_skb_hold_queue, skb);
+	    skb_queue_len(&init_audit_ns.hold_queue) < audit_backlog_limit)
+		skb_queue_tail(&init_audit_ns.hold_queue, skb);
 	else
 		kfree_skb(skb);
 }
@@ -420,13 +418,13 @@ static void flush_hold_queue(void)
 	if (!audit_default || !audit_pid)
 		return;
 
-	skb = skb_dequeue(&audit_skb_hold_queue);
+	skb = skb_dequeue(&init_audit_ns.hold_queue);
 	if (likely(!skb))
 		return;
 
 	while (skb && audit_pid) {
 		kauditd_send_skb(skb);
-		skb = skb_dequeue(&audit_skb_hold_queue);
+		skb = skb_dequeue(&init_audit_ns.hold_queue);
 	}
 
 	/*
@@ -912,7 +910,7 @@ static int __init audit_init(void)
 		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 
 	skb_queue_head_init(&init_audit_ns.queue);
-	skb_queue_head_init(&audit_skb_hold_queue);
+	skb_queue_head_init(&init_audit_ns.hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
-- 
1.8.3.1

