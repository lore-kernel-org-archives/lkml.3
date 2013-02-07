Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3BGILe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:11:34 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39330 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3BGILa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:11:30 -0500
Date: Thu, 7 Feb 2013 03:11:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmalloc: Remove alloc_map from vmap_block.
Message-ID: <20130207081115.GA1094@cmpxchg.org>
References: <CAOAMb1AZaXHiW47MbstoVaDVEbVaSC+fqcZoSM0EXC5RpH7nHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1AZaXHiW47MbstoVaDVEbVaSC+fqcZoSM0EXC5RpH7nHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanho,

On Thu, Feb 07, 2013 at 11:27:54AM +0900, Chanho Min wrote:
> There is no reason to maintain alloc_map in the vmap_block.
> The use of alloc_map may require heavy bitmap operation sometimes.
> In the worst-case, We need 1024 for-loops to find 1 free bit and
> thus cause overhead. vmap_block is fragmented unnecessarily by
> 2 order alignment as well.
> 
> Instead we can map by using vb->free in order. When It is freed,
> Its corresponding bit will be set in the dirty_map and all
> free/purge operations are carried out in the dirty_map.
> vmap_block is not fragmented sporadically anymore and thus
> purge_fragmented_blocks_thiscpu in the vb_alloc can be removed.

I submitted a similar patch some time ago, but at the time Mel
suggested instead to figure out if this bitmap was not supposed to be
doing something useful and depending on that implement recycling of
partially used vmap blocks.

Here is the thread:

https://lkml.org/lkml/2011/4/14/619

I started looking for workloads to profile but then lost interest.
The current code can theoretically end up walking through a lot of
partially used blocks if a string of allocations never fit any of
them.  The number of these blocks depends on previous allocations that
leave them unusable for future allocations and whether any other
vmalloc/vmap user recently flushed them all.  So it's painful to think
about it and hard to impossible to pin down should this ever actually
result in a performance problem.

Either way, short of an actual fix I suspect this patch will pop up
again as it removes currently dead code.
