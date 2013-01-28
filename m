Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3A1Dqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:46:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3A1Dqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:46:52 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Richard Guy Briggs <rbriggs@redhat.com>
Subject: [PATCH 1/6] audit: refactor hold queue flush
Date: Sun, 27 Jan 2013 22:45:13 -0500
Message-Id: <1359344718-3953-2-git-send-email-rbriggs@redhat.com>
In-Reply-To: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
References: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

The hold queue flush code is an autonomous chunk of code that can be
refactored, removed from kauditd_thread() into flush_hold_queue() and
flattenned for better legibility.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
---

This is a code clean up in preparation to add a multicast netlink socket to
kaudit for read-only userspace clients such as systemd, in addition to the
bidirectional audit userspace client.

 kernel/audit.c | 62 +++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d596e53..4bf486c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -417,34 +417,52 @@ static void kauditd_send_skb(struct sk_buff *skb)
 		consume_skb(skb);
 }
 
+/*
+ * flush_hold_queue - empty the hold queue if auditd appears
+ *
+ * If auditd just started, drain the queue of messages already
+ * sent to syslog/printk.  Remember loss here is ok.  We already
+ * called audit_log_lost() if it didn't go out normally.  so the
+ * race between the skb_dequeue and the next check for audit_pid
+ * doesn't matter.
+ *
+ * If you ever find kauditd to be too slow we can get a perf win
+ * by doing our own locking and keeping better track if there
+ * are messages in this queue.  I don't see the need now, but
+ * in 5 years when I want to play with this again I'll see this
+ * note and still have no friggin idea what i'm thinking today.
+ */
+static void flush_hold_queue(void)
+{
+	struct sk_buff *skb;
+
+	if (!audit_default || !audit_pid)
+		return;
+
+	skb = skb_dequeue(&audit_skb_hold_queue);
+	if (likely(!skb))
+		return;
+
+	while (skb && audit_pid) {
+		kauditd_send_skb(skb);
+		skb = skb_dequeue(&audit_skb_hold_queue);
+	}
+
+	/*
+	 * if auditd just disappeared but we
+	 * dequeued an skb we need to drop ref
+	 */
+	if (skb)
+		consume_skb(skb);
+}
+
 static int kauditd_thread(void *dummy)
 {
 	struct sk_buff *skb;
 
 	set_freezable();
 	while (!kthread_should_stop()) {
-		/*
-		 * if auditd just started drain the queue of messages already
-		 * sent to syslog/printk.  remember loss here is ok.  we already
-		 * called audit_log_lost() if it didn't go out normally.  so the
-		 * race between the skb_dequeue and the next check for audit_pid
-		 * doesn't matter.
-		 *
-		 * if you ever find kauditd to be too slow we can get a perf win
-		 * by doing our own locking and keeping better track if there
-		 * are messages in this queue.  I don't see the need now, but
-		 * in 5 years when I want to play with this again I'll see this
-		 * note and still have no friggin idea what i'm thinking today.
-		 */
-		if (audit_default && audit_pid) {
-			skb = skb_dequeue(&audit_skb_hold_queue);
-			if (unlikely(skb)) {
-				while (skb && audit_pid) {
-					kauditd_send_skb(skb);
-					skb = skb_dequeue(&audit_skb_hold_queue);
-				}
-			}
-		}
+		flush_hold_queue();
 
 		skb = skb_dequeue(&audit_skb_queue);
 		wake_up(&audit_backlog_wait);
-- 
1.8.0.2

