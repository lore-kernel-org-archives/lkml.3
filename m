Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab3ICEt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 00:49:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759356Ab3ICEtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 00:49:00 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, dan.duval@oracle.com,
        akpm@linux-foundation.org, rgb@redhat.com, oleg@redhat.com,
        chuck.anderson@oracle.com
Subject: [PATCH 1/2] audit: flush_hold_queue(): don't drop queued SKBs
Date: Tue,  3 Sep 2013 00:48:54 -0400
Message-Id: <1378183735-19338-2-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
References: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

flush_hold_queue() first dequeues an SKB and then checks if
auditd exists. If auditd doesn't exist, the SKB is silently
dropped.

Avoid this by not dequeing an SKB when we detected that
auditd disappeared.

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 kernel/audit.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..475c1d1 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -380,7 +380,7 @@ static void audit_printk_skb(struct sk_buff *skb)
 	audit_hold_skb(skb);
 }
 
-static void kauditd_send_skb(struct sk_buff *skb)
+static int kauditd_send_skb(struct sk_buff *skb)
 {
 	int err;
 	/* take a reference in case we can't send it and we want to hold it */
@@ -393,9 +393,12 @@ static void kauditd_send_skb(struct sk_buff *skb)
 		audit_pid = 0;
 		/* we might get lucky and get this in the next auditd */
 		audit_hold_skb(skb);
+		return err;
 	} else
 		/* drop the extra reference if sent ok */
 		consume_skb(skb);
+
+	return 0;
 }
 
 /*
@@ -416,6 +419,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
 static void flush_hold_queue(void)
 {
 	struct sk_buff *skb;
+	int err;
 
 	if (!audit_default || !audit_pid)
 		return;
@@ -424,17 +428,12 @@ static void flush_hold_queue(void)
 	if (likely(!skb))
 		return;
 
-	while (skb && audit_pid) {
-		kauditd_send_skb(skb);
+	while (skb) {
+		err = kauditd_send_skb(skb);
+		if (err)
+			break;
 		skb = skb_dequeue(&audit_skb_hold_queue);
 	}
-
-	/*
-	 * if auditd just disappeared but we
-	 * dequeued an skb we need to drop ref
-	 */
-	if (skb)
-		consume_skb(skb);
 }
 
 static int kauditd_thread(void *dummy)
-- 
1.8.1.4

