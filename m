Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936668Ab3DIBU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:20:57 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51034 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936057Ab3DIBUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:20:47 -0400
X-AuditID: 9c930179-b7b2aae000000518-89-51636cebf047
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 3/3] mm, slab: count freed pages via rcu as this task's reclaimed_slab
Date: Tue,  9 Apr 2013 10:21:18 +0900
Message-Id: <1365470478-645-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, freed pages via rcu is not counted for reclaimed_slab, because
it is freed in rcu context, not current task context. But, this free is
initiated by this task, so counting this into this task's reclaimed_slab
is meaningful to decide whether we continue reclaim, or not.
So change code to count these pages for this task's reclaimed_slab.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 856e4a1..4d94bcb 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1934,8 +1934,6 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	}
 
 	memcg_release_pages(cachep, cachep->gfporder);
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += nr_freed;
 	free_memcg_kmem_pages((unsigned long)addr, cachep->gfporder);
 }
 
@@ -2165,6 +2163,7 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slab
  */
 static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 {
+	unsigned long nr_freed = (1 << cachep->gfporder);
 	void *addr = slabp->s_mem - slabp->colouroff;
 
 	slab_destroy_debugcheck(cachep, slabp);
@@ -2180,6 +2179,9 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 		if (OFF_SLAB(cachep))
 			kmem_cache_free(cachep->slabp_cache, slabp);
 	}
+
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed_slab += nr_freed;
 }
 
 /**
-- 
1.7.9.5

