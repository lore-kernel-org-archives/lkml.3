Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaIOBtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 21:49:42 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:33094 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaIOBtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 21:49:40 -0400
X-Original-SENDERIP: 10.177.220.159
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 15 Sep 2014 10:49:39 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        Pekka Enberg <penberg@kernel.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH -mmotm] mm: fix kmemcheck.c build errors
Message-ID: <20140915014939.GB2676@js1304-P5Q-DELUXE>
References: <1409902086-32311-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140905130102.f6b8866115f83a0bacedb899@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905130102.f6b8866115f83a0bacedb899@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 01:01:02PM -0700, Andrew Morton wrote:
> On Fri,  5 Sep 2014 16:28:06 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
> > in mmotm makes following build failure.
> > 
> > ../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
> > ../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
> > ../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
> > ../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type
> > 
> > ../mm/slab.h: In function 'cache_from_obj':
> > ../mm/slab.h:283:2: error: implicit declaration of function
> > 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]
> > 
> > Add header files to fix kmemcheck.c build errors.
> > 
> > [iamjoonsoo.kim@lge.com] move up memcontrol.h header
> > to fix build failure if CONFIG_MEMCG_KMEM=y too.
> 
> Looking at this line
> 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> and at this line
> 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> I am suspecting that this patch was authored by Randy.  But there was
> no From: line at start-of-changelog to communicate this?
> 
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 13845d0..963a3f8 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -37,6 +37,8 @@ struct kmem_cache {
> >  #include <linux/slub_def.h>
> >  #endif
> >  
> > +#include <linux/memcontrol.h>
> > +
> >  /*
> >   * State of the slab allocator.
> >   *
> 
> It seems a bit wrong to include a fairly high-level memcontol.h into a
> fairly low-level slab.h, but I expect it will work.
> 
> I can't really see how
> mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
> caused the breakage.  I don't know how you were triggering this build
> failure - please always include such info in the changelogs.

Hello,

Sorry for all mistakes.
Here goes new one having proper commit description and authorship.

------------>8------------------
>From d2026b2cf932ae459fb421a66923288352993e74 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@infradead.org>
Date: Fri, 5 Sep 2014 16:18:13 +0900
Subject: [PATCH] mm/slab: fix kmemcheck.c build errors

If we turn on CONFIG_KMEMCHECK,
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
in mmotm makes following build failure.

../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type

Reason for this failure is that kmemcheck uses internal fields of struct
kmem_cache and above patch moves these struct kmem_cache definitions to
mm/slab.h, so kmemcheck which only includes include/linux/slab.h can't
dereference them.

Add header file mm/slab.h in kmemcheck.c to fix kmemcheck.c build errors.

There is one more problem revealing from this change.
mm/slab.h uses memcg's internal fields so it needs memcontrol.h. Util now,
only sl[aou]b use mm/slab.h header, and they luckilly include memcontrol.h
through swap.h so no problems happen. Unfortunately, kmemcheck doesn't
include memcontrol.h so problem happens if we add mm/slab.h in kmemcheck.c.
To fix it too, add memcontrol.h into mm/slab.h.

[iamjoonsoo.kim@lge.com] add commit description and move up memcontrol.h
header to fix build failure if CONFIG_MEMCG_KMEM=y too.
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/kmemcheck.c |    1 +
 mm/slab.h      |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index fd814fd..cab58bb 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -2,6 +2,7 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include "slab.h"
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
diff --git a/mm/slab.h b/mm/slab.h
index 13845d0..963a3f8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -37,6 +37,8 @@ struct kmem_cache {
 #include <linux/slub_def.h>
 #endif
 
+#include <linux/memcontrol.h>
+
 /*
  * State of the slab allocator.
  *
-- 
1.7.9.5

