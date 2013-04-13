Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3DMSSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:18:20 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41620 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3DMSSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:18:18 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 13 Apr 2013 11:18:00 -0700
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
Message-ID: <20130413181800.GA12096@leaf>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413063804.GV29861@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:38:04PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 12, 2013 at 04:54:02PM -0700, Josh Triplett wrote:
> > On Fri, Apr 12, 2013 at 04:19:13PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Systems with HZ=100 can have slow bootup times due to the default
> > > three-jiffy delays between quiescent-state forcing attempts.  This
> > > commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
> > > on the value of HZ.  However, this would break very large systems that
> > > require more time between quiescent-state forcing attempts.  This
> > > commit therefore also ups the default delay by one jiffy for each
> > > 256 CPUs that might be on the system (based off of nr_cpu_ids at
> > > runtime, -not- NR_CPUS at build time).
> > > 
> > > Reported-by: Paul Mackerras <paulus@au1.ibm.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Something seems very wrong if RCU regularly hits the fqs code during
> > boot; feels like there's some more straightforward solution we're
> > missing.  What causes these CPUs to fall under RCU's scrutiny during
> > boot yet not actually hit the RCU codepaths naturally?
> 
> The problem is that they are running HZ=100, so that RCU will often
> take 30-60 milliseconds per grace period.  At that point, you only
> need 16-30 grace periods to chew up a full second, so it is not all
> that hard to eat up the additional 8-12 seconds of boot time that
> they were seeing.  IIRC, UP boot was costing them 4 seconds.
> 
> For HZ=1000, this would translate to 800ms to 1.2s, which is nowhere
> near as annoying.

That raises two questions, though.  First, who calls synchronize_rcu()
repeatedly during boot, and could they call call_rcu() instead to avoid
blocking for an RCU grace period?  Second, why does RCU need 3-6 jiffies
to resolve a grace period during boot?  That suggests that RCU doesn't
actually resolve a grace period until the force-quiescent-state
machinery kicks in, meaning that the normal quiescent-state mechanism
didn't work.

> > Also, a comment below.
> > 
> > > --- a/kernel/rcutree.h
> > > +++ b/kernel/rcutree.h
> > > @@ -342,7 +342,17 @@ struct rcu_data {
> > >  #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
> > >  #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
> > >  
> > > -#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
> > > +#if HZ > 500
> > > +#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for jiffies_till_first_fqs */
> > > +#elif HZ > 250
> > > +#define RCU_JIFFIES_TILL_FORCE_QS	 2
> > > +#else
> > > +#define RCU_JIFFIES_TILL_FORCE_QS	 1
> > > +#endif
> > 
> > This seems like it really wants to use a duration calculated directly
> > from HZ; perhaps (HZ/100)?
> 
> Very possibly to the direct calculation, but HZ/100 would get 10 ticks
> delay at HZ=1000, which is too high -- the value of 3 ticks for HZ=1000
> works well.  But I could do something like this:
> 
> #define RCU_JIFFIES_TILL_FORCE_QS (((HZ + 199) / 300) + ((HZ + 199) / 300 ? 0 : 1))
> 
> Or maybe a bit better:
> 
> #define RCU_JTFQS_SE ((HZ + 199) / 300)
> #define RCU_JIFFIES_TILL_FORCE_QS (RCU_JTFQS_SE + (RCU_JTFQS_SE ? 0 : 1))
> 
> This would come reasonably close to the values shown above.  Would
> this work for you?

I'd argue that if you need something that complex, you should just
explicitly write it as a step function:

#define RCU_JIFFIES_TILL_FORCE_QS (1 + (HZ > 250) + (HZ > 500))

- Josh Triplett
