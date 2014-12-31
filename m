Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaLaM03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:26:29 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36596 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaM02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:26:28 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] audit: skip klog-fowarding if mcasts were sent
Date: Wed, 31 Dec 2014 13:20:50 +0100
Message-Id: <1420028450-25505-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently skip forwarding audit messages to the kernel-log if auditd is
running. However, if auditd is not running, but there are multicast
listeners, we still forward those messages to the kerne-log. This causes
generic log-daemons to get audit messages twice if auditd is not running.
Once via the multicast message, and once via the kernel-log. As the
kernel-log is much less convenient to parse, compared to netlink audit
messages, we'd like to avoid dropping netlink support again.

Therefore, this patch makes the audit infrastructure forward audit
messages only to the kernel-log if neither auditd nor a multicast
listener is present.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 kernel/audit.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 80983df..c087c6a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -429,14 +429,9 @@ static void kauditd_send_skb(struct sk_buff *skb)
  * This function doesn't consume an skb as might be expected since it has to
  * copy it anyways.
  */
-static void kauditd_send_multicast_skb(struct sk_buff *skb)
+static void kauditd_send_multicast_skb(struct sock *sock, struct sk_buff *skb)
 {
 	struct sk_buff		*copy;
-	struct audit_net	*aunet = net_generic(&init_net, audit_net_id);
-	struct sock		*sock = aunet->nlsk;
-
-	if (!netlink_has_listeners(sock, AUDIT_NLGRP_READLOG))
-		return;
 
 	/*
 	 * The seemingly wasteful skb_copy() rather than bumping the refcount
@@ -1947,9 +1942,14 @@ void audit_log_end(struct audit_buffer *ab)
 		audit_log_lost("rate limit exceeded");
 	} else {
 		struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
+		struct audit_net *aunet = net_generic(&init_net, audit_net_id);
+		struct sock *sock = aunet->nlsk;
+		bool has_mc = netlink_has_listeners(sock, AUDIT_NLGRP_READLOG);
 
 		nlh->nlmsg_len = ab->skb->len;
-		kauditd_send_multicast_skb(ab->skb);
+
+		if (has_mc)
+			kauditd_send_multicast_skb(sock, ab->skb);
 
 		/*
 		 * The original kaudit unicast socket sends up messages with
@@ -1965,8 +1965,10 @@ void audit_log_end(struct audit_buffer *ab)
 		if (audit_pid) {
 			skb_queue_tail(&audit_skb_queue, ab->skb);
 			wake_up_interruptible(&kauditd_wait);
-		} else {
+		} else if (!has_mc) {
 			audit_printk_skb(ab->skb);
+		} else {
+			audit_hold_skb(ab->skb);
 		}
 		ab->skb = NULL;
 	}
-- 
2.2.1

