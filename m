Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab3BHHBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:01:32 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39391 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab3BHHBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:01:31 -0500
Date: Fri, 8 Feb 2013 02:01:14 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH] vmalloc: Remove alloc_map from vmap_block.
Message-ID: <20130208070114.GB7511@cmpxchg.org>
References: <CAOAMb1AZaXHiW47MbstoVaDVEbVaSC+fqcZoSM0EXC5RpH7nHw@mail.gmail.com>
 <CAOAMb1BwVCPMLRMkMZuHhoi-meULJ-jG+O5sU4ppkR_MLDQ5dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1BwVCPMLRMkMZuHhoi-meULJ-jG+O5sU4ppkR_MLDQ5dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:37:13PM +0900, Chanho Min wrote:
> >I started looking for workloads to profile but then lost interest.
> >The current code can theoretically end up walking through a lot of
> >partially used blocks if a string of allocations never fit any of
> >them.  The number of these blocks depends on previous allocations that
> >leave them unusable for future allocations and whether any other
> >vmalloc/vmap user recently flushed them all.  So it's painful to think
> >about it and hard to impossible to pin down should this ever actually
> >result in a performance problem.
> 
> vm_map_ram() is allowed to be called by external kernel module.
> I profiled some kernel module as bellow perf log. Its mapping behavior
> was most of the workload. yes, we can improve its inefficient mapping.
> But, This shows the allocation bitmap has the potential to cause significant
> overhead.

No question that you can find a scenario where this bitmap becomes
expensive.  And I don't think we should leave the code as is, because
it really is a waste of time for cpus and readers of the code.

The question is whether we put the bitmap to good use and implement
partial block recycling, or keep with the current allocation model but
make it a little less expensive.

Nobody actually seems interested in implementing partial block
recycling and we do have multiple patches to ditch the bitmap.  I
think we should probably merge the patch that we have and save some
wasted cycles, that doesn't prevent anyone from improving the
algorithm later on.
