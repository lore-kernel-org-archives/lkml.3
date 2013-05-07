Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab3EGCav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:30:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760080Ab3EGCT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201762"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 18/48] Audit: make audit_backlog_wait per user namespace
Date: Tue, 7 May 2013 10:20:39 +0800
Message-Id: <1367893269-9308-19-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize complete at 2013/05/07 10:18:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tasks are added to audit_backlog_wait when the
audit_skb_queue of user namespace is full, so
audit_backlog_wait should be per user namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  1 +
 kernel/audit.c                 | 11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 7c2c65c..5a778f8 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -29,6 +29,7 @@ struct audit_ctrl {
 	struct sk_buff_head	hold_queue;
 	struct task_struct	*kauditd_task;
 	wait_queue_head_t	kauditd_wait;
+	wait_queue_head_t	backlog_wait;
 	bool			ever_enabled;
 };
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index ad03f4f..62f244b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -117,8 +117,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
-
 /* Serialize requests from userspace. */
 DEFINE_MUTEX(audit_cmd_mutex);
 
@@ -444,7 +442,7 @@ static int kauditd_thread(void *dummy)
 		}
 
 		skb = skb_dequeue(queue);
-		wake_up(&audit_backlog_wait);
+		wake_up(&ns->audit.backlog_wait);
 		if (skb) {
 			if (ns->audit.pid)
 				kauditd_send_skb(ns, skb);
@@ -1146,14 +1144,14 @@ static void wait_for_auditd(unsigned long sleep_time)
 	const struct sk_buff_head *queue = &init_user_ns.audit.queue;
 	DECLARE_WAITQUEUE(wait, current);
 	set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
+	add_wait_queue(&init_user_ns.audit.backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
 	    skb_queue_len(queue) > audit_backlog_limit)
 		schedule_timeout(sleep_time);
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&audit_backlog_wait, &wait);
+	remove_wait_queue(&init_user_ns.audit.backlog_wait, &wait);
 }
 
 /* Obtain an audit buffer.  This routine does locking to obtain the
@@ -1219,7 +1217,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			       audit_backlog_limit);
 		audit_log_lost("backlog limit exceeded");
 		audit_backlog_wait_time = audit_backlog_wait_overflow;
-		wake_up(&audit_backlog_wait);
+		wake_up(&init_user_ns.audit.backlog_wait);
 		return NULL;
 	}
 
@@ -1599,6 +1597,7 @@ void audit_set_user_ns(struct user_namespace *ns)
 	ns->audit.enabled = audit_default;
 	ns->audit.ever_enabled |= !!audit_default;
 	init_waitqueue_head(&ns->audit.kauditd_wait);
+	init_waitqueue_head(&ns->audit.backlog_wait);
 
 	ns->audit.initialized = AUDIT_INITIALIZED;
 }
-- 
1.8.1.4

