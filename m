Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaIZJtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:49:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbaIZJq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 129/142] drm/ttm: Fix possible stack overflow by recursive shrinker calls.
Date: Fri, 26 Sep 2014 11:45:40 +0200
Message-Id: <726e09542d0526359c9066f27fcc99437558bf7e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 863bef9f9234..deba59b6ef83 100644
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
2.1.0

