Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaLRTwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:52:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:56233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaLRTwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:52:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,602,1413270000"; 
   d="scan'208";a="626175776"
Date: Thu, 18 Dec 2014 11:52:39 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
Message-ID: <20141218115239.53d17e39@jacob-VirtualBox>
In-Reply-To: <DD415AA12F8FF042BF4EA69DF123C1478AF91730@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.11.1412181110110.17382@nanos>
	<54930EB1.9080309@linux.vnet.ibm.com>
	<DD415AA12F8FF042BF4EA69DF123C1478AF91730@ORSMSX101.amr.corp.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> 
> -----Original Message-----
> From: Preeti U Murthy [mailto:preeti@linux.vnet.ibm.com] 
> Sent: Thursday, December 18, 2014 9:28 AM
> To: Thomas Gleixner; Preeti Murthy; Pan, Jacob jun; Peter Zijlstra
> Cc: Viresh Kumar; Frederic Weisbecker; Wu, Fengguang; Frederic
> Weisbecker; LKML; LKP; Zhang, Rui Subject: Re: [PATCH]
> tick/powerclamp: Remove tick_nohz_idle abuse
> 
> Hi Thomas,
> 
> On 12/18/2014 04:21 PM, Thomas Gleixner wrote:
> > commit 4dbd27711cd9 "tick: export nohz tick idle symbols for module 
> > use" was merged via the thermal tree without an explicit ack from
> > the relevant maintainers.
> > 
> > The exports are abused by the intel powerclamp driver which
> > implements a fake idle state from a sched FIFO task. This causes
> > all kinds of wreckage in the NOHZ core code which rightfully
> > assumes that tick_nohz_idle_enter/exit() are only called from the
> > idle task itself.
> > 
> > Recent changes in the NOHZ core lead to a failure of the powerclamp 
> > driver and now people try to hack completely broken and backwards 
> > workarounds into the NOHZ core code. This is completely
> > unacceptable.
> > 
> > The real solution is to fix the powerclamp driver by rewriting it
> > with a sane concept, but that's beyond the scope of this.
> > 
> > So the only solution for now is to remove the calls into the core
> > NOHZ code from the powerclamp trainwreck along with the exports.
> > 
> > Fixes: d6d71ee4a14a "PM: Introduce Intel PowerClamp Driver"
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> > diff --git a/drivers/thermal/intel_powerclamp.c 
> > b/drivers/thermal/intel_powerclamp.c
> > index b46c706e1cac..e98b4249187c 100644
> > --- a/drivers/thermal/intel_powerclamp.c
> > +++ b/drivers/thermal/intel_powerclamp.c
> > @@ -435,7 +435,6 @@ static int clamp_thread(void *arg)
> >  		 * allowed. thus jiffies are updated properly.
> >  		 */
> >  		preempt_disable();
> > -		tick_nohz_idle_enter();
> >  		/* mwait until target jiffies is reached */
> >  		while (time_before(jiffies, target_jiffies)) {
> >  			unsigned long ecx = 1;
> > @@ -451,7 +450,6 @@ static int clamp_thread(void *arg)
> >  			start_critical_timings();
> >  			atomic_inc(&idle_wakeup_counter);
> >  		}
> > -		tick_nohz_idle_exit();
> >  		preempt_enable();
> >  	}
> >  	del_timer_sync(&wakeup_timer);
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 4d54b7540585..1363d58f07e9 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -847,7 +847,6 @@ void tick_nohz_idle_enter(void)
> > 
> >  	local_irq_enable();
> >  }
> > -EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
> > 
> >  /**
> >   * tick_nohz_irq_exit - update next tick event from interrupt exit
> > @@ -974,7 +973,6 @@ void tick_nohz_idle_exit(void)
> > 
> >  	local_irq_enable();
> >  }
> > -EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
> > 
> >  static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t
> > now)  {
> > 
> 
(switching to my linux email)

OK I agree, also as I mentioned earlier, Peter already has a patch for
consolidated idle loop and remove tick_nohz_idle_enter/exit call from
powerclamp driver. I have been working on a few tweaks to maintain the
functionality and efficiency with the consolidated idle loop.
We can apply the patches on top of yours.

> Ok the solution looks apt to me.
> 
> Let me see if I can come up with a sane solution for powerclamp based
> on the suggestions that you gave in the previous thread. I was
> thinking of the below steps towards its implementation. The idea is
> based on the throttling mechanism that you had suggested.
> 
> 1. Queue a deferable periodic timer whose handler checks if idle
> needs to be injected. If so, it sets rq->need_throttle for the cpu.
> If its already in the fake idle period, it clears rq->need_throttle
> and sets need_resched.
> 
The key to powerclamp driver is to achieve package level idle
states, which implies synchronized idle injection. From
power/performance standpoint, only package level idle states is worth
injection.

IMHO, percpu the deferrable timer based solution makes it hard to
synchronize. And you have to be able to request deepest idle.

Some background on why we do this:
As the power consumption in package level idle goes lower and lower with
new processors, it became negligible compared to running states.
Therefore, powerclamp driver can give you near linear power-performance
throttling. Idle injection at per cpu core level may not be worthwhile
in most of todays' cpus.

Just some background on the use case, if you want to try powerclamp on
your ultrabook, you will be able compare the effectiveness in
controlling cpu thermal. You can use tmon tool in kernel source.
e.g.
$tools/thermal/tmon$ sudo ./tmon -z 1 -c intel_powerclamp
(choose -z thermal zone of your processor zone, pkg-temp or acpi tz)


> 2. pick_next_task_fair() checks rq->need_throttle and dequeues all
> tasks in the rq if this is set and puts them on a throttled list.
> This mechanism is similar to throttling cfs rq today. This function
> hence fails to return a task, and if no task from any other sched
> class exists, idle task is picked.
> 
> Peter thoughts?
> 
> 3. So we are now in the idle injected period. The scheduler state is
> sane because the cpu is idle, rq->nr_running = 0, rq->curr =
> rq->idle. The nohz state is sane, because ts->inidle = 1 and
> tick_stopped may or may not be 1 and they are set by an idle task.
> 
> 4. When need_resched is set again, the idle task of course unsets
> inidle and restarts tick. In the following scheduler tick,
> pick_next_task_fair() sees that rq->need_throttle is cleared,
> enqueues back the tasks and returns one of them to run.
> 
> Of course there may be several points that I have missed. But how
> does the approach appear? If it looks sane enough, the cases which do
> not obviously fall in place can be worked upon.
> 
> Regards
> Preeti U Murthy
> 
