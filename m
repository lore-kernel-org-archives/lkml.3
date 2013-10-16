Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337Ab3JPIo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:44:29 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59579 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3JPIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:44:18 -0400
X-AuditID: 9c930179-b7c78ae000003065-7b-525e51dca6c9
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 05/15] slab: remove cachep in struct slab_rcu
Date: Wed, 16 Oct 2013 17:44:02 +0900
Message-Id: <1381913052-23875-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get cachep using page in struct slab_rcu, so remove it.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 71ba8f5..7e1aabe 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -204,7 +204,6 @@ typedef unsigned int kmem_bufctl_t;
  */
 struct slab_rcu {
 	struct rcu_head head;
-	struct kmem_cache *cachep;
 	struct page *page;
 };
 
@@ -1824,7 +1823,7 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 static void kmem_rcu_free(struct rcu_head *head)
 {
 	struct slab_rcu *slab_rcu = (struct slab_rcu *)head;
-	struct kmem_cache *cachep = slab_rcu->cachep;
+	struct kmem_cache *cachep = slab_rcu->page->slab_cache;
 
 	kmem_freepages(cachep, slab_rcu->page);
 	if (OFF_SLAB(cachep))
@@ -2052,7 +2051,6 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
 		struct slab_rcu *slab_rcu;
 
 		slab_rcu = (struct slab_rcu *)slabp;
-		slab_rcu->cachep = cachep;
 		slab_rcu->page = page;
 		call_rcu(&slab_rcu->head, kmem_rcu_free);
 	} else {
-- 
1.7.9.5

