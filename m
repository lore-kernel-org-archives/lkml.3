Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab3FSBx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:53:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934095Ab3FSBxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596300"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 17/22] Audit: make audit_backlog_wait per user namespace
Date: Wed, 19 Jun 2013 09:53:49 +0800
Message-Id: <1371606834-5802-18-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:02,
	Serialize complete at 2013/06/19 09:52:02
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
index 28938f3..c186a84 100644
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
index e3d7da7..3dcaa97 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -119,8 +119,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
-
 /* Serialize requests from userspace. */
 DEFINE_MUTEX(audit_cmd_mutex);
 
@@ -453,7 +451,7 @@ static int kauditd_thread(void *dummy)
 		flush_hold_queue(ns);
 
 		skb = skb_dequeue(queue);
-		wake_up(&audit_backlog_wait);
+		wake_up(&ns->audit.backlog_wait);
 		if (skb) {
 			if (ns->audit.pid && ns->audit.sock)
 				kauditd_send_skb(ns, skb);
@@ -1119,14 +1117,14 @@ static void wait_for_auditd(unsigned long sleep_time)
 	const struct sk_buff_head *queue = &init_user_ns.audit.queue;
 	DECLARE_WAITQUEUE(wait, current);
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
+	add_wait_queue(&init_user_ns.audit.backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
 	    skb_queue_len(queue) > audit_backlog_limit)
 		schedule_timeout(sleep_time);
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&audit_backlog_wait, &wait);
+	remove_wait_queue(&init_user_ns.audit.backlog_wait, &wait);
 }
 
 /**
@@ -1185,7 +1183,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			       audit_backlog_limit);
 		audit_log_lost("backlog limit exceeded");
 		audit_backlog_wait_time = audit_backlog_wait_overflow;
-		wake_up(&audit_backlog_wait);
+		wake_up(&init_user_ns.audit.backlog_wait);
 		return NULL;
 	}
 
@@ -1799,6 +1797,7 @@ void audit_set_user_ns(struct user_namespace *ns)
 	ns->audit.enabled = audit_default;
 	ns->audit.ever_enabled |= !!audit_default;
 	init_waitqueue_head(&ns->audit.kauditd_wait);
+	init_waitqueue_head(&ns->audit.backlog_wait);
 
 	ns->audit.initialized = AUDIT_INITIALIZED;
 }
-- 
1.8.1.4

