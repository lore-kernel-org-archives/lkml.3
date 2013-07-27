Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3G0L0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 07:26:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41278 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3G0L0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 07:26:46 -0400
Date: Sat, 27 Jul 2013 04:26:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, hch@lst.de,
        jack@suse.cz, curtw@google.com, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC fs] v2 Make sync() satisfy many requests with one
 invocation
Message-ID: <20130727112628.GE26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726232852.GA15147@linux.vnet.ibm.com>
 <20130727025703.GF21982@dastard>
 <20130727040524.GC26694@linux.vnet.ibm.com>
 <20130727062101.GG21982@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130727062101.GG21982@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072711-5518-0000-0000-000010A994A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 04:21:01PM +1000, Dave Chinner wrote:
> On Fri, Jul 26, 2013 at 09:05:24PM -0700, Paul E. McKenney wrote:
> > On Sat, Jul 27, 2013 at 12:57:03PM +1000, Dave Chinner wrote:
> > > On Fri, Jul 26, 2013 at 04:28:52PM -0700, Paul E. McKenney wrote:
> > > > Dave Jones reported RCU stalls, overly long hrtimer interrupts, and
> > > > amazingly long NMI handlers from a trinity-induced workload involving
> > > > lots of concurrent sync() calls (https://lkml.org/lkml/2013/7/23/369).
> > > > There are any number of things that one might do to make sync() behave
> > > > better under high levels of contention, but it is also the case that
> > > > multiple concurrent sync() system calls can be satisfied by a single
> > > > sys_sync() invocation.
> > > > 
> > > > Given that this situation is reminiscent of rcu_barrier(), this commit
> > > > applies the rcu_barrier() approach to sys_sync().  This approach uses
> > > > a global mutex and a sequence counter.  The mutex is held across the
> > > > sync() operation, which eliminates contention between concurrent sync()
> > > > operations.
> > > >
> > > > The counter is incremented at the beginning and end of
> > > > each sync() operation, so that it is odd while a sync() operation is in
> > > > progress and even otherwise, just like sequence locks.
> > > > 
> > > > The code that used to be in sys_sync() is now in do_sync(), and sys_sync()
> > > > now handles the concurrency.  The sys_sync() function first takes a
> > > > snapshot of the counter, then acquires the mutex, and then takes another
> > > > snapshot of the counter.  If the values of the two snapshots indicate that
> > > > a full do_sync() executed during the mutex acquisition, the sys_sync()
> > > > function releases the mutex and returns ("Our work is done!").  Otherwise,
> > > > sys_sync() increments the counter, invokes do_sync(), and increments
> > > > the counter again.
> > > > 
> > > > This approach allows a single call to do_sync() to satisfy an arbitrarily
> > > > large number of sync() system calls, which should eliminate issues due
> > > > to large numbers of concurrent invocations of the sync() system call.
> > > 
> > > This is not addressing the problem that is causing issues during
> > > sync. Indeed, it only puts a bandaid over the currently observed
> > > trigger.
> > > 
> > > Indeed, i suspect that this will significantly slow down concurrent
> > > sync operations, as it serialised sync across all superblocks rather
> > > than serialising per-superblock like is currently done. Indeed, that
> > > per-superblock serialisation is where all the lock contention
> > > problems are. And it's not sync alone that causes the contention
> > > problems - it has to be combined with other concurrent workloads
> > > that add or remove inodes from the inode cache at tha same time.
> > 
> > Seems like something along the lines of wakeup_flusher_threads()
> > currently at the start of sys_sync() would address this.
> 
> That's the first thing sync() currently does, but it doesn't solve
> the problem because that only triggers WB_SYNC_NONE writeback. ie.
> it's not data integrity writeback, so if there's any contention it
> will skip pages and inodes. So we still need sync to dispatch IO.
> 
> Further, it requires scheduling of the work before anything will be
> done, and so if you are CPU loaded then there's a good chance that
> the flusher thread doesn't get to a CPU until sync actually queues
> the sync work to it and then waits for completion on it...

I could address these fairly straightforwardly, but I will hold off
for a bit to see what you come up with.

> > > I have patches to address that by removing the source
> > > of the lock contention completely, and not just for the sys_sync
> > > trigger. Those patches make the problems with concurrent
> > > sys_sync operation go away completely for me, not to mention improve
> > > performance for 8+ thread metadata workloads on XFS significantly.
> > > 
> > > IOWs, I don't see that concurrent sys_sync operation is a problem at
> > > all, and it is actively desirable for systems that have multiple
> > > busy filesystems as it allows concurrent dispatch of IO across those
> > > multiple filesystems. Serialising all sys_sync work might stop the
> > > contention problems, but it will also slow down concurrent sync
> > > operations on busy systems as it only allows one thread to dispatch
> > > and wait for IO at a time.
> > > 
> > > So, let's not slap a bandaid over a symptom - let's address the
> > > cause of the lock contention properly....
> > 
> > Hmmm...
> > 
> > Could you please send your patches over to Dave Jones right now?  I am
> > getting quite tired of getting RCU CPU stall warning complaints from
> > him that turn out to be due to highly contended sync() system calls.
> 
> Then ignore them until the code is ready - it'll be 3.12 before the
> fixes are merged, anyway, because the lock contention fix requires
> infrastructure that is currently in mmotm that is queued for 3.12
> (i.e. the per-node list infrastructure) to fix a whole bunch of
> other, more critical VFS lock contention problems. Seeing as a new
> mmotm went out last week, I should have the patches ready for review
> early next week.
> 
> FWIW, we (as in XFS filesystem testers) regularly run tests that
> have hundreds of concurrent sys_sync() calls running at the same
> time. e.g. xfstests::xfs/297 runs a 1000 fsstress processes while
> freezing and unfreezing the filesystem, and that usually shows
> hundreds of threads running sys_sync concurrently after a short
> amount of runtime. So it's pretty clear that what Dave is seeing
> is not necessarily representative of what happens when there ar lots
> of sys_sync() calls run concurrently.

So Dave might be finding an additional problem.  ;-)

> BTW, concurrent syncfs() calls are going to have exactly the same
> problem as concurrent sync() calls, as is any other operation that
> results in a walk of the per-superblock inodes list.

Yep!  Your upcoming patch addresses these as well?

							Thanx, Paul

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

