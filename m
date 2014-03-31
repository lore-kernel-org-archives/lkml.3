Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaCaD3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:29:36 -0400
Received: from mail.efficios.com ([78.47.125.74]:40636 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaCaD3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:29:34 -0400
Date: Mon, 31 Mar 2014 03:29:25 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Message-ID: <1983376434.2684.1396236565608.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140330230856.GA21498@linux.vnet.ibm.com>
References: <20140330230856.GA21498@linux.vnet.ibm.com>
Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Promela/spin model for NO_HZ_FULL_SYSIDLE code
Thread-Index: YxaGlvJVNegMu90UKRSUZVFXxZ3ljA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> To: fweisbec@gmail.com, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>, peterz@infradead.org
> Cc: linux-kernel@vger.kernel.org
> Sent: Sunday, March 30, 2014 7:08:56 PM
> Subject: Promela/spin model for NO_HZ_FULL_SYSIDLE code
> 
> For whatever it is worth, the following model claims safety and progress
> for the sysidle state machine.
> 
> Thoughts?

Hi Paul,

Please keep in mind that it's been a while since I've looked at Promela
proofs, but a couple of questions come to mind. First, how is the execution
script below checking for progress in any way ? I remember that we used
the negation of a "_np" LTL claim to check for progress in the past.
Moreover, I'd be much more comfortable seeing ifdefs in the code that inject
known failures, and let them be triggered by error-triggering runs in the
scripts (with e.g. -DINJECT_ERROR_XYZ), to confirm that this model actually
catches known issues.

If we can show that the model can detect a few failure modes, both for safety
and progress, then my confidence level in the model will start to improve. ;-)

Thanks,

Mathieu

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
> 		:: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
> 			/* Non-idle and state advanced, revert to base state. */
> 			full_sysidle_state = RCU_SYSIDLE_NOT;
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
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
