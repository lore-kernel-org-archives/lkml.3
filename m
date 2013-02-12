Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3BLUg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3BLUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 59/61] net: splice: avoid high order page splitting
Date: Tue, 12 Feb 2013 12:35:19 -0800
Message-Id: <20130212203425.797926841@linuxfoundation.org>
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

[ Upstream commit 82bda6195615891181115f579a480aa5001ce7e9 ]

splice() can handle pages of any order, but network code tries hard to
split them in PAGE_SIZE units. Not quite successfully anyway, as
__splice_segment() assumed poff < PAGE_SIZE. This is true for
the skb->data part, not necessarily for the fragments.

This patch removes this logic to give the pages as they are in the skb.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1677,20 +1677,6 @@ static bool spd_fill_page(struct splice_
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
@@ -1698,6 +1684,8 @@ static bool __splice_segment(struct page
 			     struct sock *sk,
 			     struct pipe_inode_info *pipe)
 {
+	unsigned int flen;
+
 	if (!*len)
 		return true;
 
@@ -1708,24 +1696,16 @@ static bool __splice_segment(struct page
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


