Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaBTAAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:00:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:56004 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaBTAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:00:10 -0500
Date: Thu, 20 Feb 2014 01:00:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH] softirq: stable v3.1[23] (others?) have screaming tasklet
 disease - ksoftirqd[random] eats 100% CPU
In-Reply-To: <1392833773.5423.142.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.02.1402192119480.4468@ionos.tec.linutronix.de>
References: <1392833773.5423.142.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Mike Galbraith wrote:
> I'm seeing ksoftirqd chewing 100% CPU on one or more CPUs in both 3.12
> and 3.13, as below in a 40 core (+smt) box.  It should look very
> familiar to CCs, especially Ingo.
> 
> Below, tasklet is disabled by ioat2_free_chan_resources, and what I
> presume was systemd-udevd-1050 starts screaming when it meets same,
> until debug patchlet turns tracing off.  Once the box was up such that I
> could login, 1050 was long gone, and ksoftirqd had taken over.
> 
>    systemd-udevd-976   [016] ....    27.467534: ioat_init_channel: tasklet_disable_nosync ffff880465b8bee8
>    systemd-udevd-976   [016] ....    27.467649: ioat2_alloc_chan_resources: tasklet_enable ffff880465b8bee8
>           <idle>-0     [072] ..s.    27.467659: tasklet_action: ENTER struct tasklet_struct *list: ffff880465b8bee8
>           <idle>-0     [072] .Ns.    27.467667: tasklet_action: LOOP struct tasklet_struct *t = list: ffff880465b8bee8
>           <idle>-0     [072] .Ns.    27.467673: tasklet_action: LOOP processed ffff880465b8bee8
>    systemd-udevd-976   [016] ....    27.467679: ioat2_free_chan_resources: tasklet_disable_nosync ffff880465b8bee8
>    systemd-udevd-1034  [000] .Ns.    27.467917: tasklet_action: ENTER struct tasklet_struct *list: ffff880465b8bee8
>    systemd-udevd-1034  [000] .Ns.    27.467918: tasklet_action: LOOP struct tasklet_struct *t = list: ffff880465b8bee8
>            <...>-1050  [000] ..s.    27.468203: tasklet_action: ENTER struct tasklet_struct *list: ffff880465b8bee8
>            <...>-1050  [000] ..s.    27.468204: tasklet_action: LOOP struct tasklet_struct *t = list: ffff880465b8bee8
>            <...>-1050  [000] ..s.    27.468204: tasklet_action: ENTER struct tasklet_struct *list: ffff880465b8bee8
>            <...>-1050  [000] ..s.    27.468205: tasklet_action: LOOP struct tasklet_struct *t = list: ffff880465b8bee8
> ... much no processing, see tasklet disabled, raise softirq - wash rinse repeat
>            <...>-1050  [000] ..s.    27.469561: tasklet_action: ENTER struct tasklet_struct *list: ffff880465b8bee8
>            <...>-1050  [000] ..s.    27.469562: tasklet_action: LOOP struct tasklet_struct *t = list: ffff880465b8bee8
>            <...>-1050  [000] ..s.    27.469563: tasklet_action: LOOP tasklet disabled ffff880465b8bee8 - It's dead Jim
> 
> Hm, he says, now where have I seen text describing that trace?  Right,
> RT, and the below fixes screaming NOPREEMPT kernels.
> 
> Taken from 3.12-rt, and applied to screaming 3.12.11-virgin

Indeed. That's a very similar issue just for different reasons. The RT
case is special as the mainline usage side of tasklets do not expect
the preemption scenario.

But this one is clearly a driver issue.

The window where you can bring a machine into that state is infinite
large. Lets look at the tasklet_schedule --> softirq sequence:

tasklet_schedule(t)
  set_bit(TASKLET_STATE_SCHED, &t->state);
  queue_tasklet_on_cpu_list(t);
  raise_softirq();

softirq()
  splice_tasklet_cpu_list(cpu_list, list);
  while (list) {
    t = list;
    list = t->next;
    /* Sets the TASKLET_STATE_RUN bit ! */
    if (tasklet_trylock(t) {
      if (!atomic_read(&t->count)) {               <----- 
	clear_bit(TASKLET_STATE_SCHED, &t->state);
	t->func();
	/* Clear the TASKLET_STATE_RUN bit */
	tasklet_unlock();
	continue;
      }
    tasklet_unlock();
    queue_tasklet_on_cpu_list(t);
    raise_softirq();
  }  

So up to the atomic_read in the softirq all calls to tasklet_disable()
even if issued eons before that point are going to put the softirq
into an infinite loop when the tasklet is scheduled.

Even if we would put a check for the disabled state into
tasklet_schedule there would be still the window between the schedule
and the actual softirq handling. And we even can't add that check
because that would break "sane" use sites of tasklet_disable.

tasklet_disable/enable is only meant for temporary, i.e. over a very
short code sequence, preventing the execution of the tasklet.

The usage of tasklet_disable() in teardown scenarios is completely
broken. The only way to do that is to have a proper serialization of
the teardown versus the interrupt which schedules the tasklet:

    	/*
	 * First step.
	 */
    	disable_interrupt_at_device_or_irq_line_level();

	/*
	 * This makes sure that even a spurious interrupt which
	 * arrives _AFTER_ the synchronize_irq() cannot schedule
	 * the tasklet anymore.
	 */
	tell_interrupt_to_not_schedule_tasklet();

	/* Make sure that no interrupt is on the fly */
	synchronize_irq();

	/* 
	 * Kill the tasklet, which also waits for an already
	 * scheduled one to complete.
	 */
	tasklet_kill();

I tried to find something like that in the ioat code but I failed
miserably.

Instead of that it uses tasklet_disable/enable for the setup/teardown
which is completely buggered and obviously written by people who have
no clue about the tasklet semantics at all.

What's worse is that at the point where this code was written it was
already well known that tasklets are a steaming pile of crap and
should die.

I know why and how the RT patch works around that issue, but do we
really want to make it simpler to (ab)use and introduce new users of
tasklets instead of getting rid of them? Definitely NOT!

Seriously, people who still use tasklets without being aware of their
subtle issues and without an extremly good reason to use them at all
should use a wire cutter or some other appropriate tool to render
their keyboard unusable and get a job in a bakery where they can eat
the mess they produce themself.

Thanks,

	tglx
