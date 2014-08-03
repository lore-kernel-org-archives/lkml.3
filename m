Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaHCLOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:14:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:30178 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaHCLOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:14:32 -0400
To: konrad.wilk@oracle.com, dchinner@redhat.com
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/5] gpu/drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405311158.DGE64002.QLOOHJSFFMVFOt@I-love.SAKURA.ne.jp>
	<201405311159.CHG64048.SOFLQHVtFOMFJO@I-love.SAKURA.ne.jp>
	<201405311200.III57894.MLFOOFStQVHJFO@I-love.SAKURA.ne.jp>
	<20140610191741.GA28523@phenom.dumpdata.com>
	<201406110516.HCH90692.FFFStVJMOHOLQO@I-love.SAKURA.ne.jp>
In-Reply-To: <201406110516.HCH90692.FFFStVJMOHOLQO@I-love.SAKURA.ne.jp>
Message-Id: <201408032014.EBE26508.FQOFtHFOSVJMOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 3 Aug 2014 20:14:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5c2f18ca300a1182e40f143b81e927426232b005 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 3 Aug 2014 19:59:35 +0900
Subject: [PATCH 1/5] gpu/drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().

list_empty(&_manager->pools) being false before taking _manager->lock
does not guarantee that _manager->npools != 0 after taking _manager->lock
because _manager->npools is updated under _manager->lock.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@kernel.org> [3.3+]
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index fb8259f..b751fff 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1015,6 +1015,8 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		return SHRINK_STOP;
 
 	mutex_lock(&_manager->lock);
+	if (!_manager->npools)
+		goto out;
 	pool_offset = pool_offset % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
@@ -1034,6 +1036,7 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			 p->pool->dev_name, p->pool->name, current->pid,
 			 nr_free, shrink_pages);
 	}
+out:
 	mutex_unlock(&_manager->lock);
 	return freed;
 }
-- 
1.7.1
