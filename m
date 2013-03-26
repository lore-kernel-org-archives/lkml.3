Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778Ab3CZPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:25:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965438Ab3CZPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 147/150] inet: limit length of fragment queue hash table bucket lists
Date: Tue, 26 Mar 2013 15:20:46 +0000
Message-Id: <1364311249-14454-148-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 5a3da1fe9561828d0ca7eca664b16ec2b9bf0055 upstream.

This patch introduces a constant limit of the fragment queue hash
table bucket list lengths. Currently the limit 128 is choosen somewhat
arbitrary and just ensures that we can fill up the fragment cache with
empty packets up to the default ip_frag_high_thresh limits. It should
just protect from list iteration eating considerable amounts of cpu.

If we reach the maximum length in one hash bucket a warning is printed.
This is implemented on the caller side of inet_frag_find to distinguish
between the different users of inet_fragment.c.

I dropped the out of memory warning in the ipv4 fragment lookup path,
because we already get a warning by the slab allocator.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jesper Dangaard Brouer <jbrouer@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/inet_frag.h                 |  9 +++++++++
 net/ipv4/inet_fragment.c                | 20 +++++++++++++++++++-
 net/ipv4/ip_fragment.c                  | 11 ++++-------
 net/ipv6/netfilter/nf_conntrack_reasm.c | 11 ++++++-----
 net/ipv6/reassembly.c                   |  8 ++++++--
 5 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 2431cf8..92e211e 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -33,6 +33,13 @@ struct inet_frag_queue {
 
 #define INETFRAGS_HASHSZ		64
 
+/* averaged:
+ * max_depth = default ipfrag_high_thresh / INETFRAGS_HASHSZ /
+ *	       rounded up (SKB_TRUELEN(0) + sizeof(struct ipq or
+ *	       struct frag_queue))
+ */
+#define INETFRAGS_MAXDEPTH		128
+
 struct inet_frags {
 	struct hlist_head	hash[INETFRAGS_HASHSZ];
 	rwlock_t		lock;
@@ -63,6 +70,8 @@ int inet_frag_evictor(struct netns_frags *nf, struct inet_frags *f);
 struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 		struct inet_frags *f, void *key, unsigned int hash)
 	__releases(&f->lock);
+void inet_frag_maybe_warn_overflow(struct inet_frag_queue *q,
+				   const char *prefix);
 
 static inline void inet_frag_put(struct inet_frag_queue *q, struct inet_frags *f)
 {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 5ff2a51..210b710 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -21,6 +21,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 
+#include <net/sock.h>
 #include <net/inet_frag.h>
 
 static void inet_frag_secret_rebuild(unsigned long dummy)
@@ -271,6 +272,7 @@ struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 {
 	struct inet_frag_queue *q;
 	struct hlist_node *n;
+	int depth = 0;
 
 	hlist_for_each_entry(q, n, &f->hash[hash], list) {
 		if (q->net == nf && f->match(q, key)) {
@@ -278,9 +280,25 @@ struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 			read_unlock(&f->lock);
 			return q;
 		}
+		depth++;
 	}
 	read_unlock(&f->lock);
 
-	return inet_frag_create(nf, f, key);
+	if (depth <= INETFRAGS_MAXDEPTH)
+		return inet_frag_create(nf, f, key);
+	else
+		return ERR_PTR(-ENOBUFS);
 }
 EXPORT_SYMBOL(inet_frag_find);
+
+void inet_frag_maybe_warn_overflow(struct inet_frag_queue *q,
+				   const char *prefix)
+{
+	static const char msg[] = "inet_frag_find: Fragment hash bucket"
+		" list length grew over limit " __stringify(INETFRAGS_MAXDEPTH)
+		". Dropping fragment.\n";
+
+	if (PTR_ERR(q) == -ENOBUFS)
+		LIMIT_NETDEBUG(KERN_WARNING "%s%s", prefix, msg);
+}
+EXPORT_SYMBOL(inet_frag_maybe_warn_overflow);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 3fdcdb8..d513c62 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -295,14 +295,11 @@ static inline struct ipq *ip_find(struct net *net, struct iphdr *iph, u32 user)
 	hash = ipqhashfn(iph->id, iph->saddr, iph->daddr, iph->protocol);
 
 	q = inet_frag_find(&net->ipv4.frags, &ip4_frags, &arg, hash);
-	if (q == NULL)
-		goto out_nomem;
-
+	if (IS_ERR_OR_NULL(q)) {
+		inet_frag_maybe_warn_overflow(q, pr_fmt());
+		return NULL;
+	}
 	return container_of(q, struct ipq, q);
-
-out_nomem:
-	LIMIT_NETDEBUG(KERN_ERR pr_fmt("ip_frag_create: no memory left !\n"));
-	return NULL;
 }
 
 /* Is the fragment too far ahead to be part of ipq? */
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index c9c78c2..7373dcd 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -14,6 +14,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) "IPv6-nf: " fmt
+
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -176,13 +178,12 @@ fq_find(__be32 id, u32 user, struct in6_addr *src, struct in6_addr *dst)
 
 	q = inet_frag_find(&nf_init_frags, &nf_frags, &arg, hash);
 	local_bh_enable();
-	if (q == NULL)
-		goto oom;
+	if (IS_ERR_OR_NULL(q)) {
+		inet_frag_maybe_warn_overflow(q, pr_fmt());
+		return NULL;
+	}
 
 	return container_of(q, struct nf_ct_frag6_queue, q);
-
-oom:
-	return NULL;
 }
 
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 4ff9af6..66d2096 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -26,6 +26,9 @@
  *	YOSHIFUJI,H. @USAGI	Always remove fragment header to
  *				calculate ICV correctly.
  */
+
+#define pr_fmt(fmt) "IPv6: " fmt
+
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -241,9 +244,10 @@ fq_find(struct net *net, __be32 id, const struct in6_addr *src, const struct in6
 	hash = inet6_hash_frag(id, src, dst, ip6_frags.rnd);
 
 	q = inet_frag_find(&net->ipv6.frags, &ip6_frags, &arg, hash);
-	if (q == NULL)
+	if (IS_ERR_OR_NULL(q)) {
+		inet_frag_maybe_warn_overflow(q, pr_fmt());
 		return NULL;
-
+	}
 	return container_of(q, struct frag_queue, q);
 }
 
-- 
1.8.1.2

