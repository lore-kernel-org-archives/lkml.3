Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaHXO4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:40 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59546 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaHXO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:37 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-mm@kvack.org
Subject: [PATCH 2/2] mm: use memblock_alloc_range()
Date: Sun, 24 Aug 2014 23:56:03 +0900
Message-Id: <1408892163-8073-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
References: <1408892163-8073-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace memblock_find_in_range() and memblock_reserve() with
memblock_alloc_range().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-mm@kvack.org
---
 mm/memblock.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 6d2f219..4d98d93 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1151,21 +1151,16 @@ static void * __init memblock_virt_alloc_internal(
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
@@ -1178,7 +1173,6 @@ again:
 	}
 
 done:
-	memblock_reserve(alloc, size);
 	ptr = phys_to_virt(alloc);
 	memset(ptr, 0, size);
 
-- 
1.9.1

