Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaHUIKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:10:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48067 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaHUIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:09:26 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/5] mm/slab: noinline __ac_put_obj()
Date: Thu, 21 Aug 2014 17:09:21 +0900
Message-Id: <1408608562-20339-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our intention of __ac_put_obj() is that it doesn't affect anything if
sk_memalloc_socks() is disabled. But, because __ac_put_obj() is too small,
compiler inline it to ac_put_obj() and affect code size of free path.
This patch add noinline keyword for __ac_put_obj() not to distrupt normal
free path at all.

<Before>
nm -S slab-orig.o |
	grep -e "t cache_alloc_refill" -e "T kfree" -e "T kmem_cache_free"

0000000000001e80 00000000000002f5 t cache_alloc_refill
0000000000001230 0000000000000258 T kfree
0000000000000690 000000000000024c T kmem_cache_free

<After>
nm -S slab-patched.o |
	grep -e "t cache_alloc_refill" -e "T kfree" -e "T kmem_cache_free"

0000000000001e00 00000000000002e5 t cache_alloc_refill
00000000000011e0 0000000000000228 T kfree
0000000000000670 0000000000000216 T kmem_cache_free

cache_alloc_refill: 0x2f5->0x2e5
kfree: 0x256->0x228
kmem_cache_free: 0x24c->0x216

code size of each function is reduced slightly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index d364e3f..c9f137f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -785,8 +785,8 @@ static inline void *ac_get_obj(struct kmem_cache *cachep,
 	return objp;
 }
 
-static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
-								void *objp)
+static noinline void *__ac_put_obj(struct kmem_cache *cachep,
+			struct array_cache *ac, void *objp)
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
-- 
1.7.9.5

