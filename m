Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaKRP2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:28:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbaKROJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 013/206] tcp: md5: do not use alloc_percpu()
Date: Tue, 18 Nov 2014 15:06:08 +0100
Message-Id: <a388cd772c2e0cd19f61a3b0dc8d2ecd6b380216.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
---
 net/ipv4/tcp.c | 59 ++++++++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cbe5adaad338..a880ccc10f61 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2909,61 +2909,42 @@ EXPORT_SYMBOL(compat_tcp_getsockopt);
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
-
-		hash = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR_OR_NULL(hash))
-			goto out_free;
+		if (!per_cpu(tcp_md5sig_pool, cpu).md5_desc.tfm) {
+			struct crypto_hash *hash;
 
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
 
@@ -2977,13 +2958,13 @@ EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
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
-- 
2.1.3

