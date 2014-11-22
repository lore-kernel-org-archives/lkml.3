Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbaKWGTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 01:19:23 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53895 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaKWGTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 01:19:21 -0500
Date: Sat, 22 Nov 2014 15:41:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST
 context
Message-ID: <20141122234157.GB5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
 <CALCETrXLq1y7e_dKFPgou-FKHB6Pu-r8+t-6Ds+8=va7anBWDA@mail.gmail.com>
 <20141121220704.GU5050@linux.vnet.ibm.com>
 <CALCETrXVRqZ2fJJNOWLFzhE7wQvWejXbw0OUpcm6rt_UdFP6CA@mail.gmail.com>
 <20141121225508.GV5050@linux.vnet.ibm.com>
 <CALCETrXgd=5+RFugdi4CdCOzULK8u+ku-EQaJvY6JhXAMEW7rQ@mail.gmail.com>
 <20141121233834.GW5050@linux.vnet.ibm.com>
 <CALCETrVNnDEcVu_BteA2gVBeRB7zOsQmrA6JCrE8ez4U=vc0MQ@mail.gmail.com>
 <20141122042056.GY5050@linux.vnet.ibm.com>
 <CALCETrXSY9JpW3uE6H8WYk81sg56qasA2aqmjMPsq5dOtzso=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXSY9JpW3uE6H8WYk81sg56qasA2aqmjMPsq5dOtzso=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112306-0025-0000-0000-0000064EB30B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:53:29PM -0800, Andy Lutomirski wrote:
> On Fri, Nov 21, 2014 at 8:20 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Fri, Nov 21, 2014 at 06:00:14PM -0800, Andy Lutomirski wrote:
> >> On Fri, Nov 21, 2014 at 3:38 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Fri, Nov 21, 2014 at 03:06:48PM -0800, Andy Lutomirski wrote:
> >> >> On Fri, Nov 21, 2014 at 2:55 PM, Paul E. McKenney
> >> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >> > On Fri, Nov 21, 2014 at 02:19:17PM -0800, Andy Lutomirski wrote:
> >> >> >> On Fri, Nov 21, 2014 at 2:07 PM, Paul E. McKenney
> >> >> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >> >> > On Fri, Nov 21, 2014 at 01:32:50PM -0800, Andy Lutomirski wrote:
> >> >> >> >> On Fri, Nov 21, 2014 at 1:26 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> >> >> >> > We currently pretend that IST context is like standard exception
> >> >> >> >> > context, but this is incorrect.  IST entries from userspace are like
> >> >> >> >> > standard exceptions except that they use per-cpu stacks, so they are
> >> >> >> >> > atomic.  IST entries from kernel space are like NMIs from RCU's
> >> >> >> >> > perspective -- they are not quiescent states even if they
> >> >> >> >> > interrupted the kernel during a quiescent state.
> >> >> >> >> >
> >> >> >> >> > Add and use ist_enter and ist_exit to track IST context.  Even
> >> >> >> >> > though x86_32 has no IST stacks, we track these interrupts the same
> >> >> >> >> > way.
> >> >> >> >>
> >> >> >> >> I should add:
> >> >> >> >>
> >> >> >> >> I have no idea why RCU read-side critical sections are safe inside
> >> >> >> >> __do_page_fault today.  It's guarded by exception_enter(), but that
> >> >> >> >> doesn't do anything if context tracking is off, and context tracking
> >> >> >> >> is usually off. What am I missing here?
> >> >> >> >
> >> >> >> > Ah!  There are three cases:
> >> >> >> >
> >> >> >> > 1.      Context tracking is off on a non-idle CPU.  In this case, RCU is
> >> >> >> >         still paying attention to CPUs running in both userspace and in
> >> >> >> >         the kernel.  So if a page fault happens, RCU will be set up to
> >> >> >> >         notice any RCU read-side critical sections.
> >> >> >> >
> >> >> >> > 2.      Context tracking is on on a non-idle CPU.  In this case, RCU
> >> >> >> >         might well be ignoring userspace execution: NO_HZ_FULL and
> >> >> >> >         all that.  However, as you pointed out, in this case the
> >> >> >> >         context-tracking code lets RCU know that we have entered the
> >> >> >> >         kernel, which means that RCU will again be paying attention to
> >> >> >> >         RCU read-side critical sections.
> >> >> >> >
> >> >> >> > 3.      The CPU is idle.  In this case, RCU is ignoring the CPU, so
> >> >> >> >         if we take a page fault when context tracking is off, life
> >> >> >> >         will be hard.  But the kernel is not supposed to take page
> >> >> >> >         faults in the idle loop, so this is not a problem.
> >> >> >>
> >> >> >> I guess so, as long as there are really no page faults in the idle loop.
> >> >> >
> >> >> > As far as I know, there are not.  If there are, someone needs to let
> >> >> > me know!  ;-)
> >> >> >
> >> >> >> There are, however, machine checks in the idle loop, and maybe kprobes
> >> >> >> (haven't checked), so I think this patch might fix real bugs.
> >> >> >
> >> >> > If you can get ISTs from the idle loop, then the patch is needed.
> >> >> >
> >> >> >> > Just out of curiosity...  Can an NMI occur in IST context?  If it can,
> >> >> >> > I need to make rcu_nmi_enter() and rcu_nmi_exit() deal properly with
> >> >> >> > nested calls.
> >> >> >>
> >> >> >> Yes, and vice versa.  That code looked like it handled nesting
> >> >> >> correctly, but I wasn't entirely sure.
> >> >> >
> >> >> > It currently does not, please see below patch.  Are you able to test
> >> >> > nesting?  It would be really cool if you could do so -- I have no
> >> >> > way to test this patch.
> >> >>
> >> >> I can try.  It's sort of easy -- I'll put an int3 into do_nmi and add
> >> >> a fixup to avoid crashing.
> >> >>
> >> >> What should I look for?  Should I try to force full nohz on and assert
> >> >> something?  I don't really know how to make full nohz work.
> >> >
> >> > You should look for the WARN_ON_ONCE() calls in rcu_nmi_enter() and
> >> > rcu_nmi_exit() to fire.
> >>
> >> No warning with or without your patch, maybe because all of those
> >> returns skip the labels.
> >
> > I will be guardedly optimistic and take this as a good sign.  ;-)
> >
> >> Also, an NMI can happen *during* rcu_nmi_enter or rcu_nmi_exit.  Is
> >> that okay?  Should those dynticks_nmi_nesting++ things be local_inc
> >> and local_dec_and_test?
> >
> > Yep, it is OK during rcu_nmi_enter() or rcu_nmi_exit().  The nested
> > NMI will put the dynticks_nmi_nesting counter back where it was, so
> > no chance of confusion.
> 
> That sounds like it's making a scary assumption about the code
> generated by the ++ operator.

Yeah, well, local_inc becomes the ++ operator on many systems.  ;-)

I could perhaps be convinced to use ACCESS_ONCE(), will give it some
thought.

> >> That dynticks_nmi_nesting thing seems scary to me.  Shouldn't the code
> >> unconditionally increment dynticks_nmi_nesting in rcu_nmi_enter and
> >> unconditionally decrement it in rcu_nmi_exit?
> >
> > You might be able to get that to work, but the reason it is not done
> > that way is because we might get an NMI while not in dyntick-idle
> > state.  In that case, it would be very bad to atomically increment
> > rcu_dynticks, because that would tell RCU to ignore the CPU while it
> > was in the NMI handler, which is the opposite of what we want.
> >
> > But what did you have in mind?
> 
> If you're willing to have rcu_nmi_enter return a value and pass it
> back to rcu_nmi_exit, then it could be like:
> 
> int rcu_nmi_enter()
> {
>   if (rdtp->dynticks & 1) {
>     return 0;
>   } else {
>     rdtp->dynticks++;
>     return 1;
>   }
> }
> 
> but wrapped in a cmpxchg loop to make it atomic, and
> 
> void rcu_nmi_exit(int state)
> {
>   if (state)
>    rdtp->dynticks++;
> }

Returning state sounds like a bad idea, if we can reasonably avoid it.

And I think I finally see what you are pointing out about my code: If
another NMI comes in between the time I increment ->dynticks_nmi_nesting
and the time I atomically increment ->dynticks, the nested NMI handler
will incorrectly believe that RCU is already paying attention to this CPU.
Which would indeed not be at all good, so good catch!!!

> Otherwise, I think that there may need to be enough state somewhere so
> that the outermost nested rcu_nmi_enter knows whether to increment
> dynticks.  For example, dynticks_nmi_nesting could store the nesting
> count * 2 - (1 if the outermost nested user needs to increment
> dynticks).  Something like:
> 
> void rcu_nmi_enter(void)
> {
>   /* Be very careful -- this function may be called reentrently on the
> same CPU. */
>   atomically: increment dynticks if it's even.
> 
>   /* If an rcu_nmi_enter/rcu_nmi_exit pair happens here, then it will not change
>    * the state. */
> 
>   local_inc(&dynticks_nmi_nesting, (we incremented dynticks ? 1 : 2));
> 
>   WARN_ON(we incremented dynticks and dynticks_nmi_nesting was nonzero);
> }
> 
> void rcu_nmi_exit(void)
> {
>   WARN_ON(!(dynticks & 1));
>   locally atomically: dynticks_nmi_nesting -= 2, unless
> dynticks_nmi_nesting == 1, in which case set it to zero
> 
>   if (dynticks_nmi_nesting was 1)
>     atomic_inc(&dynticks);
> }
> 
> The invariant here is that, for a single unnested enter/exit, if
> dynticks_nmi_nesting != 0, then dynticks is odd.  As a result, an
> rcu_nmi_enter/rcu_nmi_exit pair at any time when dynticks_nmi_nesting
> != 0 *or* dynticks is odd will have no net effect, so the invariant,
> in fact, holds for all invocations, nested or otherwise.
> 
> At least one of those conditions is true at all times during the
> execution of outermost pair, starting with the first atomic operation
> and ending with the final atomic_inc.  So they nest properly no matter
> what else happens (unless, of course, someone else pokes dynticks in
> the middle).
> 
> Thoughts?

Let's see...  The evenness of ->dynticks should be preserved by nested NMI
handlers, so the check and increment need not be atomic.  We don't have
any way (other than atomic operations) to do local atomic modifications
on all architectures, because we cannot mask NMIs.  (Yes, it can work
on x86, but this is common code that needs to work everywhere.)  On the
other hand, presumably NMIs are rare, so atomic modification of the NMI
nesting counter should be OK, at least if it proves absolutely necessary.
And I am thinking that a mechanical proof will be needed here.  :-/

But first, let me try generating the code and informally evaluating it:

	 1   struct rcu_dynticks {
	 2     long long dynticks_nesting;
	 3     int dynticks_nmi_nesting;
	 4     atomic_t dynticks;
	 5   };
	 6 
	 7   void rcu_nmi_enter(void)
	 8   {
	 9     struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
	10     int incby = 2;
	11 
	12     if (!(atomic_read(&rdtp->dynticks) & 0x1)) {
	13       smp_mb__before_atomic();
	14       atomic_inc(&rdtp->dynticks);
	15       smp_mb__after_atomic();
	16       WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
	17       incby = 1;
	18     }
	19     rdtp->dynticks_nmi_nesting += incby;
	20     barrier();
	21   }
	22 
	23   void rcu_nmi_exit(void)
	24   {
	25     struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
	26 
	27     WARN_ON_ONCE(!rdtp->dynticks_nmi_nesting);
	28     WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
	29     if (rdtp->dynticks_nmi_nesting != 1) {
	30       rdtp->dynticks_nmi_nesting -= 2;
	31       return;
	32     }
	33     rdtp->dynticks_nmi_nesting = 0;
	34     smp_mb__before_atomic();
	35     atomic_inc(&rdtp->dynticks);
	36     smp_mb__after_atomic();
	37     WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
	38   }

Line 9 picks up a pointer to this CPU's rcu_dynticks structure and line 10
assumes that we don't need to increment ->dynticks.

Line 12 checks to see if ->dynticks is even.  Note that this check is
stable: If there are nested NMIs, they will increment ->dynticks twice
or not at all, and either way preserves the evenness (to be proven, of
course, but that is the plan).  If ->dynticks is even, lines 13-15
atomically increment it, line 16 complains if still even, and line 17
says we will increment ->dynticks_nmi_nesting by only 1.

Either way, line 19 increments ->dynticks_nmi_nesting as needed and
line 20 keeps the compiler from getting too cute.

For rcu_nmi_exit(), line 25 again picks up this CPUs rcu_dynticks
structure.  Lines 27 and 28 complain bitterly if invariants are violated.
If line 29 finds that the value of ->dynticks_nmi_nesting is not 1,
then line 30 subtracts 2 from ->dynticks_nmi_nesting and line 31 returns.

Otherwise, line 33 sets ->dynticks_nmi_nesting to zero, lines 34-36
atomically increment ->dynticks with full ordering, and line 37
complains bitterly if ->dynticks is not even.

So, if an NMI occurs before rcu_nmi_enter's atomic increment, then the
nested NMI's rcu_nmi_enter() and rcu_nmi_exit() will think that they are
not nested, which is the correct thing for them to think in that case.
They will increment ->dynticks twice and restore ->dynticks_nmi_nesting
to zero (adding and then subtracting 1).  If the NMI happens after the
atomic increment, then the nested rcu_nmi_enter() and rcu_nmi_exit()
will leave ->dynticks alone, and will restore ->dynticks_nmi_nesting
to zero (adding and subtracting two again).  If the NMI happens after
the increment of ->dynticks_nmi_nesting, the nested NMI's rcu_nmi_enter()
and rcu_nmi_exit() will again restore ->dynticks_nmi_nesting, but this
time to one (again adding and subtracting two).

In rcu_nmi_exit(), ->dynticks_nmi_nesting of zero had better not happen,
one means we need to atomically increment ->dynticks, and other values
mean that we are partially or fully nested.  Reasoning proceeds as for
rcu_nmi_enter(), but in the opposite direction.

Whew!  That might even work.

But how about taking a different approach.  Assuming that there can
never be more than (say) 14 nesting NMI-like things, use the lower
four bits of ->dynticks to represent the NMI nesting and the upper
28 bits as the counter.  This of course requires modifying lots of
places in RCU that check the counter, but it is probably time to
abstract the check anyway.

This would allow my earlier attempted logic to work and (maybe) simplify
the reasoning a bit (and yes, the "magic" constants need macros):

	void rcu_nmi_enter(void)
	{
		struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
		int nesting = atomic_read(&rdtp->dynticks) & 0xf;
		int incby = 0x01;

		WARN_ON_ONCE(nexting == 0xf);
		if (nesting == 0) {
			if (atomic_read(&rdtp->dynticks) & 0x10)
				return;
			incby = 0x11;
		}
		smp_mb__before_atomic();
		atomic_add(&rdtp->dynticks, incby);
		smp_mb__after_atomic();
		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
	}

	void rcu_nmi_exit(void)
	{
		struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
		int nesting = atomic_read(&rdtp->dynticks) & 0xf;
		int incby = 0x0f;

		if (nesting == 0)
			return;
		if (nesting > 1)
			incby = -1;
		smp_mb__before_atomic();
		atomic_add(&rdtp->dynticks, incby);
		smp_mb__after_atomic();
		WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
	}

Over to you!  ;-)

							Thanx, Paul

