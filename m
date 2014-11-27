Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaLAQq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:46:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45025 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaLAQqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:46:55 -0500
Date: Thu, 27 Nov 2014 08:46:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST
 context
Message-ID: <20141127164649.GW5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141124205441.GW5050@linux.vnet.ibm.com>
 <CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
 <20141124213501.GX5050@linux.vnet.ibm.com>
 <20141124223407.GB8512@linux.vnet.ibm.com>
 <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
 <20141124225754.GY5050@linux.vnet.ibm.com>
 <20141124233101.GA2819@linux.vnet.ibm.com>
 <CALCETrV37kqC658AzBHZ5z_vH2b_1T821q5EfbMcS9Ecpj8EEw@mail.gmail.com>
 <20141124235058.GZ5050@linux.vnet.ibm.com>
 <5476CCBA.4000003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5476CCBA.4000003@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120116-8236-0000-0000-0000075AFB43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 03:03:22PM +0800, Lai Jiangshan wrote:
> 
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you, recorded!

> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 8749f43f3f05..fc0236992655 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -759,39 +759,71 @@ void rcu_irq_enter(void)
> >  /**
> >   * rcu_nmi_enter - inform RCU of entry to NMI context
> >   *
> > - * If the CPU was idle with dynamic ticks active, and there is no
> > - * irq handler running, this updates rdtp->dynticks_nmi to let the
> > - * RCU grace-period handling know that the CPU is active.
> > + * If the CPU was idle from RCU's viewpoint, update rdtp->dynticks and
> > + * rdtp->dynticks_nmi_nesting to let the RCU grace-period handling know
> > + * that the CPU is active.  This implementation permits nested NMIs, as
> > + * long as the nesting level does not overflow an int.  (You will probably
> > + * run out of stack space first.)
> >   */
> >  void rcu_nmi_enter(void)
> >  {
> >  	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
> > +	int incby = 2;
> >  
> > -	if (rdtp->dynticks_nmi_nesting == 0 &&
> > -	    (atomic_read(&rdtp->dynticks) & 0x1))
> > -		return;
> > -	rdtp->dynticks_nmi_nesting++;
> > -	smp_mb__before_atomic();  /* Force delay from prior write. */
> > -	atomic_inc(&rdtp->dynticks);
> > -	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
> > -	smp_mb__after_atomic();  /* See above. */
> > -	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> > +	/* Complain about underflow. */
> > +	WARN_ON_ONCE(rdtp->dynticks_nmi_nesting < 0);
> > +
> > +	/*
> > +	 * If idle from RCU viewpoint, atomically increment ->dynticks
> > +	 * to mark non-idle and increment ->dynticks_nmi_nesting by one.
> > +	 * Otherwise, increment ->dynticks_nmi_nesting by two.  This means
> > +	 * if ->dynticks_nmi_nesting is equal to one, we are guaranteed
> > +	 * to be in the outermost NMI handler that interrupted an RCU-idle
> > +	 * period (observation due to Andy Lutomirski).
> > +	 */
> > +	if (!(atomic_read(&rdtp->dynticks) & 0x1)) {
> > +		smp_mb__before_atomic();  /* Force delay from prior write. */
> > +		atomic_inc(&rdtp->dynticks);
> > +		/* atomic_inc() before later RCU read-side crit sects */
> > +		smp_mb__after_atomic();  /* See above. */
> > +		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> > +		incby = 1;
> > +	}
> > +	rdtp->dynticks_nmi_nesting += incby;
> 
> I prefer a "else" branch here.
> 
> 	if (!(atomic_read(&rdtp->dynticks) & 0x1)) {
> 		...
> 		WARN_ON_ONCE(rdtp->dynticks_nmi_nesting); /* paired with "rdtp->dynticks_nmi_nesting = 0" */
> 		rdtp->dynticks_nmi_nesting = 1;  /* paired with "if (rdtp->dynticks_nmi_nesting != 1) {" */
> 	} else {
> 		rdtp->dynticks_nmi_nesting += 2;
> 	}

I avoided this approach due to the extra line.

							Thanx, Paul

> > +	barrier();
> >  }
> >  
> >  /**
> >   * rcu_nmi_exit - inform RCU of exit from NMI context
> >   *
> > - * If the CPU was idle with dynamic ticks active, and there is no
> > - * irq handler running, this updates rdtp->dynticks_nmi to let the
> > - * RCU grace-period handling know that the CPU is no longer active.
> > + * If we are returning from the outermost NMI handler that interrupted an
> > + * RCU-idle period, update rdtp->dynticks and rdtp->dynticks_nmi_nesting
> > + * to let the RCU grace-period handling know that the CPU is back to
> > + * being RCU-idle.
> >   */
> >  void rcu_nmi_exit(void)
> >  {
> >  	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
> >  
> > -	if (rdtp->dynticks_nmi_nesting == 0 ||
> > -	    --rdtp->dynticks_nmi_nesting != 0)
> > +	/*
> > +	 * Check for ->dynticks_nmi_nesting underflow and bad ->dynticks.
> > +	 * (We are exiting an NMI handler, so RCU better be paying attention
> > +	 * to us!)
> > +	 */
> > +	WARN_ON_ONCE(rdtp->dynticks_nmi_nesting <= 0);
> > +	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> > +
> > +	/*
> > +	 * If the nesting level is not 1, the CPU wasn't RCU-idle, so
> > +	 * leave it in non-RCU-idle state.
> > +	 */
> > +	if (rdtp->dynticks_nmi_nesting != 1) {
> > +		rdtp->dynticks_nmi_nesting -= 2;
> >  		return;
> > +	}
> > +
> > +	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
> > +	rdtp->dynticks_nmi_nesting = 0;
> >  	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
> >  	smp_mb__before_atomic();  /* See above. */
> >  	atomic_inc(&rdtp->dynticks);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > .
> > 
> 

