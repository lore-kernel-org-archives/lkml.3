Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750778AbaKVFxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 00:53:54 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:38469 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaKVFxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 00:53:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141122042056.GY5050@linux.vnet.ibm.com>
References: <cover.1416604491.git.luto@amacapital.net> <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
 <CALCETrXLq1y7e_dKFPgou-FKHB6Pu-r8+t-6Ds+8=va7anBWDA@mail.gmail.com>
 <20141121220704.GU5050@linux.vnet.ibm.com> <CALCETrXVRqZ2fJJNOWLFzhE7wQvWejXbw0OUpcm6rt_UdFP6CA@mail.gmail.com>
 <20141121225508.GV5050@linux.vnet.ibm.com> <CALCETrXgd=5+RFugdi4CdCOzULK8u+ku-EQaJvY6JhXAMEW7rQ@mail.gmail.com>
 <20141121233834.GW5050@linux.vnet.ibm.com> <CALCETrVNnDEcVu_BteA2gVBeRB7zOsQmrA6JCrE8ez4U=vc0MQ@mail.gmail.com>
 <20141122042056.GY5050@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 21:53:29 -0800
Message-ID: <CALCETrXSY9JpW3uE6H8WYk81sg56qasA2aqmjMPsq5dOtzso=g@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:20 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Nov 21, 2014 at 06:00:14PM -0800, Andy Lutomirski wrote:
>> On Fri, Nov 21, 2014 at 3:38 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Fri, Nov 21, 2014 at 03:06:48PM -0800, Andy Lutomirski wrote:
>> >> On Fri, Nov 21, 2014 at 2:55 PM, Paul E. McKenney
>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >> > On Fri, Nov 21, 2014 at 02:19:17PM -0800, Andy Lutomirski wrote:
>> >> >> On Fri, Nov 21, 2014 at 2:07 PM, Paul E. McKenney
>> >> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >> >> > On Fri, Nov 21, 2014 at 01:32:50PM -0800, Andy Lutomirski wrote:
>> >> >> >> On Fri, Nov 21, 2014 at 1:26 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> >> >> >> > We currently pretend that IST context is like standard exception
>> >> >> >> > context, but this is incorrect.  IST entries from userspace are like
>> >> >> >> > standard exceptions except that they use per-cpu stacks, so they are
>> >> >> >> > atomic.  IST entries from kernel space are like NMIs from RCU's
>> >> >> >> > perspective -- they are not quiescent states even if they
>> >> >> >> > interrupted the kernel during a quiescent state.
>> >> >> >> >
>> >> >> >> > Add and use ist_enter and ist_exit to track IST context.  Even
>> >> >> >> > though x86_32 has no IST stacks, we track these interrupts the same
>> >> >> >> > way.
>> >> >> >>
>> >> >> >> I should add:
>> >> >> >>
>> >> >> >> I have no idea why RCU read-side critical sections are safe inside
>> >> >> >> __do_page_fault today.  It's guarded by exception_enter(), but that
>> >> >> >> doesn't do anything if context tracking is off, and context tracking
>> >> >> >> is usually off. What am I missing here?
>> >> >> >
>> >> >> > Ah!  There are three cases:
>> >> >> >
>> >> >> > 1.      Context tracking is off on a non-idle CPU.  In this case, RCU is
>> >> >> >         still paying attention to CPUs running in both userspace and in
>> >> >> >         the kernel.  So if a page fault happens, RCU will be set up to
>> >> >> >         notice any RCU read-side critical sections.
>> >> >> >
>> >> >> > 2.      Context tracking is on on a non-idle CPU.  In this case, RCU
>> >> >> >         might well be ignoring userspace execution: NO_HZ_FULL and
>> >> >> >         all that.  However, as you pointed out, in this case the
>> >> >> >         context-tracking code lets RCU know that we have entered the
>> >> >> >         kernel, which means that RCU will again be paying attention to
>> >> >> >         RCU read-side critical sections.
>> >> >> >
>> >> >> > 3.      The CPU is idle.  In this case, RCU is ignoring the CPU, so
>> >> >> >         if we take a page fault when context tracking is off, life
>> >> >> >         will be hard.  But the kernel is not supposed to take page
>> >> >> >         faults in the idle loop, so this is not a problem.
>> >> >>
>> >> >> I guess so, as long as there are really no page faults in the idle loop.
>> >> >
>> >> > As far as I know, there are not.  If there are, someone needs to let
>> >> > me know!  ;-)
>> >> >
>> >> >> There are, however, machine checks in the idle loop, and maybe kprobes
>> >> >> (haven't checked), so I think this patch might fix real bugs.
>> >> >
>> >> > If you can get ISTs from the idle loop, then the patch is needed.
>> >> >
>> >> >> > Just out of curiosity...  Can an NMI occur in IST context?  If it can,
>> >> >> > I need to make rcu_nmi_enter() and rcu_nmi_exit() deal properly with
>> >> >> > nested calls.
>> >> >>
>> >> >> Yes, and vice versa.  That code looked like it handled nesting
>> >> >> correctly, but I wasn't entirely sure.
>> >> >
>> >> > It currently does not, please see below patch.  Are you able to test
>> >> > nesting?  It would be really cool if you could do so -- I have no
>> >> > way to test this patch.
>> >>
>> >> I can try.  It's sort of easy -- I'll put an int3 into do_nmi and add
>> >> a fixup to avoid crashing.
>> >>
>> >> What should I look for?  Should I try to force full nohz on and assert
>> >> something?  I don't really know how to make full nohz work.
>> >
>> > You should look for the WARN_ON_ONCE() calls in rcu_nmi_enter() and
>> > rcu_nmi_exit() to fire.
>>
>> No warning with or without your patch, maybe because all of those
>> returns skip the labels.
>
> I will be guardedly optimistic and take this as a good sign.  ;-)
>
>> Also, an NMI can happen *during* rcu_nmi_enter or rcu_nmi_exit.  Is
>> that okay?  Should those dynticks_nmi_nesting++ things be local_inc
>> and local_dec_and_test?
>
> Yep, it is OK during rcu_nmi_enter() or rcu_nmi_exit().  The nested
> NMI will put the dynticks_nmi_nesting counter back where it was, so
> no chance of confusion.
>

That sounds like it's making a scary assumption about the code
generated by the ++ operator.

>> That dynticks_nmi_nesting thing seems scary to me.  Shouldn't the code
>> unconditionally increment dynticks_nmi_nesting in rcu_nmi_enter and
>> unconditionally decrement it in rcu_nmi_exit?
>
> You might be able to get that to work, but the reason it is not done
> that way is because we might get an NMI while not in dyntick-idle
> state.  In that case, it would be very bad to atomically increment
> rcu_dynticks, because that would tell RCU to ignore the CPU while it
> was in the NMI handler, which is the opposite of what we want.
>
> But what did you have in mind?

If you're willing to have rcu_nmi_enter return a value and pass it
back to rcu_nmi_exit, then it could be like:

int rcu_nmi_enter()
{
  if (rdtp->dynticks & 1) {
    return 0;
  } else {
    rdtp->dynticks++;
    return 1;
  }
}

but wrapped in a cmpxchg loop to make it atomic, and

void rcu_nmi_exit(int state)
{
  if (state)
   rdtp->dynticks++;
}

Otherwise, I think that there may need to be enough state somewhere so
that the outermost nested rcu_nmi_enter knows whether to increment
dynticks.  For example, dynticks_nmi_nesting could store the nesting
count * 2 - (1 if the outermost nested user needs to increment
dynticks).  Something like:

void rcu_nmi_enter(void)
{
  /* Be very careful -- this function may be called reentrently on the
same CPU. */
  atomically: increment dynticks if it's even.

  /* If an rcu_nmi_enter/rcu_nmi_exit pair happens here, then it will not change
   * the state. */

  local_inc(&dynticks_nmi_nesting, (we incremented dynticks ? 1 : 2));

  WARN_ON(we incremented dynticks and dynticks_nmi_nesting was nonzero);
}

void rcu_nmi_exit(void)
{
  WARN_ON(!(dynticks & 1));
  locally atomically: dynticks_nmi_nesting -= 2, unless
dynticks_nmi_nesting == 1, in which case set it to zero

  if (dynticks_nmi_nesting was 1)
    atomic_inc(&dynticks);
}

The invariant here is that, for a single unnested enter/exit, if
dynticks_nmi_nesting != 0, then dynticks is odd.  As a result, an
rcu_nmi_enter/rcu_nmi_exit pair at any time when dynticks_nmi_nesting
!= 0 *or* dynticks is odd will have no net effect, so the invariant,
in fact, holds for all invocations, nested or otherwise.

At least one of those conditions is true at all times during the
execution of outermost pair, starting with the first atomic operation
and ending with the final atomic_inc.  So they nest properly no matter
what else happens (unless, of course, someone else pokes dynticks in
the middle).

Thoughts?

>
>                                                         Thanx, Paul
>
>> --Andy
>>
>> >
>> >                                                         Thanx, Paul
>> >
>> >> >> Also, just to make sure: are we okay if rcu_nmi_enter() is called
>> >> >> before exception_enter if context tracking is on and we came directly
>> >> >> from userspace?
>> >> >
>> >> > If I understand correctly, this will result in context tracking invoking
>> >> > rcu_user_enter(), which will result in the rcu_dynticks counter having an
>> >> > odd value.  In that case, rcu_nmi_enter() will notice that RCU is already
>> >> > paying attention to this CPU via its check of atomic_read(&rdtp->dynticks)
>> >> > & 0x1), and will thus just return.  The matching rcu_nmi_exit() will
>> >> > notice that the nesting count is zero, and will also just return.
>> >> >
>> >> > Thus, everything works in that case.
>> >> >
>> >> > In contrast, if rcu_nmi_enter() was invoked from the idle loop, it
>> >> > would see that RCU is not paying attention to this CPU and that the
>> >> > NMI nesting depth (which rcu_nmi_enter() increments) used to be zero.
>> >> > It would then atomically increment rtdp->dynticks, forcing RCU to start
>> >> > paying attention to this CPU.  The matching rcu_nmi_exit() will see
>> >> > that the nesting count was non-zero, but became zero when decremented.
>> >> > This will cause rcu_nmi_exit() to atomically increment rtdp->dynticks,
>> >> > which will tell RCU to stop paying attention to this CPU.
>> >> >
>> >> >                                                         Thanx, Paul
>> >> >
>> >> > ------------------------------------------------------------------------
>> >> >
>> >> > rcu: Make rcu_nmi_enter() handle nesting
>> >> >
>> >> > Andy Lutomirski is introducing ISTs into x86, which from RCU's
>> >> > viewpoint are NMIs.  Because ISTs and NMIs can nest, rcu_nmi_enter()
>> >> > and rcu_nmi_exit() must now correctly handle nesting.  As luck would
>> >> > have it, rcu_nmi_exit() handles nesting but rcu_nmi_enter() does not.
>> >> > This patch therefore makes rcu_nmi_enter() handle nesting.
>> >>
>> >> Thanks.  Should I add this to v5 of my series?
>> >>
>> >> --Andy
>> >>
>> >> >
>> >> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> >> >
>> >> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
>> >> > index 8749f43f3f05..875421aff6e3 100644
>> >> > --- a/kernel/rcu/tree.c
>> >> > +++ b/kernel/rcu/tree.c
>> >> > @@ -770,7 +770,8 @@ void rcu_nmi_enter(void)
>> >> >         if (rdtp->dynticks_nmi_nesting == 0 &&
>> >> >             (atomic_read(&rdtp->dynticks) & 0x1))
>> >> >                 return;
>> >> > -       rdtp->dynticks_nmi_nesting++;
>> >> > +       if (rdtp->dynticks_nmi_nesting++ != 0)
>> >> > +               return; /* Nested NMI/IST/whatever. */
>> >> >         smp_mb__before_atomic();  /* Force delay from prior write. */
>> >> >         atomic_inc(&rdtp->dynticks);
>> >> >         /* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
>> >> >
>> >>
>> >>
>> >>
>> >> --
>> >> Andy Lutomirski
>> >> AMA Capital Management, LLC
>> >>
>> >
>>
>>
>>
>> --
>> Andy Lutomirski
>> AMA Capital Management, LLC
>>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
