Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaBFP6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:58:18 -0500
Received: from relay.parallels.com ([195.214.232.42]:60426 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaBFP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:58:16 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <cl@linux.com>, <penberg@kernel.org>
CC: <akpm@linux-foundation.org>, <rientjes@google.com>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH RFC] slub: do not drop slab_mutex for sysfs_slab_{add,remove}
Date: Thu, 6 Feb 2014 19:58:13 +0400
Message-ID: <1391702294-27289-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating/destroying a kmem cache, we do a lot of work holding the
slab_mutex, but we drop it for sysfs_slab_{add,remove} for some reason.
Since __kmem_cache_create and __kmem_cache_shutdown are extremely rare,
I propose to simplify locking by calling sysfs_slab_{add,remove} w/o
dropping the slab_mutex.

I'm interested in this, because when creating a memcg cache I need the
slab_mutex locked until the cache is fully initialized and registered to
the memcg subsys (memcg_cache_register() is called). If this is not
true, I get races when several threads try to create a cache for the
same memcg.  An alternative fix for my problem would be moving
sysfs_slab_{add,remove} after the slab_mutex is dropped, but I'd like to
try the shortest path first.

Any objections to this?

Thanks.
---
 mm/slub.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3d3a8a7a0f8c..6f4393892d2d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3229,19 +3229,8 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 {
 	int rc = kmem_cache_close(s);
 
-	if (!rc) {
-		/*
-		 * We do the same lock strategy around sysfs_slab_add, see
-		 * __kmem_cache_create. Because this is pretty much the last
-		 * operation we do and the lock will be released shortly after
-		 * that in slab_common.c, we could just move sysfs_slab_remove
-		 * to a later point in common code. We should do that when we
-		 * have a common sysfs framework for all allocators.
-		 */
-		mutex_unlock(&slab_mutex);
+	if (!rc)
 		sysfs_slab_remove(s);
-		mutex_lock(&slab_mutex);
-	}
 
 	return rc;
 }
@@ -3772,9 +3761,7 @@ int __kmem_cache_create(struct kmem_cache *s, unsigned long flags)
 		return 0;
 
 	memcg_propagate_slab_attrs(s);
-	mutex_unlock(&slab_mutex);
 	err = sysfs_slab_add(s);
-	mutex_lock(&slab_mutex);
 
 	if (err)
 		kmem_cache_close(s);
-- 
1.7.10.4

