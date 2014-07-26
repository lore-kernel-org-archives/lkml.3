Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaGZTXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:23:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaGZTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 046/109] ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
Date: Sat, 26 Jul 2014 12:02:08 -0700
Message-Id: <20140726190225.261057824@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7f502361531e9eecb396cf99bdc9e9a59f7ebd7f ]

We have two different ways to handle changes to sk->sk_dst

First way (used by TCP) assumes socket lock is owned by caller, and use
no extra lock : __sk_dst_set() & __sk_dst_reset()

Another way (used by UDP) uses sk_dst_lock because socket lock is not
always taken. Note that sk_dst_lock is not softirq safe.

These ways are not inter changeable for a given socket type.

ipv4_sk_update_pmtu(), added in linux-3.8, added a race, as it used
the socket lock as synchronization, but users might be UDP sockets.

Instead of converting sk_dst_lock to a softirq safe version, use xchg()
as we did for sk_rx_dst in commit e47eb5dfb296b ("udp: ipv4: do not use
sk_dst_lock from softirq context")

In a follow up patch, we probably can remove sk_dst_lock, as it is
only used in IPv6.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Fixes: 9cb3a50c5f63e ("ipv4: Invalidate the socket cached route on pmtu events if possible")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |   12 ++++++------
 net/ipv4/route.c   |   15 ++++++++-------
 2 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1766,9 +1766,11 @@ __sk_dst_set(struct sock *sk, struct dst
 static inline void
 sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
-	spin_lock(&sk->sk_dst_lock);
-	__sk_dst_set(sk, dst);
-	spin_unlock(&sk->sk_dst_lock);
+	struct dst_entry *old_dst;
+
+	sk_tx_queue_clear(sk);
+	old_dst = xchg(&sk->sk_dst_cache, dst);
+	dst_release(old_dst);
 }
 
 static inline void
@@ -1780,9 +1782,7 @@ __sk_dst_reset(struct sock *sk)
 static inline void
 sk_dst_reset(struct sock *sk)
 {
-	spin_lock(&sk->sk_dst_lock);
-	__sk_dst_reset(sk);
-	spin_unlock(&sk->sk_dst_lock);
+	sk_dst_set(sk, NULL);
 }
 
 struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie);
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1022,7 +1022,7 @@ void ipv4_sk_update_pmtu(struct sk_buff
 	const struct iphdr *iph = (const struct iphdr *) skb->data;
 	struct flowi4 fl4;
 	struct rtable *rt;
-	struct dst_entry *dst;
+	struct dst_entry *odst = NULL;
 	bool new = false;
 
 	bh_lock_sock(sk);
@@ -1030,16 +1030,17 @@ void ipv4_sk_update_pmtu(struct sk_buff
 	if (!ip_sk_accept_pmtu(sk))
 		goto out;
 
-	rt = (struct rtable *) __sk_dst_get(sk);
+	odst = sk_dst_get(sk);
 
-	if (sock_owned_by_user(sk) || !rt) {
+	if (sock_owned_by_user(sk) || !odst) {
 		__ipv4_sk_update_pmtu(skb, sk, mtu);
 		goto out;
 	}
 
 	__build_flow_key(&fl4, sk, iph, 0, 0, 0, 0, 0);
 
-	if (!__sk_dst_check(sk, 0)) {
+	rt = (struct rtable *)odst;
+	if (odst->obsolete && odst->ops->check(odst, 0) == NULL) {
 		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
 		if (IS_ERR(rt))
 			goto out;
@@ -1049,8 +1050,7 @@ void ipv4_sk_update_pmtu(struct sk_buff
 
 	__ip_rt_update_pmtu((struct rtable *) rt->dst.path, &fl4, mtu);
 
-	dst = dst_check(&rt->dst, 0);
-	if (!dst) {
+	if (!dst_check(&rt->dst, 0)) {
 		if (new)
 			dst_release(&rt->dst);
 
@@ -1062,10 +1062,11 @@ void ipv4_sk_update_pmtu(struct sk_buff
 	}
 
 	if (new)
-		__sk_dst_set(sk, &rt->dst);
+		sk_dst_set(sk, &rt->dst);
 
 out:
 	bh_unlock_sock(sk);
+	dst_release(odst);
 }
 EXPORT_SYMBOL_GPL(ipv4_sk_update_pmtu);
 


