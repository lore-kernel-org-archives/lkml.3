Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195AbaGBAlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:41:07 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53730 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaGBAlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:41:04 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 2 Jul 2014 09:46:15 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 4/9] slab: factor out initialization of arracy cache
Message-ID: <20140702004615.GC9972@js1304-P5Q-DELUXE>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1404203258-8923-5-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.02.1407011525350.4004@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407011525350.4004@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:26:26PM -0700, David Rientjes wrote:
> On Tue, 1 Jul 2014, Joonsoo Kim wrote:
> 
> > Factor out initialization of array cache to use it in following patch.
> > 
> > Acked-by: Christoph Lameter <cl@linux.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Not sure what happened to my
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> from http://marc.info/?l=linux-mm&m=139951195724487 and my comment still 
> stands about s/arracy/array/ in the patch title.

This is new one with applying your comment.

Thanks.

--------------8<--------------
>From 5d4f47d839ae4fc0796b633d41858d9c87fd235d Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 30 Aug 2013 14:34:38 +0900
Subject: [PATCH v4 4/9] slab: factor out initialization of array cache

Factor out initialization of array cache to use it in following patch.

Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 8f9e176..6fa3fdf 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -791,13 +791,8 @@ static void start_cpu_timer(int cpu)
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
@@ -805,15 +800,25 @@ static struct array_cache *alloc_arraycache(int node, int entries,
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

