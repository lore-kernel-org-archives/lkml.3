Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3F1UKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:10:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36018 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3F1UJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:09:59 -0400
Date: Fri, 28 Jun 2013 13:09:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for full-system
 idle
Message-ID: <20130628200949.GA17458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062820-7182-0000-0000-00000792FDD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever there is at least one non-idle CPU, it is necessary to
periodically update timekeeping information.  Before NO_HZ_FULL, this
updating was carried out by the scheduling-clock tick, which ran on
every non-idle CPU.  With the advent of NO_HZ_FULL, it is possible
to have non-idle CPUs that are not receiving scheduling-clock ticks.
This possibility is handled by assigning a timekeeping CPU that continues
taking scheduling-clock ticks.

Unfortunately, timekeeping CPU continues taking scheduling-clock
interrupts even when all other CPUs are completely idle, which is
not so good for energy efficiency and battery lifetime.  Clearly, it
would be good to turn off the timekeeping CPU's scheduling-clock tick
when all CPUs are completely idle.  This is conceptually simple, but
we also need good performance and scalability on large systems, which
rules out implementations based on frequently updated global counts of
non-idle CPUs as well as implementations that frequently scan all CPUs.
Nevertheless, we need a single global indicator in order to keep the
overhead of checking acceptably low.

The chosen approach is to enforce hysteresis on the non-idle to
full-system-idle transition, with the amount of hysteresis increasing
linearly with the number of CPUs, thus keeping contention acceptably low.
This approach piggybacks on RCU's existing force-quiescent-state scanning
of idle CPUs, which has the advantage of avoiding the scan entirely on
busy systems that have high levels of multiprogramming.  This scan
takes per-CPU idleness information and feeds it into a state machine
that applies the level of hysteresis required to arrive at a single
full-system-idle indicator.

The individual patches are as follows:

1.	Add a CONFIG_NO_HZ_FULL_SYSIDLE Kconfig parameter to enable
	this feature.  Kernels built with CONFIG_NO_HZ_FULL_SYSIDLE=n
	act exactly as they do today.

2.	Add new fields to the rcu_dynticks structure that track CPU-idle
	information.  These fields consider CPUs running usermode to be
	non-idle, in contrast with the existing fields in that structure.

3.	Track per-CPU idle states.

4.	Add full-system idle states and state variables.

5.	Expand force_qs_rnp(), dyntick_save_progress_counter(), and
	rcu_implicit_dynticks_qs() APIs to enable passing full-system
	idle state information.

6.	Add full-system-idle state machine.

7.	Force RCU's grace-period kthreads onto the timekeeping CPU.

Changes since v1:

o	Removed NMI support because NMI handlers cannot safely read
	the time anyway (thanks to Thomas Gleixner and Peter Zijlstra).

						Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |   18 +
 b/kernel/rcutree.c         |   49 ++++-
 b/kernel/rcutree.h         |   17 +
 b/kernel/rcutree_plugin.h  |  407 ++++++++++++++++++++++++++++++++++++++++++++-
 b/kernel/time/Kconfig      |   23 ++
 5 files changed, 499 insertions(+), 15 deletions(-)

