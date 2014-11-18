Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaKRTnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:43:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53971 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaKRTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:43:17 -0500
Date: Tue, 18 Nov 2014 19:43:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: netdev@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] bury skb_copy_to_page()
Message-ID: <20141118194315.GE14641@ZenIV.linux.org.uk>
References: <20141118084745.GT7996@ZenIV.linux.org.uk>
 <20141118194053.GA14641@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118194053.GA14641@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no callers since 3.0

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/sock.h |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 94e0ead..d7d43e9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1883,29 +1883,6 @@ static inline int skb_copy_to_page_nocache(struct sock *sk, char __user *from,
 	return 0;
 }
 
-static inline int skb_copy_to_page(struct sock *sk, char __user *from,
-				   struct sk_buff *skb, struct page *page,
-				   int off, int copy)
-{
-	if (skb->ip_summed == CHECKSUM_NONE) {
-		int err = 0;
-		__wsum csum = csum_and_copy_from_user(from,
-						     page_address(page) + off,
-							    copy, 0, &err);
-		if (err)
-			return err;
-		skb->csum = csum_block_add(skb->csum, csum, skb->len);
-	} else if (__copy_from_user(page_address(page) + off, from, copy))
-		return -EFAULT;
-
-	skb->len	     += copy;
-	skb->data_len	     += copy;
-	skb->truesize	     += copy;
-	sk->sk_wmem_queued   += copy;
-	sk_mem_charge(sk, copy);
-	return 0;
-}
-
 /**
  * sk_wmem_alloc_get - returns write allocations
  * @sk: socket
-- 
1.7.10.4

