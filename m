Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3KDEW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 23:22:56 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:4234 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3KDEWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 23:22:55 -0500
Message-ID: <1383538971.2373.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: cache largest vma
From: Davidlohr Bueso <davidlohr@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Sun, 03 Nov 2013 20:22:51 -0800
In-Reply-To: <CAHGf_=okr7mFx3j=gRfkETS21KZXkdo4XevF1KQM+gbXkTabgg@mail.gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
	 <5274114B.7010302@gmail.com>
	 <1383340291.2653.33.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=okr7mFx3j=gRfkETS21KZXkdo4XevF1KQM+gbXkTabgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-03 at 18:57 -0500, KOSAKI Motohiro wrote:
> >> I'm slightly surprised this cache makes 15% hit. Which application
> >> get a benefit? You listed a lot of applications, but I'm not sure
> >> which is highly depending on largest vma.
> >
> > Well I chose the largest vma because it gives us a greater chance of
> > being already cached when we do the lookup for the faulted address.
> >
> > The 15% improvement was with Hadoop. According to my notes it was at
> > ~48% with the baseline kernel and increased to ~63% with this patch.
> >
> > In any case I didn't measure the rates on a per-task granularity, but at
> > a general system level. When a system is first booted I can see that the
> > mmap_cache access rate becomes the determinant factor and when adding a
> > workload it doesn't change much. One exception to this was a kernel
> > build, where we go from ~50% to ~89% hit rate on a vanilla kernel.
> 
> I looked at this patch a bit. The worth of this is to improve the
> cache hit ratio
> of heap.
> 
> 1) For single thread applications, heap is frequently largest mapping
> in the process.

Right.

> 2) For java VM, "java -Xms1000m -Xmx1000m HelloWorld" makes following
> /proc/<pid>/smaps entry. That said, JVM allocate single heap even if
> applications are multi threaded.

Oh, this is new to me and nicely explains why I see the most benefit in
java related workloads.

> 
> c1800000-100000000 rw-p 00000000 00:00 0
> Size:            1024000 kB
> Rss:                 244 kB
> Pss:                 244 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:       244 kB
> Referenced:          244 kB
> Anonymous:           244 kB
> AnonHugePages:         0 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> 
> That's good.
> 
> However, we know there is a situation that this patch doesn't work.
> glibc makes per thread heap (arena) by default. So, it is not to be
> expected works well on glibc multi threaded programs. That's a
> slightly big limitation.

I think this is what Linus was referring to.

> 
> Anyway, I haven't observed real performance difference because most
> big penalty of find_vma come from taking mmap_sem, not rb-tree search.

Yes, undoubtedly, which is why I'm using units of hit/miss rather than
workload throughput.

Thanks,
Davidlohr

