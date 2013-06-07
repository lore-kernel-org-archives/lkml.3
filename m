Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3FGJ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:57:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23526 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3FGJ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:57:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,821,1363104000"; 
   d="scan'208";a="7491549"
Message-ID: <51B1ADFE.2020201@cn.fujitsu.com>
Date: Fri, 07 Jun 2013 17:55:10 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: chanho.min@lge.com, Johannes Weiner <hannes@cmpxchg.org>,
        iamjoonsoo.kim@lge.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/3] mm, vmalloc: Remove alloc_map from vmap_block
References: <51B1AD2F.4030702@cn.fujitsu.com>
In-Reply-To: <51B1AD2F.4030702@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:56:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:56:08,
	Serialize complete at 2013/06/07 17:56:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have removed the dead code in the vb_alloc, it seems there is
no place to use the alloc_map. So there is no reason to maintain
the alloc_map in vmap_block.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5c037b9..ad11d4f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -754,7 +754,6 @@ struct vmap_block {
 	struct vmap_area *va;
 	struct vmap_block_queue *vbq;
 	unsigned long free, dirty;
-	DECLARE_BITMAP(alloc_map, VMAP_BBMAP_BITS);
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	struct list_head free_list;
 	struct rcu_head rcu_head;
@@ -820,7 +819,6 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	vb->va = va;
 	vb->free = VMAP_BBMAP_BITS;
 	vb->dirty = 0;
-	bitmap_zero(vb->alloc_map, VMAP_BBMAP_BITS);
 	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
 	INIT_LIST_HEAD(&vb->free_list);
 
@@ -873,7 +871,6 @@ static void purge_fragmented_blocks(int cpu)
 		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
 			vb->free = 0; /* prevent further allocs after releasing lock */
 			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
-			bitmap_fill(vb->alloc_map, VMAP_BBMAP_BITS);
 			bitmap_fill(vb->dirty_map, VMAP_BBMAP_BITS);
 			spin_lock(&vbq->lock);
 			list_del_rcu(&vb->free_list);
-- 
1.7.1

