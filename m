Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3HRDNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 23:13:53 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39348 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3HRDNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 23:13:52 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 20:13:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/9] sysidle changes for v3.12
Message-ID: <20130818031341.GK28923@leaf>
References: <20130818014918.GA27827@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818014918.GA27827@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:49:18PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> Whenever there is at least one non-idle CPU, it is necessary to
> periodically update timekeeping information.  Before NO_HZ_FULL, this
> updating was carried out by the scheduling-clock tick, which ran on
> every non-idle CPU.  With the advent of NO_HZ_FULL, it is possible
> to have non-idle CPUs that are not receiving scheduling-clock ticks.
> This possibility is handled by assigning a timekeeping CPU that continues
> taking scheduling-clock ticks.
> 
> Unfortunately, timekeeping CPU continues taking scheduling-clock
> interrupts even when all other CPUs are completely idle, which is
> not so good for energy efficiency and battery lifetime.  Clearly, it
> would be good to turn off the timekeeping CPU's scheduling-clock tick
> when all CPUs are completely idle.  This is conceptually simple, but
> we also need good performance and scalability on large systems, which
> rules out implementations based on frequently updated global counts of
> non-idle CPUs as well as implementations that frequently scan all CPUs.
> Nevertheless, we need a single global indicator in order to keep the
> overhead of checking acceptably low.
> 
> The chosen approach is to enforce hysteresis on the non-idle to
> full-system-idle transition, with the amount of hysteresis increasing
> linearly with the number of CPUs, thus keeping contention acceptably low.
> This approach piggybacks on RCU's existing force-quiescent-state scanning
> of idle CPUs, which has the advantage of avoiding the scan entirely on
> busy systems that have high levels of multiprogramming.  This scan
> takes per-CPU idleness information and feeds it into a state machine
> that applies the level of hysteresis required to arrive at a single
> full-system-idle indicator.
> 
> The individual patches are as follows:
> 
> 1.	Eliminate unused APIs that were intended for adaptive ticks.
> 
> 2.	Add documentation covering the testing of nohz_full.
> 
> 3.	Add a CONFIG_NO_HZ_FULL_SYSIDLE Kconfig parameter to enable
> 	this feature.  Kernels built with CONFIG_NO_HZ_FULL_SYSIDLE=n
> 	act exactly as they do today.
> 
> 4.	Add new fields to the rcu_dynticks structure that track CPU-idle
> 	information.  These fields consider CPUs running usermode to be
> 	non-idle, in contrast with the existing fields in that structure.
> 
> 5.	Track per-CPU idle states.
> 
> 6.	Add full-system idle states and state variables.
> 
> 7.	Expand force_qs_rnp(), dyntick_save_progress_counter(), and
> 	rcu_implicit_dynticks_qs() APIs to enable passing full-system
> 	idle state information.
> 
> 8.	Add full-system-idle state machine.
> 
> 9.	Force RCU's grace-period kthreads onto the timekeeping CPU.

Comments on 4, 5, and 6; for 1-3 and 7-9,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
