Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3FZWYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:24:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53378 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3FZWYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:24:48 -0400
Date: Wed, 26 Jun 2013 15:24:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
Message-ID: <20130626222442.GU3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <20130626122022.GI28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626122022.GI28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062622-5406-0000-0000-000009E3B447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:20:22PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 25, 2013 at 02:37:21PM -0700, Paul E. McKenney wrote:
> > Whenever there is at least one non-idle CPU, it is necessary to
> > periodically update timekeeping information.  Before NO_HZ_FULL, this
> > updating was carried out by the scheduling-clock tick, which ran on
> > every non-idle CPU.  With the advent of NO_HZ_FULL, it is possible
> > to have non-idle CPUs that are not receiving scheduling-clock ticks.
> > This possibility is handled by assigning a timekeeping CPU that continues
> > taking scheduling-clock ticks.
> > 
> > Unfortunately, timekeeping CPU continues taking scheduling-clock
> > interrupts even when all other CPUs are completely idle, which is
> > not so good for energy efficiency and battery lifetime.  Clearly, it
> > would be good to turn off the timekeeping CPU's scheduling-clock tick
> > when all CPUs are completely idle.  This is conceptually simple, but
> > we also need good performance and scalability on large systems, which
> > rules out implementations based on frequently updated global counts of
> > non-idle CPUs as well as implementations that frequently scan all CPUs.
> > Nevertheless, we need a single global indicator in order to keep the
> > overhead of checking acceptably low.
> > 
> > The chosen approach is to enforce hysteresis on the non-idle to
> > full-system-idle transition, with the amount of hysteresis increasing
> > linearly with the number of CPUs, thus keeping contention acceptably low.
> > This approach piggybacks on RCU's existing force-quiescent-state scanning
> > of idle CPUs, which has the advantage of avoiding the scan entirely on
> > busy systems that have high levels of multiprogramming.  This scan
> > take per-CPU idleness information and feeds it into a state machine
> > that applies the level of hysteresis required to arrive at a single
> > full-system-idle indicator.
> > 
> > Note that this version pays attention to CPUs that have taken an NMI
> > from idle.  It is not clear to me that NMI handlers can safely access
> > the time on a system that is long-term idle.  Unless someone tells me
> > that it is somehow safe to access time from an NMI from idle, I will
> > remove NMI support in the next version.
> 
> Using perf it is 'possible' to come near; we use local_clock() from NMI
> context. It will do a TSC read.
> 
> On systems where the TSC is usable we'll end up with a sane timestamp;
> on systems where we need the whole kernel/sched/clock.c song and dance
> routine we'll return a stable time-stamp when called from long idle.
> 
> I don't think there's anything we can do better there.

Just to make sure I understand...  You are saying that it is OK for
NO_HZ_FULL to shut down timekeeping if all CPUs are idle, even if some
of them are taking NMIs from time to time, right?

							Thanx, Paul

