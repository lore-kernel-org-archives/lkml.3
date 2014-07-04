Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbaGDBqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:46:11 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:4713 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaGDBqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:46:09 -0400
Message-ID: <1404438366.8764.121.camel@j-VirtualBox>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Jason Low <jason.low2@hp.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 03 Jul 2014 18:46:06 -0700
In-Reply-To: <20140704010147.GY4453@dastard>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 11:01 +1000, Dave Chinner wrote:
> [re-added lkml]
> 
> On Thu, Jul 03, 2014 at 11:50:20AM -0700, Jason Low wrote:
> > On Wed, Jul 2, 2014 at 7:32 PM, Dave Chinner <david@fromorbit.com> wrote:
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
> > 
> > Hi Dave,
> > 
> > So with no sign of rwsem_spin_on_owner(), yet with such heavy contention in
> > osq_lock, this makes me wonder if it's spending most of its time spinning
> > on !owner while a reader has the lock? (We don't set sem->owner for the readers.)
> > 
> > If that's an issue, maybe the below is worth a test, in which we'll just
> > avoid spinning if rwsem_can_spin_on_owner() finds that there is no owner.
> > If we just had to enter the slowpath yet there is no owner, we'll be conservative
> > and assume readers have the lock.
> 
> That makes it quite a bit faster:
> 
>         XFS_REPAIR Summary    Fri Jul  4 10:39:32 2014
> 
> Phase           Start           End             Duration
> Phase 1:        07/04 10:38:04  07/04 10:38:05  1 second
> Phase 2:        07/04 10:38:05  07/04 10:38:08  3 seconds
> Phase 3:        07/04 10:38:08  07/04 10:39:12  1 minute, 4 seconds
> Phase 4:        07/04 10:39:12  07/04 10:39:21  9 seconds
> Phase 5:        07/04 10:39:21  07/04 10:39:22  1 second
> Phase 6:        07/04 10:39:22  07/04 10:39:30  8 seconds
> Phase 7:        07/04 10:39:30  07/04 10:39:30  
> 
> Total run time: 1 minute, 26 seconds
> done
> 
> real    1m28.504s
> user    1m23.990s
> sys     3m20.132s
> 
> So system time goes down massively, and speed comes up to within 30%
> of the single AG run.  But it's still 2-3000 IOPS down, but it's
> acceptible for the moment.
> 
> FWIW, the kernel profile ifor the multi-AG run now looks like:
> 
>   29.64%  [kernel]  [k] _raw_spin_unlock_irq
>    - _raw_spin_unlock_irq
>       + 35.34% __schedule
>       - 34.15% call_rwsem_down_write_failed
>          + 99.27% sys_mprotect
>       - 30.02% call_rwsem_down_read_failed
>            95.59% __do_page_fault
> -  24.65%  [kernel]  [k] _raw_spin_unlock_irqrestore
>    - _raw_spin_unlock_irqrestore
>       - 69.38% rwsem_wake
>          - call_rwsem_wake
>             - 83.32% sys_mprotect
>             + 15.54% __do_page_fault
>       + 22.55% try_to_wake_up
> +   9.77%  [kernel]  [k] default_send_IPI_mask_sequence_phys
> -   3.21%  [kernel]  [k] smp_call_function_many
>    - smp_call_function_many
>       - 99.22% flush_tlb_page
> +   2.51%  [kernel]  [k] rwsem_down_write_failed
> 
> It's much more like the 3.15 profile - it's only wasting half the
> CPU spinning on the internal spinlock and it's now going fast enough
> to be blowing another 10-12% of the CPU time sending tlb flushes to
> other CPUs....
> 
> One thing I did notice, even with the single-AG-at-a-time run, is
> that the system time is *significantly* reduced with this patch,
> even though it doesn't change performance.
> 
> ie unpatched:
> 
> 	unpatched	patched
> runtime   0m58s		  1m2s
> systime   4m55s		  1m1s
> 
> So not spinning when there are read holders is a major win even
> when there are few threads contending on read/write.
> 
> FWIW, the rwsems in the struct xfs_inode are often heavily
> read/write contended, so there are lots of IO related workloads that
> are going to regress on XFS without this optimisation...
> 
> Anyway, consider the patch:
> 
> Tested-by: Dave Chinner <dchinner@redhat.com>

Hi Dave,

Thanks for testing. I'll update the patch with an actual changelog.


