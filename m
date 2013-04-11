Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175Ab3DKU00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3DKU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:02 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-2IyI36E8UoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=doxy4TXk0-gA:10 a=SaWEO8HGAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=jrNz0osMl2L7_OeuMJYA:9 a=w2ubnULX9RwA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=cFICVh8XXNd2HHLS:21 a=fJhYTNaojow5O3tQ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202549.523484672@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 020/171 ] inet: limit length of fragment queue hash table bucket lists
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0020-inet-limit-length-of-fragment-queue-hash-table-bucke.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 5a3da1fe9561828d0ca7eca664b16ec2b9bf0055 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/inet_frag.h                 |    9 +++++++++
 net/ipv4/inet_fragment.c                |   20 +++++++++++++++++++-
 net/ipv4/ip_fragment.c                  |   11 ++++-------
 net/ipv6/netfilter/nf_conntrack_reasm.c |   12 ++++++------
 net/ipv6/reassembly.c                   |    8 ++++++--
 5 files changed, 44 insertions(+), 16 deletions(-)

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
index 85190e6..7112e6c 100644
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
index cea1859..578e536 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -299,14 +299,11 @@ static inline struct ipq *ip_find(struct net *net, struct iphdr *iph, u32 user)
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
index c9c78c2..f5ea02f 100644
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
@@ -176,13 +178,11 @@ fq_find(__be32 id, u32 user, struct in6_addr *src, struct in6_addr *dst)
 
 	q = inet_frag_find(&nf_init_frags, &nf_frags, &arg, hash);
 	local_bh_enable();
-	if (q == NULL)
-		goto oom;
-
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
1.7.10.4


