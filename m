Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaA1WYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:24:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:55458 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbaA1WYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:24:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,738,1384329600"; 
   d="scan'208";a="474014724"
Subject: [RFC][PATCH] mm: sl[uo]b: fix misleading comments
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        akpm@linux-foundation.org
From: Dave Hansen <dave@sr71.net>
Date: Tue, 28 Jan 2014 14:24:50 -0800
Message-Id: <20140128222450.0B32C3FD@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

On x86, SLUB creates and handles <=8192-byte allocations internally.
It passes larger ones up to the allocator.  Saying "up to order 2" is,
at best, ambiguous.  Is that order-1?  Or (order-2 bytes)?  Make
it more clear.

SLOB commits a similar sin.  It *handles* page-size requests, but the
comment says that it passes up "all page size and larger requests".

SLOB also swaps around the order of the very-similarly-named
KMALLOC_SHIFT_HIGH and KMALLOC_SHIFT_MAX #defines.  Make it
consistent with the order of the other two allocators.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

 b/include/linux/slab.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/slab.h~mm-slub-off-by-one-comment-on-kmalloc-max include/linux/slab.h
--- a/include/linux/slab.h~mm-slub-off-by-one-comment-on-kmalloc-max	2014-01-28 13:27:50.883108273 -0800
+++ b/include/linux/slab.h	2014-01-28 13:27:50.886108408 -0800
@@ -205,8 +205,8 @@ struct kmem_cache {
 
 #ifdef CONFIG_SLUB
 /*
- * SLUB allocates up to order 2 pages directly and otherwise
- * passes the request to the page allocator.
+ * SLUB directly allocates requests fitting in to an order-1 page
+ * (PAGE_SIZE*2).  Larger requests are passed to the page allocator.
  */
 #define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 1)
 #define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT)
@@ -217,12 +217,12 @@ struct kmem_cache {
 
 #ifdef CONFIG_SLOB
 /*
- * SLOB passes all page size and larger requests to the page allocator.
+ * SLOB passes all requests larger than one page to the page allocator.
  * No kmalloc array is necessary since objects of different sizes can
  * be allocated from the same page.
  */
-#define KMALLOC_SHIFT_MAX	30
 #define KMALLOC_SHIFT_HIGH	PAGE_SHIFT
+#define KMALLOC_SHIFT_MAX	30
 #ifndef KMALLOC_SHIFT_LOW
 #define KMALLOC_SHIFT_LOW	3
 #endif
_
