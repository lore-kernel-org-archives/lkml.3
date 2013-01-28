Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3A1DsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:48:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab3A1Dqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:46:53 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Richard Guy Briggs <rbriggs@redhat.com>
Subject: [PATCH 2/6] audit: flatten kauditd_thread wait queue code
Date: Sun, 27 Jan 2013 22:45:14 -0500
Message-Id: <1359344718-3953-3-git-send-email-rbriggs@redhat.com>
In-Reply-To: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
References: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

The wait queue control code in kauditd_thread() was nested deeper than
necessary.  The function has been flattened for better legibility.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
---

This is a code clean up in preparation to add a multicast netlink socket to
kaudit for read-only userspace clients such as systemd, in addition to the
bidirectional audit userspace client.

 kernel/audit.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4bf486c..1531efb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -458,10 +458,11 @@ static void flush_hold_queue(void)
 
 static int kauditd_thread(void *dummy)
 {
-	struct sk_buff *skb;
-
 	set_freezable();
 	while (!kthread_should_stop()) {
+		struct sk_buff *skb;
+		DECLARE_WAITQUEUE(wait, current);
+
 		flush_hold_queue();
 
 		skb = skb_dequeue(&audit_skb_queue);
@@ -471,19 +472,18 @@ static int kauditd_thread(void *dummy)
 				kauditd_send_skb(skb);
 			else
 				audit_printk_skb(skb);
-		} else {
-			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue(&kauditd_wait, &wait);
-
-			if (!skb_queue_len(&audit_skb_queue)) {
-				try_to_freeze();
-				schedule();
-			}
+			continue;
+		}
+		set_current_state(TASK_INTERRUPTIBLE);
+		add_wait_queue(&kauditd_wait, &wait);
 
-			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&kauditd_wait, &wait);
+		if (!skb_queue_len(&audit_skb_queue)) {
+			try_to_freeze();
+			schedule();
 		}
+
+		__set_current_state(TASK_RUNNING);
+		remove_wait_queue(&kauditd_wait, &wait);
 	}
 	return 0;
 }
-- 
1.8.0.2

