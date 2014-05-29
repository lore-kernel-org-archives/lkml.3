Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934832AbaE2OEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:04:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59417 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933339AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/103] net: Fix ns_capable check in sock_diag_put_filterinfo
Date: Thu, 29 May 2014 15:48:58 +0200
Message-Id: <6bebcc8d95669e32c9ac6e836e985ae50392ae23.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 78541c1dc60b65ecfce5a6a096fc260219d6784e ]

The caller needs capabilities on the namespace being queried, not on
their own namespace.  This is a security bug, although it likely has
only a minor impact.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/sock_diag.h | 2 +-
 net/core/sock_diag.c      | 4 ++--
 net/packet/diag.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
index 54f91d35e5fd..302ab805b0bb 100644
--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -23,7 +23,7 @@ int sock_diag_check_cookie(void *sk, __u32 *cookie);
 void sock_diag_save_cookie(void *sk, __u32 *cookie);
 
 int sock_diag_put_meminfo(struct sock *sk, struct sk_buff *skb, int attr);
-int sock_diag_put_filterinfo(struct user_namespace *user_ns, struct sock *sk,
+int sock_diag_put_filterinfo(struct sock *sk,
 			     struct sk_buff *skb, int attrtype);
 
 #endif
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index a0e9cf6379de..6a7fae228634 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -49,7 +49,7 @@ int sock_diag_put_meminfo(struct sock *sk, struct sk_buff *skb, int attrtype)
 }
 EXPORT_SYMBOL_GPL(sock_diag_put_meminfo);
 
-int sock_diag_put_filterinfo(struct user_namespace *user_ns, struct sock *sk,
+int sock_diag_put_filterinfo(struct sock *sk,
 			     struct sk_buff *skb, int attrtype)
 {
 	struct nlattr *attr;
@@ -57,7 +57,7 @@ int sock_diag_put_filterinfo(struct user_namespace *user_ns, struct sock *sk,
 	unsigned int len;
 	int err = 0;
 
-	if (!ns_capable(user_ns, CAP_NET_ADMIN)) {
+	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 		nla_reserve(skb, attrtype, 0);
 		return 0;
 	}
diff --git a/net/packet/diag.c b/net/packet/diag.c
index a9584a2f6d69..ec8b6e8a80b1 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -171,7 +171,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 		goto out_nlmsg_trim;
 
 	if ((req->pdiag_show & PACKET_SHOW_FILTER) &&
-	    sock_diag_put_filterinfo(user_ns, sk, skb, PACKET_DIAG_FILTER))
+	    sock_diag_put_filterinfo(sk, skb, PACKET_DIAG_FILTER))
 		goto out_nlmsg_trim;
 
 	return nlmsg_end(skb, nlh);
-- 
1.9.3

