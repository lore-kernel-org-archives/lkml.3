Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3J3KDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:03:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56869 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3J3KDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:03:49 -0400
X-AuditID: 9c930197-b7b3eae00000122e-fb-5270d9810d2c
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 16/15] slab: fix to calm down kmemleak warning
Date: Wed, 30 Oct 2013 19:04:00 +0900
Message-Id: <1383127441-30563-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After using struct page as slab management, we should not call
kmemleak_scan_area(), since struct page isn't the tracking object of
kmemleak. Without this patch and if CONFIG_DEBUG_KMEMLEAK is enabled,
so many kmemleak warnings are printed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index af2db76..a8a9349 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2531,14 +2531,6 @@ static struct freelist *alloc_slabmgmt(struct kmem_cache *cachep,
 		/* Slab management obj is off-slab. */
 		freelist = kmem_cache_alloc_node(cachep->freelist_cache,
 					      local_flags, nodeid);
-		/*
-		 * If the first object in the slab is leaked (it's allocated
-		 * but no one has a reference to it), we want to make sure
-		 * kmemleak does not treat the ->s_mem pointer as a reference
-		 * to the object. Otherwise we will not report the leak.
-		 */
-		kmemleak_scan_area(&page->lru, sizeof(struct list_head),
-				   local_flags);
 		if (!freelist)
 			return NULL;
 	} else {
-- 
1.7.9.5

