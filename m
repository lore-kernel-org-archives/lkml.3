Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaBCUwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:52:19 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41056 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaBCUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:52:16 -0500
Message-ID: <1391460734.28432.111.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] ip_tunnel: fix panic in ip_tunnel_xmit()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tommi Rantala <tt.rantala@gmail.com>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>
Date: Mon, 03 Feb 2014 12:52:14 -0800
In-Reply-To: <CA+ydwto5CTDSED=pZ_DfAZyh6Jx7xKJafRuDFUtV4ZZCb70ULA@mail.gmail.com>
References: <CA+ydwtrWCgi=v7v=8yjNMV37Aa4ua9zbqYM5_uUdQrLSQt+VEw@mail.gmail.com>
	 <1391201873.28432.86.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+ydwtpmFbhkck9z8G7tfHQZW+4rWSepQMgPURqVCwrZ77v2bA@mail.gmail.com>
	 <CA+ydwto5CTDSED=pZ_DfAZyh6Jx7xKJafRuDFUtV4ZZCb70ULA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Setting rt variable to NULL at the beginning of ip_tunnel_xmit()
missed possible use of this variable as a scratch value.

Also fixes a possible dst leak in tunnel_dst_check() :
If we had to call tunnel_dst_reset(), we forgot to
release the reference on dst.

Merges tunnel_dst_get()/tunnel_dst_check() into
a single tunnel_rtable_get() function for clarity.

Many thanks to Tommi for his report and tests.

Fixes: 7d442fab0a67 ("ipv4: Cache dst in tunnels)"
Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
---
 net/ipv4/ip_tunnel.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index bd28f386bd02..50228be5c17b 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -101,28 +101,22 @@ static void tunnel_dst_reset_all(struct ip_tunnel *t)
 		__tunnel_dst_set(per_cpu_ptr(t->dst_cache, i), NULL);
 }
 
-static struct dst_entry *tunnel_dst_get(struct ip_tunnel *t)
+static struct rtable *tunnel_rtable_get(struct ip_tunnel *t, u32 cookie)
 {
 	struct dst_entry *dst;
 
 	rcu_read_lock();
 	dst = rcu_dereference(this_cpu_ptr(t->dst_cache)->dst);
-	if (dst)
+	if (dst) {
+		if (dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
+			rcu_read_unlock();
+			tunnel_dst_reset(t);
+			return NULL;
+		}
 		dst_hold(dst);
-	rcu_read_unlock();
-	return dst;
-}
-
-static struct dst_entry *tunnel_dst_check(struct ip_tunnel *t, u32 cookie)
-{
-	struct dst_entry *dst = tunnel_dst_get(t);
-
-	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
-		tunnel_dst_reset(t);
-		return NULL;
 	}
-
-	return dst;
+	rcu_read_unlock();
+	return (struct rtable *)dst;
 }
 
 /* Often modified stats are per cpu, other are shared (netdev->stats) */
@@ -584,7 +578,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	struct flowi4 fl4;
 	u8     tos, ttl;
 	__be16 df;
-	struct rtable *rt = NULL;	/* Route to the other host */
+	struct rtable *rt;		/* Route to the other host */
 	unsigned int max_headroom;	/* The extra header space needed */
 	__be32 dst;
 	int err;
@@ -657,8 +651,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	init_tunnel_flow(&fl4, protocol, dst, tnl_params->saddr,
 			 tunnel->parms.o_key, RT_TOS(tos), tunnel->parms.link);
 
-	if (connected)
-		rt = (struct rtable *)tunnel_dst_check(tunnel, 0);
+	rt = connected ? tunnel_rtable_get(tunnel, 0) : NULL;
 
 	if (!rt) {
 		rt = ip_route_output_key(tunnel->net, &fl4);


