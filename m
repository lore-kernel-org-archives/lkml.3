Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaIVAcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:32:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:33800 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIVAcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:32:23 -0400
X-Original-SENDERIP: 10.177.220.159
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 22 Sep 2014 09:32:45 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: linux-kernel@vger.kernel.org
Cc: cl@linux.com, penberg@kernel.org, rdunlap@infradead.org,
        rientjes@google.com, mm-commits@vger.kernel.org
Subject: Re: + mm-slab_common-commonize-slab-merge-logic.patch added to -mm
 tree
Message-ID: <20140922003245.GA28902@js1304-P5Q-DELUXE>
References: <541cb039.GkGFlIDKO1+jpDW0%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541cb039.GkGFlIDKO1+jpDW0%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 03:37:45PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/slab_common: commonize slab merge logic
> has been added to the -mm tree.  Its filename is
>      mm-slab_common-commonize-slab-merge-logic.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-commonize-slab-merge-logic.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-commonize-slab-merge-logic.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Subject: mm/slab_common: commonize slab merge logic
> 
> Slab merge is good feature to reduce fragmentation.  Now, it is only
> applied to SLUB, but, it would be good to apply it to SLAB.  This patch is
> preparation step to apply slab merge to SLAB by commonizing slab merge
> logic.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/kernel-parameters.txt |   14 ++--
>  mm/slab.h                           |   15 ++++
>  mm/slab_common.c                    |   91 ++++++++++++++++++++++++++
>  mm/slub.c                           |   91 --------------------------
>  4 files changed, 117 insertions(+), 94 deletions(-)
> 
> diff -puN Documentation/kernel-parameters.txt~mm-slab_common-commonize-slab-merge-logic Documentation/kernel-parameters.txt
> --- a/Documentation/kernel-parameters.txt~mm-slab_common-commonize-slab-merge-logic
> +++ a/Documentation/kernel-parameters.txt
> @@ -3140,6 +3140,13 @@ bytes respectively. Such letter suffixes
>  
>  	slram=		[HW,MTD]
>  
> +	slab_nomerge	[MM]
> +			Disable merging of slabs with similar size. May be
> +			necessary if there is some reason to distinguish
> +			allocs to different slabs. Debug options disable
> +			merging on their own.
> +			For more information see Documentation/vm/slub.txt.
> +
>  	slab_max_order=	[MM, SLAB]
>  			Determines the maximum allowed order for slabs.
>  			A high setting may cause OOMs due to memory
> @@ -3175,11 +3182,8 @@ bytes respectively. Such letter suffixes
>  			For more information see Documentation/vm/slub.txt.
>  
>  	slub_nomerge	[MM, SLUB]
> -			Disable merging of slabs with similar size. May be
> -			necessary if there is some reason to distinguish
> -			allocs to different slabs. Debug options disable
> -			merging on their own.
> -			For more information see Documentation/vm/slub.txt.
> +			Same with slab_nomerge. This is supported for legacy.
> +			See slab_nomerge for more information.
>  
>  	smart2=		[HW]
>  			Format: <io1>[,<io2>[,...,<io8>]]
> diff -puN mm/slab.h~mm-slab_common-commonize-slab-merge-logic mm/slab.h
> --- a/mm/slab.h~mm-slab_common-commonize-slab-merge-logic
> +++ a/mm/slab.h
> @@ -88,15 +88,30 @@ extern void create_boot_cache(struct kme
>  			size_t size, unsigned long flags);
>  
>  struct mem_cgroup;
> +
> +int slab_unmergeable(struct kmem_cache *s);
> +struct kmem_cache *find_mergeable(size_t size, size_t align,
> +		unsigned long flags, const char *name, void (*ctor)(void *));
>  #ifdef CONFIG_SLUB
>  struct kmem_cache *
>  __kmem_cache_alias(const char *name, size_t size, size_t align,
>  		   unsigned long flags, void (*ctor)(void *));
> +
> +unsigned long kmem_cache_flags(unsigned long object_size,
> +	unsigned long flags, const char *name,
> +	void (*ctor)(void *));
>  #else
>  static inline struct kmem_cache *
>  __kmem_cache_alias(const char *name, size_t size, size_t align,
>  		   unsigned long flags, void (*ctor)(void *))
>  { return NULL; }
> +
> +static inline unsigned long kmem_cache_flags(unsigned long object_size,
> +	unsigned long flags, const char *name,
> +	void (*ctor)(void *))
> +{
> +	return flags;
> +}
>  #endif
>  
>  
> diff -puN mm/slab_common.c~mm-slab_common-commonize-slab-merge-logic mm/slab_common.c
> --- a/mm/slab_common.c~mm-slab_common-commonize-slab-merge-logic
> +++ a/mm/slab_common.c
> @@ -31,6 +31,34 @@ DEFINE_MUTEX(slab_mutex);
>  struct kmem_cache *kmem_cache;
>  
>  /*
> + * Set of flags that will prevent slab merging
> + */
> +#define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> +		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
> +		SLAB_FAILSLAB)
> +
> +#define SLAB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
> +		SLAB_CACHE_DMA | SLAB_NOTRACK)
> +
> +/*
> + * Merge control. If this is set then no merging of slab caches will occur.
> + * (Could be removed. This was introduced to pacify the merge skeptics.)
> + */
> +static int slab_nomerge;
> +
> +static int __init setup_slab_nomerge(char *str)
> +{
> +	slab_nomerge = 1;
> +	return 1;
> +}
> +
> +#ifdef CONFIG_SLUB
> +__setup("slub_nomerge", setup_slab_nomerge);
> +#endif
> +
> +__setup("slab_nomerge", setup_slab_nomerge);

Hello, Andrew.

This patch has build failure problem if CONFIG_SLUB.
Detailed information and fix is in following patch.

Thanks.


------------->8----------------
>From 6da74766a11459de82acc54a97a268179ddfca87 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 22 Sep 2014 08:58:19 +0900
Subject: [PATCH] mm/slab_common: fix build failure if CONFIG_SLUB
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 'mm/slab_common: commonize slab merge logic' introduces following
build failure if CONFIG_SLUB.

mm/slab_common.c:59:1: error: redefinition of ‘__setup_str_setup_slab_nomerge’
mm/slab_common.c:56:1: note: previous definition of ‘__setup_str_setup_slab_nomerge’ was here
mm/slab_common.c:59:1: error: redefinition of ‘__setup_setup_slab_nomerge’
mm/slab_common.c:56:1: note: previous definition of ‘__setup_setup_slab_nomerge’ was here
make[1]: *** [mm/slab_common.o] Error 1
make: *** [mm/slab_common.o] Error 2

It is caused by using one function for two kernel parameter,
slab_nomerge and slub_nomerg. In expanding
__setup(parameter name, function name), function name is used for unique
id so that using one function for two kernel parameter makes redefinition
error. To provide unique id and overcome this issue, this patch uses
__setup_param() rather than __setup() for slub_nomerge kernel parameter.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index f4468c0..8cfa7cd 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -53,7 +53,7 @@ static int __init setup_slab_nomerge(char *str)
 }
 
 #ifdef CONFIG_SLUB
-__setup("slub_nomerge", setup_slab_nomerge);
+__setup_param("slub_nomerge", slub_nomerge, setup_slab_nomerge, 0);
 #endif
 
 __setup("slab_nomerge", setup_slab_nomerge);
-- 
1.7.9.5

