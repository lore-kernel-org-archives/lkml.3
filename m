Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaL2BPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:15:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33136 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbaL2BMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Crestez Dan Leonard" <cdleonard@gmail.com>,
        "Eric Dumazet" <edumazet@google.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.899600188@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 23/27] tcp: md5: do not use alloc_percpu()
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

commit 349ce993ac706869d553a1816426d3a4bfda02b1 upstream.

percpu tcp_md5sig_pool contains memory blobs that ultimately
go through sg_set_buf().

-> sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));

This requires that whole area is in a physically contiguous portion
of memory. And that @buf is not backed by vmalloc().

Given that alloc_percpu() can use vmalloc() areas, this does not
fit the requirements.

Replace alloc_percpu() by a static DEFINE_PER_CPU() as tcp_md5sig_pool
is small anyway, there is no gain to dynamically allocate it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 765cf9976e93 ("tcp: md5: remove one indirection level in tcp_md5sig_pool")
Reported-by: Crestez Dan Leonard <cdleonard@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: the deleted code differs slightly due to API changes]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp.c | 59 ++++++++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2863,61 +2863,42 @@ int tcp_gro_complete(struct sk_buff *skb
 EXPORT_SYMBOL(tcp_gro_complete);
 
 #ifdef CONFIG_TCP_MD5SIG
-static struct tcp_md5sig_pool __percpu *tcp_md5sig_pool __read_mostly;
+static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
 static DEFINE_MUTEX(tcp_md5sig_mutex);
-
-static void __tcp_free_md5sig_pool(struct tcp_md5sig_pool __percpu *pool)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct tcp_md5sig_pool *p = per_cpu_ptr(pool, cpu);
-
-		if (p->md5_desc.tfm)
-			crypto_free_hash(p->md5_desc.tfm);
-	}
-	free_percpu(pool);
-}
+static bool tcp_md5sig_pool_populated = false;
 
 static void __tcp_alloc_md5sig_pool(void)
 {
 	int cpu;
-	struct tcp_md5sig_pool __percpu *pool;
-
-	pool = alloc_percpu(struct tcp_md5sig_pool);
-	if (!pool)
-		return;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_hash *hash;
+		if (!per_cpu(tcp_md5sig_pool, cpu).md5_desc.tfm) {
+			struct crypto_hash *hash;
 
-		hash = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
-		if (!hash || IS_ERR(hash))
-			goto out_free;
-
-		per_cpu_ptr(pool, cpu)->md5_desc.tfm = hash;
+			hash = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+			if (IS_ERR_OR_NULL(hash))
+				return;
+			per_cpu(tcp_md5sig_pool, cpu).md5_desc.tfm = hash;
+		}
 	}
-	/* before setting tcp_md5sig_pool, we must commit all writes
-	 * to memory. See ACCESS_ONCE() in tcp_get_md5sig_pool()
+	/* before setting tcp_md5sig_pool_populated, we must commit all writes
+	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
 	 */
 	smp_wmb();
-	tcp_md5sig_pool = pool;
-	return;
-out_free:
-	__tcp_free_md5sig_pool(pool);
+	tcp_md5sig_pool_populated = true;
 }
 
 bool tcp_alloc_md5sig_pool(void)
 {
-	if (unlikely(!tcp_md5sig_pool)) {
+	if (unlikely(!tcp_md5sig_pool_populated)) {
 		mutex_lock(&tcp_md5sig_mutex);
 
-		if (!tcp_md5sig_pool)
+		if (!tcp_md5sig_pool_populated)
 			__tcp_alloc_md5sig_pool();
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool != NULL;
+	return tcp_md5sig_pool_populated;
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -2931,13 +2912,13 @@ EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
  */
 struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
-	struct tcp_md5sig_pool __percpu *p;
-
 	local_bh_disable();
-	p = ACCESS_ONCE(tcp_md5sig_pool);
-	if (p)
-		return __this_cpu_ptr(p);
 
+	if (tcp_md5sig_pool_populated) {
+		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
+		smp_rmb();
+		return this_cpu_ptr(&tcp_md5sig_pool);
+	}
 	local_bh_enable();
 	return NULL;
 }

