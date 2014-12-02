Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaLBSKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:10:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51936 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaLBSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:10:00 -0500
Date: Tue, 2 Dec 2014 10:09:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202180947.GA27959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <20141201230813.GE25340@linux.vnet.ibm.com>
 <547dec29.c71f8c0a.33d1.11d9@mx.google.com>
 <20141202170407.GK25340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141202170407.GK25340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120218-0021-0000-0000-000006985F24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:04:07AM -0800, Paul E. McKenney wrote:
> On Tue, Dec 02, 2014 at 02:43:17PM -0200, Dâniel Fraga wrote:
> > On Mon, 1 Dec 2014 15:08:13 -0800
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Well, this turned out to be way simpler than I expected.  Passes
> > > light rcutorture testing.  Sometimes you get lucky...
> > 
> > 	Linus, Paul and others, I finally got a call trace with
> > only CONFIG_TREE_PREEMPT_RCU *disabled* using Paul's patch (to trigger 
> > it I compiled PHP with make -j8).
> 
> Is it harder to reproduce with CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n?
> 
> If it is a -lot- harder to reproduce, it might be worth bisecting among
> the RCU read-side critical sections.  If making a few of them be
> non-preemptible greatly reduces the probability of the bug occuring,
> that might provide a clue about root cause.
> 
> On the other hand, if it is just a little harder to reproduce, this
> RCU read-side bisection would likely be an exercise in futility.

To Linus's point, I guess I could look at the RCU CPU stall warning.  ;-)

Summary:  Not seeing something that would loop for 21 seconds.
Dâniel, if you let this run, does it hit a second RCU CPU stall
warning, or does it just lock up?

Details:

First, what would we be looking for?  We know that with CONFIG_PREEMPT=n,
things work, or at least that the failure rate is quite low.
With CONFIG_PREEMPT=y, with or without CONFIG_TREE_PREEMPT_RCU=y,
things can break.  This is backwards of the usual behavior: Normally
CONFIG_PREEMPT=y kernels are a bit less prone to RCU CPU stall warnings,
at least assuming that the kernel spends a relatively small fraction of
its time in RCU read-side critical sections.

So, how could this be?

1.	Someone forgot an rcu_read_unlock() on one of the exit paths from
	some RCU read-side critical section somewhere.  This seems unlikely,
	but either CONFIG_PROVE_RCU=y or CONFIG_PREEMPT_DEBUG=y should
	catch it.

2.	Someone forgot a preempt_enable() on one of the exit paths from
	some preempt-disable region somewhere.  This also seems a bit
	unlikely, but CONFIG_PREEMPT_DEBUG=y should catch it.

3.	Preemption exposes a race condition that is extremely unlikely
	for CONFIG_PREEMPT=n.

Of course, it wouldn't hurt for someone who knows mm better than I to
check my work.

> > Dec  2 14:24:39 tux kernel: [ 8475.941616] conftest[9730]: segfault at 0 ip 0000000000400640 sp 00007fffa67ab300 error 4 in conftest[400000+1000]
> > Dec  2 14:24:40 tux kernel: [ 8476.104725] conftest[9753]: segfault at 0 ip 00007f6863024906 sp 00007fff0e31cc48 error 4 in libc-2.19.so[7f6862efe000+1a1000]
> > Dec  2 14:25:54 tux kernel: [ 8550.791697] INFO: rcu_sched detected stalls on CPUs/tasks: { 4} (detected by 0, t=60002 jiffies, g=112854, c=112853, q=0)

Note that the patch I gave to Dâniel provides only rcu_sched, as opposed
to the usual CONFIG_PREEMPT=y rcu_preempt and rcu_sched.  This is expected
behavior for CONFIG_TREE_RCU=y/CONFIG_TREE_PREEMPT_RCU=n.

> > Dec  2 14:25:54 tux kernel: [ 8550.791702] Task dump for CPU 4:
> > Dec  2 14:25:54 tux kernel: [ 8550.791703] cc1             R  running task        0 14344  14340 0x00080008
> > Dec  2 14:25:54 tux kernel: [ 8550.791706]  000000001bcebcd8 ffff880100000003 ffffffff810cb7f1 ffff88021f5f5c00
> > Dec  2 14:25:54 tux kernel: [ 8550.791708]  ffff88011bcebfd8 ffff88011bcebce8 ffffffff811fb970 ffff8802149a2a00
> > Dec  2 14:25:54 tux kernel: [ 8550.791710]  ffff8802149a2cc8 ffff88011bcebd28 ffffffff8103e979 ffff88020ed01398
> > Dec  2 14:25:54 tux kernel: [ 8550.791712] Call Trace:
> > Dec  2 14:25:54 tux kernel: [ 8550.791718]  [<ffffffff810cb7f1>] ? release_pages+0xa1/0x1e0

This does have a loop whose length is controlled by the "nr" argument.

> > Dec  2 14:25:54 tux kernel: [ 8550.791722]  [<ffffffff811fb970>] ? cpumask_any_but+0x30/0x40

This one is inconsistent with the release_pages() called function.
Besides, its runtime is limited by the number of CPUs, so it shouldn't
go on forever.

> > Dec  2 14:25:54 tux kernel: [ 8550.791725]  [<ffffffff8103e979>] ? flush_tlb_page+0x49/0xf0

This one should also have a sharply limited runtime.

> > Dec  2 14:25:54 tux kernel: [ 8550.791727]  [<ffffffff810cbe72>] ? lru_cache_add_active_or_unevictable+0x22/0x90

This one does acquire locks, so could in theory run for a long time.
Would require high contention on ->lru_lock, though.  A pvec can only
contain 14 pages, so the move loop should have limited runtime.

> > Dec  2 14:25:54 tux kernel: [ 8550.791731]  [<ffffffff810fc4c2>] ? alloc_pages_vma+0x72/0x130

This one contains a retry loop, at least if CONFIG_NUMA=y.  But I don't
see anything here that would block an RCU grace period.

> > Dec  2 14:25:54 tux kernel: [ 8550.791733]  [<ffffffff810cbe72>] ? lru_cache_add_active_or_unevictable+0x22/0x90

Duplicate address above, presumably one or both are due to stack-trace
confusion.

> > Dec  2 14:25:54 tux kernel: [ 8550.791735]  [<ffffffff810e5220>] ? handle_mm_fault+0x3a0/0xaf0

If this one had a problem, I would expect to see it in some of its called
functions.

> > Dec  2 14:25:54 tux kernel: [ 8550.791737]  [<ffffffff81039074>] ? __do_page_fault+0x224/0x4c0

Ditto.

> > Dec  2 14:25:54 tux kernel: [ 8550.791740]  [<ffffffff8110d54c>] ? new_sync_write+0x7c/0xb0

Ditto.

> > Dec  2 14:25:55 tux kernel: [ 8550.791743]  [<ffffffff8114765c>] ? fsnotify+0x27c/0x350

This one uses SRCU, not RCU.

> > Dec  2 14:25:55 tux kernel: [ 8550.791746]  [<ffffffff81087233>] ? rcu_eqs_enter+0x93/0xa0
> > Dec  2 14:25:55 tux kernel: [ 8550.791748]  [<ffffffff81087a5e>] ? rcu_user_enter+0xe/0x10

These two don't call fsnotify(), so I am assuming that the stack trace is
confused here.  Any chance of enabling frame pointers or some such to get
an accurate stack trace?  (And yes, this is one CPU tracing another live
CPU's stack, so some confusion is inherent, but probably not this far up
the stack.)

> > Dec  2 14:25:55 tux kernel: [ 8550.791749]  [<ffffffff8103938a>] ? do_page_fault+0x5a/0x70

Wrapper for __do_page_fault().  Yay!  Functions that actually call each
other in this stack trace!  ;-)

> > Dec  2 14:25:55 tux kernel: [ 8550.791752]  [<ffffffff8139d9d2>] ? page_fault+0x22/0x30

Not seeing much in the way of loops here.

							Thanx, Paul

> > 
> > 	If you need more info/testing, just ask.
> > 
> > -- 
> > Linux 3.17.0-dirty: Shuffling Zombie Juror
> > http://www.youtube.com/DanielFragaBR
> > http://exchangewar.info
> > Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
> > 

