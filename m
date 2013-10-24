Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3JXHeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:34:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab3JXHbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:05 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847747"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 09/20] audit: make audit_backlog_wait per audit namespace
Date: Thu, 24 Oct 2013 15:31:54 +0800
Message-Id: <1382599925-25143-10-git-send-email-gaofeng@cn.fujitsu.com>
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

Tasks are added to audit_backlog_wait when the
audit_skb_queue of audit namespace is full, so
audit_backlog_wait should be per audit namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h |  1 +
 kernel/audit.c                  | 11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index 2888238..79a9b78 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -20,6 +20,7 @@ struct audit_namespace {
 	struct sk_buff_head hold_queue;
 	struct task_struct *kauditd_task;
 	wait_queue_head_t kauditd_wait;
+	wait_queue_head_t backlog_wait;
 };
 
 extern struct audit_namespace init_audit_ns;
diff --git a/kernel/audit.c b/kernel/audit.c
index a4bfd7f..d7a0993 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -126,8 +126,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
-
 /* Serialize requests from userspace. */
 DEFINE_MUTEX(audit_cmd_mutex);
 
@@ -443,7 +441,7 @@ static int kauditd_thread(void *dummy)
 		flush_hold_queue(ns);
 
 		skb = skb_dequeue(&ns->queue);
-		wake_up(&audit_backlog_wait);
+		wake_up(&init_audit_ns.backlog_wait);
 		if (skb) {
 			if (ns->pid)
 				kauditd_send_skb(skb);
@@ -941,6 +939,7 @@ static int __init audit_init(void)
 	skb_queue_head_init(&init_audit_ns.queue);
 	skb_queue_head_init(&init_audit_ns.hold_queue);
 	init_waitqueue_head(&init_audit_ns.kauditd_wait);
+	init_waitqueue_head(&init_audit_ns.backlog_wait);
 	audit_initialized = AUDIT_INITIALIZED;
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
@@ -1091,14 +1090,14 @@ static void wait_for_auditd(unsigned long sleep_time)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
+	add_wait_queue(&init_audit_ns.backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
 	    skb_queue_len(&init_audit_ns.queue) > audit_backlog_limit)
 		schedule_timeout(sleep_time);
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&audit_backlog_wait, &wait);
+	remove_wait_queue(&init_audit_ns.backlog_wait, &wait);
 }
 
 /* Obtain an audit buffer.  This routine does locking to obtain the
@@ -1164,7 +1163,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			       audit_backlog_limit);
 		audit_log_lost("backlog limit exceeded");
 		audit_backlog_wait_time = audit_backlog_wait_overflow;
-		wake_up(&audit_backlog_wait);
+		wake_up(&init_audit_ns.backlog_wait);
 		return NULL;
 	}
 
-- 
1.8.3.1

