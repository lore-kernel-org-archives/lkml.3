Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3BLUgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3BLUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 48/61] ipv4: Fix route refcount on pmtu discovery
Date: Tue, 12 Feb 2013 12:35:08 -0800
Message-Id: <20130212203424.452624921@linuxfoundation.org>
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

[ Upstream commit b44108dbdbaa07c609bb5755e8dd6c2035236251 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -985,6 +985,7 @@ void ipv4_sk_update_pmtu(struct sk_buff
 	struct flowi4 fl4;
 	struct rtable *rt;
 	struct dst_entry *dst;
+	bool new = false;
 
 	bh_lock_sock(sk);
 	rt = (struct rtable *) __sk_dst_get(sk);
@@ -1000,20 +1001,26 @@ void ipv4_sk_update_pmtu(struct sk_buff
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


