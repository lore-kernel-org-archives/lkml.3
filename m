Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbaGAIWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:22:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32857 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbaGAIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:22:33 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 2/9] slab: move up code to get kmem_cache_node in free_block()
Date: Tue,  1 Jul 2014 17:27:31 +0900
Message-Id: <1404203258-8923-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node isn't changed, so we don't need to retreive this structure
everytime we move the object. Maybe compiler do this optimization,
but making it explicitly is better.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index f8a0ed1..19e2136 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3417,7 +3417,7 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		       int node)
 {
 	int i;
-	struct kmem_cache_node *n;
+	struct kmem_cache_node *n = get_node(cachep, node);
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
@@ -3427,7 +3427,6 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		objp = objpp[i];
 
 		page = virt_to_head_page(objp);
-		n = get_node(cachep, node);
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
 		slab_put_obj(cachep, page, objp, node);
-- 
1.7.9.5

