Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3HVIoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:44:34 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54869 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3HVIoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:23 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-55-5215cf62b1bd
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 06/16] slab: put forward freeing slab management object
Date: Thu, 22 Aug 2013 17:44:15 +0900
Message-Id: <1377161065-30552-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to free slab management object in rcu context,
because, from now on, we don't manage this slab anymore.
So put forward freeing.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index b378f91..607a9b8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1820,8 +1820,6 @@ static void kmem_rcu_free(struct rcu_head *head)
 	struct kmem_cache *cachep = slab_rcu->page->slab_cache;
 
 	kmem_freepages(cachep, slab_rcu->page);
-	if (OFF_SLAB(cachep))
-		kmem_cache_free(cachep->slabp_cache, slab_rcu);
 }
 
 #if DEBUG
@@ -2047,11 +2045,16 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 		slab_rcu = (struct slab_rcu *)slabp;
 		slab_rcu->page = page;
 		call_rcu(&slab_rcu->head, kmem_rcu_free);
-	} else {
+
+	} else
 		kmem_freepages(cachep, page);
-		if (OFF_SLAB(cachep))
-			kmem_cache_free(cachep->slabp_cache, slabp);
-	}
+
+	/*
+	 * From now on, we don't use slab management
+	 * although actual page will be freed in rcu context.
+	 */
+	if (OFF_SLAB(cachep))
+		kmem_cache_free(cachep->slabp_cache, slabp);
 }
 
 /**
-- 
1.7.9.5

