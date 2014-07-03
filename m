Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaGCFjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:39:32 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:9877 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaGCFjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:39:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArhaAEHstFN5LHZ8PGdsb2JhbABagw2DSoUIpB0BAgEBB5pVAYEHFwQBAQEBODWEAwEBBTocDxQQCAMYCSUPBSUDBxoTiEHHPBcYhViGDQGCW0kHhEMFmmyWDIFUK4Ey
Date: Thu, 3 Jul 2014 15:39:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140703053911.GQ4453@dastard>
References: <20140703023204.GN4453@dastard>
 <1404358268.23839.13.camel@buesod1.americas.hpqcorp.net>
 <20140703045933.GP4453@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703045933.GP4453@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 02:59:33PM +1000, Dave Chinner wrote:
> On Wed, Jul 02, 2014 at 08:31:08PM -0700, Davidlohr Bueso wrote:
> > On Thu, 2014-07-03 at 12:32 +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I've got a workload that hammers the mmap_sem via multi-threads
> > > memory allocation and page faults: it's called xfs_repair. 
> > 
> > Another reason for concurrent address space operations :/
> 
> *nod*
> 
> > >         XFS_REPAIR Summary    Thu Jul  3 11:41:28 2014
> > > 
> > > Phase           Start           End             Duration
> > > Phase 1:        07/03 11:40:27  07/03 11:40:27  
> > > Phase 2:        07/03 11:40:27  07/03 11:40:36  9 seconds
> > > Phase 3:        07/03 11:40:36  07/03 11:41:12  36 seconds
> > 
> > The *real* degradation is here then.
> 
> Yes, as I said, it's in phase 2 and 3 where all the IO and memory
> allocation is done.
> 
> > > This is what the kernel profile looks like on the strided run:
> > > 
> > > -  83.06%  [kernel]  [k] osq_lock
> > >    - osq_lock
> > >       - 100.00% rwsem_down_write_failed
> > >          - call_rwsem_down_write_failed
> > >             - 99.55% sys_mprotect
> > >                  tracesys
> > >                  __GI___mprotect
> > > -  12.02%  [kernel]  [k] rwsem_down_write_failed
> > >      rwsem_down_write_failed
> > >      call_rwsem_down_write_failed
> > > +   1.09%  [kernel]  [k] _raw_spin_unlock_irqrestore
> > > +   0.92%  [kernel]  [k] _raw_spin_unlock_irq
> > > +   0.68%  [kernel]  [k] __do_softirq
> > > +   0.33%  [kernel]  [k] default_send_IPI_mask_sequence_phys
> > > +   0.10%  [kernel]  [k] __do_page_fault
> > > 
> > > Basically, all the kernel time is spent processing lock contention
> > > rather than doing real work.
> > 
> > While before it just blocked.
> 
> Yup, pretty much - there was contention on the rwsem internal
> spinlock, but nothing else burnt CPU time.
> 
> > > I haven't tested back on 3.15 yet, but historically the strided AG
> > > repair for such filesystems (which I test all the time on 100+500TB
> > > filesystem images) is about 20-25% faster on this storage subsystem.
> > > Yes, the old code also burnt a lot of CPU due to lock contention,
> > > but it didn't go 5x slower than having no threading at all.
> > > 
> > > So this looks like a significant performance regression due to:
> > > 
> > > 4fc828e locking/rwsem: Support optimistic spinning
> > > 
> > > which changed the rwsem behaviour in 3.16-rc1.
> > 
> > So the mmap_sem is held long enough in this workload that the cost of
> > blocking is actually significantly smaller than just spinning --
> 
> The issues is that the memory allocation pattern alternates between
> read and write locks. i.e. write lock on mprotect at allocation,
> read lock on page fault when processing the contents. Hence we have
> a pretty consistent pattern of allocation (and hence mprotect)
> in prefetch threads, while there page faults are in the
> processing threads.
> 
> > particularly MCS. How many threads are you running when you see the
> > issue?
> 
> Lots. In phase 3:
> 
> $ ps -eLF |grep [x]fs_repair | wc -l
> 140
> $
> 
> We use 6 threads per AG being processed:
> 
> 	- 4 metadata prefetch threads (do allocation and IO),
> 	- 1 prefetch control thread
> 	- 1 metadata processing thread (do page faults)
> 
> That works out about right - default is to create a new processing
> group every 15 AGs, so with 336 AGs we should have roughly 22 AGs
> being processed concurrently...

There's another regression with the optimisitic spinning in rwsems
as well: it increases the size of the struct rw_semaphore by 16
bytes. That has increased the size of the struct xfs_inode by 32
bytes.

That's pretty damn significant - it's no uncommon to see machines
with tens of millions of cached XFS inodes, so increasing the size
of the inode by 4% is actually very significant. That's enough to go
from having a well balanced workload to not being able to fit the
working set of inodes in memory.

Filesystem developers will do almost anything to remove a few bytes
from the struct inode because inode cache footprint is extremely
important for performance. We also tend to get upset and
unreasonable when other people undo that hard work by making changes
that bloat the generic structures embedded in the inode
structures....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
