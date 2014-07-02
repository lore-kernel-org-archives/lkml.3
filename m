Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbaGBAnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:43:10 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54596 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaGBAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:43:08 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 2 Jul 2014 09:48:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 5/9] slab: introduce alien_cache
Message-ID: <20140702004819.GD9972@js1304-P5Q-DELUXE>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1404203258-8923-6-git-send-email-iamjoonsoo.kim@lge.com>
 <20140701151547.fa67354878399575c8eb4647@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701151547.fa67354878399575c8eb4647@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:15:47PM -0700, Andrew Morton wrote:
> On Tue,  1 Jul 2014 17:27:34 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > -static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
> > +static struct alien_cache *__alloc_alien_cache(int node, int entries,
> > +						int batch, gfp_t gfp)
> > +{
> > +	int memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
> 
> nit: all five memsizes in slab.c have type `int'.  size_t would be more
> appropriate.
> 

Hello,

As my inspection, there are 4 memsize. Can you confirm that?
Anyway, here goes the patch you suggested.

Thanks.

----------8<-----------------
>From e9ae011804f3d90375b2e50c0dbd95e708afc509 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Wed, 2 Jul 2014 09:23:05 +0900
Subject: [PATCH] slab: change int to size_t for representing allocation size

It is better to represent allocation size in size_t rather than int.
So change it.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 5b0224c..e7763db 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -681,7 +681,7 @@ static void init_arraycache(struct array_cache *ac, int limit, int batch)
 static struct array_cache *alloc_arraycache(int node, int entries,
 					    int batchcount, gfp_t gfp)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
+	size_t memsize = sizeof(void *) * entries + sizeof(struct array_cache);
 	struct array_cache *ac = NULL;
 
 	ac = kmalloc_node(memsize, gfp, node);
@@ -868,7 +868,7 @@ static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
 static struct alien_cache *__alloc_alien_cache(int node, int entries,
 						int batch, gfp_t gfp)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
+	size_t memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
 	struct alien_cache *alc = NULL;
 
 	alc = kmalloc_node(memsize, gfp, node);
@@ -880,7 +880,7 @@ static struct alien_cache *__alloc_alien_cache(int node, int entries,
 static struct alien_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	struct alien_cache **alc_ptr;
-	int memsize = sizeof(void *) * nr_node_ids;
+	size_t memsize = sizeof(void *) * nr_node_ids;
 	int i;
 
 	if (limit > 1)
@@ -1037,7 +1037,7 @@ static int init_cache_node_node(int node)
 {
 	struct kmem_cache *cachep;
 	struct kmem_cache_node *n;
-	const int memsize = sizeof(struct kmem_cache_node);
+	const size_t memsize = sizeof(struct kmem_cache_node);
 
 	list_for_each_entry(cachep, &slab_caches, list) {
 		/*
-- 
1.7.9.5

