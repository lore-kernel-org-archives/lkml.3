Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaDGSy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:54:58 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36621 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaDGSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:54:56 -0400
Date: Mon, 7 Apr 2014 20:54:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@efficios.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
Message-ID: <20140407185450.GB4106@localhost.localdomain>
References: <20140330230856.GA21498@linux.vnet.ibm.com>
 <20140403234312.GA2812@localhost.localdomain>
 <20140407181154.GE5272@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407181154.GE5272@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 11:11:55AM -0700, Paul E. McKenney wrote:
> > On the upstream code, the first read of full_sysidle_state after exiting idle is not
> > performed by an atomic operation. So I wonder if this is right to put this
> > in the atomic section.
> > 
> > I don't know the language enough to tell if it has no effect but I'm just
> > worried that it gets badly intepreted. Like the above read plus the below
> > conditional write in the same atomic section gets packed in a kind of cmpxchg_if_above() ?
> > 
> > Which is what we want to avoid if the value is not above RCU_SYSIDLE_SHORT after
> > a non atomic read.
> 
> Given that cmpxchg() is being used to emulate exactly that atomic
> operation, I feel good about this Promela translation.

Right but the very first read that checks if full_sysidle_state is > RCU_SYSIDLE_SHORT
is done in a non-atomic way. Only when it verifies the condition do we use cmpxchg()

       while (oldstate > RCU_SYSIDLE_SHORT) {
           newoldstate = cmpxchg(&full_sysidle_state,
                                  oldstate, RCU_SYSIDLE_NOT);
           if (oldstate == newoldstate && oldstate == RCU_SYSIDLE_FULL_NOTED) {
                rcu_kick_nohz_cpu(tick_do_timer_cpu);
                return; /* We cleared it, done! */
           }
           oldstate = newoldstate;
       }

Now the way you wrote it PROMELA looked like we use cmpxchg() (or some close relative)
right away from the first read. It's hard to translate with real world operations so I'm
inventing cmpxchg_if_above() which has the same atomic and full barrier properties
than cmpxchg() expect that it only exchanges old value with new value if old is
above the last parameter:

        oldstate = cmpxchg_if_above(oldstate, RCU_SYSIDLE_NOT, RCU_SYSIDLE_SHORT);
        if (oldstate == RCU_SYSIDLE_FULL_NOTED)
                rcu_kick_nohz_cpu(tick_do_timer_cpu);
                return; /* We cleared it, done! */


> If the value is different at the time of the cmpxchg(), the cmpxchg() fails.

Right but it might not do a cmpxchg() if oldval is <= SHORT.

> I suppose I could write it as follows instead:
> 
> 		/* Get state out of full-system idle states. */
> 		oldstate = full_sysidle_state;
> 		do
> 		:: 1 ->
> 			atomic {
> 				if
> 				:: oldstate > RCU_SYSIDLE_SHORT &&
> 				   oldstate == full_sysidle_state ->
> 					full_sysidle_state = RCU_SYSIDLE_NOT;
> 					break;
> 				:: else ->
> 					oldstate = full_sysidle_state;
> 				fi;
> 			}
> 		od;
> 
> Here the "if" emulates the cmpxchg() instruction and the rest emulates
> the loop.  Both representations get the same result when

Ok if they have the same result and implement the first read in a non atomic
way then it's all good. The PROMELA syntax has just been confusing to me in
this regard.

> 
> > > 			if
> > > 			:: oldstate > RCU_SYSIDLE_SHORT ->
> > > 				full_sysidle_state = RCU_SYSIDLE_NOT;
> > > 			:: else -> skip;
> > > 			fi;
> > > 		}
> > > 
> > > 		/* If needed, wake up the timekeeper. */
> > > 		if
> > > 		:: oldstate == RCU_SYSIDLE_FULL_NOTED ->
> > > 			wakeup_timekeeper = 1;
> > > 		:: else -> skip;
> > > 		fi;
> > > 
> > > 		/* Mark ourselves fully awake and operational. */
> > > 		am_setup[me] = 1;
> > > 
> > > 		/* We are fully awake, so timekeeper must not be asleep. */
> > > 		assert(full_sysidle_state < RCU_SYSIDLE_FULL);
> > > 
> > > 		/* Running in kernel in the following loop. */
> > > 		do
> > > 		:: 1 -> skip;
> > > 		:: 1 -> break;
> > > 		od;
> > > 	od
> > > }
> > > 
> > > /*
> > >  * Are all the workers in dyntick-idle state?
> > >  */
> > > #define check_idle() \
> > > 	i = 0; \
> > > 	idle = 1; \
> > > 	do \
> > > 	:: i < NUM_WORKERS -> \
> > > 		if \
> > > 		:: am_busy[i] == 1 -> idle = 0; \
> > > 		:: else -> skip; \
> > > 		fi; \
> > > 		i++; \
> > > 	:: i >= NUM_WORKERS -> break; \
> > > 	od
> > > 
> > > /*
> > >  * Timekeeping CPU.
> > >  */
> > > proctype timekeeper()
> > > {
> > > 	byte i;
> > > 	byte idle;
> > > 	byte curstate;
> > > 	byte newstate;
> > > 
> > > 	do
> > > 	:: 1 ->
> > > 		/* Capture current state. */
> > > 		check_idle();
> > > 		curstate = full_sysidle_state;
> > > 		newstate = curstate;
> > > 
> > > 		/* Check for acceptance state. */
> > > 		if
> > > 		:: idle == 0 ->
> > > progress_idle:
> > 
> > Is this some kind of label? I can't find the target anywhere.
> 
> It is a marker.  If you specify -DNP and if there is any cycle of
> states that does not pass through a label beginning with "progress",
> the verification will fail.  So it is useful for finding livelocks.
> 
> Mathieu posted another way of getting this same effect.

Ah ok.

> 
> > > 		:: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
> > > 			/* Non-idle and state advanced, revert to base state. */
> > > 			full_sysidle_state = RCU_SYSIDLE_NOT;
> > 
> > Looking at the upstream code, I think we reset also when state == RCU_SYSIDLE_SHORT
> > once we detect a non-idle state. If it's not a mistyping, I'm probably missing something.
> 
> I don't see this.  The resetting happens in rcu_sysidle_force_exit(),
> which contains the following:
> 
> 	while (oldstate > RCU_SYSIDLE_SHORT) {
> 		newoldstate = cmpxchg(&full_sysidle_state,
> 				      oldstate, RCU_SYSIDLE_NOT);
> 		if (oldstate == newoldstate &&
> 		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
> 			rcu_kick_nohz_cpu(tick_do_timer_cpu);
> 			return; /* We cleared it, done! */
> 		}
> 		oldstate = newoldstate;
> 	}
> 
> If the state is RCU_SYSIDLE_SHORT, we skip the body of the "if" thus
> declining to reset back to RCU_SYSIDLE_NOT.  Or am I confused?

Hmm, the loop above is the code of !timekeeper side. I'm referring to the timekeeper side (which
is what this PROMELA chunck represents, unless I'm utterly confused).

And the timekeeper side resets full_sysidle_state when it detects a non-idle CPU:

rcu_sys_is_idle() -> rcu_sysidle_report -> rcu_sysidle_cancel()

So the PROMELA code suggests that when we find a non idle CPU, we only reset
full_sysidle_state when is it >= RCU_SYSIDLE_LONG:

                  :: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
                        /* Non-idle and state advanced, revert to base state. */
                        full_sysidle_state = RCU_SYSIDLE_NOT;

...but actually the condition upstream seems to be full_sysidle_state >= RCU_SYSIDLE_SHORT.

For example we loop in rcu_sys_is_idle() (case of NR_CPUS < 8), and we detect a round of full-idle CPUs, so we
set full_sysidle_state to RCU_SYSIDLE_SHORT. Then we do another pass in the loop but this
time we detect a CPU is not idle, so we reset to RCU_SYSIDLE_NOT instead of advancing to RCU_SYSIDLE_LONG.

Right?

Thanks.
