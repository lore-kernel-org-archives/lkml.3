Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3E1KHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:07:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54100 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3E1KHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:07:47 -0400
Date: Tue, 28 May 2013 12:07:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130528100742.GA11088@gmail.com>
References: <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130515092055.GB7027@gmail.com>
 <20130515154457.GJ4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515154457.GJ4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, May 15, 2013 at 11:20:55AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > rcu: Fix comparison sense in rcu_needs_cpu()
> > > 
> > > Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
> > > callbacks) introduced a bug that can result in excessively long grace
> > > periods.  This bug reverse the senes of the "if" statement checking
> > > for lazy callbacks, so that RCU takes a lazy approach when there are
> > > in fact non-lazy callbacks.  This can result in excessive boot, suspend,
> > > and resume times.
> > > 
> > > This commit therefore fixes the sense of this "if" statement.
> > > 
> > > Reported-by: Borislav Petkov <bp@alien8.de>
> > > Reported-by: Bj?rn Mork <bjorn@mork.no>
> > > Reported-by: Joerg Roedel <joro@8bytes.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > > index 170814d..6d939a6 100644
> > > --- a/kernel/rcutree_plugin.h
> > > +++ b/kernel/rcutree_plugin.h
> > > @@ -1667,7 +1667,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
> > >  	rdtp->last_accelerate = jiffies;
> > >  
> > >  	/* Request timer delay depending on laziness, and round. */
> > > -	if (rdtp->all_lazy) {
> > > +	if (!rdtp->all_lazy) {
> > >  		*dj = round_up(rcu_idle_gp_delay + jiffies,
> > >  			       rcu_idle_gp_delay) - jiffies;
> > 
> > Neat - could this explain sporadic long (but not infinite) boot times with 
> > NOHZ_FULL?
> > 
> > We changed HZ to be at least 1 Hz pretty recently, which might have worked 
> > around this bug.
> 
> Quite possibly...
> 
> Of course, I don't see the boot slowdowns in my testing.  :-/

They were pretty sporadic and only popped up (and down) during randconfig 
testing. Simple unrelated changes to the .config made them go away - 
heisenbugs.

Thanks,

	Ingo
