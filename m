Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaGZTVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:21:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaGZTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:21:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Dormando <dormando@rydia.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 045/109] ipv4: fix dst race in sk_dst_get()
Date: Sat, 26 Jul 2014 12:02:07 -0700
Message-Id: <20140726190225.225014517@linuxfoundation.org>
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

[ Upstream commit f88649721268999bdff09777847080a52004f691 ]

When IP route cache had been removed in linux-3.6, we broke assumption
that dst entries were all freed after rcu grace period. DST_NOCACHE
dst were supposed to be freed from dst_release(). But it appears
we want to keep such dst around, either in UDP sockets or tunnels.

In sk_dst_get() we need to make sure dst refcount is not 0
before incrementing it, or else we might end up freeing a dst
twice.

DST_NOCACHE set on a dst does not mean this dst can not be attached
to a socket or a tunnel.

Then, before actual freeing, we need to observe a rcu grace period
to make sure all other cpus can catch the fact the dst is no longer
usable.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Dormando <dormando@rydia.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h   |    4 ++--
 net/core/dst.c       |   16 +++++++++++-----
 net/ipv4/ip_tunnel.c |   14 +++++---------
 3 files changed, 18 insertions(+), 16 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1728,8 +1728,8 @@ sk_dst_get(struct sock *sk)
 
 	rcu_read_lock();
 	dst = rcu_dereference(sk->sk_dst_cache);
-	if (dst)
-		dst_hold(dst);
+	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
+		dst = NULL;
 	rcu_read_unlock();
 	return dst;
 }
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -269,6 +269,15 @@ again:
 }
 EXPORT_SYMBOL(dst_destroy);
 
+static void dst_destroy_rcu(struct rcu_head *head)
+{
+	struct dst_entry *dst = container_of(head, struct dst_entry, rcu_head);
+
+	dst = dst_destroy(dst);
+	if (dst)
+		__dst_free(dst);
+}
+
 void dst_release(struct dst_entry *dst)
 {
 	if (dst) {
@@ -276,11 +285,8 @@ void dst_release(struct dst_entry *dst)
 
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
 		WARN_ON(newrefcnt < 0);
-		if (unlikely(dst->flags & DST_NOCACHE) && !newrefcnt) {
-			dst = dst_destroy(dst);
-			if (dst)
-				__dst_free(dst);
-		}
+		if (unlikely(dst->flags & DST_NOCACHE) && !newrefcnt)
+			call_rcu(&dst->rcu_head, dst_destroy_rcu);
 	}
 }
 EXPORT_SYMBOL(dst_release);
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -73,12 +73,7 @@ static void __tunnel_dst_set(struct ip_t
 {
 	struct dst_entry *old_dst;
 
-	if (dst) {
-		if (dst->flags & DST_NOCACHE)
-			dst = NULL;
-		else
-			dst_clone(dst);
-	}
+	dst_clone(dst);
 	old_dst = xchg((__force struct dst_entry **)&idst->dst, dst);
 	dst_release(old_dst);
 }
@@ -108,13 +103,14 @@ static struct rtable *tunnel_rtable_get(
 
 	rcu_read_lock();
 	dst = rcu_dereference(this_cpu_ptr(t->dst_cache)->dst);
+	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
+		dst = NULL;
 	if (dst) {
 		if (dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
-			rcu_read_unlock();
 			tunnel_dst_reset(t);
-			return NULL;
+			dst_release(dst);
+			dst = NULL;
 		}
-		dst_hold(dst);
 	}
 	rcu_read_unlock();
 	return (struct rtable *)dst;


