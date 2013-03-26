Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3CZRnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:43:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3CZRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:25 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=IHbmYsxIYacA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=koTvw1UCLf0A:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173611.986940862@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 76/86] net: splice: avoid high order page splitting
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0076-net-splice-avoid-high-order-page-splitting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4678414601960b3d60b651d82e2913c48c53508d ]

splice() can handle pages of any order, but network code tries hard to
split them in PAGE_SIZE units. Not quite successfully anyway, as
__splice_segment() assumed poff < PAGE_SIZE. This is true for
the skb->data part, not necessarily for the fragments.

This patch removes this logic to give the pages as they are in the skb.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/skbuff.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9708777..8e6a22c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1682,20 +1682,6 @@ static bool spd_fill_page(struct splice_pipe_desc *spd,
 	return false;
 }
 
-static inline void __segment_seek(struct page **page, unsigned int *poff,
-				  unsigned int *plen, unsigned int off)
-{
-	unsigned long n;
-
-	*poff += off;
-	n = *poff / PAGE_SIZE;
-	if (n)
-		*page = nth_page(*page, n);
-
-	*poff = *poff % PAGE_SIZE;
-	*plen -= off;
-}
-
 static bool __splice_segment(struct page *page, unsigned int poff,
 			     unsigned int plen, unsigned int *off,
 			     unsigned int *len, struct sk_buff *skb,
@@ -1703,6 +1689,8 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 			     struct sock *sk,
 			     struct pipe_inode_info *pipe)
 {
+	unsigned int flen;
+
 	if (!*len)
 		return true;
 
@@ -1713,24 +1701,16 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 	}
 
 	/* ignore any bits we already processed */
-	if (*off) {
-		__segment_seek(&page, &poff, &plen, *off);
-		*off = 0;
-	}
-
-	do {
-		unsigned int flen = min(*len, plen);
+	poff += *off;
+	plen -= *off;
+	*off = 0;
 
-		/* the linear region may spread across several pages  */
-		flen = min_t(unsigned int, flen, PAGE_SIZE - poff);
+	flen = min(*len, plen);
 
-		if (spd_fill_page(spd, pipe, page, &flen, poff, skb, linear, sk))
-			return true;
-
-		__segment_seek(&page, &poff, &plen, flen);
-		*len -= flen;
+	if (spd_fill_page(spd, pipe, page, &flen, poff, skb, linear, sk))
+		return true;
 
-	} while (*len && plen);
+	*len -= flen;
 
 	return false;
 }
-- 
1.7.10.4


