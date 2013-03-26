Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3CZRmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:42:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3CZRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:30 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ngfri430Yy4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Yo7RFQAmwbQA:10 a=7ZN4cI0QAAAA:8 a=pK7X0mNQAAAA:8 a=J1Y8HTJGAAAA:8 a=yazBKBY6XBTsJ3rTyb8A:9 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173610.750910110@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 68/86] ipv4: Invalidate the socket cached route on pmtu events if possible
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0068-ipv4-Invalidate-the-socket-cached-route-on-pmtu-even.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit c82d543a2e8727233337c6f93ba7a1bddd5228cc ]

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
---
 net/ipv4/route.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6d0ae55..4c8a57d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -965,7 +965,7 @@ void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,
 }
 EXPORT_SYMBOL_GPL(ipv4_update_pmtu);
 
-void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
+static void __ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 {
 	const struct iphdr *iph = (const struct iphdr *) skb->data;
 	struct flowi4 fl4;
@@ -978,6 +978,46 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
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
-- 
1.7.10.4


