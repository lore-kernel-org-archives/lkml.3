Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904AbaEaC6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:58:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51162 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbaEaC6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:58:39 -0400
X-Nat-Received: from [202.181.97.72]:53047 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1401505116.4812
To: konrad.wilk@oracle.com
Cc: dchinner@redhat.com, airlied@linux.ie, glommer@openvz.org, mgorman@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/5] gpu/drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405242322.AID86423.HOMLQJOtFFVOSF@I-love.SAKURA.ne.jp>
	<20140528185445.GA23122@phenom.dumpdata.com>
	<201405290647.DHI69200.HSFVFMFOJOLOQt@I-love.SAKURA.ne.jp>
	<201405292334.EAG00503.FLOOJFStHVQMFO@I-love.SAKURA.ne.jp>
	<20140530160824.GD3621@localhost.localdomain>
In-Reply-To: <20140530160824.GD3621@localhost.localdomain>
Message-Id: <201405311158.DGE64002.QLOOHJSFFMVFOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 31 May 2014 11:58:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 30052014 #8090611, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c1af6a76f8566eeeed049d3cf24635a43b4a83a6 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 31 May 2014 09:39:22 +0900
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
