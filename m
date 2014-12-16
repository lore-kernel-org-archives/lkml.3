Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaLPMtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:49:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:49850 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLPMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:49:17 -0500
Date: Tue, 16 Dec 2014 13:49:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <548FFD20.1040102@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1412161105470.17382@nanos>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com> <548FFD20.1040102@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Preeti U Murthy wrote:
> As far as I can see, the primary purpose of tick_nohz_irq_enter()/exit()
> paths was to take care of *tick stopped* cases.
> 
> Before handling interrupts we would want jiffies to be updated, which is
> done in tick_nohz_irq_enter(). And after handling interrupts we need to
> verify if any timers/RCU callbacks were queued during an interrupt.
> Both of these will not be handled properly
> *only when the tick is stopped* right?
>  
> If so, the checks which permit entry into these functions should at a
> minimum include a check on ts->tick_stopped(). The rest of the checks
> around if the CPU is idle/need_resched() may be needed in conjunction,
> but will not be complete without checking if ticks are stopped. I see
> that tick_nohz_irq_enter() has a check on ts->tick_stopped, which is
> correct, but tick_noz_irq_exit() does not.
>
> Adding this check to tick_nohz_irq_exit() will not only solve this
> regression but is probably a fix to a long standing bug in the
> conditional check in tick_nohz_irq_exit().

This is a complete mess caused by the full nohz hackery and you're
just making it worse. Lets ignore the powerclamp crap for now.

The initial nohz idle logic was simple:

irq_enter
	if (ts->tick_stopped)
	   update_timekeeping()

irq_exit
	if (ts->inidle)
	   tick_nohz_update_sched_tick();

And that was completely correct. On irq_enter the only relevant
information is whether the tick is stopped or not. On irq_exit the
tick handling is only interesting if we are inidle.

If we're not inidle then the tick is not stopped either. If we are
inidle the tick might be stopped or not. So the interrupt can have
added/removed/modified timers which have consequences on the
tick_stopped state and possibly kick the machine out of idle
completely.

If the tick was not stopped, then the removal/modification of a timer
in the interrupt can cause the tick to be stoppable at irq_exit.

So making irq_exit:

   	if (!ts->tick_stopped)
	   return;

is fundamentally wrong as you miss the oportunity to stop the tick
after the changes done by the interrupt handler.

So the possible states are:

 ts->inidle 	ts->tick_stopped
 0		0		valid
 0		1		BUG
 1		0		valid
 1		1		valid

And we are transitioning in and out of that via:

    tick_nohz_idle_enter()
	ts->inidle = true;
	if (stop_possible)
	  stop_tick(ts)		

    tick_nohz_idle_exit()
	ts->inidle = false;
	if (ts->tick_stopped)
	   start_tick(ts)

irq_exit needs to take care of the following situations if we are
inidle:

    if (ts->tick_stopped) {
       	 if (stop_possible) {
	    /* handle timer changes (earlier/later) */
	    update_tick(ts);
	 } else {
	    kick_out_of_idle();
	 }
    } else {   
	if (stop_possible)
	  stop_tick(ts)		
    }

Now with nohzfull the state space looks like this:

 ts->inidle	ts->infullnohz	ts->tick_stopped
 0		0		0		valid
 0		0		1		BUG		
 1		0		0		valid
 1		0		1		valid

 0		1 		0		valid
 0		1		1		valid
 1		1		0		BUG
 1		1		1		BUG		

You might have noticed that we have neither ts->infullnohz nor
functions which transitions in and out of that state.

And that's where the whole problem starts. The nohz full stuff is
trying to evaluate everything dynamically which is just insane.

So we want to have functions which do:

   tick_nohz_full_enter()
     ts->infullnohz = true;
     if (stop_possible)
     	stop_tick(ts);

   tick_nohz_full_exit()
     ts->infullnohz = false;
     if (ts->tick_stopped)
     	start_tick(ts);

Plus irq_exit would become:     

irq_exit
	if (ts->inidle)
	   tick_nohz_update_sched_tick();

	else if (ts->infullnohz)
	   tick_nohz_full_update_sched_tick();

You need to keep track of the fact that the cpu entered fullnohz and
work from there. Whether the tick is stopped or not does not matter at
all because that is a seperate decision like in the nohz idle case.

Everything else is voodoo programming.

Now the powerclamp mess is a different story.

Calling tick_nohz_idle_enter()/exit() from outside the idle task is
just broken. Period.

Trying to work around that madness in the core code is just fiddling
with the symptoms and ignoring the root cause. And the root cause is
simply that powerclamp calls tick_nohz_idle_enter()/exit().

So there are two things to solve:

   1) Remove the powerclamp stupidity

   2) Fix the whole nohz full mess with proper state tracking.

If you folks insist on curing the symptoms and ignoring the root
causes I'm going to mark NOHZ_FULL broken and NOHZ depend on
POWERCLAMP=n.

The commit in question, does not really cause a regression, it merily
unearths the utter broken crap which existed before in both NOHZ FULL
and powerclamp and just ever worked by chance.

Thanks,

	tglx






   
