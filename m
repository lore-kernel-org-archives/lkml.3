Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaBDN3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:29:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbaBDN3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:29:15 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -v2 5/6] memcg, kmem: clean up memcg parameter handling
Date: Tue,  4 Feb 2014 14:28:59 +0100
Message-Id: <1391520540-17436-6-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg_kmem_newpage_charge doesn't always set the given memcg parameter.
Some early escape paths skip setting *memcg while
__memcg_kmem_newpage_charge down the call chain sets *memcg even if no
memcg is charged due to other escape paths.

The current code is correct because the memcg is initialized to NULL
at the highest level in __alloc_pages_nodemask but this all is very
confusing and error prone. Let's make the semantic clear and move the
memcg parameter initialization to the highest level of kmem accounting
(memcg_kmem_newpage_charge).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 4 +++-
 mm/memcontrol.c            | 2 --
 mm/page_alloc.c            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index abd0113b6620..7bcb39668917 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -522,11 +522,13 @@ void kmem_cache_destroy_memcg_children(struct kmem_cache *s);
  * allocation.
  *
  * We return true automatically if this allocation is not to be accounted to
- * any memcg.
+ * any memcg when *memcg is set to NULL.
  */
 static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
 {
+	*memcg = NULL;
+
 	if (!memcg_kmem_enabled())
 		return true;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d06743a9a765..46b9f461cedf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3637,8 +3637,6 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 	struct mem_cgroup *memcg;
 	int ret;
 
-	*_memcg = NULL;
-
 	/*
 	 * Disabling accounting is only relevant for some specific memcg
 	 * internal allocations. Therefore we would initially not have such
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e3758a09a009..6f6099d38772 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2692,7 +2692,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET;
-	struct mem_cgroup *memcg = NULL;
+	struct mem_cgroup *memcg;
 
 	gfp_mask &= gfp_allowed_mask;
 
-- 
1.9.rc1

