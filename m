Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161252Ab3DECEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:04:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50179 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161045Ab3DECEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:04:39 -0400
X-AuditID: 9c930179-b7b2aae000000518-59-515e31346ce9
Date: Fri, 5 Apr 2013 11:05:01 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
Message-ID: <20130405020501.GB13624@lge.com>
References: <20130327061351.GB17125@lge.com>
 <alpine.DEB.2.02.1303281227520.16200@gentwo.org>
 <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com>
 <alpine.DEB.2.02.1304011025550.12690@gentwo.org>
 <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com>
 <20130402004217.GA16699@lge.com>
 <0000013dcc35f310-d338600d-8a5a-4c95-9770-af4b8d81e103-000000@email.amazonses.com>
 <20130404005850.GC10683@lge.com>
 <0000013dd552ca2b-986c7b7f-850e-4108-82e8-443695368b1d-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013dd552ca2b-986c7b7f-850e-4108-82e8-443695368b1d-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:53:25PM +0000, Christoph Lameter wrote:
> On Thu, 4 Apr 2013, Joonsoo Kim wrote:
> 
> > Pekka alreay applied it.
> > Do we need update?
> 
> Well I thought the passing of the count via lru.next would be something
> worthwhile to pick up.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hello, Pekka.

Here goes a patch implementing Christoph's idea.
Instead of updating my previous patch, I re-write this patch on top of
your slab/next tree.

Thanks.

------------------------8<-------------------------------
>From e1c18793dd2a9d9cef87b07faf975364b71276d7 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 5 Apr 2013 10:49:36 +0900
Subject: [PATCH] slub: use page->lru.next to calculate nr of acquired object

We can pass inuse count via page->lru.next in order to calculate number
of acquired objects and it is more beautiful way. This reduces one
function argument and makes clean code.

Cc: Christoph Lameter <cl@linux.com>
Suggested-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slub.c b/mm/slub.c
index 21b3f00..8a35464 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1493,11 +1493,12 @@ static inline void remove_partial(struct kmem_cache_node *n,
  */
 static inline void *acquire_slab(struct kmem_cache *s,
 		struct kmem_cache_node *n, struct page *page,
-		int mode, int *objects)
+		int mode)
 {
 	void *freelist;
 	unsigned long counters;
 	struct page new;
+	unsigned long inuse;
 
 	/*
 	 * Zap the freelist and set the frozen bit.
@@ -1507,7 +1508,7 @@ static inline void *acquire_slab(struct kmem_cache *s,
 	freelist = page->freelist;
 	counters = page->counters;
 	new.counters = counters;
-	*objects = new.objects - new.inuse;
+	inuse = page->inuse;
 	if (mode) {
 		new.inuse = page->objects;
 		new.freelist = NULL;
@@ -1525,6 +1526,7 @@ static inline void *acquire_slab(struct kmem_cache *s,
 		return NULL;
 
 	remove_partial(n, page);
+	page->lru.next = (void *)inuse;
 	WARN_ON(!freelist);
 	return freelist;
 }
@@ -1541,7 +1543,6 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 	struct page *page, *page2;
 	void *object = NULL;
 	int available = 0;
-	int objects;
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
@@ -1559,11 +1560,11 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 		if (!pfmemalloc_match(page, flags))
 			continue;
 
-		t = acquire_slab(s, n, page, object == NULL, &objects);
+		t = acquire_slab(s, n, page, object == NULL);
 		if (!t)
 			break;
 
-		available += objects;
+		available += (page->objects - (unsigned long)page->lru.next);
 		if (!object) {
 			c->page = page;
 			stat(s, ALLOC_FROM_PARTIAL);
-- 
1.7.9.5

