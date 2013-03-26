Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3CZRgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab3CZRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:30 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2l0xHoKxp1kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=c3IUT6MREyMA:10 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=uKsJwcKuPPOslusW1u0A:9 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173611.036311585@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Julian Anastasov <ja@ssi.bg>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 70/86] ipv4: Fix route refcount on pmtu discovery
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0070-ipv4-Fix-route-refcount-on-pmtu-discovery.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 9a2a0fefaf476a4be4d153792eaa600203b83edf ]

git commit 9cb3a50c (ipv4: Invalidate the socket cached route on
pmtu events if possible) introduced a refcount problem. We don't
get a refcount on the route if we get it from__sk_dst_get(), but
we need one if we want to reuse this route because __sk_dst_set()
releases the refcount of the old route. This patch adds proper
refcount handling for that case. We introduce a 'new' flag to
indicate that we are going to use a new route and we release the
old route only if we replace it by a new one.

Reported-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/route.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 4c8a57d..39de0ca 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -985,6 +985,7 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 	struct flowi4 fl4;
 	struct rtable *rt;
 	struct dst_entry *dst;
+	bool new = false;
 
 	bh_lock_sock(sk);
 	rt = (struct rtable *) __sk_dst_get(sk);
@@ -1000,20 +1001,26 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
 		if (IS_ERR(rt))
 			goto out;
+
+		new = true;
 	}
 
 	__ip_rt_update_pmtu((struct rtable *) rt->dst.path, &fl4, mtu);
 
 	dst = dst_check(&rt->dst, 0);
 	if (!dst) {
+		if (new)
+			dst_release(&rt->dst);
+
 		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
 		if (IS_ERR(rt))
 			goto out;
 
-		dst = &rt->dst;
+		new = true;
 	}
 
-	 __sk_dst_set(sk, dst);
+	if (new)
+		__sk_dst_set(sk, &rt->dst);
 
 out:
 	bh_unlock_sock(sk);
-- 
1.7.10.4


