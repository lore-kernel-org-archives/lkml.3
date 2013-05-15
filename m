Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab3EOPpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:45:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37951 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943Ab3EOPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:45:38 -0400
Date: Wed, 15 May 2013 08:44:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130515154457.GJ4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130515092055.GB7027@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515092055.GB7027@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051515-3620-0000-0000-000002802A3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:20:55AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > rcu: Fix comparison sense in rcu_needs_cpu()
> > 
> > Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
> > callbacks) introduced a bug that can result in excessively long grace
> > periods.  This bug reverse the senes of the "if" statement checking
> > for lazy callbacks, so that RCU takes a lazy approach when there are
> > in fact non-lazy callbacks.  This can result in excessive boot, suspend,
> > and resume times.
> > 
> > This commit therefore fixes the sense of this "if" statement.
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Reported-by: Bj?rn Mork <bjorn@mork.no>
> > Reported-by: Joerg Roedel <joro@8bytes.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 170814d..6d939a6 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -1667,7 +1667,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
> >  	rdtp->last_accelerate = jiffies;
> >  
> >  	/* Request timer delay depending on laziness, and round. */
> > -	if (rdtp->all_lazy) {
> > +	if (!rdtp->all_lazy) {
> >  		*dj = round_up(rcu_idle_gp_delay + jiffies,
> >  			       rcu_idle_gp_delay) - jiffies;
> 
> Neat - could this explain sporadic long (but not infinite) boot times with 
> NOHZ_FULL?
> 
> We changed HZ to be at least 1 Hz pretty recently, which might have worked 
> around this bug.

Quite possibly...

Of course, I don't see the boot slowdowns in my testing.  :-/

							Thanx, Paul

