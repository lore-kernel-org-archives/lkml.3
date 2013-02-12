Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3BLUgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab3BLUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/61] net: splice: fix __splice_segment()
Date: Tue, 12 Feb 2013 12:35:20 -0800
Message-Id: <20130212203425.906692142@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bc9540c637c3d8712ccbf9dcf28621f380ed5e64 ]

commit 9ca1b22d6d2 (net: splice: avoid high order page splitting)
forgot that skb->head could need a copy into several page frags.

This could be the case for loopback traffic mostly.

Also remove now useless skb argument from linear_to_page()
and __splice_segment() prototypes.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1620,7 +1620,7 @@ static void sock_spd_release(struct spli
 
 static struct page *linear_to_page(struct page *page, unsigned int *len,
 				   unsigned int *offset,
-				   struct sk_buff *skb, struct sock *sk)
+				   struct sock *sk)
 {
 	struct page_frag *pfrag = sk_page_frag(sk);
 
@@ -1653,14 +1653,14 @@ static bool spd_can_coalesce(const struc
 static bool spd_fill_page(struct splice_pipe_desc *spd,
 			  struct pipe_inode_info *pipe, struct page *page,
 			  unsigned int *len, unsigned int offset,
-			  struct sk_buff *skb, bool linear,
+			  bool linear,
 			  struct sock *sk)
 {
 	if (unlikely(spd->nr_pages == MAX_SKB_FRAGS))
 		return true;
 
 	if (linear) {
-		page = linear_to_page(page, len, &offset, skb, sk);
+		page = linear_to_page(page, len, &offset, sk);
 		if (!page)
 			return true;
 	}
@@ -1679,13 +1679,11 @@ static bool spd_fill_page(struct splice_
 
 static bool __splice_segment(struct page *page, unsigned int poff,
 			     unsigned int plen, unsigned int *off,
-			     unsigned int *len, struct sk_buff *skb,
+			     unsigned int *len,
 			     struct splice_pipe_desc *spd, bool linear,
 			     struct sock *sk,
 			     struct pipe_inode_info *pipe)
 {
-	unsigned int flen;
-
 	if (!*len)
 		return true;
 
@@ -1700,12 +1698,16 @@ static bool __splice_segment(struct page
 	plen -= *off;
 	*off = 0;
 
-	flen = min(*len, plen);
-
-	if (spd_fill_page(spd, pipe, page, &flen, poff, skb, linear, sk))
-		return true;
+	do {
+		unsigned int flen = min(*len, plen);
 
-	*len -= flen;
+		if (spd_fill_page(spd, pipe, page, &flen, poff,
+				  linear, sk))
+			return true;
+		poff += flen;
+		plen -= flen;
+		*len -= flen;
+	} while (*len && plen);
 
 	return false;
 }
@@ -1728,7 +1730,7 @@ static bool __skb_splice_bits(struct sk_
 	if (__splice_segment(virt_to_page(skb->data),
 			     (unsigned long) skb->data & (PAGE_SIZE - 1),
 			     skb_headlen(skb),
-			     offset, len, skb, spd,
+			     offset, len, spd,
 			     skb_head_is_locked(skb),
 			     sk, pipe))
 		return true;
@@ -1741,7 +1743,7 @@ static bool __skb_splice_bits(struct sk_
 
 		if (__splice_segment(skb_frag_page(f),
 				     f->page_offset, skb_frag_size(f),
-				     offset, len, skb, spd, false, sk, pipe))
+				     offset, len, spd, false, sk, pipe))
 			return true;
 	}
 


