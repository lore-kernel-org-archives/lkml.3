Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaDRHXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:23:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50708 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaDRHXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:23:37 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Steven King <sfking@fdwdc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] slab: fix the type of the index on freelist index accessor
Date: Fri, 18 Apr 2014 16:24:09 +0900
Message-Id: <1397805849-4913-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8dcc774 (slab: introduce byte sized index for the freelist of
a slab) changes the size of freelist index and also changes prototype
of accessor function to freelist index. And there was a mistake.

The mistake is that although it changes the size of freelist index
correctly, it changes the size of the index of freelist index incorrectly.
With patch, freelist index can be 1 byte or 2 bytes, that means that
num of object on on a slab can be more than 255. So we need more than 1
byte for the index to find the index of free object on freelist. But,
above patch makes this index type 1 byte, so slab which have more than
255 objects cannot work properly and in consequence of it, the system
cannot boot.

This issue was reported by Steven King on m68knommu which would use
2 bytes freelist index. Please refer following link.

https://lkml.org/lkml/2014/4/16/433

To fix it is so easy. To change the type of the index of freelist index
on accessor functions is enough to fix this bug. Although 2 bytes is
enough, I use 4 bytes since it have no bad effect and make things
more easier. This fix was suggested and tested by Steven in his
original report.

Reported-by: Steven King <sfking@fdwdc.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
Hello, Pekka.

Could you send this for v3.15-rc2?
Without this patch, many architecture using 2 bytes freelist index cannot
work properly, I guess.

This patch is based on v3.15-rc1.

Thanks.

diff --git a/mm/slab.c b/mm/slab.c
index 388cb1a..d7f9f44 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache *cachep,
 	return freelist;
 }
 
-static inline freelist_idx_t get_free_obj(struct page *page, unsigned char idx)
+static inline freelist_idx_t get_free_obj(struct page *page, unsigned int idx)
 {
 	return ((freelist_idx_t *)page->freelist)[idx];
 }
 
 static inline void set_free_obj(struct page *page,
-					unsigned char idx, freelist_idx_t val)
+					unsigned int idx, freelist_idx_t val)
 {
 	((freelist_idx_t *)(page->freelist))[idx] = val;
 }
-- 
1.7.9.5

