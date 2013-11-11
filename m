Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3KKUrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:47:39 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8465 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3KKUrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:47:33 -0500
Message-ID: <1384202848.6940.59.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: cache largest vma
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Date: Mon, 11 Nov 2013 12:47:28 -0800
In-Reply-To: <20131111120421.GB21291@gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
	 <1383537862.2373.14.camel@buesod1.americas.hpqcorp.net>
	 <20131104073640.GF13030@gmail.com>
	 <1384143129.6940.32.camel@buesod1.americas.hpqcorp.net>
	 <CANN689Eauq+DHQrn8Wr=VU-PFGDOELz6HTabGDGERdDfeOK_UQ@mail.gmail.com>
	 <20131111120421.GB21291@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 13:04 +0100, Ingo Molnar wrote:
> * Michel Lespinasse <walken@google.com> wrote:
> 
> > On Sun, Nov 10, 2013 at 8:12 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > 2) Oracle Data mining (4K pages)
> > > +------------------------+----------+------------------+---------+
> > > |    mmap_cache type     | hit-rate | cycles (billion) | stddev  |
> > > +------------------------+----------+------------------+---------+
> > > | no mmap_cache          | -        | 63.35            | 0.20207 |
> > > | current mmap_cache     | 65.66%   | 19.55            | 0.35019 |
> > > | mmap_cache+largest VMA | 71.53%   | 15.84            | 0.26764 |
> > > | 4 element hash table   | 70.75%   | 15.90            | 0.25586 |
> > > | per-thread mmap_cache  | 86.42%   | 11.57            | 0.29462 |
> > > +------------------------+----------+------------------+---------+
> > >
> > > This workload sure makes the point of how much we can benefit of 
> > > caching the vma, otherwise find_vma() can cost more than 220% extra 
> > > cycles. We clearly win here by having a per-thread cache instead of 
> > > per address space. I also tried the same workload with 2Mb hugepages 
> > > and the results are much more closer to the kernel build, but with the 
> > > per-thread vma still winning over the rest of the alternatives.
> > >
> > > All in all I think that we should probably have a per-thread vma 
> > > cache. Please let me know if there is some other workload you'd like 
> > > me to try out. If folks agree then I can cleanup the patch and send it 
> > > out.
> > 
> > Per thread cache sounds interesting - with per-mm caches there is a real 
> > risk that some modern threaded apps pay the cost of cache updates 
> > without seeing much of the benefit. However, how do you cheaply handle 
> > invalidations for the per thread cache ?
> 
> The cheapest way to handle that would be to have a generation counter for 
> the mm and to couple cache validity to a specific value of that. 
> 'Invalidation' is then the free side effect of bumping the generation 
> counter when a vma is removed/moved.

I was basing the invalidations on the freeing of vm_area_cachep, so I
mark current->mmap_cache = NULL whenever we call
kmem_cache_free(vm_area_cachep, ...). But I can see this being a problem
if more than one task's mmap_cache points to the same vma, as we end up
invalidating only one. I'd really like to use a similar logic and base
everything around the existence of the vma instead of adding a counting
infrastructure. Sure we'd end up doing more reads when we do the lookup
in find_vma() but the cost of maintaining it comes free. I just ran into
a similar idea from 2 years ago:
http://lkml.indiana.edu/hypermail/linux/kernel/1112.1/01352.html

While there are several things that aren't needed, it does do the
is_kmem_cache() to verify that the vma is still a valid slab.

Thanks,
Davidlohr


