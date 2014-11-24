Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaKXToY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:44:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:36394 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaKXToX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:44:23 -0500
From: Jane Zhou <a17711@motorola.com>
To: linux-kernel@vger.kernel.org
Cc: Jane Zhou <a17711@motorola.com>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        stable@vger.kernel.org, Yiwei Zhao <gbjc64@motorola.com>
Subject: [PATCH] net/ping: handle protocol mismatching scenario
Date: Mon, 24 Nov 2014 11:44:08 -0800
Message-Id: <1416858248-29258-1-git-send-email-a17711@motorola.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping_lookup() may return a wrong sock if sk_buff's and sock's protocols
dont' match. For example, sk_buff's protocol is ETH_P_IPV6, but sock's
sk_family is AF_INET, in that case, if sk->sk_bound_dev_if is zero, a wrong
sock will be returned.
the fix is to "continue" the searching, if no matching, return NULL.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Jane Zhou <a17711@motorola.com>
Signed-off-by: Yiwei Zhao <gbjc64@motorola.com>
---
 net/ipv4/ping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index fc1c4b1..8892913 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -214,6 +214,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 					     &ipv6_hdr(skb)->daddr))
 				continue;
 #endif
+		} else {
+			continue;
 		}
 
 		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
-- 
1.8.0

