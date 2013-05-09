Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3EIPXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:23:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551Ab3EIPXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:23:23 -0400
Date: Thu, 9 May 2013 16:23:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Linux-MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/22] mm: page allocator: Allocate/free order-0 pages
 from a per-zone magazine
Message-ID: <20130509152318.GD11497@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
 <1368028987-8369-10-git-send-email-mgorman@suse.de>
 <0000013e85732d03-05e35c8e-205e-4242-98f5-2ae7bda64c5c-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <0000013e85732d03-05e35c8e-205e-4242-98f5-2ae7bda64c5c-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:41:58PM +0000, Christoph Lameter wrote:
> On Wed, 8 May 2013, Mel Gorman wrote:
> 
> > 1. IRQs do not have to be disabled to access the lists reducing IRQs
> >    disabled times.
> 
> The per cpu structure access also would not need to disable irq if the
> fast path would be using this_cpu ops.
> 

How does this_cpu protect against preemption due to interrupt?  this_read()
itself only disables preemption and it's explicitly documented that
interrupt that modifies the per-cpu data will not be reliable so the use
of the per-cpu lists is right out. It would require that a race-prone
check be used with cmpxchg which in turn would require arrays, not lists.

> > 2. As the list is protected by a spinlock, it is not necessary to
> >    send IPI to drain the list. As the lists are accessible by multiple CPUs,
> >    it is easier to tune.
> 
> The lists are a problem since traversing list heads creates a lot of
> pressure on the processor and TLB caches. Could we either move to an array
> of pointers to page structs (like in SLAB)

They would have large memory requirements.  The magazine data structure in
this series fits in a cache line. An array of 128 struct page pointers
would require 1K on 64-bit and if that thing is per possible CPU and per
zone then it could get really excessive.

> or to a linked list that is
> constrained within physical boundaries like within a PMD? (comparable
> to the SLUB approach)?
> 

I don't see how as the page allocator does not control the physical location
of any pages freed to it and it's the struct pages it is linking together. On
some systems at least with 1G pages, the struct pages will be backed by
memory mapped with 1G entries so the TLB pressure should be reduced but
the cache pressure from struct page modifications is certainly a problem.

> > > 3. The magazine_lock is potentially hot but it can be split to have
> >    one lock per CPU socket to reduce contention. Draining the lists
> >    in this case would acquire multiple locks be acquired.
> 
> IMHO the use of per cpu RMV operations would be lower latency than the use
> of spinlocks. There is no "lock" prefix overhead with those. Page
> allocation is a frequent operation that I would think needs to be as fast
> as possible.

The memory requirements may be large because those per-cpu areas sized are
allocated depending on num_possible_cpus()s. Correct? Regardless of their
size, it would still be required to deal with cpu hot-plug to avoid memory
leaks and draining them would still require global IPIs so the overall
code complexity would be similar to what exists today. Ultimately all that
changes is that we use an array+cmpxchg instead of a list which will shave
a small amount of latency but it will still be regularly falling back to
the buddy lists and contend on the zone->lock due the limited size of the
per-cpu magazines and hiding the advantage of using cmpxchg in the noise.

-- 
Mel Gorman
SUSE Labs
