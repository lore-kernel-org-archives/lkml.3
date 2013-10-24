Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3JXHbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:31:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab3JXHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:03 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847741"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 08/20] audit: make kaudit_wait queue per audit namespace
Date: Thu, 24 Oct 2013 15:31:53 +0800
Message-Id: <1382599925-25143-9-git-send-email-gaofeng@cn.fujitsu.com>
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

kauditd_task is added to the wait queue kaudit_wait when
there is no audit message being generated in audit namespace,
so the kaudit_wait should be per audit namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit_namespace.h | 2 ++
 kernel/audit.c                  | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
index a9e6a40..2888238 100644
--- a/include/linux/audit_namespace.h
+++ b/include/linux/audit_namespace.h
@@ -4,6 +4,7 @@
 #include <linux/audit.h>
 #include <linux/atomic.h>
 #include <linux/slab.h>
+#include <linux/wait.h>
 #include <linux/skbuff.h>
 #include <linux/user_namespace.h>
 
@@ -18,6 +19,7 @@ struct audit_namespace {
 	/* queue of skbs to send to auditd when/if it comes back */
 	struct sk_buff_head hold_queue;
 	struct task_struct *kauditd_task;
+	wait_queue_head_t kauditd_wait;
 };
 
 extern struct audit_namespace init_audit_ns;
diff --git a/kernel/audit.c b/kernel/audit.c
index 37375fb..a4bfd7f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -126,7 +126,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
 
 /* Serialize requests from userspace. */
@@ -453,7 +452,7 @@ static int kauditd_thread(void *dummy)
 			continue;
 		}
 		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&kauditd_wait, &wait);
+		add_wait_queue(&init_audit_ns.kauditd_wait, &wait);
 
 		if (!skb_queue_len(&ns->queue)) {
 			try_to_freeze();
@@ -461,7 +460,7 @@ static int kauditd_thread(void *dummy)
 		}
 
 		__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&kauditd_wait, &wait);
+		remove_wait_queue(&init_audit_ns.kauditd_wait, &wait);
 	}
 
 	ns->kauditd_task = NULL;
@@ -941,6 +940,7 @@ static int __init audit_init(void)
 	init_audit_ns.kauditd_task = NULL;
 	skb_queue_head_init(&init_audit_ns.queue);
 	skb_queue_head_init(&init_audit_ns.hold_queue);
+	init_waitqueue_head(&init_audit_ns.kauditd_wait);
 	audit_initialized = AUDIT_INITIALIZED;
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
@@ -1706,7 +1706,7 @@ void audit_log_end(struct audit_buffer *ab)
 
 		if (init_audit_ns.pid) {
 			skb_queue_tail(&init_audit_ns.queue, ab->skb);
-			wake_up_interruptible(&kauditd_wait);
+			wake_up_interruptible(&init_audit_ns.kauditd_wait);
 		} else {
 			audit_printk_skb(ab->skb);
 		}
-- 
1.8.3.1

