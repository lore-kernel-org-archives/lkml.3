Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaLPVVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:21:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:51788 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaLPVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:21:40 -0500
Date: Tue, 16 Dec 2014 22:21:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <alpine.DEB.2.11.1412161533210.17382@nanos>
Message-ID: <alpine.DEB.2.11.1412161802570.17382@nanos>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com> <548FFD20.1040102@linux.vnet.ibm.com> <alpine.DEB.2.11.1412161105470.17382@nanos> <20141216142029.GA27375@lerouge> <alpine.DEB.2.11.1412161533210.17382@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Thomas Gleixner wrote:
> On Tue, 16 Dec 2014, Frederic Weisbecker wrote:
> So like we do in tick_nohz_idle_enter() and tick_nohz_idle_exit() we
> have a clear state change in the nohz code and not something which is
> randomly deduced from async state all over the place.
> 
> So that only tells the NOHZ core that the rest of the system decided
> that the cpu can actually go into full nohz mode. Whether the tick
> code disables the tick or not is decided by the tick code.
> 
> It's not different from idle.

That made me look deeper into it. So we have a full zoo of functions
related to this nohz full stuff

extern void __tick_nohz_full_check(void);
extern void tick_nohz_full_kick(void);
extern void tick_nohz_full_kick_cpu(int cpu);
extern void tick_nohz_full_kick_all(void);
extern void __tick_nohz_task_switch(struct task_struct *tsk);

Plus a few inline functions

static inline bool tick_nohz_full_enabled(void)
{
	if (!context_tracking_is_enabled())
		return false;

	return tick_nohz_full_running;
}

static inline void tick_nohz_full_check(void)
{
	if (tick_nohz_full_enabled())
		__tick_nohz_full_check();
}

static inline void tick_nohz_task_switch(struct task_struct *tsk)
{
	if (tick_nohz_full_enabled())
		__tick_nohz_task_switch(tsk);
}

context_tracking_is_enabled() is actually the static key you talked
about, right? Very intuitive - NOT!

Now lets look at the call site of tick_nohz_task_switch(). That's
invoked at the end of finish_task_switch(). Looking at one of the
worst case call chains here:

finish_task_switch()
  tick_nohz_task_switch()
    __tick_nohz_task_switch()
        tick_nohz_tick_stopped()
	can_stop_full_tick()
	  sched_can_stop_tick()
	  posix_cpu_timers_can_stop_tick()
	  perf_event_can_stop_tick()
	tick_nohz_full_kick()
	  tick_nohz_full_kick()
	    irq_work_queue()
	      arch_irq_work_raise()

And then you take the self ipi and do:

    irq_work_run()
	can_stop_full_tick()
	  sched_can_stop_tick()
	  posix_cpu_timers_can_stop_tick()
	  perf_event_can_stop_tick()
	tick_nohz_restart_sched_tick();

and right after that:

    irq_exit()
      tick_nohz_full_stop_tick()
	can_stop_full_tick()
	  sched_can_stop_tick()
	  posix_cpu_timers_can_stop_tick()
	  perf_event_can_stop_tick()

What a trainwreck in the scheduler hotpath!

So you have three states which can change the nohzfull state:

 1)  rq->nr_running > 1
 2)  current->uses_posix_timer
 3)  perf needing the tick

So instead of evaluating the whole nonsense a gazillion times in a row
and firing pointless self ipis why are you not looking at the obvious
solution of sane state change tracking?

DEFINE_PER_CPU(nohz_full_must_tick, unsigned long);

enum {
     NOHZ_SCHED_NEEDS_TICK,
     NOHZ_POSIXTIMER_NEEDS_TICK,
     NOHZ_PERF_NEEEDS_TICK,
};

/* rq->lock is held for evaluating rq->nr_running */
static void sched_ttwu_nohz(struct rq *rq)
{
	if (nohz_full_disabled())
		return;

	if (rq->nr_running != 2)
		return;
	set_bit(NOHZ_SCHED_NEEDS_TICK, this_cpu_ptr(nohz_full_must_tick);
}

/* rq->lock is held for evaluating rq->nr_running */
static void sched_ttwu_remote_nohz(struct rq *rq)
{
	if (nohz_full_disabled())
		return;

	if (rq->nr_running != 2)
	   	return;
	/*
	 * Force smp_send_reschedule(). irq_exit() on the
	 * remote cpu will handle the rest.
	 */
	set_bit(NOHZ_SCHED_NEEDS_TICK, per_cpu_ptr(nohz_full_must_tick, rq->cpu);
	rq->force_send_resched = true;
}

/* rq->lock is held for evaluating rq->nr_running */
static void sched_out_nohz(struct rq *rq)
{
	if (nohz_full_disabled())
		return;

	if (rq->nr_running >= 2)
	   	return;
	clear_bit(NOHZ_SCHED_NEEDS_TICK, this_cpu_ptr(nohz_full_must_tick);
}

/* preeemption is disabled */
static void sched_in_nohz(struct task_struct *task)
{
	if (nohz_full_disabled())
		return;

	if (!task_uses_posix_timers(task))
		clear_bit(NOHZ_POSIXTIMER_NEEDS_TICK,
			  this_cpu_ptr(nohz_full_must_tick));
	else
		set_bit(NOHZ_POSIXTIMER_NEEDS_TICK,
			this_cpu_ptr(nohz_full_must_tick));

	local_irq_disable();
	tick_full_nohz_update_state();
	local_irq_enable();
}

/* interrupts are disabled */
void tick_full_nohz_update_state(void)
{
        struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);

	if (this_cpu_read(nohz_full_must_tick)) {
	   	if (ts->infullnohz)
			tick_full_nohz_exit();
	} else {
	        if (!ts->infullnohz)
			tick_full_nohz_enter();
	   	else
			__tick_full_nohz_enter();
	}
}

So the irq_exit() path becomes:

/* interrupts are disabled */
void tick_nohz_irq_exit(void)
{
        struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);

        if (ts->inidle) {
                __tick_nohz_idle_enter();
		return;
	}
	if (nohz_full_disabled())
		return;
	tick_nohz_update_state();
}

No self IPI, no irq work, no triple evaluation of the same condition
chain and proper state tracking of infullnohz inside of the tick code.

Precicely TWO points where the NOHZ internal state gets updated:

   switch_to() and irq_exit()	  	  

No conflict between infullnohz and inidle because it's all internal to
the NOHZ code.

Simple, isn't it?

Now for perf and posix cpu timers I'm sure you'll find equally simple
solutions which do not add extra update points. switch_to() and
irq_exit() are enough. It's really not rocket science.

While at it let me rant about some other things.

 1) Remote accounting
 
    I really cannot understand why all of you NOHZ enthusiasts just
    avoid to make that work in the first place as it reduces the
    problem space significantly.

    Instead of that you folks come up with broken patches for
    debugfs/sysfs/sysctl/... to forcefully disable the tick. Sure it's
    harder to implement remote accounting proper than hacking up some
    random disable mechanism, but the latter is just utter waste of
    time and resources.

    I told all of you from the very beginning that remote accounting
    is a key mechanism for this, but you keep insisting on hacking
    around it.

    If done right, then the whole kick ALL cpus nonsense in posix cpu
    timers can just go away. You can do the complete posix cpu timer
    thing from the housekeeper cpu(s) once you have remote accounting
    implemented.

 2) Perf

    I doubt that the tick_nohz_full_kick() in __perf_event_overflow()
    is actually necessary when you implement the above scheme.

    The nr_freq_events kick ALL cpus is horrible as well. This really
    wants to be restricted on the target cpus and not wholesale global
    just because it is conveniant.

Managerial summary:

 1) Stop fiddling on symptoms. Tackle the root causes

 2) Stop creating overengineered monstrosities which just create more
    race conditions and corner cases than actual functionality

 3) Fix that ASAP before I slap BROKEN on it or get annoyed enough to
    rip it out completely.

Thanks,

	tglx
