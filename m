Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaDCRlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:41:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43998 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaDCRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:41:07 -0400
Date: Thu, 3 Apr 2014 10:41:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: fweisbec@gmail.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
Message-ID: <20140403174103.GH4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140330230856.GA21498@linux.vnet.ibm.com>
 <1448966218.2982.1396274543268.JavaMail.zimbra@efficios.com>
 <20140331153813.GL4284@linux.vnet.ibm.com>
 <20140331172318.GA4961@linux.vnet.ibm.com>
 <101799342.3796.1396398904748.JavaMail.zimbra@efficios.com>
 <20140402025044.GE4284@linux.vnet.ibm.com>
 <1439322851.5347.1396493875373.JavaMail.zimbra@efficios.com>
 <20140403172158.GE4284@linux.vnet.ibm.com>
 <6694620.5882.1396546438476.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6694620.5882.1396546438476.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040317-0928-0000-0000-000000E49C73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 05:33:58PM +0000, Mathieu Desnoyers wrote:
> ----- Original Message -----
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Cc: fweisbec@gmail.com, peterz@infradead.org, linux-kernel@vger.kernel.org
> > Sent: Thursday, April 3, 2014 1:21:58 PM
> > Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
> > 
> > On Thu, Apr 03, 2014 at 02:57:55AM +0000, Mathieu Desnoyers wrote:
> > > ----- Original Message -----
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > > > Cc: fweisbec@gmail.com, peterz@infradead.org,
> > > > linux-kernel@vger.kernel.org
> > > > Sent: Tuesday, April 1, 2014 10:50:44 PM
> > > > Subject: Re: Promela/spin model for NO_HZ_FULL_SYSIDLE code
> > > > 
> > > [...]
> > > > > Here is the experiment I did on this latest version: I just enabled the
> > > > > safety checking (not progress). I commented these lines out (again):
> > > > > 
> > > > >                 /* If needed, wake up the timekeeper. */
> > > > >                 if
> > > > >                 //:: oldstate == RCU_SYSIDLE_FULL_NOTED ->
> > > > >                 //      wakeup_timekeeper = 1;
> > > > >                 :: else -> skip;
> > > > >                 fi;
> > > > > 
> > > > > compile and run with:
> > > > > 
> > > > > spin -a sysidle.spin
> > > > > gcc -o pan pan.c
> > > > > ./pan -m1280000 -w22
> > > > > 
> > > > > My expectation would be to trigger some kind of assertion that the
> > > > > timekeeper is not active while the worker is running. Unfortunately,
> > > > > nothing triggers.
> > > > 
> > > > That is expected behavior.  Failure to wake up the timekeeper is set
> > > > up as a progress criterion.
> > > > 
> > > > > I see 3 possible solutions: we could either add assertions into
> > > > > other branches of the timekeeper, or add assertions into the worker
> > > > > thread. Another way to do it would be to express the assertions as
> > > > > negation of a LTL formula based on state variables.
> > > > 
> > > > I did try both a hand-coded "never" clause and LTL formulas without
> > > > success. You have more experience with them, so perhaps you could make
> > > > something work.  The need is that if all worker threads go non-idle
> > > > indefinitely starting from the RCU_SYSIDLE_FULL_NOTED state, the
> > > > wakeup_timekeeper must eventually be set to 1, and then the timekeeper
> > > > must start running, for example, the wakeup_timekeeper value must revert
> > > > to zero.
> > > > 
> > > > The problem I had is that the "never" claims seem set up to catch some
> > > > finite behavior after a possibly-infinite prefix.  In this case, we
> > > > instead need to catch some infinite behavior after a possibly-infinite
> > > > prefix.
> > > > 
> > > > > Thoughts ?
> > > > 
> > > > Me, I eventually switched over to using progress detection.  Which might
> > > > be a bit unconventional, but it did have the virtue of making the
> > > > model complain when it should complain.  ;-)
> > > 
> > > Here is my attempt at simplifying the model. I use LTL formulas as checks
> > > for the two things I think really matter here: having timekeeping
> > > eventually
> > > active when threads are running, and having timekeeping eventually inactive
> > > when threads are idle. Hopefully my Promela is not too rusty:
> > 
> > Well, this was the first time I had ever tried using LTL or never claims,
> > so you are ahead of me either way.  ;-)
> > 
> > > 1) When, at any point in the trail, a worker is setup, then we want to
> > >    be sure that at some point in the future the timer is necessarily
> > >    running:
> > > 
> > > timer_active.ltl:
> > > [] (am_setup_0 -> (<> timekeeper_is_running))
> > 
> > OK, am_setup_0 implies that the timekeeper will eventually be running.
> > For two threads, this presumably becomes:
> > 
> > [] ((am_setup_0 || am_setup_1) -> (<> timekeeper_is_running))
> 
> Yes.
> 
> > 
> > > 2) When, at any point in the trail, a worker is not setup, then we
> > >    want to be sure that at some point in the future, either this
> > >    thread is setup again, or the timekeeper reaches a not running
> > >    state:
> > > 
> > > timer_inactive.ltl:
> > > [] (!am_setup_0 -> (<> (!timekeeper_is_running || am_setup_0)))
> > 
> > And here the two-thread version should be something like this:
> > 
> > [] (!(am_setup_0 || am_setup_1) -> (<> (!timekeeper_is_running || am_setup_0
> > || am_setup_1)))
> 
> Yes, I think. Should be double-checked and tested though.

I did test all four options in the sysidle.sh file with both the original
and two-thread LTL claims, and got the expected results.  Need something
to force failures in the other LTL formula, of course.

> > It would be nice if never claims allowed local variables, as that would
> > allow looping over the am_setup array.  Or maybe I just haven't figured
> > out how to tell spin that a given variable should not be considered to
> > be part of the global state.
> 
> AFAIU, we're very limited in what we can put in LTL. You could generate
> a never claim by hand (see the generated pan.ltl as an example), and maybe
> have more luck.

Any time I tried to assign to anything from within a "never" claim,
it yelled at me.  ;-)

> > > sysidle.sh:
> > > #!/bin/sh
> > > 
> > > spin -f "!(`cat timer_active.ltl`)" > pan.ltl
> > > #spin -f "!(`cat timer_inactive.ltl`)" > pan.ltl
> > > spin -a -X -N  pan.ltl sysidle.spin
> > > #spin -DINJECT_MISSING_WAKEUP -a -X -N  pan.ltl sysidle.spin
> > 
> > I definitely didn't use "-X".  The "spin --help" says "-[XYZ] reserved
> > for use by xspin interface", so maybe it doesn't matter.  ;-)
> 
> Hopefully. I grabbed the "-X" option from the urcu models. I don't
> remember why we have it there.

Ah!  ;-)

> > > gcc -o pan pan.c
> > > ./pan -f -a -m1280000 -w22
> > > 
> > > #view trail with:
> > > # spin -v -t -N pan.ltl sysidle.spin
> > 
> > Interesting.  I have put this into a separate branch.  May I use your
> > Signed-off-by?
> 
> Yes, of course.

Very good, thank you!

> > I need to play around a bit more with LTL and progress labels!
> 
> For progress, you'll want to add progress labels within the model, and
> do a LTL formula checking the _np special variable.

I did use the progress labels, but used -DNP rather than the LTL _np
special variable.

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> 
> > 
> > 							Thanx, Paul
> > 
> > > sysidle.spin:
> > > 
> > > /*
> > >  * Promela model for CONFIG_NO_HZ_FULL_SYSIDLE=y in the Linux kernel.
> > >  * This model assumes that the dyntick-idle bit manipulation works based
> > >  * on long usage, and substitutes a per-thread boolean "am_busy[]" array
> > >  * for the Linux kernel's dyntick-idle masks.  The focus of this model
> > >  * is therefore on the state machine itself.  Models timekeeper "running"
> > >  * state with respect to worker thread idle state.
> > >  *
> > >  * This program is free software; you can redistribute it and/or modify
> > >  * it under the terms of the GNU General Public License as published by
> > >  * the Free Software Foundation; either version 2 of the License, or
> > >  * (at your option) any later version.
> > >  *
> > >  * This program is distributed in the hope that it will be useful,
> > >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > >  * GNU General Public License for more details.
> > >  *
> > >  * You should have received a copy of the GNU General Public License
> > >  * along with this program; if not, you can access it online at
> > >  * http://www.gnu.org/licenses/gpl-2.0.html.
> > >  *
> > >  * Copyright IBM Corporation, 2014
> > >  * Copyright EfficiOS, 2014
> > >  *
> > >  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >  *         Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > >  */
> > > 
> > > // adapt LTL formulas before changing NUM_WORKERS
> > > //#define NUM_WORKERS 2
> > > #define NUM_WORKERS 1
> > > /* Defines used because LTL formula interprets [] */
> > > #define am_setup_0      am_setup[0]
> > > #define am_setup_1      am_setup[1]
> > > 
> > > byte wakeup_timekeeper = 0; /* Models rcu_kick_nohz_cpu(). */
> > > 
> > > #define RCU_SYSIDLE_NOT         0       /* Some CPU is not idle. */
> > > #define RCU_SYSIDLE_SHORT       1       /* All CPUs idle for brief period.
> > > */
> > > #define RCU_SYSIDLE_LONG        2       /* All CPUs idle for long enough.
> > > */
> > > #define RCU_SYSIDLE_FULL        3       /* All CPUs idle, ready for
> > > sysidle. */
> > > #define RCU_SYSIDLE_FULL_NOTED  4       /* Actually entered sysidle state.
> > > */
> > > 
> > > byte full_sysidle_state = RCU_SYSIDLE_NOT;
> > > 
> > > byte am_busy[NUM_WORKERS];  /* Busy is similar to "not dyntick-idle". */
> > > byte am_setup[NUM_WORKERS]; /* Setup means timekeeper knows I am not idle.
> > > */
> > > 
> > > byte timekeeper_is_running = 1; /* Timekeeper initially running */
> > > 
> > > /*
> > >  * Non-timekeeping CPU going into and out of dyntick-idle state.
> > >  */
> > > proctype worker(byte me)
> > > {
> > >         byte oldstate;
> > > 
> > >         do
> > >         :: 1 ->
> > >                 /* Go idle. */
> > >                 am_setup[me] = 0;
> > >                 am_busy[me] = 0;
> > > 
> > >                 /* Dyntick-idle in the following loop. */
> > >                 do
> > >                 :: 1 -> skip;
> > >                 :: 1 -> break;
> > >                 od;
> > > 
> > >                 /* Exit idle loop, model getting out of dyntick idle state.
> > >                 */
> > >                 am_busy[me] = 1;
> > > 
> > >                 /* Get state out of full-system idle states. */
> > >                 atomic {
> > >                         oldstate = full_sysidle_state;
> > >                         if
> > >                         :: oldstate > RCU_SYSIDLE_SHORT ->
> > >                                 full_sysidle_state = RCU_SYSIDLE_NOT;
> > >                         :: else -> skip;
> > >                         fi;
> > >                 }
> > > 
> > >                 /* If needed, wake up the timekeeper. */
> > >                 if
> > >                 :: oldstate == RCU_SYSIDLE_FULL_NOTED ->
> > > #ifndef INJECT_MISSING_WAKEUP
> > >                         wakeup_timekeeper = 1;
> > > #else
> > >                         skip;
> > > #endif
> > >                 :: else -> skip;
> > >                 fi;
> > > 
> > >                 /* Mark ourselves fully awake and operational. */
> > >                 am_setup[me] = 1;
> > > 
> > >                 /* We are fully awake, so timekeeper must not be asleep. */
> > >                 assert(full_sysidle_state < RCU_SYSIDLE_FULL);
> > > 
> > >                 /* Running in kernel in the following loop. */
> > >                 do
> > >                 :: 1 -> skip;
> > >                 :: 1 -> break;
> > >                 od;
> > >         od
> > > }
> > > 
> > > /*
> > >  * Are all the workers in dyntick-idle state?
> > >  */
> > > #define check_idle() \
> > >         i = 0; \
> > >         idle = 1; \
> > >         do \
> > >         :: i < NUM_WORKERS -> \
> > >                 if \
> > >                 :: am_busy[i] == 1 -> idle = 0; \
> > >                 :: else -> skip; \
> > >                 fi; \
> > >                 i++; \
> > >         :: i >= NUM_WORKERS -> break; \
> > >         od
> > > 
> > > /*
> > >  * Timekeeping CPU.
> > >  */
> > > proctype timekeeper()
> > > {
> > >         byte i;
> > >         byte idle;
> > >         byte curstate;
> > >         byte newstate;
> > > 
> > >         do
> > >         :: 1 ->
> > >                 /* Capture current state. */
> > >                 check_idle();
> > >                 curstate = full_sysidle_state;
> > >                 newstate = curstate;
> > > 
> > >                 /* Manage state... */
> > >                 if
> > >                 :: idle == 1 && curstate < RCU_SYSIDLE_FULL_NOTED ->
> > >                         /* Idle, advance to next state. */
> > >                         atomic {
> > >                                 if
> > >                                 :: full_sysidle_state == curstate ->
> > >                                         newstate = curstate + 1;
> > >                                         full_sysidle_state = newstate;
> > >                                 :: else -> skip;
> > >                                 fi;
> > >                         }
> > >                 :: idle == 0 && full_sysidle_state >= RCU_SYSIDLE_LONG ->
> > >                         /* Non-idle and state advanced, revert to base
> > >                         state. */
> > >                         full_sysidle_state = RCU_SYSIDLE_NOT;
> > >                 :: else -> skip;
> > >                 fi;
> > > 
> > >                 /* If in RCU_SYSIDLE_FULL_NOTED, wait to be awakened. */
> > >                 if
> > >                 :: newstate != RCU_SYSIDLE_FULL_NOTED ->
> > >                         skip;
> > >                 :: newstate == RCU_SYSIDLE_FULL_NOTED ->
> > >                         timekeeper_is_running = 0;
> > >                         do
> > >                         :: wakeup_timekeeper == 0 ->
> > >                                 skip; /* Awaiting wake up */
> > >                         :: else ->
> > >                                 timekeeper_is_running = 1;
> > >                                 wakeup_timekeeper = 0;
> > >                                 break; /* awakened */
> > >                         od;
> > >                 fi;
> > >                 assert(full_sysidle_state <= RCU_SYSIDLE_FULL_NOTED);
> > >         od;
> > > }
> > > 
> > > init {
> > >         byte i = 0;
> > > 
> > >         do
> > >         :: i < NUM_WORKERS ->
> > >                 am_busy[i] = 1;
> > >                 am_setup[i] = 1;
> > >                 run worker(i);
> > >                 i++;
> > >         :: i >= NUM_WORKERS -> break;
> > >         od;
> > >         run timekeeper();
> > > }
> > > 
> > > --
> > > Mathieu Desnoyers
> > > EfficiOS Inc.
> > > http://www.efficios.com
> > > 
> > 
> > 
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 

