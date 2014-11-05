Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaKENpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:45:47 -0500
Received: from mx2.parallels.com ([199.115.105.18]:36045 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaKENo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:44:56 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 3/3] memcg: only check memcg_kmem_skip_account in __memcg_kmem_get_cache
Date: Wed, 5 Nov 2014 16:44:44 +0300
Message-ID: <a834fe02d2833e235f6dd35368f4f0b9412bca4b.1415194280.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <9ac4c9e767d437f744bb61feb7e042c93c67f727.1415194280.git.vdavydov@parallels.com>
References: <9ac4c9e767d437f744bb61feb7e042c93c67f727.1415194280.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__memcg_kmem_get_cache can recurse if it calls kmalloc (which it does if
the cgroup's kmem cache doesn't exist), because kmalloc may call
__memcg_kmem_get_cache internally again. To avoid the recursion, we use
the task_struct->memcg_kmem_skip_account flag.

However, there's no need in checking the flag in
memcg_kmem_newpage_charge or memcg_kmem_recharge_slab, because there's
no way how these two functions could result in recursion, if called from
memcg_kmem_get_cache. So let's remove the redundant code.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 52d1e933bb9f..d7de40cb3c8e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2717,34 +2717,6 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 
 	*_memcg = NULL;
 
-	/*
-	 * Disabling accounting is only relevant for some specific memcg
-	 * internal allocations. Therefore we would initially not have such
-	 * check here, since direct calls to the page allocator that are
-	 * accounted to kmemcg (alloc_kmem_pages and friends) only happen
-	 * outside memcg core. We are mostly concerned with cache allocations,
-	 * and by having this test at memcg_kmem_get_cache, we are already able
-	 * to relay the allocation to the root cache and bypass the memcg cache
-	 * altogether.
-	 *
-	 * There is one exception, though: the SLUB allocator does not create
-	 * large order caches, but rather service large kmallocs directly from
-	 * the page allocator. Therefore, the following sequence when backed by
-	 * the SLUB allocator:
-	 *
-	 *	memcg_stop_kmem_account();
-	 *	kmalloc(<large_number>)
-	 *	memcg_resume_kmem_account();
-	 *
-	 * would effectively ignore the fact that we should skip accounting,
-	 * since it will drive us directly to this function without passing
-	 * through the cache selector memcg_kmem_get_cache. Such large
-	 * allocations are extremely rare but can happen, for instance, for the
-	 * cache arrays. We bring this test here.
-	 */
-	if (current->memcg_kmem_skip_account)
-		return true;
-
 	memcg = get_mem_cgroup_from_mm(current->mm);
 
 	if (!memcg_kmem_is_active(memcg)) {
@@ -2800,9 +2772,6 @@ int __memcg_kmem_recharge_slab(void *obj, gfp_t gfp)
 	int nr_pages;
 	int ret = 0;
 
-	if (current->memcg_kmem_skip_account)
-		goto out;
-
 	page = virt_to_head_page(obj);
 	page_memcg = ACCESS_ONCE(page->mem_cgroup);
 
-- 
1.7.10.4

