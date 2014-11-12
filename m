Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaKLBiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:38:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaKLBhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:37:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Crestez Dan Leonard <cdleonard@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 008/203] tcp: md5: do not use alloc_percpu()
Date: Wed, 12 Nov 2014 10:14:38 +0900
Message-Id: <20141112011543.078870365@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 349ce993ac706869d553a1816426d3a4bfda02b1 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   59 +++++++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2954,61 +2954,42 @@ EXPORT_SYMBOL(compat_tcp_getsockopt);
 #endif
 
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
-		if (IS_ERR_OR_NULL(hash))
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
 
@@ -3022,13 +3003,13 @@ EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
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


