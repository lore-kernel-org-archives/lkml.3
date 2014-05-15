Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaEONIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:08:17 -0400
Received: from relay.parallels.com ([195.214.232.42]:37355 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaEONIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:08:16 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH -mm] slab: delete cache from list after __kmem_cache_shutdown succeeds
Date: Thu, 15 May 2014 17:08:11 +0400
Message-ID: <1400159291-5330-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, on kmem_cache_destroy we delete the cache from the slab_list
before __kmem_cache_shutdown, inserting it back to the list on failure.
Initially, this was done, because we could release the slab_mutex in
__kmem_cache_shutdown to delete sysfs slub entry, but since commit
41a212859a4d ("slub: use sysfs'es release mechanism for kmem_cache") we
remove sysfs entry later in kmem_cache_destroy after dropping the
slab_mutex, so that no implementation of __kmem_cache_shutdown can ever
release the lock. Therefore we can simplify the code a bit by moving
list_del after __kmem_cache_shutdown.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
---
 mm/slab_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 48fafb61f35e..735e01a0db6f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -346,15 +346,15 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (memcg_cleanup_cache_params(s) != 0)
 		goto out_unlock;
 
-	list_del(&s->list);
 	if (__kmem_cache_shutdown(s) != 0) {
-		list_add(&s->list, &slab_caches);
 		printk(KERN_ERR "kmem_cache_destroy %s: "
 		       "Slab cache still has objects\n", s->name);
 		dump_stack();
 		goto out_unlock;
 	}
 
+	list_del(&s->list);
+
 	mutex_unlock(&slab_mutex);
 	if (s->flags & SLAB_DESTROY_BY_RCU)
 		rcu_barrier();
-- 
1.7.10.4

