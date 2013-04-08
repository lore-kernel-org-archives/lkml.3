Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935356Ab3DHRKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:10:40 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:25280 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934756Ab3DHRKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:10:37 -0400
Date: Mon, 8 Apr 2013 19:10:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] sparc: Use generic idle loop
Message-ID: <20130408171035.GA27264@merkur.ravnborg.org>
References: <20130321214930.752934102@linutronix.de> <20130329161905.GC6201@merkur.ravnborg.org> <20130329202926.GA9484@merkur.ravnborg.org> <51592EF1.4090302@linux.vnet.ibm.com> <20130401090620.GA24861@merkur.ravnborg.org> <5162B92E.6020703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162B92E.6020703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -52,17 +52,12 @@
> > 
> >  #include "kstack.h"
> > 
> > -static void sparc64_yield(int cpu)
> > +/* Idle loop support on sparc64. */
> > +void arch_cpu_idle(void)
> >  {
> >  	if (tlb_type != hypervisor) {
> >  		touch_nmi_watchdog();
> > -		return;
> > -	}
> > -
> > -	clear_thread_flag(TIF_POLLING_NRFLAG);
> > -	smp_mb__after_clear_bit();
> > -
> > -	while (!need_resched() && !cpu_is_offline(cpu)) {
> > +	} else {
> >  		unsigned long pstate;
> > 
> >  		/* Disable interrupts. */
> > @@ -73,7 +68,7 @@ static void sparc64_yield(int cpu)
> >  			: "=&r" (pstate)
> >  			: "i" (PSTATE_IE));
> > 
> > -		if (!need_resched() && !cpu_is_offline(cpu))
> > +		if (!need_resched() && !cpu_is_offline(smp_processor_id()))
> >  			sun4v_cpu_yield();
> > 
> >  		/* Re-enable interrupts. */
> > @@ -84,36 +79,16 @@ static void sparc64_yield(int cpu)
> >  			: "=&r" (pstate)
> >  			: "i" (PSTATE_IE));
> >  	}
> > -
> > -	set_thread_flag(TIF_POLLING_NRFLAG);
> > +	local_irq_enable();
> >  }
> 
> Nitpick: you can probably move the local_irq_enable() to the
> 'if' block, since the else block already has assembly code to enable
> the interrupts. But anyway its up to you.

I think not.
local_irq_disable writes 0 to the PIL register,
whereas the above code set the IE (Interrupt enable) bit to 0.

So the implementations differs - and I think there is a good
reason for being so.

But this is the part where I refer to that I am fooling around
in code that I do not understand.
I re-checked the SPARC V9 manual - but I did not within a few minutes
reading understand what is the difference between the twoo.

	Sam
