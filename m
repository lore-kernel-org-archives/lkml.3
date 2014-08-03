Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaHCLP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:15:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:16653 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaHCLP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:15:57 -0400
To: konrad.wilk@oracle.com, dchinner@redhat.com
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3/5] gpu/drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405311200.III57894.MLFOOFStQVHJFO@I-love.SAKURA.ne.jp>
	<20140610191741.GA28523@phenom.dumpdata.com>
	<201406110516.HCH90692.FFFStVJMOHOLQO@I-love.SAKURA.ne.jp>
	<201408032014.EBE26508.FQOFtHFOSVJMOL@I-love.SAKURA.ne.jp>
	<201408032014.BHF60482.VFOFSMJLtHQFOO@I-love.SAKURA.ne.jp>
In-Reply-To: <201408032014.BHF60482.VFOFSMJLtHQFOO@I-love.SAKURA.ne.jp>
Message-Id: <201408032015.EDH17687.SJOtFFLMFHVOQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 3 Aug 2014 20:15:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e945aa0d6518563835c3f279b9c7f9fc3f20b38b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 3 Aug 2014 20:01:10 +0900
Subject: [PATCH 3/5] gpu/drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.

I can observe that RHEL7 environment stalls with 100% CPU usage when a
certain type of memory pressure is given. While the shrinker functions
are called by shrink_slab() before the OOM killer is triggered, the stall
lasts for many minutes.

One of reasons of this stall is that
ttm_dma_pool_shrink_count()/ttm_dma_pool_shrink_scan() are called and
are blocked at mutex_lock(&_manager->lock). GFP_KERNEL allocation with
_manager->lock held causes someone (including kswapd) to deadlock when
these functions are called due to memory pressure. This patch changes
"mutex_lock();" to "if (!mutex_trylock()) return ...;" in order to
avoid deadlock.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@kernel.org> [3.3+]
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index d8e59f7..524cc1a 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1014,7 +1014,8 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	if (list_empty(&_manager->pools))
 		return SHRINK_STOP;
 
-	mutex_lock(&_manager->lock);
+	if (!mutex_trylock(&_manager->lock))
+		return SHRINK_STOP;
 	if (!_manager->npools)
 		goto out;
 	pool_offset = ++start_pool % _manager->npools;
@@ -1047,7 +1048,8 @@ ttm_dma_pool_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 	struct device_pools *p;
 	unsigned long count = 0;
 
-	mutex_lock(&_manager->lock);
+	if (!mutex_trylock(&_manager->lock))
+		return 0;
 	list_for_each_entry(p, &_manager->pools, pools)
 		count += p->pool->npages_free;
 	mutex_unlock(&_manager->lock);
-- 
1.7.1
