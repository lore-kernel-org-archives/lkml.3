Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaHCLQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:16:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:32388 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaHCLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:16:33 -0400
To: konrad.wilk@oracle.com, dchinner@redhat.com
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 4/5] gpu/drm/ttm: Fix possible stack overflow by recursive shrinker calls.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140610191741.GA28523@phenom.dumpdata.com>
	<201406110516.HCH90692.FFFStVJMOHOLQO@I-love.SAKURA.ne.jp>
	<201408032014.EBE26508.FQOFtHFOSVJMOL@I-love.SAKURA.ne.jp>
	<201408032014.BHF60482.VFOFSMJLtHQFOO@I-love.SAKURA.ne.jp>
	<201408032015.EDH17687.SJOtFFLMFHVOQO@I-love.SAKURA.ne.jp>
In-Reply-To: <201408032015.EDH17687.SJOtFFLMFHVOQO@I-love.SAKURA.ne.jp>
Message-Id: <201408032016.CFI95841.SOVHFQtFJFOLOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 3 Aug 2014 20:16:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 16009d9def2c3087772e6c9dbec6c60950ae768b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 3 Aug 2014 20:02:03 +0900
Subject: [PATCH 4/5] gpu/drm/ttm: Fix possible stack overflow by recursive shrinker calls.

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
Cc: stable <stable@kernel.org> [2.6.35+]
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index beb8e75..edb8315 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -391,14 +391,17 @@ out:
 static unsigned long
 ttm_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	static atomic_t start_pool = ATOMIC_INIT(0);
+	static DEFINE_MUTEX(lock);
+	static unsigned start_pool;
 	unsigned i;
-	unsigned pool_offset = atomic_add_return(1, &start_pool);
+	unsigned pool_offset;
 	struct ttm_page_pool *pool;
 	int shrink_pages = sc->nr_to_scan;
 	unsigned long freed = 0;
 
-	pool_offset = pool_offset % NUM_POOLS;
+	if (!mutex_trylock(&lock))
+		return SHRINK_STOP;
+	pool_offset = ++start_pool % NUM_POOLS;
 	/* select start pool in round robin fashion */
 	for (i = 0; i < NUM_POOLS; ++i) {
 		unsigned nr_free = shrink_pages;
@@ -408,6 +411,7 @@ ttm_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		shrink_pages = ttm_page_pool_free(pool, nr_free);
 		freed += nr_free - shrink_pages;
 	}
+	mutex_unlock(&lock);
 	return freed;
 }
 
-- 
1.7.1
