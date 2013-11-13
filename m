Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab3KMR77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:59:59 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37899 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3KMR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:59:52 -0500
Date: Wed, 13 Nov 2013 18:59:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131113175948.GA12020@gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
 <1383537862.2373.14.camel@buesod1.americas.hpqcorp.net>
 <20131104073640.GF13030@gmail.com>
 <1384143129.6940.32.camel@buesod1.americas.hpqcorp.net>
 <CANN689Eauq+DHQrn8Wr=VU-PFGDOELz6HTabGDGERdDfeOK_UQ@mail.gmail.com>
 <20131111120421.GB21291@gmail.com>
 <1384202848.6940.59.camel@buesod1.americas.hpqcorp.net>
 <1384362490.2527.20.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384362490.2527.20.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Mon, 2013-11-11 at 12:47 -0800, Davidlohr Bueso wrote:
> > On Mon, 2013-11-11 at 13:04 +0100, Ingo Molnar wrote:
> > > * Michel Lespinasse <walken@google.com> wrote:
> > > 
> > > > On Sun, Nov 10, 2013 at 8:12 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > > > > 2) Oracle Data mining (4K pages)
> > > > > +------------------------+----------+------------------+---------+
> > > > > |    mmap_cache type     | hit-rate | cycles (billion) | stddev  |
> > > > > +------------------------+----------+------------------+---------+
> > > > > | no mmap_cache          | -        | 63.35            | 0.20207 |
> > > > > | current mmap_cache     | 65.66%   | 19.55            | 0.35019 |
> > > > > | mmap_cache+largest VMA | 71.53%   | 15.84            | 0.26764 |
> > > > > | 4 element hash table   | 70.75%   | 15.90            | 0.25586 |
> > > > > | per-thread mmap_cache  | 86.42%   | 11.57            | 0.29462 |
> > > > > +------------------------+----------+------------------+---------+
> > > > >
> > > > > This workload sure makes the point of how much we can benefit of 
> > > > > caching the vma, otherwise find_vma() can cost more than 220% extra 
> > > > > cycles. We clearly win here by having a per-thread cache instead of 
> > > > > per address space. I also tried the same workload with 2Mb hugepages 
> > > > > and the results are much more closer to the kernel build, but with the 
> > > > > per-thread vma still winning over the rest of the alternatives.
> > > > >
> > > > > All in all I think that we should probably have a per-thread vma 
> > > > > cache. Please let me know if there is some other workload you'd like 
> > > > > me to try out. If folks agree then I can cleanup the patch and send it 
> > > > > out.
> > > > 
> > > > Per thread cache sounds interesting - with per-mm caches there is a real 
> > > > risk that some modern threaded apps pay the cost of cache updates 
> > > > without seeing much of the benefit. However, how do you cheaply handle 
> > > > invalidations for the per thread cache ?
> > > 
> > > The cheapest way to handle that would be to have a generation counter for 
> > > the mm and to couple cache validity to a specific value of that. 
> > > 'Invalidation' is then the free side effect of bumping the generation 
> > > counter when a vma is removed/moved.
> 
> Wouldn't this approach make us invalidate all vmas even when we 
> just want to do it for one? [...]

Yes. If it's implemented as some sort of small, vma-size-weighted 
LRU, then all these 'different' caches go away and there's just 
this single LRU cache with a handful of entries cached.

This cache is then invalidated on munmap() et al. Which should be 
fine, mmap()/munmap() is a slowpath relative to find_vma().

Thanks,

	Ingo
