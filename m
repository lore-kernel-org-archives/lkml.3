Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3BLU70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:59:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3BLUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 46/61] ipv4: Invalidate the socket cached route on pmtu events if possible
Date: Tue, 12 Feb 2013 12:35:06 -0800
Message-Id: <20130212203424.229954352@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 9cb3a50c5f63ed745702972f66eaee8767659acd ]

The route lookup in ipv4_sk_update_pmtu() might return a route
different from the route we cached at the socket. This is because
standart routes are per cpu, so each cpu has it's own struct rtable.
This means that we do not invalidate the socket cached route if the
NET_RX_SOFTIRQ is not served by the same cpu that the sending socket
uses. As a result, the cached route reused until we disconnect.

With this patch we invalidate the socket cached route if possible.
If the socket is owened by the user, we can't update the cached
route directly. A followup patch will implement socket release
callback functions for datagram sockets to handle this case.

Reported-by: Yurij M. Plotnikov <Yurij.Plotnikov@oktetlabs.ru>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -965,7 +965,7 @@ void ipv4_update_pmtu(struct sk_buff *sk
 }
 EXPORT_SYMBOL_GPL(ipv4_update_pmtu);
 
-void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
+static void __ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 {
 	const struct iphdr *iph = (const struct iphdr *) skb->data;
 	struct flowi4 fl4;
@@ -978,6 +978,46 @@ void ipv4_sk_update_pmtu(struct sk_buff
 		ip_rt_put(rt);
 	}
 }
+
+void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
+{
+	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	struct flowi4 fl4;
+	struct rtable *rt;
+	struct dst_entry *dst;
+
+	bh_lock_sock(sk);
+	rt = (struct rtable *) __sk_dst_get(sk);
+
+	if (sock_owned_by_user(sk) || !rt) {
+		__ipv4_sk_update_pmtu(skb, sk, mtu);
+		goto out;
+	}
+
+	__build_flow_key(&fl4, sk, iph, 0, 0, 0, 0, 0);
+
+	if (!__sk_dst_check(sk, 0)) {
+		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
+		if (IS_ERR(rt))
+			goto out;
+	}
+
+	__ip_rt_update_pmtu((struct rtable *) rt->dst.path, &fl4, mtu);
+
+	dst = dst_check(&rt->dst, 0);
+	if (!dst) {
+		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
+		if (IS_ERR(rt))
+			goto out;
+
+		dst = &rt->dst;
+	}
+
+	 __sk_dst_set(sk, dst);
+
+out:
+	bh_unlock_sock(sk);
+}
 EXPORT_SYMBOL_GPL(ipv4_sk_update_pmtu);
 
 void ipv4_redirect(struct sk_buff *skb, struct net *net,


