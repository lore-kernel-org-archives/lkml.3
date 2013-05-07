Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab3EGC3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:29:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab3EGCT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201763"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 17/48] Audit: make kauditd_wait per user namespace
Date: Tue, 7 May 2013 10:20:38 +0800
Message-Id: <1367893269-9308-18-git-send-email-gaofeng@cn.fujitsu.com>
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

kauditd_task is added to the wait queue kaudit_wait when
there is no audit message being generated in user namespace,
so the kaudit_wait should be per user namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h | 1 +
 kernel/audit.c                 | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index c7b5bf7..7c2c65c 100644
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
index f5e106f..ad03f4f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -117,7 +117,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
 
 /* Serialize requests from userspace. */
@@ -454,7 +453,7 @@ static int kauditd_thread(void *dummy)
 		} else {
 			DECLARE_WAITQUEUE(wait, current);
 			set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue(&kauditd_wait, &wait);
+			add_wait_queue(&ns->audit.kauditd_wait, &wait);
 
 			if (!skb_queue_len(queue)) {
 				try_to_freeze();
@@ -462,7 +461,7 @@ static int kauditd_thread(void *dummy)
 			}
 
 			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&kauditd_wait, &wait);
+			remove_wait_queue(&ns->audit.kauditd_wait, &wait);
 		}
 	}
 	return 0;
@@ -1528,7 +1527,7 @@ void audit_log_end(struct audit_buffer *ab)
 		if (init_user_ns.audit.pid) {
 			skb_queue_tail(&init_user_ns.audit.queue,
 				       ab->skb);
-			wake_up_interruptible(&kauditd_wait);
+			wake_up_interruptible(&init_user_ns.audit.kauditd_wait);
 		} else {
 			audit_printk_skb(&init_user_ns, ab->skb);
 		}
@@ -1599,6 +1598,7 @@ void audit_set_user_ns(struct user_namespace *ns)
 	skb_queue_head_init(&ns->audit.hold_queue);
 	ns->audit.enabled = audit_default;
 	ns->audit.ever_enabled |= !!audit_default;
+	init_waitqueue_head(&ns->audit.kauditd_wait);
 
 	ns->audit.initialized = AUDIT_INITIALIZED;
 }
-- 
1.8.1.4

