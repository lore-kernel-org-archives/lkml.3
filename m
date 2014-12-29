Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaL2BQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:16:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33150 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.279291519@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 22/27] tcp: md5: remove spinlock usage in fast path
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 71cea17ed39fdf1c0634f530ddc6a2c2fc601c2b upstream.

TCP md5 code uses per cpu variables but protects access to them with
a shared spinlock, which is a contention point.

[ tcp_md5sig_pool_lock is locked twice per incoming packet ]

Makes things much simpler, by allocating crypto structures once, first
time a socket needs md5 keys, and not deallocating them as they are
really small.

Next step would be to allow crypto allocations being done in a NUMA
aware way.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2:
 - Adjust context
 - Conditions for alloc/free are quite different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1214,11 +1214,13 @@ extern int tcp_v4_md5_do_del(struct sock
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-extern struct tcp_md5sig_pool __percpu *tcp_alloc_md5sig_pool(struct sock *);
-extern void tcp_free_md5sig_pool(void);
+extern bool tcp_alloc_md5sig_pool(void);
 
 extern struct tcp_md5sig_pool	*tcp_get_md5sig_pool(void);
-extern void tcp_put_md5sig_pool(void);
+static inline void tcp_put_md5sig_pool(void)
+{
+	local_bh_enable();
+}
 
 extern int tcp_md5_hash_header(struct tcp_md5sig_pool *, const struct tcphdr *);
 extern int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2863,9 +2863,8 @@ int tcp_gro_complete(struct sk_buff *skb
 EXPORT_SYMBOL(tcp_gro_complete);
 
 #ifdef CONFIG_TCP_MD5SIG
-static unsigned long tcp_md5sig_users;
-static struct tcp_md5sig_pool __percpu *tcp_md5sig_pool;
-static DEFINE_SPINLOCK(tcp_md5sig_pool_lock);
+static struct tcp_md5sig_pool __percpu *tcp_md5sig_pool __read_mostly;
+static DEFINE_MUTEX(tcp_md5sig_mutex);
 
 static void __tcp_free_md5sig_pool(struct tcp_md5sig_pool __percpu *pool)
 {
@@ -2880,30 +2879,14 @@ static void __tcp_free_md5sig_pool(struc
 	free_percpu(pool);
 }
 
-void tcp_free_md5sig_pool(void)
-{
-	struct tcp_md5sig_pool __percpu *pool = NULL;
-
-	spin_lock_bh(&tcp_md5sig_pool_lock);
-	if (--tcp_md5sig_users == 0) {
-		pool = tcp_md5sig_pool;
-		tcp_md5sig_pool = NULL;
-	}
-	spin_unlock_bh(&tcp_md5sig_pool_lock);
-	if (pool)
-		__tcp_free_md5sig_pool(pool);
-}
-EXPORT_SYMBOL(tcp_free_md5sig_pool);
-
-static struct tcp_md5sig_pool __percpu *
-__tcp_alloc_md5sig_pool(struct sock *sk)
+static void __tcp_alloc_md5sig_pool(void)
 {
 	int cpu;
 	struct tcp_md5sig_pool __percpu *pool;
 
 	pool = alloc_percpu(struct tcp_md5sig_pool);
 	if (!pool)
-		return NULL;
+		return;
 
 	for_each_possible_cpu(cpu) {
 		struct crypto_hash *hash;
@@ -2914,53 +2897,27 @@ __tcp_alloc_md5sig_pool(struct sock *sk)
 
 		per_cpu_ptr(pool, cpu)->md5_desc.tfm = hash;
 	}
-	return pool;
+	/* before setting tcp_md5sig_pool, we must commit all writes
+	 * to memory. See ACCESS_ONCE() in tcp_get_md5sig_pool()
+	 */
+	smp_wmb();
+	tcp_md5sig_pool = pool;
+	return;
 out_free:
 	__tcp_free_md5sig_pool(pool);
-	return NULL;
 }
 
-struct tcp_md5sig_pool __percpu *tcp_alloc_md5sig_pool(struct sock *sk)
+bool tcp_alloc_md5sig_pool(void)
 {
-	struct tcp_md5sig_pool __percpu *pool;
-	int alloc = 0;
+	if (unlikely(!tcp_md5sig_pool)) {
+		mutex_lock(&tcp_md5sig_mutex);
+
+		if (!tcp_md5sig_pool)
+			__tcp_alloc_md5sig_pool();
 
-retry:
-	spin_lock_bh(&tcp_md5sig_pool_lock);
-	pool = tcp_md5sig_pool;
-	if (tcp_md5sig_users++ == 0) {
-		alloc = 1;
-		spin_unlock_bh(&tcp_md5sig_pool_lock);
-	} else if (!pool) {
-		tcp_md5sig_users--;
-		spin_unlock_bh(&tcp_md5sig_pool_lock);
-		cpu_relax();
-		goto retry;
-	} else
-		spin_unlock_bh(&tcp_md5sig_pool_lock);
-
-	if (alloc) {
-		/* we cannot hold spinlock here because this may sleep. */
-		struct tcp_md5sig_pool __percpu *p;
-
-		p = __tcp_alloc_md5sig_pool(sk);
-		spin_lock_bh(&tcp_md5sig_pool_lock);
-		if (!p) {
-			tcp_md5sig_users--;
-			spin_unlock_bh(&tcp_md5sig_pool_lock);
-			return NULL;
-		}
-		pool = tcp_md5sig_pool;
-		if (pool) {
-			/* oops, it has already been assigned. */
-			spin_unlock_bh(&tcp_md5sig_pool_lock);
-			__tcp_free_md5sig_pool(p);
-		} else {
-			tcp_md5sig_pool = pool = p;
-			spin_unlock_bh(&tcp_md5sig_pool_lock);
-		}
+		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return pool;
+	return tcp_md5sig_pool != NULL;
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -2977,28 +2934,15 @@ struct tcp_md5sig_pool *tcp_get_md5sig_p
 	struct tcp_md5sig_pool __percpu *p;
 
 	local_bh_disable();
-
-	spin_lock(&tcp_md5sig_pool_lock);
-	p = tcp_md5sig_pool;
-	if (p)
-		tcp_md5sig_users++;
-	spin_unlock(&tcp_md5sig_pool_lock);
-
+	p = ACCESS_ONCE(tcp_md5sig_pool);
 	if (p)
-		return this_cpu_ptr(p);
+		return __this_cpu_ptr(p);
 
 	local_bh_enable();
 	return NULL;
 }
 EXPORT_SYMBOL(tcp_get_md5sig_pool);
 
-void tcp_put_md5sig_pool(void)
-{
-	local_bh_enable();
-	tcp_free_md5sig_pool();
-}
-EXPORT_SYMBOL(tcp_put_md5sig_pool);
-
 int tcp_md5_hash_header(struct tcp_md5sig_pool *hp,
 			const struct tcphdr *th)
 {
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -938,8 +938,7 @@ int tcp_v4_md5_do_add(struct sock *sk, _
 		}
 
 		md5sig = tp->md5sig_info;
-		if (md5sig->entries4 == 0 &&
-		    tcp_alloc_md5sig_pool(sk) == NULL) {
+		if (md5sig->entries4 == 0 && !tcp_alloc_md5sig_pool()) {
 			kfree(newkey);
 			return -ENOMEM;
 		}
@@ -949,8 +948,6 @@ int tcp_v4_md5_do_add(struct sock *sk, _
 					(md5sig->entries4 + 1)), GFP_ATOMIC);
 			if (!keys) {
 				kfree(newkey);
-				if (md5sig->entries4 == 0)
-					tcp_free_md5sig_pool();
 				return -ENOMEM;
 			}
 
@@ -994,7 +991,6 @@ int tcp_v4_md5_do_del(struct sock *sk, _
 				kfree(tp->md5sig_info->keys4);
 				tp->md5sig_info->keys4 = NULL;
 				tp->md5sig_info->alloced4 = 0;
-				tcp_free_md5sig_pool();
 			} else if (tp->md5sig_info->entries4 != i) {
 				/* Need to do some manipulation */
 				memmove(&tp->md5sig_info->keys4[i],
@@ -1022,7 +1018,6 @@ static void tcp_v4_clear_md5_list(struct
 		for (i = 0; i < tp->md5sig_info->entries4; i++)
 			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 = 0;
-		tcp_free_md5sig_pool();
 	}
 	if (tp->md5sig_info->keys4) {
 		kfree(tp->md5sig_info->keys4);
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -365,7 +365,7 @@ void tcp_time_wait(struct sock *sk, int
 			if (key != NULL) {
 				memcpy(&tcptw->tw_md5_key, key->key, key->keylen);
 				tcptw->tw_md5_keylen = key->keylen;
-				if (tcp_alloc_md5sig_pool(sk) == NULL)
+				if (!tcp_alloc_md5sig_pool())
 					BUG();
 			}
 		} while (0);
@@ -403,11 +403,6 @@ void tcp_time_wait(struct sock *sk, int
 
 void tcp_twsk_destructor(struct sock *sk)
 {
-#ifdef CONFIG_TCP_MD5SIG
-	struct tcp_timewait_sock *twsk = tcp_twsk(sk);
-	if (twsk->tw_md5_keylen)
-		tcp_free_md5sig_pool();
-#endif
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -592,7 +592,7 @@ static int tcp_v6_md5_do_add(struct sock
 			sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		}
 		if (tp->md5sig_info->entries6 == 0 &&
-			tcp_alloc_md5sig_pool(sk) == NULL) {
+		    !tcp_alloc_md5sig_pool()) {
 			kfree(newkey);
 			return -ENOMEM;
 		}
@@ -602,8 +602,6 @@ static int tcp_v6_md5_do_add(struct sock
 
 			if (!keys) {
 				kfree(newkey);
-				if (tp->md5sig_info->entries6 == 0)
-					tcp_free_md5sig_pool();
 				return -ENOMEM;
 			}
 
@@ -649,7 +647,6 @@ static int tcp_v6_md5_do_del(struct sock
 				kfree(tp->md5sig_info->keys6);
 				tp->md5sig_info->keys6 = NULL;
 				tp->md5sig_info->alloced6 = 0;
-				tcp_free_md5sig_pool();
 			} else {
 				/* shrink the database */
 				if (tp->md5sig_info->entries6 != i)
@@ -673,7 +670,6 @@ static void tcp_v6_clear_md5_list (struc
 		for (i = 0; i < tp->md5sig_info->entries6; i++)
 			kfree(tp->md5sig_info->keys6[i].base.key);
 		tp->md5sig_info->entries6 = 0;
-		tcp_free_md5sig_pool();
 	}
 
 	kfree(tp->md5sig_info->keys6);
@@ -684,7 +680,6 @@ static void tcp_v6_clear_md5_list (struc
 		for (i = 0; i < tp->md5sig_info->entries4; i++)
 			kfree(tp->md5sig_info->keys4[i].base.key);
 		tp->md5sig_info->entries4 = 0;
-		tcp_free_md5sig_pool();
 	}
 
 	kfree(tp->md5sig_info->keys4);

