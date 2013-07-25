Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3GYNSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:18:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56156 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3GYNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:18:12 -0400
Date: Thu, 25 Jul 2013 06:17:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: spinlock lockup, rcu stalls etc.
Message-ID: <20130725131739.GG3889@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130723162835.GA20430@redhat.com>
 <20130724123312.GY21367@linux.vnet.ibm.com>
 <20130724230111.GA25446@linux.vnet.ibm.com>
 <CA+5PVA7W9TKCc+MNyo3n2VMn6L9UUh4ATjm-rDYZndF1yRdZGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7W9TKCc+MNyo3n2VMn6L9UUh4ATjm-rDYZndF1yRdZGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072513-7282-0000-0000-0000199FADC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 08:42:43AM -0400, Josh Boyer wrote:
> On Wed, Jul 24, 2013 at 7:01 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 24, 2013 at 05:33:12AM -0700, Paul E. McKenney wrote:
> >> On Tue, Jul 23, 2013 at 12:28:35PM -0400, Dave Jones wrote:
> >> > Woke up to a box that I could log into, but would hang as soon as I tried to
> >> > do any disk IO.  This is what hit the logs before that.
> >> >
> >> > [28853.503179] hrtimer: interrupt took 4847 ns
> >> > [28918.966734] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=6502 jiffies, g=655835, c=655834, q=0)
> >> > [28918.968079] INFO: Stall ended before state dump start
> >> > [28932.599607] BUG: spinlock lockup suspected on CPU#0, trinity-child2/6990
> >> > [28932.600419]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1
> >> > [28932.601597] CPU: 0 PID: 6990 Comm: trinity-child2 Not tainted 3.11.0-rc2+ #54
> >> > [28932.604385]  0000000088c64840 ffff88022a567eb0 ffffffff81701c14 ffff8801f6cd5500
> >> > [28932.605322]  ffff88022a567ed0 ffffffff81701cd4 ffffffff81c04640 0000000088c64840
> >> > [28932.606666] BUG: spinlock lockup suspected on CPU#2, trinity-child2/6764
> >> > [28932.606669]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1
> >> > [28932.606259]  ffff88022a567ef8 ffffffff81328e07 ffffffff81c04640 ffffffff81c04658
> >> > [28932.609238] Call Trace:
> >> > [28932.609545]  [<ffffffff81701c14>] dump_stack+0x4e/0x82
> >> > [28932.610167]  [<ffffffff81701cd4>] spin_dump+0x8c/0x91
> >> > [28932.610781]  [<ffffffff81328e07>] do_raw_spin_lock+0x67/0x130
> >> > [28932.611476]  [<ffffffff811f2a70>] ? fdatawait_one_bdev+0x20/0x20
> >> > [28932.612202]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
> >> > [28932.612866]  [<ffffffff811fe5fc>] ? iterate_bdevs+0x2c/0x120
> >> > [28932.613550]  [<ffffffff811fe5fc>] iterate_bdevs+0x2c/0x120
> >> > [28932.614213]  [<ffffffff811f2ce3>] sys_sync+0x63/0x90
> >>
> >> Lots and lots of concurrent sync() system calls.  But one actual sync()
> >> execution would serve any number of sync() requests, as long as each
> >> request was initiated prior to the start of the sync() execution.
> >> Would it make sense to enable concurrent sync() system calls to take
> >> advantage of each others' work?
> >
> > More specifically, something like the (untested) patch shown below?
> >
> >                                                         Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > fs: Make sync() satisfy many requests with one invocation
> >
> > Dave Jones reported RCU stalls, overly long hrtimer interrupts, and
> > amazingly long NMI handlers from a trinity-induced workload involving
> > lots of concurrent sync() calls (https://lkml.org/lkml/2013/7/23/369).
> > There are any number of things that one might do to make sync() behave
> > better under high levels of contention, but it is also the case that
> > multiple concurrent sync() system calls can be satisfied by a single
> > sys_sync() invocation.
> >
> > Given that this situation is reminiscent of rcu_barrier(), this commit
> > applies the rcu_barrier() approach to sys_sync().  This approach uses
> > a global mutex and a sequence counter.  The mutex is held across the
> > sync() operation, which eliminates contention between concurrent sync()
> > operations.  The counter is incremented at the beginning and end of
> > each sync() operation, so that it is odd while a sync() operation is in
> > progress and odd otherwise, just like sequence locks.
> 
> I think you mean "... and even otherwise..." above?

Indeed I do, fixed!  Good catch!

							Thanx, Paul

> > The code that used to be in sys_sync() is now in do_sync(), and sys_sync()
> > now handles the concurrency.  The sys_sync() function first takes a
> > snapshot of the counter, then acquires the mutex, and then takes another
> > snapshot of the counter.  If the values of the two snapshots indicate that
> > a full do_sync() executed during the mutex acquisition, the sys_sync()
> > function releases the mutex and returns ("Our work is done!").  Otherwise,
> > sys_sync() increments the counter, invokes do_sync(), and increments
> > the counter again.
> >
> > This approach allows a single call to do_sync() to satisfy an arbitrarily
> > large number of sync() system calls, which should eliminate issues due
> > to large numbers of concurrent invocations of the sync() system call.
> >
> > Reported-by: Dave Jones <davej@redhat.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> > diff --git a/fs/sync.c b/fs/sync.c
> > index 905f3f6..dcc2962 100644
> > --- a/fs/sync.c
> > +++ b/fs/sync.c
> > @@ -99,7 +99,7 @@ static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
> >   * just write metadata (such as inodes or bitmaps) to block device page cache
> >   * and do not sync it on their own in ->sync_fs().
> >   */
> > -SYSCALL_DEFINE0(sync)
> > +static void do_sync(void)
> >  {
> >         int nowait = 0, wait = 1;
> >
> > @@ -111,6 +111,47 @@ SYSCALL_DEFINE0(sync)
> >         iterate_bdevs(fdatawait_one_bdev, NULL);
> >         if (unlikely(laptop_mode))
> >                 laptop_sync_completion();
> > +       return;
> > +}
> > +
> > +static DEFINE_MUTEX(sync_mutex);       /* One do_sync() at a time. */
> > +static unsigned long sync_seq;         /* Many sync()s from one do_sync(). */
> > +                                       /*  Overflow harmless, extra wait. */
> > +
> > +/*
> > + * Only allow one task to do sync() at a time, and further allow
> > + * concurrent sync() calls to be satisfied by a single do_sync()
> > + * invocation.
> > + */
> > +SYSCALL_DEFINE0(sync)
> > +{
> > +       unsigned long snap;
> > +       unsigned long snap_done;
> > +
> > +       snap = ACCESS_ONCE(sync_seq);
> > +       smp_mb();  /* Prevent above from bleeding into critical section. */
> > +       mutex_lock(&sync_mutex);
> > +       snap_done = ACCESS_ONCE(sync_seq);
> > +       if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
> > +               /*
> > +                * A full do_sync() executed between our two fetches from
> > +                * sync_seq, so our work is done!
> > +                */
> > +               smp_mb(); /* Order test with caller's subsequent code. */
> > +               mutex_unlock(&sync_mutex);
> > +               return 0;
> > +       }
> > +
> > +       /* Record the start of do_sync(). */
> > +       ACCESS_ONCE(sync_seq)++;
> > +       WARN_ON_ONCE((sync_seq & 0x1) != 1);
> > +
> > +       do_sync();
> > +
> > +       /* Record the end of do_sync(). */
> > +       ACCESS_ONCE(sync_seq)++;
> > +       WARN_ON_ONCE((sync_seq & 0x1) != 0);
> > +       mutex_unlock(&sync_mutex);
> >         return 0;
> >  }
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

