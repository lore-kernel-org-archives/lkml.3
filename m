Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3DMTxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 15:53:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42139 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3DMTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 15:53:47 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 13 Apr 2013 12:53:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130413195336.GA14799@leaf>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413193425.GY29861@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 12:34:25PM -0700, Paul E. McKenney wrote:
> On Sat, Apr 13, 2013 at 11:18:00AM -0700, Josh Triplett wrote:
> > On Fri, Apr 12, 2013 at 11:38:04PM -0700, Paul E. McKenney wrote:
> > > On Fri, Apr 12, 2013 at 04:54:02PM -0700, Josh Triplett wrote:
> > > > On Fri, Apr 12, 2013 at 04:19:13PM -0700, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > Systems with HZ=100 can have slow bootup times due to the default
> > > > > three-jiffy delays between quiescent-state forcing attempts.  This
> > > > > commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
> > > > > on the value of HZ.  However, this would break very large systems that
> > > > > require more time between quiescent-state forcing attempts.  This
> > > > > commit therefore also ups the default delay by one jiffy for each
> > > > > 256 CPUs that might be on the system (based off of nr_cpu_ids at
> > > > > runtime, -not- NR_CPUS at build time).
> > > > > 
> > > > > Reported-by: Paul Mackerras <paulus@au1.ibm.com>
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > Something seems very wrong if RCU regularly hits the fqs code during
> > > > boot; feels like there's some more straightforward solution we're
> > > > missing.  What causes these CPUs to fall under RCU's scrutiny during
> > > > boot yet not actually hit the RCU codepaths naturally?
> > > 
> > > The problem is that they are running HZ=100, so that RCU will often
> > > take 30-60 milliseconds per grace period.  At that point, you only
> > > need 16-30 grace periods to chew up a full second, so it is not all
> > > that hard to eat up the additional 8-12 seconds of boot time that
> > > they were seeing.  IIRC, UP boot was costing them 4 seconds.
> > > 
> > > For HZ=1000, this would translate to 800ms to 1.2s, which is nowhere
> > > near as annoying.
> > 
> > That raises two questions, though.  First, who calls synchronize_rcu()
> > repeatedly during boot, and could they call call_rcu() instead to avoid
> > blocking for an RCU grace period?  Second, why does RCU need 3-6 jiffies
> > to resolve a grace period during boot?  That suggests that RCU doesn't
> > actually resolve a grace period until the force-quiescent-state
> > machinery kicks in, meaning that the normal quiescent-state mechanism
> > didn't work.
> 
> Indeed, converting synchronize_rcu() to call_rcu() might also be
> helpful.  The reason that RCU often does not resolve grace periods until
> force_quiescent_state() is that it is often the case during boot that
> all but one CPU is idle.  RCU tries hard to avoid waking up idle CPUs,
> so it must scan them.  Scanning is relatively expensive, so there is
> reason to wait.

How are those CPUs going idle without first telling RCU that they're
quiesced?  Seems like, during boot at least, you want RCU to use its
idle==quiesced logic to proactively note continuously-quiescent states.
Ideally, you should not hit the FQS code at all during boot.

> One thing that could be done would be to scan immediately during boot,
> and then back off once boot has completed.  Of course, RCU has no idea
> when boot has completed, but one way to get this effect is to boot
> with rcutree.jiffies_till_first_fqs=0, and then use sysfs to set it
> to 3 once boot has completed.

What do you mean by "boot has completed" here?  The kernel's early
initialization, the kernel's initialization up to running /sbin/init, or
userspace initialization up through supporting user login?

In any case, I don't think it makes sense to do this with FQS.

- Josh Triplett
