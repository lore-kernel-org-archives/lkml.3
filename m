Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3HOFwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:52:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25473 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3HOFwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:52:07 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>, Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kmemcg: don't allocate extra memory for root memcg_cache_params (v2)
Date: Thu, 15 Aug 2013 09:49:00 +0400
Message-Id: <1376545740-14297-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memcg_cache_params structure contains the common part and the union,
which represents two different types of data: one for root cashes and
another for child caches.

The size of child data is fixed. The size of the memcg_caches array is
calculated in runtime.

Currently the size of memcg_cache_params for root caches is calculated
incorrectly, because it includes the size of parameters for child caches.

ssize_t size = memcg_caches_array_size(num_groups);
size *= sizeof(void *);

size += sizeof(struct memcg_cache_params);

v2: Fix a typo in calculations

Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 mm/memcontrol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5792a5..2e47fea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3140,7 +3140,7 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 		ssize_t size = memcg_caches_array_size(num_groups);
 
 		size *= sizeof(void *);
-		size += sizeof(struct memcg_cache_params);
+		size += offsetof(struct memcg_cache_params, memcg_caches);
 
 		s->memcg_params = kzalloc(size, GFP_KERNEL);
 		if (!s->memcg_params) {
@@ -3183,13 +3183,16 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
 			 struct kmem_cache *root_cache)
 {
-	size_t size = sizeof(struct memcg_cache_params);
+	size_t size;
 
 	if (!memcg_kmem_enabled())
 		return 0;
 
-	if (!memcg)
+	if (!memcg) {
+		size = offsetof(struct memcg_cache_params, memcg_caches);
 		size += memcg_limited_groups_array_size * sizeof(void *);
+	} else
+		size = sizeof(struct memcg_cache_params);
 
 	s->memcg_params = kzalloc(size, GFP_KERNEL);
 	if (!s->memcg_params)
-- 
1.8.3.1

