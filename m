Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaESOjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:39:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:24020 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaESOje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:39:34 -0400
X-Nat-Received: from [202.181.97.72]:12094 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400510344.18648
To: dchinner@redhat.com, glommer@openvz.org, mgorman@suse.de, airlied@linux.ie
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpu/drm/ttm: Use mutex_lock_killable() for shrinker functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201405192339.JIJ04144.FHQFVFOtOSLJOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 19 May 2014 23:39:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19052014 #7951212, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e314a1a1583e585d062dfc30c8aad8bf5380510b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 19 May 2014 18:43:21 +0900
Subject: [PATCH] gpu/drm/ttm: Use mutex_lock_killable() for shrinker functions.

I can observe that RHEL7 environment stalls with 100% CPU usage when a
certain type of memory pressure is given. While the shrinker functions
are called by shrink_slab() before the OOM killer is triggered, the stall
lasts for many minutes.

I added debug printk() and observed that many threads are blocked for more
than 10 seconds at ttm_dma_pool_shrink_count()/ttm_dma_pool_shrink_scan()
functions. Since the kswapd can call these functions later, the current
thread can return from these functions as soon as chosen by the OOM killer.

This patch changes "mutex_lock();" to "if (mutex_lock_killable()) return ...;"
so that any threads can promptly give up. (By the way, as far as I tested,
changing to "if (!mutex_trylock()) return ...;" likely shortens the duration
of stall. Maybe we don't need to wait for mutex if someone is already calling
these functions.)

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 1b79bf0..f75dab8 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1012,7 +1012,8 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	if (list_empty(&_manager->pools))
 		return SHRINK_STOP;
 
-	mutex_lock(&_manager->lock);
+	if (mutex_lock_killable(&_manager->lock))
+		return SHRINK_STOP;
 	pool_offset = pool_offset % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
@@ -1043,7 +1044,8 @@ ttm_dma_pool_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 	struct device_pools *p;
 	unsigned long count = 0;
 
-	mutex_lock(&_manager->lock);
+	if (mutex_lock_killable(&_manager->lock))
+		return 0;
 	list_for_each_entry(p, &_manager->pools, pools)
 		count += p->pool->npages_free;
 	mutex_unlock(&_manager->lock);
-- 
1.8.3.1
