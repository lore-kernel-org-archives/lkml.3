Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941Ab3CSGmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:42:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53767 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab3CSGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:42:27 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-15-514808d117f1
Date: Tue, 19 Mar 2013 15:42:47 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 1/3] mm, nobootmem: fix wrong usage of max_low_pfn
Message-ID: <20130319064247.GH8858@lge.com>
References: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
 <CAE9FiQWXYGdAp82HE8Jg=HYdxWa5nPC5g63E6rNNwYyAQ-B5tg@mail.gmail.com>
 <20130319062522.GG8858@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319062522.GG8858@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:25:22PM +0900, Joonsoo Kim wrote:
> On Mon, Mar 18, 2013 at 10:47:41PM -0700, Yinghai Lu wrote:
> > On Mon, Mar 18, 2013 at 10:15 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > > max_low_pfn reflect the number of _pages_ in the system,
> > > not the maximum PFN. You can easily find that fact in init_bootmem().
> > > So fix it.
> > 
> > I'm confused. for x86, we have max_low_pfn defined in ...
> 
> Below is queote from Russell King in 'https://lkml.org/lkml/2013/3/13/123'
> 
> 
>  Now, max_low_pfn is initialized this way:
>  
>  /**
>   * init_bootmem - register boot memory
>   * @start: pfn where the bitmap is to be placed
>   * @pages: number of available physical pages
>   *
>   * Returns the number of bytes needed to hold the bitmap.
>   */
>  unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
>  {
>         max_low_pfn = pages;
>         min_low_pfn = start;
>         return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
>  }
>  So, min_low_pfn is the PFN offset of the start of physical memory (so
>  3GB >> PAGE_SHIFT) and max_low_pfn ends up being the number of pages,
>  _not_ the maximum PFN value
> 
> So, if physical address doesn't start at 0, max_low_pfn doesn't represent 
> the maximum PFN value. This is a case for ARM.
> 
> > 
> > #ifdef CONFIG_X86_32
> >         /* max_low_pfn get updated here */
> >         find_low_pfn_range();
> > #else
> >         num_physpages = max_pfn;
> > 
> >         check_x2apic();
> > 
> >         /* How many end-of-memory variables you have, grandma! */
> >         /* need this before calling reserve_initrd */
> >         if (max_pfn > (1UL<<(32 - PAGE_SHIFT)))
> >                 max_low_pfn = e820_end_of_low_ram_pfn();
> >         else
> >                 max_low_pfn = max_pfn;
> > 
> > and under max_low_pfn is bootmem.
> > 
> > >
> > > Additionally, if 'start_pfn == end_pfn', we don't need to go futher,
> > > so change range check.
> > >
> > > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > >
> > > diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> > > index 5e07d36..4711e91 100644
> > > --- a/mm/nobootmem.c
> > > +++ b/mm/nobootmem.c
> > > @@ -110,9 +110,9 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
> > >  {
> > >         unsigned long start_pfn = PFN_UP(start);
> > >         unsigned long end_pfn = min_t(unsigned long,
> > > -                                     PFN_DOWN(end), max_low_pfn);
> > > +                                     PFN_DOWN(end), min_low_pfn);
> > 
> > what is min_low_pfn ?  is it 0 for x86?
> 
> My implementation is totally wrong. :)
> min_low_pfn is not proper value for this purpose.
> 
> I will fix it.
> Sorry for noise.
> 
> Thanks.

How about using "memblock.current_limit"?

unsigned long end_pfn = min_t(unsigned long, PFN_DOWN(end),
					memblock.current_limit);

Thanks.

> 
> > 
> > Thanks
> > 
> > Yinghai
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
