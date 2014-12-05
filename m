Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaLEF7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:59:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51316 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaLEF64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:58:56 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] skb_copy_datagram_iovec() can die
Date: Fri,  5 Dec 2014 05:58:52 +0000
Message-Id: <1417759133-18370-11-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141205055623.GQ29748@ZenIV.linux.org.uk>
References: <20141205055623.GQ29748@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

no callers other than itself.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/skbuff.h |  2 --
 net/core/datagram.c    | 84 --------------------------------------------------
 2 files changed, 86 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 45ac95c..f676e54 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2642,8 +2642,6 @@ struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned flags, int noblock,
 				  int *err);
 unsigned int datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
-int skb_copy_datagram_iovec(const struct sk_buff *from, int offset,
-			    struct iovec *to, int size);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
 			   struct iov_iter *to, int size);
 static inline int skb_copy_datagram_msg(const struct sk_buff *from, int offset,
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 41075ed..df493d6 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -310,90 +310,6 @@ int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags)
 EXPORT_SYMBOL(skb_kill_datagram);
 
 /**
- *	skb_copy_datagram_iovec - Copy a datagram to an iovec.
- *	@skb: buffer to copy
- *	@offset: offset in the buffer to start copying from
- *	@to: io vector to copy to
- *	@len: amount of data to copy from buffer to iovec
- *
- *	Note: the iovec is modified during the copy.
- */
-int skb_copy_datagram_iovec(const struct sk_buff *skb, int offset,
-			    struct iovec *to, int len)
-{
-	int start = skb_headlen(skb);
-	int i, copy = start - offset;
-	struct sk_buff *frag_iter;
-
-	trace_skb_copy_datagram_iovec(skb, len);
-
-	/* Copy header. */
-	if (copy > 0) {
-		if (copy > len)
-			copy = len;
-		if (memcpy_toiovec(to, skb->data + offset, copy))
-			goto fault;
-		if ((len -= copy) == 0)
-			return 0;
-		offset += copy;
-	}
-
-	/* Copy paged appendix. Hmm... why does this look so complicated? */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		int end;
-		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-
-		WARN_ON(start > offset + len);
-
-		end = start + skb_frag_size(frag);
-		if ((copy = end - offset) > 0) {
-			int err;
-			u8  *vaddr;
-			struct page *page = skb_frag_page(frag);
-
-			if (copy > len)
-				copy = len;
-			vaddr = kmap(page);
-			err = memcpy_toiovec(to, vaddr + frag->page_offset +
-					     offset - start, copy);
-			kunmap(page);
-			if (err)
-				goto fault;
-			if (!(len -= copy))
-				return 0;
-			offset += copy;
-		}
-		start = end;
-	}
-
-	skb_walk_frags(skb, frag_iter) {
-		int end;
-
-		WARN_ON(start > offset + len);
-
-		end = start + frag_iter->len;
-		if ((copy = end - offset) > 0) {
-			if (copy > len)
-				copy = len;
-			if (skb_copy_datagram_iovec(frag_iter,
-						    offset - start,
-						    to, copy))
-				goto fault;
-			if ((len -= copy) == 0)
-				return 0;
-			offset += copy;
-		}
-		start = end;
-	}
-	if (!len)
-		return 0;
-
-fault:
-	return -EFAULT;
-}
-EXPORT_SYMBOL(skb_copy_datagram_iovec);
-
-/**
  *	skb_copy_datagram_iter - Copy a datagram to an iovec iterator.
  *	@skb: buffer to copy
  *	@offset: offset in the buffer to start copying from
-- 
2.1.3

