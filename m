Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3CYKj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:39:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:46801 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3CYKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:39:26 -0400
Date: Mon, 25 Mar 2013 11:39:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 05/34] idle: Implement generic idle function
In-Reply-To: <20130323085647.GB3530@osiris>
Message-ID: <alpine.LFD.2.02.1303251138270.22263@ionos>
References: <20130321214930.752934102@linutronix.de> <20130321215233.646635455@linutronix.de> <20130323085647.GB3530@osiris>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Mar 2013, Heiko Carstens wrote:

> On Thu, Mar 21, 2013 at 09:53:00PM -0000, Thomas Gleixner wrote:
> > All idle functions in arch/* are more or less the same, plus minus a
> > few bugs and extra instrumentation, tickless support and other
> > optional items.
> > 
> > Implement a generic idle function which resembles the functionality
> > found in arch/. Provide weak arch_cpu_idle_* functions which can be
> > overridden by the architecture code if needed.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> [...]
> 
> > +static void cpu_idle_loop(void)
> > +{
> > +	while (1) {
> > +		tick_nohz_idle_enter();
> > +
> > +		while (!need_resched()) {
> > +			check_pgt_cache();
> > +			rmb();
> > +
> > +			if (cpu_is_offline(smp_processor_id()))
> > +				arch_cpu_idle_dead();
> > +
> > +			local_irq_disable();
> > +			arch_cpu_idle_enter();
> > +
> > +			if (cpu_idle_force_poll) {
> > +				cpu_idle_poll();
> > +			} else {
> > +				current_clr_polling();
> > +				if (!need_resched()) {
> > +					stop_critical_timings();
> > +					rcu_idle_enter();
> > +					arch_cpu_idle();
> > +					WARN_ON_ONCE(!irqs_disabled());
> 
> This should be WARN_ON_ONCE(irqs_disabled()), no?

Gah, yes.
 
> > +					rcu_idle_exit();
> > +					start_critical_timings();
> > +				} else {
> > +					local_irq_enable();
> > +				}
> > +				current_set_polling();
> > +			}
> > +			arch_cpu_idle_exit();
> > +		}
> > +		tick_nohz_idle_exit();
> 
> I was wondering why the scheduler doesn't complain when being called with
> irqs disabled. In fact tick_nohz_idle_exit() enables irqs unconditionally
> iff CONFIG_NO_HZ is set.

It should complain. I'll have a look again.
 
> > +		schedule_preempt_disabled();
> > +	}
> > +}
> > +
> > +void cpu_startup_entry(enum cpuhp_state state)
> > +{
> > +	current_set_polling();
> > +	arch_cpu_idle_prepare();
> > +	cpu_idle_loop();
> > +}
> > +#endif
> 
> 
