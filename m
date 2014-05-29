Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbaE2EtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:49:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbaE2Eih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 55/86] net: Fix ns_capable check in sock_diag_put_filterinfo
Date: Wed, 28 May 2014 21:37:30 -0700
Message-Id: <20140529043520.957204250@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lutomirski <luto@amacapital.net>

[ Upstream commit 78541c1dc60b65ecfce5a6a096fc260219d6784e ]

The caller needs capabilities on the namespace being queried, not on
their own namespace.  This is a security bug, although it likely has
only a minor impact.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sock_diag.h |    2 +-
 net/core/sock_diag.c      |    4 ++--
 net/packet/diag.c         |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -23,7 +23,7 @@ int sock_diag_check_cookie(void *sk, __u
 void sock_diag_save_cookie(void *sk, __u32 *cookie);
 
 int sock_diag_put_meminfo(struct sock *sk, struct sk_buff *skb, int attr);
-int sock_diag_put_filterinfo(struct user_namespace *user_ns, struct sock *sk,
+int sock_diag_put_filterinfo(struct sock *sk,
 			     struct sk_buff *skb, int attrtype);
 
 #endif
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -49,7 +49,7 @@ int sock_diag_put_meminfo(struct sock *s
 }
 EXPORT_SYMBOL_GPL(sock_diag_put_meminfo);
 
-int sock_diag_put_filterinfo(struct user_namespace *user_ns, struct sock *sk,
+int sock_diag_put_filterinfo(struct sock *sk,
 			     struct sk_buff *skb, int attrtype)
 {
 	struct nlattr *attr;
@@ -57,7 +57,7 @@ int sock_diag_put_filterinfo(struct user
 	unsigned int len;
 	int err = 0;
 
-	if (!ns_capable(user_ns, CAP_NET_ADMIN)) {
+	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 		nla_reserve(skb, attrtype, 0);
 		return 0;
 	}
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -171,7 +171,7 @@ static int sk_diag_fill(struct sock *sk,
 		goto out_nlmsg_trim;
 
 	if ((req->pdiag_show & PACKET_SHOW_FILTER) &&
-	    sock_diag_put_filterinfo(user_ns, sk, skb, PACKET_DIAG_FILTER))
+	    sock_diag_put_filterinfo(sk, skb, PACKET_DIAG_FILTER))
 		goto out_nlmsg_trim;
 
 	return nlmsg_end(skb, nlh);


