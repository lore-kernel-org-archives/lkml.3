Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbaHHVO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:14:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbaHHUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 237/259] ipv4: fix dst race in sk_dst_get()
Date: Fri,  8 Aug 2014 13:41:00 -0700
Message-Id: <1407530482-4483-238-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/sock.h |  4 ++--
 net/core/dst.c     | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ca1aeeb..e7ad8ac 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1743,8 +1743,8 @@ sk_dst_get(struct sock *sk)
 
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
index ca4231e..15b6792 100644
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

