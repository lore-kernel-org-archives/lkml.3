Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaHCLPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:15:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:28550 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaHCLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:15:08 -0400
To: konrad.wilk@oracle.com, dchinner@redhat.com
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 2/5] gpu/drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405311159.CHG64048.SOFLQHVtFOMFJO@I-love.SAKURA.ne.jp>
	<201405311200.III57894.MLFOOFStQVHJFO@I-love.SAKURA.ne.jp>
	<20140610191741.GA28523@phenom.dumpdata.com>
	<201406110516.HCH90692.FFFStVJMOHOLQO@I-love.SAKURA.ne.jp>
	<201408032014.EBE26508.FQOFtHFOSVJMOL@I-love.SAKURA.ne.jp>
In-Reply-To: <201408032014.EBE26508.FQOFtHFOSVJMOL@I-love.SAKURA.ne.jp>
Message-Id: <201408032014.BHF60482.VFOFSMJLtHQFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 3 Aug 2014 20:14:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ee941e18a3c05a7589b690669611c3f0895a2d5a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 3 Aug 2014 20:00:40 +0900
Subject: [PATCH 2/5] gpu/drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().

We can use "unsigned int" instead of "atomic_t" by updating start_pool
variable under _manager->lock. This patch will make it possible to avoid
skipping when choosing a pool to shrink in round-robin style, after next
patch changes mutex_lock(_manager->lock) to !mutex_trylock(_manager->lork).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@kernel.org> [3.3+]
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index b751fff..d8e59f7 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1004,9 +1004,9 @@ EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
 static unsigned long
 ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	static atomic_t start_pool = ATOMIC_INIT(0);
+	static unsigned start_pool;
 	unsigned idx = 0;
-	unsigned pool_offset = atomic_add_return(1, &start_pool);
+	unsigned pool_offset;
 	unsigned shrink_pages = sc->nr_to_scan;
 	struct device_pools *p;
 	unsigned long freed = 0;
@@ -1017,7 +1017,7 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	mutex_lock(&_manager->lock);
 	if (!_manager->npools)
 		goto out;
-	pool_offset = pool_offset % _manager->npools;
+	pool_offset = ++start_pool % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
 
-- 
1.7.1
