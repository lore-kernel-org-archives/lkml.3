Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaHRKBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:01:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHRJeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/137] ipv4: fix dst race in sk_dst_get()
Date: Mon, 18 Aug 2014 10:31:40 +0100
Message-Id: <1408354398-10226-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit f88649721268999bdff09777847080a52004f691 upstream.

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
[ luis: backported to 3.11: used davem's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/sock.h |  4 ++--
 net/core/dst.c     | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0588d4f195e3..84e621daed8e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1733,8 +1733,8 @@ sk_dst_get(struct sock *sk)
 
 	rcu_read_lock();
 	dst = rcu_dereference(sk->sk_dst_cache);
-	if (dst)
-		dst_hold(dst);
+	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
+		dst = NULL;
 	rcu_read_unlock();
 	return dst;
 }
diff --git a/net/core/dst.c b/net/core/dst.c
index ca4231ec7347..15b6792e6ebb 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -267,6 +267,15 @@ again:
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
@@ -274,11 +283,8 @@ void dst_release(struct dst_entry *dst)
 
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
-- 
1.9.1

