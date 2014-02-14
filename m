Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaBNG7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:59:15 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58134 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaBNG51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:57:27 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-eb-52fdbe544798
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 5/9] slab: factor out initialization of arracy cache
Date: Fri, 14 Feb 2014 15:57:19 +0900
Message-Id: <1392361043-22420-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out initialization of array cache to use it in following patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 551d503..90bfd79 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -741,13 +741,8 @@ static void start_cpu_timer(int cpu)
 	}
 }
 
-static struct array_cache *alloc_arraycache(int node, int entries,
-					    int batchcount, gfp_t gfp)
+static void init_arraycache(struct array_cache *ac, int limit, int batch)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
-	struct array_cache *nc = NULL;
-
-	nc = kmalloc_node(memsize, gfp, node);
 	/*
 	 * The array_cache structures contain pointers to free object.
 	 * However, when such objects are allocated or transferred to another
@@ -755,15 +750,25 @@ static struct array_cache *alloc_arraycache(int node, int entries,
 	 * valid references during a kmemleak scan. Therefore, kmemleak must
 	 * not scan such objects.
 	 */
-	kmemleak_no_scan(nc);
-	if (nc) {
-		nc->avail = 0;
-		nc->limit = entries;
-		nc->batchcount = batchcount;
-		nc->touched = 0;
-		spin_lock_init(&nc->lock);
+	kmemleak_no_scan(ac);
+	if (ac) {
+		ac->avail = 0;
+		ac->limit = limit;
+		ac->batchcount = batch;
+		ac->touched = 0;
+		spin_lock_init(&ac->lock);
 	}
-	return nc;
+}
+
+static struct array_cache *alloc_arraycache(int node, int entries,
+					    int batchcount, gfp_t gfp)
+{
+	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
+	struct array_cache *ac = NULL;
+
+	ac = kmalloc_node(memsize, gfp, node);
+	init_arraycache(ac, entries, batchcount);
+	return ac;
 }
 
 static inline bool is_slab_pfmemalloc(struct page *page)
-- 
1.7.9.5

