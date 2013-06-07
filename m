Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3FGJ4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:56:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5300 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3FGJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:56:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,821,1363104000"; 
   d="scan'208";a="7491533"
Message-ID: <51B1AD9D.2010803@cn.fujitsu.com>
Date: Fri, 07 Jun 2013 17:53:33 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: chanho.min@lge.com, Johannes Weiner <hannes@cmpxchg.org>,
        iamjoonsoo.kim@lge.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/3] mm, vmalloc: Remove dead code in vb_alloc
References: <51B1AD2F.4030702@cn.fujitsu.com>
In-Reply-To: <51B1AD2F.4030702@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:54:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:54:32,
	Serialize complete at 2013/06/07 17:54:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Space in a vmap block that was once allocated is considered dirty and
not made available for allocation again before the whole block is
recycled. The result is that free space within a vmap block is always
contiguous.

So if a vmap block has enough free space for allocation, the allocation
is impossible to fail. Thus, the fragmented block purging was never invoked
from vb_alloc(). So remove this dead code.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d365724..b8abcba 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -910,7 +910,6 @@ static void *vb_alloc(unsigned long size, gfp_t gfp_mask)
 	struct vmap_block *vb;
 	unsigned long addr = 0;
 	unsigned int order;
-	int purge = 0;
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
@@ -934,17 +933,7 @@ again:
 		if (vb->free < 1UL << order)
 			goto next;
 
-		i = bitmap_find_free_region(vb->alloc_map,
-						VMAP_BBMAP_BITS, order);
-
-		if (i < 0) {
-			if (vb->free + vb->dirty == VMAP_BBMAP_BITS) {
-				/* fragmented and no outstanding allocations */
-				BUG_ON(vb->dirty != VMAP_BBMAP_BITS);
-				purge = 1;
-			}
-			goto next;
-		}
+		i = VMAP_BBMAP_BITS - vb->free;
 		addr = vb->va->va_start + (i << PAGE_SHIFT);
 		BUG_ON(addr_to_vb_idx(addr) !=
 				addr_to_vb_idx(vb->va->va_start));
@@ -960,9 +949,6 @@ next:
 		spin_unlock(&vb->lock);
 	}
 
-	if (purge)
-		purge_fragmented_blocks_thiscpu();
-
 	put_cpu_var(vmap_block_queue);
 	rcu_read_unlock();
 
-- 
1.7.1
