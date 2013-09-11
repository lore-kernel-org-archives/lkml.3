Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3IKACz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:02:55 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:41106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751890Ab3IKACx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:02:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:4321:5007:7652:8784:9592:10004:10400:10848:11658:11914:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: party67_704cf563ecb4b
X-Filterd-Recvd-Size: 2072
Message-ID: <1378857771.15187.4.camel@joe-AO722>
Subject: [PATCH] slab: Make allocations with GFP_ZERO slightly more efficient
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Sep 2013 17:02:51 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the likely mechanism already around valid
pointer tests to better choose when to memset
to 0 allocations with __GFP_ZERO

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/slab.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 2580db0..94e7e54 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3392,11 +3392,11 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	kmemleak_alloc_recursive(ptr, cachep->object_size, 1, cachep->flags,
 				 flags);
 
-	if (likely(ptr))
+	if (likely(ptr)) {
 		kmemcheck_slab_alloc(cachep, flags, ptr, cachep->object_size);
-
-	if (unlikely((flags & __GFP_ZERO) && ptr))
-		memset(ptr, 0, cachep->object_size);
+		if (unlikely(flags & __GFP_ZERO))
+			memset(ptr, 0, cachep->object_size);
+	}
 
 	return ptr;
 }
@@ -3457,11 +3457,11 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 				 flags);
 	prefetchw(objp);
 
-	if (likely(objp))
+	if (likely(objp)) {
 		kmemcheck_slab_alloc(cachep, flags, objp, cachep->object_size);
-
-	if (unlikely((flags & __GFP_ZERO) && objp))
-		memset(objp, 0, cachep->object_size);
+		if (unlikely(flags & __GFP_ZERO))
+			memset(objp, 0, cachep->object_size);
+	}
 
 	return objp;
 }


