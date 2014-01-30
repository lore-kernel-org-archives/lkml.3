Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaA3QBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:01:37 -0500
Received: from relay.parallels.com ([195.214.232.42]:35541 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaA3QBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:01:35 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] memcg: fix mutex not unlocked on memcg_create_kmem_cache fail path
Date: Thu, 30 Jan 2014 20:01:33 +0400
Message-ID: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 19d5d4274e22..53385cd4e6f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3400,7 +3400,7 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *s)
 {
-	struct kmem_cache *new;
+	struct kmem_cache *new = NULL;
 	static char *tmp_name = NULL;
 	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
 
@@ -3416,7 +3416,7 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	if (!tmp_name) {
 		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!tmp_name)
-			return NULL;
+			goto out;
 	}
 
 	rcu_read_lock();
@@ -3426,12 +3426,11 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 
 	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
 				      (s->flags & ~SLAB_PANIC), s->ctor, s);
-
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
 	else
 		new = s;
-
+out:
 	mutex_unlock(&mutex);
 	return new;
 }
-- 
1.7.10.4

