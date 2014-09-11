Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaIKMjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:39:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51678 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>,
        "Dave Airlie" <airlied@redhat.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.803181458@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 051/131] drm/ttm: Fix possible stack overflow by
 recursive shrinker calls.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 71336e011d1d2312bcbcaa8fcec7365024f3a95d upstream.

While ttm_dma_pool_shrink_scan() tries to take mutex before doing GFP_KERNEL
allocation, ttm_pool_shrink_scan() does not do it. This can result in stack
overflow if kmalloc() in ttm_page_pool_free() triggered recursion due to
memory pressure.

  shrink_slab()
  => ttm_pool_shrink_scan()
     => ttm_page_pool_free()
        => kmalloc(GFP_KERNEL)
           => shrink_slab()
              => ttm_pool_shrink_scan()
                 => ttm_page_pool_free()
                    => kmalloc(GFP_KERNEL)

Change ttm_pool_shrink_scan() to do like ttm_dma_pool_shrink_scan() does.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Change return value in the contended case to follow the old shrinker
   API]   
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -398,13 +398,18 @@ static int ttm_pool_get_num_unused_pages
 static int ttm_pool_mm_shrink(struct shrinker *shrink,
 			      struct shrink_control *sc)
 {
-	static atomic_t start_pool = ATOMIC_INIT(0);
+	static DEFINE_MUTEX(lock);
+	static unsigned start_pool;
 	unsigned i;
-	unsigned pool_offset = atomic_add_return(1, &start_pool);
+	unsigned pool_offset;
 	struct ttm_page_pool *pool;
 	int shrink_pages = sc->nr_to_scan;
 
-	pool_offset = pool_offset % NUM_POOLS;
+	if (shrink_pages == 0)
+		goto out;
+	if (!mutex_trylock(&lock))
+		return -1;
+	pool_offset = ++start_pool % NUM_POOLS;
 	/* select start pool in round robin fashion */
 	for (i = 0; i < NUM_POOLS; ++i) {
 		unsigned nr_free = shrink_pages;
@@ -413,6 +418,8 @@ static int ttm_pool_mm_shrink(struct shr
 		pool = &_manager->pools[(i + pool_offset)%NUM_POOLS];
 		shrink_pages = ttm_page_pool_free(pool, nr_free);
 	}
+	mutex_unlock(&lock);
+out:
 	/* return estimated number of unused pages in pool */
 	return ttm_pool_get_num_unused_pages();
 }

