Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaK1HcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 02:32:16 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33942 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaK1HcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 02:32:15 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 28 Nov 2014 16:35:24 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] mm/debug-pagealloc: prepare boottime configurable
 on/off
Message-ID: <20141128073524.GC11802@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1417091739.29407.95.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091739.29407.95.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 01:35:39PM +0100, Paul Bolle wrote:
> Joonsoo,
> 
> On Mon, 2014-11-24 at 17:15 +0900, Joonsoo Kim wrote:
> > Until now, debug-pagealloc needs extra flags in struct page, so we need
> > to recompile whole source code when we decide to use it. This is really
> > painful, because it takes some time to recompile and sometimes rebuild is
> > not possible due to third party module depending on struct page.
> > So, we can't use this good feature in many cases.
> > 
> > Now, we have the page extension feature that allows us to insert
> > extra flags to outside of struct page. This gets rid of third party module
> > issue mentioned above. And, this allows us to determine if we need extra
> > memory for this page extension in boottime. With these property, we can
> > avoid using debug-pagealloc in boottime with low computational overhead
> > in the kernel built with CONFIG_DEBUG_PAGEALLOC. This will help our
> > development process greatly.
> > 
> > This patch is the preparation step to achive above goal. debug-pagealloc
> > originally uses extra field of struct page, but, after this patch, it
> > will use field of struct page_ext. Because memory for page_ext is
> > allocated later than initialization of page allocator in CONFIG_SPARSEMEM,
> > we should disable debug-pagealloc feature temporarily until initialization
> > of page_ext. This patch implements this.
> > 
> > v2: fix compile error on CONFIG_PAGE_POISONING
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> This patch is included in today's linux-next (ie, next-2o0141127) as
> commit 1e491e9be4c9 ("mm/debug-pagealloc: prepare boottime configurable
> on/off").
> 
> > [...]
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 33a8acf..c7b22e7 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -10,7 +10,6 @@
> >  #include <linux/rwsem.h>
> >  #include <linux/completion.h>
> >  #include <linux/cpumask.h>
> > -#include <linux/page-debug-flags.h>
> >  #include <linux/uprobes.h>
> >  #include <linux/page-flags-layout.h>
> >  #include <asm/page.h>
> > @@ -186,9 +185,6 @@ struct page {
> >  	void *virtual;			/* Kernel virtual address (NULL if
> >  					   not kmapped, ie. highmem) */
> >  #endif /* WANT_PAGE_VIRTUAL */
> > -#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
> > -	unsigned long debug_flags;	/* Use atomic bitops on this */
> > -#endif
> >  
> >  #ifdef CONFIG_KMEMCHECK
> >  	/*
> > diff --git a/include/linux/page-debug-flags.h b/include/linux/page-debug-flags.h
> > deleted file mode 100644
> > index 22691f61..0000000
> > --- a/include/linux/page-debug-flags.h
> > +++ /dev/null
> > @@ -1,32 +0,0 @@
> > -#ifndef LINUX_PAGE_DEBUG_FLAGS_H
> > -#define  LINUX_PAGE_DEBUG_FLAGS_H
> > -
> > -/*
> > - * page->debug_flags bits:
> > - *
> > - * PAGE_DEBUG_FLAG_POISON is set for poisoned pages. This is used to
> > - * implement generic debug pagealloc feature. The pages are filled with
> > - * poison patterns and set this flag after free_pages(). The poisoned
> > - * pages are verified whether the patterns are not corrupted and clear
> > - * the flag before alloc_pages().
> > - */
> > -
> > -enum page_debug_flags {
> > -	PAGE_DEBUG_FLAG_POISON,		/* Page is poisoned */
> > -	PAGE_DEBUG_FLAG_GUARD,
> > -};
> > -
> > -/*
> > - * Ensure that CONFIG_WANT_PAGE_DEBUG_FLAGS reliably
> > - * gets turned off when no debug features are enabling it!
> > - */
> > -
> > -#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
> > -#if !defined(CONFIG_PAGE_POISONING) && \
> > -    !defined(CONFIG_PAGE_GUARD) \
> > -/* && !defined(CONFIG_PAGE_DEBUG_SOMETHING_ELSE) && ... */
> > -#error WANT_PAGE_DEBUG_FLAGS is turned on with no debug features!
> > -#endif
> > -#endif /* CONFIG_WANT_PAGE_DEBUG_FLAGS */
> > -
> > -#endif /* LINUX_PAGE_DEBUG_FLAGS_H */
> 
> This remove all uses of CONFIG_WANT_PAGE_DEBUG_FLAGS and
> CONFIG_PAGE_GUARD. So the Kconfig symbols WANT_PAGE_DEBUG_FLAGS and
> PAGE_GUARD are now unused.
> 
> Should I submit the trivial patch to remove these symbols or is a patch
> that does that queued already?

Hello, Paul.

Thanks for spotting this.
I attach the patch. :)

Andrew,
Could you kindly fold this into the patch in your tree?

Thanks.

------------------->8---------------
>From a33c480160904cc93333807a448960151ac4c534 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 28 Nov 2014 16:05:32 +0900
Subject: [PATCH] mm/debug_pagealloc: remove obsolete Kconfig options

These are obsolete since commit "mm/debug-pagealloc: prepare boottime
configurable" is merged. So, remove it.

[pebolle@tiscali.nl: find obsolete Kconfig options]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/Kconfig.debug |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 56badfc..957d3da 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -14,7 +14,6 @@ config DEBUG_PAGEALLOC
 	depends on !KMEMCHECK
 	select PAGE_EXTENSION
 	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
@@ -27,13 +26,5 @@ config DEBUG_PAGEALLOC
 	  that would result in incorrect warnings of memory corruption after
 	  a resume because free pages are not saved to the suspend image.
 
-config WANT_PAGE_DEBUG_FLAGS
-	bool
-
 config PAGE_POISONING
 	bool
-	select WANT_PAGE_DEBUG_FLAGS
-
-config PAGE_GUARD
-	bool
-	select WANT_PAGE_DEBUG_FLAGS
-- 
1.7.9.5

