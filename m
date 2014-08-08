Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbaHHVlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:41:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbaHHVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:37:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergey Popov <pinkbyte@gentoo.org>, Dmitry Popov <ixaphire@qrator.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 01/17] ip_tunnel(ipv4): fix tunnels with "local any remote $remote_ip"
Date: Fri,  8 Aug 2014 14:35:23 -0700
Message-Id: <20140808213457.572871955@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213457.511493898@linuxfoundation.org>
References: <20140808213457.511493898@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Popov <ixaphire@qrator.net>

[ Upstream commit 95cb5745983c222867cc9ac593aebb2ad67d72c0 ]

Ipv4 tunnels created with "local any remote $ip" didn't work properly since
7d442fab0 (ipv4: Cache dst in tunnels). 99% of packets sent via those tunnels
had src addr = 0.0.0.0. That was because only dst_entry was cached, although
fl4.saddr has to be cached too. Every time ip_tunnel_xmit used cached dst_entry
(tunnel_rtable_get returned non-NULL), fl4.saddr was initialized with
tnl_params->saddr (= 0 in our case), and wasn't changed until iptunnel_xmit().

This patch adds saddr to ip_tunnel->dst_cache, fixing this issue.

Reported-by: Sergey Popov <pinkbyte@gentoo.org>
Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_tunnels.h |    1 +
 net/ipv4/ip_tunnel.c     |   29 ++++++++++++++++++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -40,6 +40,7 @@ struct ip_tunnel_prl_entry {
 
 struct ip_tunnel_dst {
 	struct dst_entry __rcu 		*dst;
+	__be32				 saddr;
 };
 
 struct ip_tunnel {
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -69,23 +69,25 @@ static unsigned int ip_tunnel_hash(__be3
 }
 
 static void __tunnel_dst_set(struct ip_tunnel_dst *idst,
-			     struct dst_entry *dst)
+			     struct dst_entry *dst, __be32 saddr)
 {
 	struct dst_entry *old_dst;
 
 	dst_clone(dst);
 	old_dst = xchg((__force struct dst_entry **)&idst->dst, dst);
 	dst_release(old_dst);
+	idst->saddr = saddr;
 }
 
-static void tunnel_dst_set(struct ip_tunnel *t, struct dst_entry *dst)
+static void tunnel_dst_set(struct ip_tunnel *t,
+			   struct dst_entry *dst, __be32 saddr)
 {
-	__tunnel_dst_set(this_cpu_ptr(t->dst_cache), dst);
+	__tunnel_dst_set(this_cpu_ptr(t->dst_cache), dst, saddr);
 }
 
 static void tunnel_dst_reset(struct ip_tunnel *t)
 {
-	tunnel_dst_set(t, NULL);
+	tunnel_dst_set(t, NULL, 0);
 }
 
 void ip_tunnel_dst_reset_all(struct ip_tunnel *t)
@@ -93,20 +95,25 @@ void ip_tunnel_dst_reset_all(struct ip_t
 	int i;
 
 	for_each_possible_cpu(i)
-		__tunnel_dst_set(per_cpu_ptr(t->dst_cache, i), NULL);
+		__tunnel_dst_set(per_cpu_ptr(t->dst_cache, i), NULL, 0);
 }
 EXPORT_SYMBOL(ip_tunnel_dst_reset_all);
 
-static struct rtable *tunnel_rtable_get(struct ip_tunnel *t, u32 cookie)
+static struct rtable *tunnel_rtable_get(struct ip_tunnel *t,
+					u32 cookie, __be32 *saddr)
 {
+	struct ip_tunnel_dst *idst;
 	struct dst_entry *dst;
 
 	rcu_read_lock();
-	dst = rcu_dereference(this_cpu_ptr(t->dst_cache)->dst);
+	idst = this_cpu_ptr(t->dst_cache);
+	dst = rcu_dereference(idst->dst);
 	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
 		dst = NULL;
 	if (dst) {
-		if (dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
+		if (!dst->obsolete || dst->ops->check(dst, cookie)) {
+			*saddr = idst->saddr;
+		} else {
 			tunnel_dst_reset(t);
 			dst_release(dst);
 			dst = NULL;
@@ -367,7 +374,7 @@ static int ip_tunnel_bind_dev(struct net
 
 		if (!IS_ERR(rt)) {
 			tdev = rt->dst.dev;
-			tunnel_dst_set(tunnel, &rt->dst);
+			tunnel_dst_set(tunnel, &rt->dst, fl4.saddr);
 			ip_rt_put(rt);
 		}
 		if (dev->type != ARPHRD_ETHER)
@@ -610,7 +617,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 	init_tunnel_flow(&fl4, protocol, dst, tnl_params->saddr,
 			 tunnel->parms.o_key, RT_TOS(tos), tunnel->parms.link);
 
-	rt = connected ? tunnel_rtable_get(tunnel, 0) : NULL;
+	rt = connected ? tunnel_rtable_get(tunnel, 0, &fl4.saddr) : NULL;
 
 	if (!rt) {
 		rt = ip_route_output_key(tunnel->net, &fl4);
@@ -620,7 +627,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 			goto tx_error;
 		}
 		if (connected)
-			tunnel_dst_set(tunnel, &rt->dst);
+			tunnel_dst_set(tunnel, &rt->dst, fl4.saddr);
 	}
 
 	if (rt->dst.dev == dev) {


