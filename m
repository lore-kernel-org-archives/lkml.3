Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040Ab3DHGez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:34:55 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20462 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab3DHGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:34:52 -0400
Message-ID: <516264F1.8020904@huawei.com>
Date: Mon, 8 Apr 2013 14:34:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 06/12] memcg: don't use mem_cgroup_get() when creating a kmemcg
 cache
References: <5162648B.9070802@huawei.com>
In-Reply-To: <5162648B.9070802@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().

There are two things being done in the current code:

First, we acquired a css_ref to make sure that the underlying cgroup
would not go away. That is a short lived reference, and it is put as
soon as the cache is created.

At this point, we acquire a long-lived per-cache memcg reference count
to guarantee that the memcg will still be alive.

so it is:

enqueue: css_get
create : memcg_get, css_put
destroy: memcg_put

So we only need to get rid of the memcg_get, change the memcg_put to
css_put, and get rid of the now extra css_put.

(This changelog is basically written by Glauber)

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bbf5bf3..c308ea0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3197,7 +3197,7 @@ void memcg_release_cache(struct kmem_cache *s)
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
-	mem_cgroup_put(memcg);
+	css_put(&memcg->css);
 out:
 	kfree(s->memcg_params);
 }
@@ -3356,16 +3356,18 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 
 	mutex_lock(&memcg_cache_mutex);
 	new_cachep = cachep->memcg_params->memcg_caches[idx];
-	if (new_cachep)
+	if (new_cachep) {
+		css_put(&memcg->css);
 		goto out;
+	}
 
 	new_cachep = kmem_cache_dup(memcg, cachep);
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
+		css_put(&memcg->css);
 		goto out;
 	}
 
-	mem_cgroup_get(memcg);
 	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
@@ -3453,8 +3455,6 @@ static void memcg_create_cache_work_func(struct work_struct *w)
 
 	cw = container_of(w, struct create_work, work);
 	memcg_create_kmem_cache(cw->memcg, cw->cachep);
-	/* Drop the reference gotten when we enqueued. */
-	css_put(&cw->memcg->css);
 	kfree(cw);
 }
 
-- 
1.8.0.2
