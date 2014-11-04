Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaKDIbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:31:50 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:48923 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKDIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:31:44 -0500
Subject: [PATCH 1/4] inet: Add skb_copy_datagram_iter
References: <20141104033818.GA11149@gondor.apana.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Message-Id: <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 04 Nov 2014 16:31:34 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds skb_copy_datagram_iter, which is identical to
skb_copy_datagram_iovec except that it operates on iov_iter
instead of iovec.

Eventually all users of skb_copy_datagram_iovec should switch
over to iov_iter and then we can remove skb_copy_datagram_iovec.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/skbuff.h |    3 +
 net/core/datagram.c    |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6c8b6f6..5ff7054 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -148,6 +148,7 @@
 struct net_device;
 struct scatterlist;
 struct pipe_inode_info;
+struct iov_iter;
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 struct nf_conntrack {
@@ -2641,6 +2642,8 @@ int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *frm,
 int skb_copy_datagram_const_iovec(const struct sk_buff *from, int offset,
 				  const struct iovec *to, int to_offset,
 				  int size);
+int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
+			   struct iov_iter *to, int size);
 void skb_free_datagram(struct sock *sk, struct sk_buff *skb);
 void skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb);
 int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index fdbc9a8..45a9d4d 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -49,6 +49,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/uio.h>
 
 #include <net/protocol.h>
 #include <linux/skbuff.h>
@@ -482,6 +483,87 @@ fault:
 EXPORT_SYMBOL(skb_copy_datagram_const_iovec);
 
 /**
+ *	skb_copy_datagram_iter - Copy a datagram to an iovec iterator.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying from
+ *	@to: iovec iterator to copy to
+ *	@len: amount of data to copy from buffer to iovec
+ */
+int skb_copy_datagram_iter(const struct sk_buff *skb, int offset,
+			   struct iov_iter *to, int len)
+{
+	int start = skb_headlen(skb);
+	int i, copy = start - offset;
+	struct sk_buff *frag_iter;
+
+	trace_skb_copy_datagram_iovec(skb, len);
+
+	/* Copy header. */
+	if (copy > 0) {
+		if (copy > len)
+			copy = len;
+		if (copy_to_iter(skb->data + offset, copy, to))
+			goto fault;
+		if ((len -= copy) == 0)
+			return 0;
+		offset += copy;
+	}
+
+	/* Copy paged appendix. Hmm... why does this look so complicated? */
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		int end;
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+		WARN_ON(start > offset + len);
+
+		end = start + skb_frag_size(frag);
+		if ((copy = end - offset) > 0) {
+			int err;
+			u8  *vaddr;
+			struct page *page = skb_frag_page(frag);
+
+			if (copy > len)
+				copy = len;
+			vaddr = kmap(page);
+			err = copy_to_iter(vaddr + frag->page_offset +
+					   offset - start, copy, to);
+			kunmap(page);
+			if (err)
+				goto fault;
+			if (!(len -= copy))
+				return 0;
+			offset += copy;
+		}
+		start = end;
+	}
+
+	skb_walk_frags(skb, frag_iter) {
+		int end;
+
+		WARN_ON(start > offset + len);
+
+		end = start + frag_iter->len;
+		if ((copy = end - offset) > 0) {
+			if (copy > len)
+				copy = len;
+			if (skb_copy_datagram_iter(frag_iter, offset - start,
+						   to, copy))
+				goto fault;
+			if ((len -= copy) == 0)
+				return 0;
+			offset += copy;
+		}
+		start = end;
+	}
+	if (!len)
+		return 0;
+
+fault:
+	return -EFAULT;
+}
+EXPORT_SYMBOL(skb_copy_datagram_iter);
+
+/**
  *	skb_copy_datagram_from_iovec - Copy a datagram from an iovec.
  *	@skb: buffer to copy
  *	@offset: offset in the buffer to start copying to
