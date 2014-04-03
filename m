Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaDCC6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:58:04 -0400
Received: from mail.efficios.com ([78.47.125.74]:55253 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbaDCC6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:58:02 -0400
Date: Thu, 3 Apr 2014 02:57:55 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Message-ID: <1439322851.5347.1396493875373.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140402025044.GE4284@linux.vnet.ibm.com>
References: <20140330230856.GA21498@linux.vnet.ibm.com> <1983376434.2684.1396236565608.JavaMail.zimbra@efficios.com> <20140331035458.GJ4284@linux.vnet.ibm.com> <1448966218.2982.1396274543268.JavaMail.zimbra@efficios.com> <20140331153813.GL4284@linux.vnet.ibm.com> <20140331172318.GA4961@linux.vnet.ibm.com> <101799342.3796.1396398904748.JavaMail.zimbra@efficios.com> <20140402025044.GE4284@linux.vnet.ibm.com>
Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: Promela/spin model for NO_HZ_FULL_SYSIDLE code
Thread-Index: yQfiLlyuKZuYFQcnnl/aurDaP2f+3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: fweisbec@gmail.com, peterz@infradead.org, linux-kernel@vger.kernel.org
> Sent: Tuesday, April 1, 2014 10:50:44 PM
> Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
> 
[...]
> > Here is the experiment I did on this latest version: I just enabled the
> > safety checking (not progress). I commented these lines out (again):
> > 
> >                 /* If needed, wake up the timekeeper. */
> >                 if
> >                 //:: oldstate == RCU_SYSIDLE_FULL_NOTED ->
> >                 //      wakeup_timekeeper = 1;
> >                 :: else -> skip;
> >                 fi;
> > 
> > compile and run with:
> > 
> > spin -a sysidle.spin
> > gcc -o pan pan.c
> > ./pan -m1280000 -w22
> > 
> > My expectation would be to trigger some kind of assertion that the
> > timekeeper is not active while the worker is running. Unfortunately,
> > nothing triggers.
> 
> That is expected behavior.  Failure to wake up the timekeeper is set
> up as a progress criterion.
> 
> > I see 3 possible solutions: we could either add assertions into
> > other branches of the timekeeper, or add assertions into the worker
> > thread. Another way to do it would be to express the assertions as
> > negation of a LTL formula based on state variables.
> 
> I did try both a hand-coded "never" clause and LTL formulas without
> success. You have more experience with them, so perhaps you could make
> something work.  The need is that if all worker threads go non-idle
> indefinitely starting from the RCU_SYSIDLE_FULL_NOTED state, the
> wakeup_timekeeper must eventually be set to 1, and then the timekeeper
> must start running, for example, the wakeup_timekeeper value must revert
> to zero.
> 
> The problem I had is that the "never" claims seem set up to catch some
> finite behavior after a possibly-infinite prefix.  In this case, we
> instead need to catch some infinite behavior after a possibly-infinite
> prefix.
> 
> > Thoughts ?
> 
> Me, I eventually switched over to using progress detection.  Which might
> be a bit unconventional, but it did have the virtue of making the
> model complain when it should complain.  ;-)

Here is my attempt at simplifying the model. I use LTL formulas as checks
for the two things I think really matter here: having timekeeping eventually
active when threads are running, and having timekeeping eventually inactive
when threads are idle. Hopefully my Promela is not too rusty:

1) When, at any point in the trail, a worker is setup, then we want to
   be sure that at some point in the future the timer is necessarily
   running:

timer_active.ltl:
[] (am_setup_0 -> (<> timekeeper_is_running))

2) When, at any point in the trail, a worker is not setup, then we
   want to be sure that at some point in the future, either this
   thread is setup again, or the timekeeper reaches a not running
   state:

timer_inactive.ltl:
[] (!am_setup_0 -> (<> (!timekeeper_is_running || am_setup_0)))

sysidle.sh:
#!/bin/sh

spin -f "!(`cat timer_active.ltl`)" > pan.ltl
#spin -f "!(`cat timer_inactive.ltl`)" > pan.ltl
spin -a -X -N  pan.ltl sysidle.spin
#spin -DINJECT_MISSING_WAKEUP -a -X -N  pan.ltl sysidle.spin
gcc -o pan pan.c
./pan -f -a -m1280000 -w22

#view trail with:
# spin -v -t -N pan.ltl sysidle.spin

sysidle.spin:

/*
 * Promela model for CONFIG_NO_HZ_FULL_SYSIDLE=y in the Linux kernel.
 * This model assumes that the dyntick-idle bit manipulation works based
 * on long usage, and substitutes a per-thread boolean "am_busy[]" array
 * for the Linux kernel's dyntick-idle masks.  The focus of this model
 * is therefore on the state machine itself.  Models timekeeper "running"
 * state with respect to worker thread idle state.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, you can access it online at
 * http://www.gnu.org/licenses/gpl-2.0.html.
 *
 * Copyright IBM Corporation, 2014
 * Copyright EfficiOS, 2014
 *
 * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 *         Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 */

// adapt LTL formulas before changing NUM_WORKERS
//#define NUM_WORKERS 2
#define NUM_WORKERS 1
/* Defines used because LTL formula interprets [] */
#define am_setup_0      am_setup[0]
#define am_setup_1      am_setup[1]

byte wakeup_timekeeper = 0; /* Models rcu_kick_nohz_cpu(). */

#define RCU_SYSIDLE_NOT         0       /* Some CPU is not idle. */
#define RCU_SYSIDLE_SHORT       1       /* All CPUs idle for brief period. */
#define RCU_SYSIDLE_LONG        2       /* All CPUs idle for long enough. */
#define RCU_SYSIDLE_FULL        3       /* All CPUs idle, ready for sysidle. */
#define RCU_SYSIDLE_FULL_NOTED  4       /* Actually entered sysidle state. */

byte full_sysidle_state = RCU_SYSIDLE_NOT;

byte am_busy[NUM_WORKERS];  /* Busy is similar to "not dyntick-idle". */
byte am_setup[NUM_WORKERS]; /* Setup means timekeeper knows I am not idle. */

byte timekeeper_is_running = 1; /* Timekeeper initially running */

/*
 * Non-timekeeping CPU going into and out of dyntick-idle state.
 */
proctype worker(byte me)
{
        byte oldstate;

        do
        :: 1 ->
                /* Go idle. */
                am_setup[me] = 0;
                am_busy[me] = 0;

                /* Dyntick-idle in the following loop. */
                do
                :: 1 -> skip;
                :: 1 -> break;
                od;

                /* Exit idle loop, model getting out of dyntick idle state. */
                am_busy[me] = 1;

                /* Get state out of full-system idle states. */
                atomic {
                        oldstate = full_sysidle_state;
                        if
                        :: oldstate > RCU_SYSIDLE_SHORT ->
                                full_sysidle_state = RCU_SYSIDLE_NOT;
                        :: else -> skip;
                        fi;
                }

                /* If needed, wake up the timekeeper. */
                if
                :: oldstate == RCU_SYSIDLE_FULL_NOTED ->
#ifndef INJECT_MISSING_WAKEUP
                        wakeup_timekeeper = 1;
#else
                        skip;
#endif
                :: else -> skip;
                fi;

                /* Mark ourselves fully awake and operational. */
                am_setup[me] = 1;

                /* We are fully awake, so timekeeper must not be asleep. */
                assert(full_sysidle_state < RCU_SYSIDLE_FULL);

                /* Running in kernel in the following loop. */
                do
                :: 1 -> skip;
                :: 1 -> break;
                od;
        od
}

/*
 * Are all the workers in dyntick-idle state?
 */
#define check_idle() \
        i = 0; \
        idle = 1; \
        do \
        :: i < NUM_WORKERS -> \
                if \
                :: am_busy[i] == 1 -> idle = 0; \
                :: else -> skip; \
                fi; \
                i++; \
        :: i >= NUM_WORKERS -> break; \
        od

/*
 * Timekeeping CPU.
 */
proctype timekeeper()
{
        byte i;
        byte idle;
        byte curstate;
        byte newstate;

        do
        :: 1 ->
                /* Capture current state. */
                check_idle();
                curstate = full_sysidle_state;
                newstate = curstate;

                /* Manage state... */
                if
                :: idle == 1 && curstate < RCU_SYSIDLE_FULL_NOTED ->
                        /* Idle, advance to next state. */
                        atomic {
                                if
                                :: full_sysidle_state == curstate ->
                                        newstate = curstate + 1;
                                        full_sysidle_state = newstate;
                                :: else -> skip;
                                fi;
                        }
                :: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
                        /* Non-idle and state advanced, revert to base state. */
                        full_sysidle_state = RCU_SYSIDLE_NOT;
                :: else -> skip;
                fi;

                /* If in RCU_SYSIDLE_FULL_NOTED, wait to be awakened. */
                if
                :: newstate != RCU_SYSIDLE_FULL_NOTED ->
                        skip;
                :: newstate == RCU_SYSIDLE_FULL_NOTED ->
                        timekeeper_is_running = 0;
                        do
                        :: wakeup_timekeeper == 0 ->
                                skip; /* Awaiting wake up */
                        :: else ->
                                timekeeper_is_running = 1;
                                wakeup_timekeeper = 0;
                                break; /* awakened */
                        od;
                fi;
                assert(full_sysidle_state <= RCU_SYSIDLE_FULL_NOTED);
        od;
}

init {
        byte i = 0;

        do
        :: i < NUM_WORKERS ->
                am_busy[i] = 1;
                am_setup[i] = 1;
                run worker(i);
                i++;
        :: i >= NUM_WORKERS -> break;
        od;
        run timekeeper();
}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
