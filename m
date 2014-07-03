Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaGCMk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:40:28 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54449 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaGCMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:40:27 -0400
Date: Thu, 3 Jul 2014 20:40:15 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
Message-ID: <20140703124015.GA17431@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <53AAFDF7.2010607@oracle.com>
 <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
 <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
 <alpine.DEB.2.11.1407010956470.5353@gentwo.org>
 <20140702020454.GA6961@richard>
 <alpine.DEB.2.11.1407020918130.17773@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407020918130.17773@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070312-9574-0000-0000-00000EAF46A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:20:20AM -0500, Christoph Lameter wrote:
>On Wed, 2 Jul 2014, Wei Yang wrote:
>
>> My patch is somewhat convoluted since I wanted to preserve the original logic
>> and make minimal change. And yes, it looks not that nice to audience.
>
>Well I was the author of the initial "convoluted" logic.
>
>> I feel a little hurt by this patch. What I found and worked is gone with this
>> patch.
>
>Ok how about giving this one additional revision. Maybe you can make the
>function even easier to read? F.e. the setting of the NULL pointer at the
>end of the loop is ugly.

Hi, Christoph

Here is my refined version, hope this is more friendly to the audience.


>From 3f4fdeab600e53fdcbd65c817db3aa560ac16bfb Mon Sep 17 00:00:00 2001
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2014 15:48:59 +0800
Subject: [PATCH] slub: reduce duplicate creation on the first object

When a kmem_cache is created with ctor, each object in the kmem_cache will be
initialized before ready to use. While in slub implementation, the first
object will be initialized twice.

This patch reduces the duplication of initialization of the first object.

Fix commit 7656c72b: SLUB: add macros for scanning objects in a slab.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 mm/slub.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b2b0473..79611d9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -288,6 +288,10 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 	for (__p = (__addr); __p < (__addr) + (__objects) * (__s)->size;\
 			__p += (__s)->size)
 
+#define for_each_object_idx(__p, __idx, __s, __addr, __objects) \
+	for (__p = (__addr), __idx = 1; __idx <= __objects;\
+			__p += (__s)->size, __idx++)
+
 /* Determine object index from a given position */
 static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
 {
@@ -1409,9 +1413,9 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page *page;
 	void *start;
-	void *last;
 	void *p;
 	int order;
+	int idx;
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
@@ -1432,14 +1436,13 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
-	last = start;
-	for_each_object(p, s, start, page->objects) {
-		setup_object(s, page, last);
-		set_freepointer(s, last, p);
-		last = p;
+	for_each_object_idx(p, idx, s, start, page->objects) {
+		setup_object(s, page, p);
+		if (likely(idx < page->objects))
+			set_freepointer(s, p, p + s->size);
+		else
+			set_freepointer(s, p, NULL);
 	}
-	setup_object(s, page, last);
-	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
 	page->inuse = page->objects;
-- 
1.7.9.5


-- 
Richard Yang
Help you, Help me

