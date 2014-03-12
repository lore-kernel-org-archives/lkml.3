Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaCLI0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:26:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51708 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbaCLI0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:26:17 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-31-53201a269c64
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Casteyde <casteyde.christian@free.fr>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RESEND PATCH] slub: fix high order page allocation problem with  __GFP_NOFAIL
Date: Wed, 12 Mar 2014 17:26:20 +0900
Message-Id: <1394612780-8033-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB already try to allocate high order page with clearing __GFP_NOFAIL.
But, when allocating shadow page for kmemcheck, it missed clearing
the flag. This trigger WARN_ON_ONCE() reported by Christian Casteyde.

https://bugzilla.kernel.org/show_bug.cgi?id=65991
https://lkml.org/lkml/2013/12/3/764

This patch fix this situation by using same allocation flag as original
allocation.

Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slub.c b/mm/slub.c
index 3508ede..d43b063 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1348,11 +1348,12 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {
 		oo = s->min;
+		alloc_gfp = flags;
 		/*
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		page = alloc_slab_page(flags, node, oo);
+		page = alloc_slab_page(alloc_gfp, node, oo);
 
 		if (page)
 			stat(s, ORDER_FALLBACK);
@@ -1362,7 +1363,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
 
-		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
+		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
 
 		/*
 		 * Objects from caches that have a constructor don't get
-- 
1.7.9.5

