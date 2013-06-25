Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3FYVh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:37:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60239 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3FYVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:37:28 -0400
Date: Tue, 25 Jun 2013 14:37:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system idle
Message-ID: <20130625213721.GA19452@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062521-4834-0000-0000-0000086749AC
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
take per-CPU idleness information and feeds it into a state machine
that applies the level of hysteresis required to arrive at a single
full-system-idle indicator.

Note that this version pays attention to CPUs that have taken an NMI
from idle.  It is not clear to me that NMI handlers can safely access
the time on a system that is long-term idle.  Unless someone tells me
that it is somehow safe to access time from an NMI from idle, I will
remove NMI support in the next version.

						Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |   18 +
 b/kernel/rcutree.c         |   56 ++++-
 b/kernel/rcutree.h         |   20 ++
 b/kernel/rcutree_plugin.h  |  427 ++++++++++++++++++++++++++++++++++++++++++++-
 b/kernel/time/Kconfig      |   23 ++
 5 files changed, 527 insertions(+), 17 deletions(-)

