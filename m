Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaIZJuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:50:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbaIZJq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 127/142] drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().
Date: Fri, 26 Sep 2014 11:45:38 +0200
Message-Id: <50ac045c45d41dad0c4b38a456dcc58a64c58244.1411724724.git.jslaby@suse.cz>
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

commit 46c2df68f03a236b30808bba361f10900c88d95e upstream.

We can use "unsigned int" instead of "atomic_t" by updating start_pool
variable under _manager->lock. This patch will make it possible to avoid
skipping when choosing a pool to shrink in round-robin style, after next
patch changes mutex_lock(_manager->lock) to !mutex_trylock(_manager->lork).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index eeb8527aba90..5d49274afd0e 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1003,9 +1003,9 @@ EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
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
@@ -1016,7 +1016,7 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	mutex_lock(&_manager->lock);
 	if (!_manager->npools)
 		goto out;
-	pool_offset = pool_offset % _manager->npools;
+	pool_offset = ++start_pool % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
 
-- 
2.1.0

