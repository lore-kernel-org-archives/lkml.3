Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaJTPLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:11:40 -0400
Received: from mx2.parallels.com ([199.115.105.18]:36195 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaJTPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:11:39 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] memcg: remove activate_kmem_mutex
Date: Mon, 20 Oct 2014 19:11:29 +0400
Message-ID: <1413817889-13915-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The activate_kmem_mutex is used to serialize memcg.kmem.limit updates,
but we already serialize them with memcg_limit_mutex so let's remove the
former.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a203c7ec6c7..e957f0c80c6e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2618,8 +2618,6 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
  */
 static DEFINE_MUTEX(memcg_slab_mutex);
 
-static DEFINE_MUTEX(activate_kmem_mutex);
-
 /*
  * This is a bit cumbersome, but it is rarely used and avoids a backpointer
  * in the memcg_cache_params struct.
@@ -3756,9 +3754,8 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-/* should be called with activate_kmem_mutex held */
-static int __memcg_activate_kmem(struct mem_cgroup *memcg,
-				 unsigned long nr_pages)
+static int memcg_activate_kmem(struct mem_cgroup *memcg,
+			       unsigned long nr_pages)
 {
 	int err = 0;
 	int memcg_id;
@@ -3820,17 +3817,6 @@ out:
 	return err;
 }
 
-static int memcg_activate_kmem(struct mem_cgroup *memcg,
-			       unsigned long nr_pages)
-{
-	int ret;
-
-	mutex_lock(&activate_kmem_mutex);
-	ret = __memcg_activate_kmem(memcg, nr_pages);
-	mutex_unlock(&activate_kmem_mutex);
-	return ret;
-}
-
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
@@ -3853,14 +3839,14 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 	if (!parent)
 		return 0;
 
-	mutex_lock(&activate_kmem_mutex);
+	mutex_lock(&memcg_limit_mutex);
 	/*
 	 * If the parent cgroup is not kmem-active now, it cannot be activated
 	 * after this point, because it has at least one child already.
 	 */
 	if (memcg_kmem_is_active(parent))
-		ret = __memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
-	mutex_unlock(&activate_kmem_mutex);
+		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
+	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
 #else
-- 
1.7.10.4

