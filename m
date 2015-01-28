Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbbA2B5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:57:03 -0500
Received: from mx2.parallels.com ([199.115.105.18]:34980 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbbA2Bzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:48 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm v2 2/3] slub: fix kmem_cache_shrink return value
Date: Wed, 28 Jan 2015 19:22:50 +0300
Message-ID: <7ee54d0d26f6c61e2ecf50300ee955610749b344.1422461573.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1422461573.git.vdavydov@parallels.com>
References: <cover.1422461573.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is supposed to return 0 if the cache has no remaining objects and 1
otherwise, while currently it always returns 0. Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index dbf9334b6a5c..63abe52c2951 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3379,6 +3379,7 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 	LIST_HEAD(discard);
 	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
+	int ret = 0;
 
 	for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
 		INIT_LIST_HEAD(promote + i);
@@ -3419,6 +3420,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 		for (i = SHRINK_PROMOTE_MAX - 1; i >= 0; i--)
 			list_splice_init(promote + i, &n->partial);
 
+		if (n->nr_partial || slabs_node(s, node))
+			ret = 1;
+
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
@@ -3426,7 +3430,7 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 			discard_slab(s, page);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int slab_mem_going_offline_callback(void *arg)
-- 
1.7.10.4

