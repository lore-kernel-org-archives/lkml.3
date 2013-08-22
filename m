Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3HVIoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:44:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55113 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab3HVIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:22 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-54-5215cf623f2e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 05/16] slab: remove cachep in struct slab_rcu
Date: Thu, 22 Aug 2013 17:44:14 +0900
Message-Id: <1377161065-30552-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get cachep using page in struct slab_rcu, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 69dc25a..b378f91 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -204,7 +204,6 @@ typedef unsigned int kmem_bufctl_t;
  */
 struct slab_rcu {
 	struct rcu_head head;
-	struct kmem_cache *cachep;
 	struct page *page;
 };
 
@@ -1818,7 +1817,7 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 static void kmem_rcu_free(struct rcu_head *head)
 {
 	struct slab_rcu *slab_rcu = (struct slab_rcu *)head;
-	struct kmem_cache *cachep = slab_rcu->cachep;
+	struct kmem_cache *cachep = slab_rcu->page->slab_cache;
 
 	kmem_freepages(cachep, slab_rcu->page);
 	if (OFF_SLAB(cachep))
@@ -2046,7 +2045,6 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 		struct slab_rcu *slab_rcu;
 
 		slab_rcu = (struct slab_rcu *)slabp;
-		slab_rcu->cachep = cachep;
 		slab_rcu->page = page;
 		call_rcu(&slab_rcu->head, kmem_rcu_free);
 	} else {
-- 
1.7.9.5

