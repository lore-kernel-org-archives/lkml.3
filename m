Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbaFJURD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:17:03 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:34228 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbaFJURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:17:00 -0400
X-Nat-Received: from [202.181.97.72]:55134 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1402431418.14013
To: konrad.wilk@oracle.com
Cc: dchinner@redhat.com, airlied@linux.ie, glommer@openvz.org, mgorman@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 3/5] gpu/drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140530160824.GD3621@localhost.localdomain>
	<201405311158.DGE64002.QLOOHJSFFMVFOt@I-love.SAKURA.ne.jp>
	<201405311159.CHG64048.SOFLQHVtFOMFJO@I-love.SAKURA.ne.jp>
	<201405311200.III57894.MLFOOFStQVHJFO@I-love.SAKURA.ne.jp>
	<20140610191741.GA28523@phenom.dumpdata.com>
In-Reply-To: <20140610191741.GA28523@phenom.dumpdata.com>
Message-Id: <201406110516.HCH90692.FFFStVJMOHOLQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 11 Jun 2014 05:16:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10062014 #8203084, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> Hmm..
> 
> /home/konrad/linux/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c: In function ‘ttm_dma_pool_shrink_scan’:
> /home/konrad/linux/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c:1015:2: error: invalid use of void expression
>   if (!mutex_lock(&_manager->lock))
> 
> This is based on v3.15 with these patches.

Wow! I didn't know that my gcc does not emit warning on such a mistake.
Thank you for catching this.
----------
>From 6e6774a87695408ef077cab576e76f7fa2cf4355 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 11 Jun 2014 05:10:50 +0900
Subject: [PATCH 3/5 (v2)] gpu/drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.

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

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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
