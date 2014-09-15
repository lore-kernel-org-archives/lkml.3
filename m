Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaIOWNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522AbaIOWNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/187] drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.
Date: Mon, 15 Sep 2014 15:09:17 -0700
Message-Id: <1410818997-9432-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 22e71691fd54c637800d10816bbeba9cf132d218 upstream.

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
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
1.9.1

