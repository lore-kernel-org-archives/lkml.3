Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbaJDAws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:52:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaJCVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.16 015/357] drm/ttm: Fix possible stack overflow by recursive shrinker calls.
Date: Fri,  3 Oct 2014 14:26:41 -0700
Message-Id: <20141003212933.930837412@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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
@@ -408,6 +411,7 @@ ttm_pool_shrink_scan(struct shrinker *sh
 		shrink_pages = ttm_page_pool_free(pool, nr_free);
 		freed += nr_free - shrink_pages;
 	}
+	mutex_unlock(&lock);
 	return freed;
 }
 


