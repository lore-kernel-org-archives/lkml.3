Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaCaDzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:55:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43734 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaCaDzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:55:04 -0400
Date: Sun, 30 Mar 2014 20:54:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: fweisbec@gmail.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
Message-ID: <20140331035458.GJ4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140330230856.GA21498@linux.vnet.ibm.com>
 <1983376434.2684.1396236565608.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1983376434.2684.1396236565608.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033103-0928-0000-0000-000000CA17CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 03:29:25AM +0000, Mathieu Desnoyers wrote:
> ----- Original Message -----
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > To: fweisbec@gmail.com, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>, peterz@infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Sent: Sunday, March 30, 2014 7:08:56 PM
> > Subject: Promela/spin model for NO_HZ_FULL_SYSIDLE code
> > 
> > For whatever it is worth, the following model claims safety and progress
> > for the sysidle state machine.
> > 
> > Thoughts?
> 
> Hi Paul,
> 
> Please keep in mind that it's been a while since I've looked at Promela
> proofs, but a couple of questions come to mind. First, how is the execution
> script below checking for progress in any way ? I remember that we used
> the negation of a "_np" LTL claim to check for progress in the past.
> Moreover, I'd be much more comfortable seeing ifdefs in the code that inject
> known failures, and let them be triggered by error-triggering runs in the
> scripts (with e.g. -DINJECT_ERROR_XYZ), to confirm that this model actually
> catches known issues.

Well, if I comment out the four "progress_" labels, it complains about
a non-progress cycle.  So at least spin does pay attention to these.  ;-)

If I put the "progress_" labels back in, but change the check so as to
prevent the state machine from ever entering RCU_SYSIDLE_FULL_NOTED,
it cranks through 14M states before complaining about a non-progress cycle,
as expected.

If I revert back to pristine state, and then comment out the statements
that reverts state back to RCU_SYSIDLE_NOT when exiting idle, an assert()
triggers, as expected.

> If we can show that the model can detect a few failure modes, both for safety
> and progress, then my confidence level in the model will start to improve. ;-)

Well, there probably is a bug in there somewhere, Murphy being who he is.  ;-)

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > sysidle.sh
> > ------------------------------------------------------------------------
> > spin -a sysidle.spin
> > cc -DNP -o pan pan.c
> > # Fair scheduling to focus progress checks in timekeeper.
> > ./pan -f -l -m1280000 -w22
> > 
> > ------------------------------------------------------------------------
> > sysidle.spin
> > ------------------------------------------------------------------------
> > /*
> >  * Promela model for CONFIG_NO_HZ_FULL_SYSIDLE=y in the Linux kernel.
> >  * This model assumes that the dyntick-idle bit manipulation works based
> >  * on long usage, and substitutes a per-thread boolean "am_busy[]" array
> >  * for the Linux kernel's dyntick-idle masks.  The focus of this model
> >  * is therefore on the state machine itself.  Checks for both safety and
> >  * forward progress.
> >  *
> >  * This program is free software; you can redistribute it and/or modify
> >  * it under the terms of the GNU General Public License as published by
> >  * the Free Software Foundation; either version 2 of the License, or
> >  * (at your option) any later version.
> >  *
> >  * This program is distributed in the hope that it will be useful,
> >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >  * GNU General Public License for more details.
> >  *
> >  * You should have received a copy of the GNU General Public License
> >  * along with this program; if not, you can access it online at
> >  * http://www.gnu.org/licenses/gpl-2.0.html.
> >  *
> >  * Copyright IBM Corporation, 2014
> >  *
> >  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >  */
> > 
> > #define NUM_WORKERS 3
> > 
> > byte wakeup_timekeeper = 0; /* Models rcu_kick_nohz_cpu(). */
> > 
> > #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
> > #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
> > #define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
> > #define RCU_SYSIDLE_FULL	3	/* All CPUs idle, ready for sysidle. */
> > #define RCU_SYSIDLE_FULL_NOTED	4	/* Actually entered sysidle state. */
> > 
> > byte full_sysidle_state = RCU_SYSIDLE_NOT;
> > 
> > byte am_busy[NUM_WORKERS];  /* Busy is similar to "not dyntick-idle". */
> > byte am_setup[NUM_WORKERS]; /* Setup means timekeeper knows I am not idle. */
> > 
> > /*
> >  * Non-timekeeping CPU going into and out of dyntick-idle state.
> >  */
> > proctype worker(byte me)
> > {
> > 	byte oldstate;
> > 
> > 	do
> > 	:: 1 ->
> > 		/* Go idle. */
> > 		am_setup[me] = 0;
> > 		am_busy[me] = 0;
> > 
> > 		/* Dyntick-idle in the following loop. */
> > 		do
> > 		:: 1 -> skip;
> > 		:: 1 -> break;
> > 		od;
> > 
> > 		/* Exit idle loop, model getting out of dyntick idle state. */
> > 		am_busy[me] = 1;
> > 
> > 		/* Get state out of full-system idle states. */
> > 		atomic {
> > 			oldstate = full_sysidle_state;
> > 			if
> > 			:: oldstate > RCU_SYSIDLE_SHORT ->
> > 				full_sysidle_state = RCU_SYSIDLE_NOT;
> > 			:: else -> skip;
> > 			fi;
> > 		}
> > 
> > 		/* If needed, wake up the timekeeper. */
> > 		if
> > 		:: oldstate == RCU_SYSIDLE_FULL_NOTED ->
> > 			wakeup_timekeeper = 1;
> > 		:: else -> skip;
> > 		fi;
> > 
> > 		/* Mark ourselves fully awake and operational. */
> > 		am_setup[me] = 1;
> > 
> > 		/* We are fully awake, so timekeeper must not be asleep. */
> > 		assert(full_sysidle_state < RCU_SYSIDLE_FULL);
> > 
> > 		/* Running in kernel in the following loop. */
> > 		do
> > 		:: 1 -> skip;
> > 		:: 1 -> break;
> > 		od;
> > 	od
> > }
> > 
> > /*
> >  * Are all the workers in dyntick-idle state?
> >  */
> > #define check_idle() \
> > 	i = 0; \
> > 	idle = 1; \
> > 	do \
> > 	:: i < NUM_WORKERS -> \
> > 		if \
> > 		:: am_busy[i] == 1 -> idle = 0; \
> > 		:: else -> skip; \
> > 		fi; \
> > 		i++; \
> > 	:: i >= NUM_WORKERS -> break; \
> > 	od
> > 
> > /*
> >  * Timekeeping CPU.
> >  */
> > proctype timekeeper()
> > {
> > 	byte i;
> > 	byte idle;
> > 	byte curstate;
> > 	byte newstate;
> > 
> > 	do
> > 	:: 1 ->
> > 		/* Capture current state. */
> > 		check_idle();
> > 		curstate = full_sysidle_state;
> > 		newstate = curstate;
> > 
> > 		/* Check for acceptance state. */
> > 		if
> > 		:: idle == 0 ->
> > progress_idle:
> > 			skip;
> > 		:: curstate == RCU_SYSIDLE_NOT ->
> > progress_idle_reset:
> > 			skip;
> > 		:: else -> skip;
> > 		fi;
> > 
> > 		/* Manage state... */
> > 		if
> > 		:: idle == 1 && curstate < RCU_SYSIDLE_FULL_NOTED ->
> > 			/* Idle, advance to next state. */
> > 			atomic {
> > 				if
> > 				:: full_sysidle_state == curstate ->
> > 					newstate = curstate + 1;
> > 					full_sysidle_state = newstate;
> > 				:: else -> skip;
> > 				fi;
> > 			}
> > 		:: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
> > 			/* Non-idle and state advanced, revert to base state. */
> > 			full_sysidle_state = RCU_SYSIDLE_NOT;
> > 		:: else -> skip;
> > 		fi;
> > 
> > 		/* If in RCU_SYSIDLE_FULL_NOTED, wait to be awakened. */
> > 		do
> > 		:: newstate != RCU_SYSIDLE_FULL_NOTED &&
> > 		   wakeup_timekeeper == 1 ->
> > 			assert(0); /* Should never get here. */
> > 		:: newstate != RCU_SYSIDLE_FULL_NOTED &&
> > 		   wakeup_timekeeper == 0 ->
> > 			break;
> > 		:: newstate == RCU_SYSIDLE_FULL_NOTED &&
> > 		   wakeup_timekeeper == 1 ->
> > progress_full_system_idle_1:
> > 			assert(full_sysidle_state == RCU_SYSIDLE_NOT);
> > 		   	wakeup_timekeeper = 0;
> > 			break;
> > 		:: newstate == RCU_SYSIDLE_FULL_NOTED &&
> > 		   wakeup_timekeeper == 0 ->
> > progress_full_system_idle_2:
> > 
> > 			/* We are asleep, so all workers better be idle. */
> > 			atomic {
> > 				i = 0;
> > 				idle = 1;
> > 				do
> > 				:: i < NUM_WORKERS ->
> > 					if
> > 					:: am_setup[i] -> idle = 0;
> > 					:: else -> skip;
> > 					fi;
> > 					i++;
> > 				:: i >= NUM_WORKERS -> break;
> > 				od;
> > 				assert(idle == 1 ||
> > 				       full_sysidle_state < RCU_SYSIDLE_FULL);
> > 			}
> > 		od;
> > 		assert(full_sysidle_state <= RCU_SYSIDLE_FULL_NOTED);
> > 	od;
> > }
> > 
> > init {
> > 	byte i = 0;
> > 
> > 	do
> > 	:: i < NUM_WORKERS ->
> > 		am_busy[i] = 1;
> > 		am_setup[i] = 1;
> > 		run worker(i);
> > 		i++;
> > 	:: i >= NUM_WORKERS -> break;
> > 	od;
> > 	run timekeeper();
> > }
> > 
> > 
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 

