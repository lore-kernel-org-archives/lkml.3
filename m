Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3CZRn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:43:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3CZRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:25 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ON8CkkjY_z4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=o707MHCW9TUA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=4GEhVLJy-apUUS-8O-sA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173612.141152254@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 77/86] net: splice: fix __splice_segment()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0077-net-splice-fix-__splice_segment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9049d7450887d54b199441144f8ba50fa4d8cf92 ]

commit 9ca1b22d6d2 (net: splice: avoid high order page splitting)
forgot that skb->head could need a copy into several page frags.

This could be the case for loopback traffic mostly.

Also remove now useless skb argument from linear_to_page()
and __splice_segment() prototypes.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/skbuff.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8e6a22c..043139d01 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1606,7 +1606,7 @@ static void sock_spd_release(struct splice_pipe_desc *spd, unsigned int i)
 
 static struct page *linear_to_page(struct page *page, unsigned int *len,
 				   unsigned int *offset,
-				   struct sk_buff *skb, struct sock *sk)
+				   struct sock *sk)
 {
 	struct page *p = sk->sk_sndmsg_page;
 	unsigned int off;
@@ -1658,14 +1658,14 @@ static bool spd_can_coalesce(const struct splice_pipe_desc *spd,
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
@@ -1684,13 +1684,11 @@ static bool spd_fill_page(struct splice_pipe_desc *spd,
 
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
 
@@ -1705,12 +1703,16 @@ static bool __splice_segment(struct page *page, unsigned int poff,
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
@@ -1733,7 +1735,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 	if (__splice_segment(virt_to_page(skb->data),
 			     (unsigned long) skb->data & (PAGE_SIZE - 1),
 			     skb_headlen(skb),
-			     offset, len, skb, spd,
+			     offset, len, spd,
 			     skb_head_is_locked(skb),
 			     sk, pipe))
 		return true;
@@ -1746,7 +1748,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 		if (__splice_segment(skb_frag_page(f),
 				     f->page_offset, skb_frag_size(f),
-				     offset, len, skb, spd, false, sk, pipe))
+				     offset, len, spd, false, sk, pipe))
 			return true;
 	}
 
-- 
1.7.10.4


