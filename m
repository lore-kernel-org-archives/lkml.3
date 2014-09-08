Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaIHXi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:38:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:65535 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaIHXiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:38:25 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>, linux-mm@kvack.org
Subject: [PATCH v2 1/3] mm: use memblock_alloc_range_nid() and memblock_alloc_range()
Date: Tue,  9 Sep 2014 08:38:02 +0900
Message-Id: <1410219484-8038-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_alloc_range_nid() is equivalent to memblock_find_in_range_node()
followed by memblock_reserve().  memblock_alloc_range() is equivalent to
memblock_alloc_range_nid() with NUMA_NO_NODE for any node.

Convert to use these functions and remove subsequent kmemleak_alloc()
call as it is already called in memblock_alloc() and its variants.

This is just a cleanup.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: linux-mm@kvack.org
---
* v2: fix overlapping kmemleak_alloc() calls, reported by Sabrina Dubroca.

 mm/memblock.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 70fad0c..a942f6e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1150,21 +1150,16 @@ static void * __init memblock_virt_alloc_internal(
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, nid);
 
-	if (!align)
-		align = SMP_CACHE_BYTES;
-
 	if (max_addr > memblock.current_limit)
 		max_addr = memblock.current_limit;
 
 again:
-	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
-					    nid);
+	alloc = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid);
 	if (alloc)
 		goto done;
 
 	if (nid != NUMA_NO_NODE) {
-		alloc = memblock_find_in_range_node(size, align, min_addr,
-						    max_addr,  NUMA_NO_NODE);
+		alloc = memblock_alloc_range(size, align, min_addr, max_addr);
 		if (alloc)
 			goto done;
 	}
@@ -1177,18 +1172,9 @@ again:
 	}
 
 done:
-	memblock_reserve(alloc, size);
 	ptr = phys_to_virt(alloc);
 	memset(ptr, 0, size);
 
-	/*
-	 * The min_count is set to 0 so that bootmem allocated blocks
-	 * are never reported as leaks. This is because many of these blocks
-	 * are only referred via the physical address which is not
-	 * looked up by kmemleak.
-	 */
-	kmemleak_alloc(ptr, size, 0, 0);
-
 	return ptr;
 
 error:
-- 
1.9.1

