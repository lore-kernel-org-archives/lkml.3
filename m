Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3KKEXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 23:23:08 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42720 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3KKEXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 23:23:00 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Nov 2013 23:23:00 EST
Message-ID: <1384143129.6940.32.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: cache largest vma
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Date: Sun, 10 Nov 2013 20:12:09 -0800
In-Reply-To: <20131104073640.GF13030@gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
	 <1383537862.2373.14.camel@buesod1.americas.hpqcorp.net>
	 <20131104073640.GF13030@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, 2013-11-04 at 08:36 +0100, Ingo Molnar wrote:
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > I will look into doing the vma cache per thread instead of mm (I hadn't 
> > really looked at the problem like this) as well as Ingo's suggestion on 
> > the weighted LRU approach. However, having seen that we can cheaply and 
> > easily reach around ~70% hit rate in a lot of workloads, makes me wonder 
> > how good is good enough?
> 
> So I think it all really depends on the hit/miss cost difference. It makes 
> little sense to add a more complex scheme if it washes out most of the 
> benefits!
> 
> Also note the historic context: the _original_ mmap_cache, that I 
> implemented 16 years ago, was a front-line cache to a linear list walk 
> over all vmas (!).
> 
> This is the relevant 2.1.37pre1 code in include/linux/mm.h:
> 
> /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
> static inline struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr)
> {
>         struct vm_area_struct *vma = NULL;
> 
>         if (mm) {
>                 /* Check the cache first. */
>                 vma = mm->mmap_cache;
>                 if(!vma || (vma->vm_end <= addr) || (vma->vm_start > addr)) {
>                         vma = mm->mmap;
>                         while(vma && vma->vm_end <= addr)
>                                 vma = vma->vm_next;
>                         mm->mmap_cache = vma;
>                 }
>         }
>         return vma;
> }
> 
> See that vma->vm_next iteration? It was awful - but back then most of us 
> had at most a couple of megs of RAM with just a few vmas. No RAM, no SMP, 
> no worries - the mm was really simple back then.
> 
> Today we have the vma rbtree, which is self-balancing and a lot faster 
> than your typical linear list walk search ;-)
> 
> So I'd _really_ suggest to first examine the assumptions behind the cache, 
> it being named 'cache' and it having a hit rate does in itself not 
> guarantee that it gives us any worthwile cost savings when put in front of 
> an rbtree ...

So having mmap_cache around, in whatever form, is an important
optimization for find_vma() - even to this day. It can save us at least
50% cycles that correspond to this function. I ran a variety of
mmap_cache alternatives over two workloads that are heavy on page faults
(as opposed to Java based ones I had tried previously, which really
don't trigger enough for it to be worthwhile).  So we now have a
comparison of 5 different caching schemes -- note that the 4 element
hash table is quite similar to two elements, with a hash function of
(addr % hash_size).

1) Kernel build
+------------------------+----------+------------------+---------+
|    mmap_cache type     | hit-rate | cycles (billion) | stddev  |
+------------------------+----------+------------------+---------+
| no mmap_cache          | -        | 15.85            | 0.10066 |
| current mmap_cache     | 72.32%   | 11.03            | 0.01155 |
| mmap_cache+largest VMA | 84.55%   |  9.91            | 0.01414 |
| 4 element hash table   | 78.38%   | 10.52            | 0.01155 |
| per-thread mmap_cache  | 78.84%   | 10.69            | 0.01325 |
+------------------------+----------+------------------+---------+

In this particular workload the proposed patch benefits the most and
current alternatives, while they do help some, aren't really worth
bothering with as the current implementation already does a nice enough
job.

2) Oracle Data mining (4K pages)
+------------------------+----------+------------------+---------+
|    mmap_cache type     | hit-rate | cycles (billion) | stddev  |
+------------------------+----------+------------------+---------+
| no mmap_cache          | -        | 63.35            | 0.20207 |
| current mmap_cache     | 65.66%   | 19.55            | 0.35019 |
| mmap_cache+largest VMA | 71.53%   | 15.84            | 0.26764 |
| 4 element hash table   | 70.75%   | 15.90            | 0.25586 |
| per-thread mmap_cache  | 86.42%   | 11.57            | 0.29462 |
+------------------------+----------+------------------+---------+

This workload sure makes the point of how much we can benefit of caching
the vma, otherwise find_vma() can cost more than 220% extra cycles. We
clearly win here by having a per-thread cache instead of per address
space. I also tried the same workload with 2Mb hugepages and the results
are much more closer to the kernel build, but with the per-thread vma
still winning over the rest of the alternatives.

All in all I think that we should probably have a per-thread vma cache.
Please let me know if there is some other workload you'd like me to try
out. If folks agree then I can cleanup the patch and send it out.

Thanks,
Davidlohr

