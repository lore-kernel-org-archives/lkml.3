Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKUWzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:55:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44894 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKUWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:55:14 -0500
Date: Fri, 21 Nov 2014 14:55:08 -0800
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
Message-ID: <20141121225508.GV5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1416604491.git.luto@amacapital.net>
 <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
 <CALCETrXLq1y7e_dKFPgou-FKHB6Pu-r8+t-6Ds+8=va7anBWDA@mail.gmail.com>
 <20141121220704.GU5050@linux.vnet.ibm.com>
 <CALCETrXVRqZ2fJJNOWLFzhE7wQvWejXbw0OUpcm6rt_UdFP6CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXVRqZ2fJJNOWLFzhE7wQvWejXbw0OUpcm6rt_UdFP6CA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112122-8236-0000-0000-0000071C802C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 02:19:17PM -0800, Andy Lutomirski wrote:
> On Fri, Nov 21, 2014 at 2:07 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Fri, Nov 21, 2014 at 01:32:50PM -0800, Andy Lutomirski wrote:
> >> On Fri, Nov 21, 2014 at 1:26 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> > We currently pretend that IST context is like standard exception
> >> > context, but this is incorrect.  IST entries from userspace are like
> >> > standard exceptions except that they use per-cpu stacks, so they are
> >> > atomic.  IST entries from kernel space are like NMIs from RCU's
> >> > perspective -- they are not quiescent states even if they
> >> > interrupted the kernel during a quiescent state.
> >> >
> >> > Add and use ist_enter and ist_exit to track IST context.  Even
> >> > though x86_32 has no IST stacks, we track these interrupts the same
> >> > way.
> >>
> >> I should add:
> >>
> >> I have no idea why RCU read-side critical sections are safe inside
> >> __do_page_fault today.  It's guarded by exception_enter(), but that
> >> doesn't do anything if context tracking is off, and context tracking
> >> is usually off. What am I missing here?
> >
> > Ah!  There are three cases:
> >
> > 1.      Context tracking is off on a non-idle CPU.  In this case, RCU is
> >         still paying attention to CPUs running in both userspace and in
> >         the kernel.  So if a page fault happens, RCU will be set up to
> >         notice any RCU read-side critical sections.
> >
> > 2.      Context tracking is on on a non-idle CPU.  In this case, RCU
> >         might well be ignoring userspace execution: NO_HZ_FULL and
> >         all that.  However, as you pointed out, in this case the
> >         context-tracking code lets RCU know that we have entered the
> >         kernel, which means that RCU will again be paying attention to
> >         RCU read-side critical sections.
> >
> > 3.      The CPU is idle.  In this case, RCU is ignoring the CPU, so
> >         if we take a page fault when context tracking is off, life
> >         will be hard.  But the kernel is not supposed to take page
> >         faults in the idle loop, so this is not a problem.
> 
> I guess so, as long as there are really no page faults in the idle loop.

As far as I know, there are not.  If there are, someone needs to let
me know!  ;-)

> There are, however, machine checks in the idle loop, and maybe kprobes
> (haven't checked), so I think this patch might fix real bugs.

If you can get ISTs from the idle loop, then the patch is needed.

> > Just out of curiosity...  Can an NMI occur in IST context?  If it can,
> > I need to make rcu_nmi_enter() and rcu_nmi_exit() deal properly with
> > nested calls.
> 
> Yes, and vice versa.  That code looked like it handled nesting
> correctly, but I wasn't entirely sure.

It currently does not, please see below patch.  Are you able to test
nesting?  It would be really cool if you could do so -- I have no
way to test this patch.

> Also, just to make sure: are we okay if rcu_nmi_enter() is called
> before exception_enter if context tracking is on and we came directly
> from userspace?

If I understand correctly, this will result in context tracking invoking
rcu_user_enter(), which will result in the rcu_dynticks counter having an
odd value.  In that case, rcu_nmi_enter() will notice that RCU is already
paying attention to this CPU via its check of atomic_read(&rdtp->dynticks)
& 0x1), and will thus just return.  The matching rcu_nmi_exit() will
notice that the nesting count is zero, and will also just return.

Thus, everything works in that case.

In contrast, if rcu_nmi_enter() was invoked from the idle loop, it
would see that RCU is not paying attention to this CPU and that the
NMI nesting depth (which rcu_nmi_enter() increments) used to be zero.
It would then atomically increment rtdp->dynticks, forcing RCU to start
paying attention to this CPU.  The matching rcu_nmi_exit() will see
that the nesting count was non-zero, but became zero when decremented.
This will cause rcu_nmi_exit() to atomically increment rtdp->dynticks,
which will tell RCU to stop paying attention to this CPU.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make rcu_nmi_enter() handle nesting

Andy Lutomirski is introducing ISTs into x86, which from RCU's
viewpoint are NMIs.  Because ISTs and NMIs can nest, rcu_nmi_enter()
and rcu_nmi_exit() must now correctly handle nesting.  As luck would
have it, rcu_nmi_exit() handles nesting but rcu_nmi_enter() does not.
This patch therefore makes rcu_nmi_enter() handle nesting.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8749f43f3f05..875421aff6e3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -770,7 +770,8 @@ void rcu_nmi_enter(void)
 	if (rdtp->dynticks_nmi_nesting == 0 &&
 	    (atomic_read(&rdtp->dynticks) & 0x1))
 		return;
-	rdtp->dynticks_nmi_nesting++;
+	if (rdtp->dynticks_nmi_nesting++ != 0)
+		return; /* Nested NMI/IST/whatever. */
 	smp_mb__before_atomic();  /* Force delay from prior write. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */

