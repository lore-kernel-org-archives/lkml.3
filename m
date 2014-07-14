Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaGNG4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:56:39 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55057 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaGNG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:56:31 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 14 Jul 2014 16:02:25 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gioh Kim <gioh.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
Message-ID: <20140714070225.GE11317@js1304-P5Q-DELUXE>
References: <53B664E5.5060102@lge.com>
 <20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
 <xa1tpphf4x3s.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xa1tpphf4x3s.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:46:31PM +0200, Michal Nazarewicz wrote:
> On Mon, Jul 07 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
> > What I proposed is that CMA call invalidate_bh_lrus() right at the
> > outset.  Something along the lines of
> >
> > --- a/mm/page_alloc.c~a
> > +++ a/mm/page_alloc.c
> > @@ -6329,6 +6329,14 @@ int alloc_contig_range(unsigned long sta
> >  	};
> >  	INIT_LIST_HEAD(&cc.migratepages);
> >  
> > +#ifdef CONFIG_CMA
> > +	/*
> > +	 * Comment goes here
> > +	 */
> > +	if (migratetype == MIGRATE_CMA)
> > +		invalidate_bh_lrus();
> > +#endif
> > +
> 
> This seems reasonable, except I think it should go after
> start_isolate_page_range call because otherwise there's no guarantee
> that someone won't grab those pages back.
> 
> Also to avoid the #ifdef perhaps we want this as well:

I think that we just want to remove ifdef CONFIG_CMA on above code
snippet, because invalidate_bh_lrus() would also help user of
alloc_contig_range() with MIGRATE_MOVABLE.

> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6cbd1b6..2640a55 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -64,10 +64,11 @@ enum {
>  };
>  
>  #ifdef CONFIG_CMA
> -#  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
> +#  define __is_migrate_cma(migratetype) ((migratetype) == MIGRATE_CMA)
>  #else
> -#  define is_migrate_cma(migratetype) false
> +#  define __is_migrate_cma(migratetype) false
>  #endif
> +#define is_migrate_cma(migratetype) unlikely(__is_migrate_cma(migratetype))
>  
>  #define for_each_migratetype_order(order, type) \
>  	for (order = 0; order < MAX_ORDER; order++) \
> 
> and then use “if (__is_migrate_cma(migratetype))”.
> 
> >  	/*
> >  	 * What we do here is we mark all pageblocks in range as
> >  	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
> >
> >
> > - I'd have thought that it would make sense to do this for huge pages
> >   as well (MIGRATE_MOVABLE) but nobody really seems to know.
> >
> > - There's a patch floating around ("Allow increasing the buffer-head
> >   per-CPU LRU size") which will double the size of the bh lrus, so this
> >   all becomes more important.
> >
> > - alloc_contig_range() does lru_add_drain_all() and drain_all_pages()
> >   *after* performing the allocation.  I can't work out why this is the
> >   case and of course it is undocumented.  If this is indeed not a bug
> >   then probably the invalidate_bh_lrus() should happen in the same
> >   place.
> 
> The purpose is to get free non-buddy pages (so pages on PCP lists for
> instance) back onto the buddy list.  It's safe to move those calls above
> the call to __alloc_contig_migrate_range, but I don't think it will
> change anything (except of course the fact that if migration fails,
> we'll do the draining for nothing).

At a glance, we don't need that drain_all_pages(), because
drain_all_pages() is also called by set_migratetype_isolate() after changing
migratetype.

And, it is better to move up lru_add_drain_all() to ahead of
__alloc_contig_migrate_range(), because some pages could be skipped
to migrate due to this lru page caching mechanism.

Thanks.
