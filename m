Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaIZJtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:49:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbaIZJq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 126/142] drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
Date: Fri, 26 Sep 2014 11:45:37 +0200
Message-Id: <1718e957131772d5344ee58e8c804a0641061aff.1411724724.git.jslaby@suse.cz>
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

commit 11e504cc705e8ccb06ac93a276e11b5e8fee4d40 upstream.

list_empty(&_manager->pools) being false before taking _manager->lock
does not guarantee that _manager->npools != 0 after taking _manager->lock
because _manager->npools is updated under _manager->lock.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 7957beeeaf73..eeb8527aba90 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1014,6 +1014,8 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		return SHRINK_STOP;
 
 	mutex_lock(&_manager->lock);
+	if (!_manager->npools)
+		goto out;
 	pool_offset = pool_offset % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
@@ -1033,6 +1035,7 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			 p->pool->dev_name, p->pool->name, current->pid,
 			 nr_free, shrink_pages);
 	}
+out:
 	mutex_unlock(&_manager->lock);
 	return freed;
 }
-- 
2.1.0

