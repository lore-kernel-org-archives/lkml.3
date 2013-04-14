Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3DNGKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:10:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54638 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3DNGKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:10:13 -0400
Date: Sat, 13 Apr 2013 23:10:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130414061000.GA16307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413220943.GB29861@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041406-7606-0000-0000-00000A61F306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 03:09:43PM -0700, Paul E. McKenney wrote:
> On Sat, Apr 13, 2013 at 12:53:36PM -0700, Josh Triplett wrote:
> > On Sat, Apr 13, 2013 at 12:34:25PM -0700, Paul E. McKenney wrote:
> > > On Sat, Apr 13, 2013 at 11:18:00AM -0700, Josh Triplett wrote:
> > > > On Fri, Apr 12, 2013 at 11:38:04PM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Apr 12, 2013 at 04:54:02PM -0700, Josh Triplett wrote:
> > > > > > On Fri, Apr 12, 2013 at 04:19:13PM -0700, Paul E. McKenney wrote:
> > > > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > > 
> > > > > > > Systems with HZ=100 can have slow bootup times due to the default
> > > > > > > three-jiffy delays between quiescent-state forcing attempts.  This
> > > > > > > commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
> > > > > > > on the value of HZ.  However, this would break very large systems that
> > > > > > > require more time between quiescent-state forcing attempts.  This
> > > > > > > commit therefore also ups the default delay by one jiffy for each
> > > > > > > 256 CPUs that might be on the system (based off of nr_cpu_ids at
> > > > > > > runtime, -not- NR_CPUS at build time).
> > > > > > > 
> > > > > > > Reported-by: Paul Mackerras <paulus@au1.ibm.com>
> > > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > 
> > > > > > Something seems very wrong if RCU regularly hits the fqs code during
> > > > > > boot; feels like there's some more straightforward solution we're
> > > > > > missing.  What causes these CPUs to fall under RCU's scrutiny during
> > > > > > boot yet not actually hit the RCU codepaths naturally?
> > > > > 
> > > > > The problem is that they are running HZ=100, so that RCU will often
> > > > > take 30-60 milliseconds per grace period.  At that point, you only
> > > > > need 16-30 grace periods to chew up a full second, so it is not all
> > > > > that hard to eat up the additional 8-12 seconds of boot time that
> > > > > they were seeing.  IIRC, UP boot was costing them 4 seconds.
> > > > > 
> > > > > For HZ=1000, this would translate to 800ms to 1.2s, which is nowhere
> > > > > near as annoying.
> > > > 
> > > > That raises two questions, though.  First, who calls synchronize_rcu()
> > > > repeatedly during boot, and could they call call_rcu() instead to avoid
> > > > blocking for an RCU grace period?  Second, why does RCU need 3-6 jiffies
> > > > to resolve a grace period during boot?  That suggests that RCU doesn't
> > > > actually resolve a grace period until the force-quiescent-state
> > > > machinery kicks in, meaning that the normal quiescent-state mechanism
> > > > didn't work.
> > > 
> > > Indeed, converting synchronize_rcu() to call_rcu() might also be
> > > helpful.  The reason that RCU often does not resolve grace periods until
> > > force_quiescent_state() is that it is often the case during boot that
> > > all but one CPU is idle.  RCU tries hard to avoid waking up idle CPUs,
> > > so it must scan them.  Scanning is relatively expensive, so there is
> > > reason to wait.
> > 
> > How are those CPUs going idle without first telling RCU that they're
> > quiesced?  Seems like, during boot at least, you want RCU to use its
> > idle==quiesced logic to proactively note continuously-quiescent states.
> > Ideally, you should not hit the FQS code at all during boot.
> 
> FQS is RCU's idle==quiesced logic.  ;-)
> 
> In theory, RCU could add logic at idle entry to report a quiescent state,
> in fact CONFIG_RCU_FAST_NO_HZ used to do exactly that.  In practice,
> this is not good for energy efficiency at runtime for a goodly number
> of workloads, which is why CONFIG_RCU_FAST_NO_HZ now relies on callback
> numbering and FQS.
> 
> I understand that at boot time, energy efficiency is best served by
> making boot go faster, but that means that something has to tell RCU
> when boot is complete.
> 
> > > One thing that could be done would be to scan immediately during boot,
> > > and then back off once boot has completed.  Of course, RCU has no idea
> > > when boot has completed, but one way to get this effect is to boot
> > > with rcutree.jiffies_till_first_fqs=0, and then use sysfs to set it
> > > to 3 once boot has completed.
> > 
> > What do you mean by "boot has completed" here?  The kernel's early
> > initialization, the kernel's initialization up to running /sbin/init, or
> > userspace initialization up through supporting user login?
> 
> That is exactly the question.  After all, if RCU is going to do something
> special during boot, it needs to know when boot ends.  People normally
> count boot as up to user login, but RCU currently has no way to know
> when this is, at least as far as I know.  Which is why I suggested that
> something tell RCU via sysfs.
> 
> Regardless, for the usual definition of "boot is complete", user space has
> to decide when boot is complete.  The kernel is out of the loop early on.
> 
> > In any case, I don't think it makes sense to do this with FQS.
> 
> OK, let's go through the possibilities I can imagine at the moment:
> 
> 1.	Force the scheduling-clock interrupt to remain on during
> 	boot.  This way, each CPU could tell RCU of its idle/non-idle
> 	state.  Of course, something then needs to tell the kernel
> 	when boot is over so that it can go back to energy-efficient
> 	mode.
> 
> 2.	Set rcutree.jiffies_till_first_fqs=0 at boot time, then when
> 	boot is complete, set it to 3 via sysfs, or to some magic number
> 	telling RCU to recompute the default.  This has the virtue of
> 	allowing different userspaces to handle this differently.
> 
> 3.	Take a half-step by having RCU register a callback during the
> 	latest phase of kernel-visible boot.  I am under the impression
> 	that this is a relatively small fraction of boot, so it would
> 	be sub-optimal.
> 
> 4.	Make CPUs announce quiescence on each entry to idle.  This
> 	covers the transition to idle, but when a given CPU stays idle
> 	for more than one grace period, RCU has to do something to verify
> 	that the CPU remains idle.  Right now, that is FQS's job --
> 	it cycles through the dyntick-idle structures of all CPUs that
> 	have not already announced quiescence.
> 
> 5.	Make CPUs IPI RCU's grace-period kthread on each transition
> 	to and from idle.  I might be missing something, but given the
> 	cost and disuptiveness of IPIs, this does not seem to me to be
> 	a strategy to win.
> 
> 6.	IPI the CPUs to see if they are still idle.  This would defeat
> 	energy efficiency.  Of course, RCU could take this approach
> 	only during boot, but it is cheaper and faster to just check
> 	each CPU's rcu_dynticks structure -- which is what FQS does.
> 
> 7.	Treat all normal grace periods as expedited grace periods, but
> 	only during boot.  It is fairly easy for RCU to do this, but
> 	again, something has to tell RCU when boot is complete.
> 
> 8.	Your idea here.  Plus more of mine as I remember them.  ;-)
> 
> So, what am I missing?

Hmmm...  I suppose I could have RCU define boot as being (say) the ten
seconds following the early_inits.  That is crude enough that it might
actually work reasonably well.

							Thanx, Paul

