Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaDCXnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:43:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47597 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaDCXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:43:19 -0400
Date: Fri, 4 Apr 2014 01:43:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mathieu.desnoyers@efficios.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
Message-ID: <20140403234312.GA2812@localhost.localdomain>
References: <20140330230856.GA21498@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330230856.GA21498@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 04:08:56PM -0700, Paul E. McKenney wrote:
> For whatever it is worth, the following model claims safety and progress
> for the sysidle state machine.
> 
> Thoughts?

I'm going to get fun of myself by risking a review of this. Warning,
I don't speak promelian, so I may well write non-sense :)

> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> sysidle.sh
> ------------------------------------------------------------------------
> spin -a sysidle.spin
> cc -DNP -o pan pan.c
> # Fair scheduling to focus progress checks in timekeeper.
> ./pan -f -l -m1280000 -w22
> 
> ------------------------------------------------------------------------
> sysidle.spin
> ------------------------------------------------------------------------
> /*
>  * Promela model for CONFIG_NO_HZ_FULL_SYSIDLE=y in the Linux kernel.
>  * This model assumes that the dyntick-idle bit manipulation works based
>  * on long usage, and substitutes a per-thread boolean "am_busy[]" array
>  * for the Linux kernel's dyntick-idle masks.  The focus of this model
>  * is therefore on the state machine itself.  Checks for both safety and
>  * forward progress.
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, you can access it online at
>  * http://www.gnu.org/licenses/gpl-2.0.html.
>  *
>  * Copyright IBM Corporation, 2014
>  *
>  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>  */
> 
> #define NUM_WORKERS 3
> 
> byte wakeup_timekeeper = 0; /* Models rcu_kick_nohz_cpu(). */
> 
> #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
> #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
> #define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
> #define RCU_SYSIDLE_FULL	3	/* All CPUs idle, ready for sysidle. */
> #define RCU_SYSIDLE_FULL_NOTED	4	/* Actually entered sysidle state. */
> 
> byte full_sysidle_state = RCU_SYSIDLE_NOT;
> 
> byte am_busy[NUM_WORKERS];  /* Busy is similar to "not dyntick-idle". */
> byte am_setup[NUM_WORKERS]; /* Setup means timekeeper knows I am not idle. */
> 
> /*
>  * Non-timekeeping CPU going into and out of dyntick-idle state.
>  */
> proctype worker(byte me)
> {
> 	byte oldstate;
> 
> 	do
> 	:: 1 ->
> 		/* Go idle. */
> 		am_setup[me] = 0;
> 		am_busy[me] = 0;
> 
> 		/* Dyntick-idle in the following loop. */
> 		do
> 		:: 1 -> skip;
> 		:: 1 -> break;
> 		od;
> 
> 		/* Exit idle loop, model getting out of dyntick idle state. */
> 		am_busy[me] = 1;
> 
> 		/* Get state out of full-system idle states. */
> 		atomic {
> 			oldstate = full_sysidle_state;

On the upstream code, the first read of full_sysidle_state after exiting idle is not
performed by an atomic operation. So I wonder if this is right to put this
in the atomic section.

I don't know the language enough to tell if it has no effect but I'm just
worried that it gets badly intepreted. Like the above read plus the below
conditional write in the same atomic section gets packed in a kind of cmpxchg_if_above() ?

Which is what we want to avoid if the value is not above RCU_SYSIDLE_SHORT after
a non atomic read.

> 			if
> 			:: oldstate > RCU_SYSIDLE_SHORT ->
> 				full_sysidle_state = RCU_SYSIDLE_NOT;
> 			:: else -> skip;
> 			fi;
> 		}
> 
> 		/* If needed, wake up the timekeeper. */
> 		if
> 		:: oldstate == RCU_SYSIDLE_FULL_NOTED ->
> 			wakeup_timekeeper = 1;
> 		:: else -> skip;
> 		fi;
> 
> 		/* Mark ourselves fully awake and operational. */
> 		am_setup[me] = 1;
> 
> 		/* We are fully awake, so timekeeper must not be asleep. */
> 		assert(full_sysidle_state < RCU_SYSIDLE_FULL);
> 
> 		/* Running in kernel in the following loop. */
> 		do
> 		:: 1 -> skip;
> 		:: 1 -> break;
> 		od;
> 	od
> }
> 
> /*
>  * Are all the workers in dyntick-idle state?
>  */
> #define check_idle() \
> 	i = 0; \
> 	idle = 1; \
> 	do \
> 	:: i < NUM_WORKERS -> \
> 		if \
> 		:: am_busy[i] == 1 -> idle = 0; \
> 		:: else -> skip; \
> 		fi; \
> 		i++; \
> 	:: i >= NUM_WORKERS -> break; \
> 	od
> 
> /*
>  * Timekeeping CPU.
>  */
> proctype timekeeper()
> {
> 	byte i;
> 	byte idle;
> 	byte curstate;
> 	byte newstate;
> 
> 	do
> 	:: 1 ->
> 		/* Capture current state. */
> 		check_idle();
> 		curstate = full_sysidle_state;
> 		newstate = curstate;
> 
> 		/* Check for acceptance state. */
> 		if
> 		:: idle == 0 ->
> progress_idle:

Is this some kind of label? I can't find the target anywhere.

> 			skip;
> 		:: curstate == RCU_SYSIDLE_NOT ->
> progress_idle_reset:
> 			skip;
> 		:: else -> skip;
> 		fi;
> 
> 		/* Manage state... */
> 		if
> 		:: idle == 1 && curstate < RCU_SYSIDLE_FULL_NOTED ->
> 			/* Idle, advance to next state. */
> 			atomic {
> 				if
> 				:: full_sysidle_state == curstate ->
> 					newstate = curstate + 1;
> 					full_sysidle_state = newstate;
> 				:: else -> skip;
> 				fi;
> 			}

It looks good but just one thing about the transition from FULL -> FULL_NOTED.
At least in the case of CONFIG_NO_HZ_FULL_SYSIDLE_SMALL (which is usually the
scenario I refer to, but I'll check further the grace-period driven way as well),
we switch from FULL to FULL_NOTED without checking a new round of the dynticks counters.

But this timekeeper() proc doesn't seem to care and does a check_idle() no matter
the current state.

There should probably be a special case to handle that otherwise we add a new
round of dynticks counters read between FULL and FULL_NOTED transition and this is an
entirely different scenario than what we run.

> 		:: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
> 			/* Non-idle and state advanced, revert to base state. */
> 			full_sysidle_state = RCU_SYSIDLE_NOT;

Looking at the upstream code, I think we reset also when state == RCU_SYSIDLE_SHORT
once we detect a non-idle state. If it's not a mistyping, I'm probably missing something.

Thanks.

> 		:: else -> skip;
> 		fi;
> 
> 		/* If in RCU_SYSIDLE_FULL_NOTED, wait to be awakened. */
> 		do
> 		:: newstate != RCU_SYSIDLE_FULL_NOTED &&
> 		   wakeup_timekeeper == 1 ->
> 			assert(0); /* Should never get here. */
> 		:: newstate != RCU_SYSIDLE_FULL_NOTED &&
> 		   wakeup_timekeeper == 0 ->
> 			break;
> 		:: newstate == RCU_SYSIDLE_FULL_NOTED &&
> 		   wakeup_timekeeper == 1 ->
> progress_full_system_idle_1:
> 			assert(full_sysidle_state == RCU_SYSIDLE_NOT);
> 		   	wakeup_timekeeper = 0;
> 			break;
> 		:: newstate == RCU_SYSIDLE_FULL_NOTED &&
> 		   wakeup_timekeeper == 0 ->
> progress_full_system_idle_2:
> 
> 			/* We are asleep, so all workers better be idle. */
> 			atomic {
> 				i = 0;
> 				idle = 1;
> 				do
> 				:: i < NUM_WORKERS ->
> 					if
> 					:: am_setup[i] -> idle = 0;
> 					:: else -> skip;
> 					fi;
> 					i++;
> 				:: i >= NUM_WORKERS -> break;
> 				od;
> 				assert(idle == 1 ||
> 				       full_sysidle_state < RCU_SYSIDLE_FULL);
> 			}
> 		od;
> 		assert(full_sysidle_state <= RCU_SYSIDLE_FULL_NOTED);
> 	od;
> }
> 
> init {
> 	byte i = 0;
> 
> 	do
> 	:: i < NUM_WORKERS ->
> 		am_busy[i] = 1;
> 		am_setup[i] = 1;
> 		run worker(i);
> 		i++;
> 	:: i >= NUM_WORKERS -> break;
> 	od;
> 	run timekeeper();
> }
> 
