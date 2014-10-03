Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbaJCVrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:47:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbaJCVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.14 009/238] drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().
Date: Fri,  3 Oct 2014 14:28:44 -0700
Message-Id: <20141003212913.964218529@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 46c2df68f03a236b30808bba361f10900c88d95e upstream.

We can use "unsigned int" instead of "atomic_t" by updating start_pool
variable under _manager->lock. This patch will make it possible to avoid
skipping when choosing a pool to shrink in round-robin style, after next
patch changes mutex_lock(_manager->lock) to !mutex_trylock(_manager->lork).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -1017,7 +1017,7 @@ ttm_dma_pool_shrink_scan(struct shrinker
 	mutex_lock(&_manager->lock);
 	if (!_manager->npools)
 		goto out;
-	pool_offset = pool_offset % _manager->npools;
+	pool_offset = ++start_pool % _manager->npools;
 	list_for_each_entry(p, &_manager->pools, pools) {
 		unsigned nr_free;
 


