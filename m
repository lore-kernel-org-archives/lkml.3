Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbbAPON3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:13:29 -0500
Received: from mx2.parallels.com ([199.115.105.18]:58913 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbbAPON2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:13:28 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 3/6] slab: use css id for naming per memcg caches
Date: Fri, 16 Jan 2015 17:13:03 +0300
Message-ID: <80763f3a50c0f505bad9dcc3b135594e726bbf74.1421411660.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1421411660.git.vdavydov@parallels.com>
References: <cover.1421411660.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use mem_cgroup->kmemcg_id to guarantee kmem_cache->name
uniqueness. This is correct, because kmemcg_id is only released on css
free after destroying all per memcg caches.

However, I am going to change that and release kmemcg_id on css offline,
because it is not wise to keep it for so long, wasting valuable entries
of memcg_cache_params->memcg_caches arrays. Therefore, to preserve cache
name uniqueness, let us switch to css->id.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index fe99859ba34c..512ee119e5c3 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -487,6 +487,7 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 			     struct kmem_cache *root_cache)
 {
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
+	struct cgroup_subsys_state *css = mem_cgroup_css(memcg);
 	struct memcg_cache_array *arr;
 	struct kmem_cache *s = NULL;
 	char *cache_name;
@@ -509,10 +510,9 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	if (arr->entries[idx])
 		goto out_unlock;
 
-	cgroup_name(mem_cgroup_css(memcg)->cgroup,
-		    memcg_name_buf, sizeof(memcg_name_buf));
+	cgroup_name(css->cgroup, memcg_name_buf, sizeof(memcg_name_buf));
 	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       idx, memcg_name_buf);
+			       css->id, memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
-- 
1.7.10.4

