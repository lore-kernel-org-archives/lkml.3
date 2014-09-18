Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaIRSc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:32:29 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:62066 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:32:28 -0400
Date: Thu, 18 Sep 2014 14:32:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/2] sched: let the scheduler see CPU idle states
In-Reply-To: <20140918173733.GQ4723@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.11.1409181425080.8647@knanqh.ubzr>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <1409844730-12273-2-git-send-email-nicolas.pitre@linaro.org> <20140918173733.GQ4723@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Paul E. McKenney wrote:

> On Thu, Sep 04, 2014 at 11:32:09AM -0400, Nicolas Pitre wrote:
> > From: Daniel Lezcano <daniel.lezcano@linaro.org>
> > 
> > When the cpu enters idle, it stores the cpuidle state pointer in its
> > struct rq instance which in turn could be used to make a better decision
> > when balancing tasks.
> > 
> > As soon as the cpu exits its idle state, the struct rq reference is
> > cleared.
> > 
> > There are a couple of situations where the idle state pointer could be changed
> > while it is being consulted:
> > 
> > 1. For x86/acpi with dynamic c-states, when a laptop switches from battery
> >    to AC that could result on removing the deeper idle state. The acpi driver
> >    triggers:
> > 	'acpi_processor_cst_has_changed'
> > 		'cpuidle_pause_and_lock'
> > 			'cpuidle_uninstall_idle_handler'
> > 				'kick_all_cpus_sync'.
> > 
> > All cpus will exit their idle state and the pointed object will be set to
> > NULL.
> > 
> > 2. The cpuidle driver is unloaded. Logically that could happen but not
> > in practice because the drivers are always compiled in and 95% of them are
> > not coded to unregister themselves.  In any case, the unloading code must
> > call 'cpuidle_unregister_device', that calls 'cpuidle_pause_and_lock'
> > leading to 'kick_all_cpus_sync' as mentioned above.
> > 
> > A race can happen if we use the pointer and then one of these two scenarios
> > occurs at the same moment.
> > 
> > In order to be safe, the idle state pointer stored in the rq must be
> > used inside a rcu_read_lock section where we are protected with the
> > 'rcu_barrier' in the 'cpuidle_uninstall_idle_handler' function. The
> > idle_get_state() and idle_put_state() accessors should be used to that
> > effect.
> > 
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  drivers/cpuidle/cpuidle.c |  6 ++++++
> >  kernel/sched/idle.c       |  6 ++++++
> >  kernel/sched/sched.h      | 39 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 51 insertions(+)
> > 
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index ee9df5e3f5..530e3055a2 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -225,6 +225,12 @@ void cpuidle_uninstall_idle_handler(void)
> >  		initialized = 0;
> >  		kick_all_cpus_sync();
> >  	}
> > +
> > +	/*
> > +	 * Make sure external observers (such as the scheduler)
> > +	 * are done looking at pointed idle states.
> > +	 */
> > +	rcu_barrier();
> 
> Actually, all rcu_barrier() does is to make sure that all previously
> queued RCU callbacks have been invoked.  And given the current
> implementation, if there are no callbacks queued anywhere in the system,
> rcu_barrier() is an extended no-op.  "Has CPU 0 any callbacks?" "Nope!"
> "Has CPU 1 any callbacks?"  "Nope!" ... "Has CPU nr_cpu_ids-1 any
> callbacks?"  "Nope!"  "OK, done!"
> 
> This is all done with the current task looking at per-CPU data structures,
> with no interaction with the scheduler and with no need to actually make
> those other CPUs do anything.
> 
> So what is it that you really need to do here?

In short, we don't want the cpufreq data to go away (see the 2 scenarios 
above) while the scheduler is looking at it.  The scheduler uses the 
provided accessors (see patch 2/2) so we can put any protection 
mechanism we want in them.  A simple spinlock could do just as well 
which should be good enough.


Nicolas
