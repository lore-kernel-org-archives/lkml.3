Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaBYMgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:36:45 -0500
Received: from asav4.altibox.net ([81.167.36.153]:49791 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBYMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:36:40 -0500
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linuxtronix.de>
Cc: Henrik Austad <haustad@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/6 v2] Expose do_timer CPU as RW to userspace
Date: Tue, 25 Feb 2014 13:33:55 +0100
Message-Id: <1393331641-14016-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

Hi!

This is a rework of the preiovus patch based on the feedback gathered
from the last round. I've split it up a bit, mostly to make it easier to
single out the parts that require more attention (#4 comes to mind).

Being able to read (and possible force a specific CPU to handle all
do_timer() updates) can be very handy when debugging a system and tuning
for performance. It is not always easy to route interrupts to a specific
core (or away from one, for that matter).

These patches therefore enables userspace to explicitly set which core
to handle do_timer(), regardless of NO_HZ_FULL or NO_HZ_IDLE.


Tested on x86_64 (in a VM with 8 emulated cores). Dumping the cores
every 100ms using

for i in $(seq 1 300); do
    cat /sys/kernel/timekeeping/current_cpu ;
    sleep 0.1;
done|sort -n|uniq -c

* CONFIG_NO_HZ_FULL:

Forced timer disabled
     38 -1
      6 0
     12 1
      9 2
      4 3
      5 4
    176 5
      4 6
     46 7

sysctl -w kernel.forced_timer_cpu=3
    300 3

* CONFIG_NO_HZ_FULL_ALL:

Forced timer disabled
    300 0
sysctl -w kernel.forced_timer_cpu=2
    300 2



* CONFIG_NO_HZ_IDLE

Forced timer disabled
     38 -1
     35 0
     20 1
     23 2
     69 3
     30 4
     39 5
     22 6
     24 7
sysctl -w kernel.forced_timer_cpu=4
    300 4

* CONFIG_HZ_PERIODIC

Forced timer disabled
    300 0

sysctl -w kernel.forced_timer_cpu=5
    300 5


I also took the liberty of adding paulmck as RCU is testing for
tick_do_timer_cpu in tree_plugin.h I don't expect RCU to blow up, but
better safe than sorry and all.

The series include
Patch 1:
  Make tick_do_timer_cpu readable from other parts of the kernel

Patch 2:
  Based on #1, add a simple sysfs interface for reading it from
  userspace. This also lays the foundation for #6.

Patch 3:
  Add sysctl-hook for exposing tick_do_timer_cpu to userspace.

Patch 4:
  Add support for forcing a specific core to handle all do_timer()
  updates. This is probably the patch that requires the most careful
  review.

Patch 5:
  Allow for setting/getting forced_cpu via sysctl

Patch 6:
  Allow for setting/getting forced_cpu via sysfs

Series is based on Linus' current upstream head 7472e0.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: John Stultz <john.stultz@linaro.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Henrik Austad (6):
  Expose do_timer CPU from tick-common
  Add sysfs RO interface to tick_do_timer_cpu
  Expose do_timer CPU as RO variable to userspace via sysctl
  Force a specific CPU to handle all do_timer() events.
  Expose the forced_timer_cpu to userspace via sysctl as R/W
  Expose tick_set_forced_cpu() via sysfs

 include/linux/clocksource.h |   19 +++++++
 kernel/sysctl.c             |   15 ++++++
 kernel/time/tick-common.c   |  115 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-internal.h |    5 ++
 kernel/time/tick-sched.c    |   14 +++++-
 kernel/time/timekeeping.c   |  110 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 277 insertions(+), 1 deletion(-)

-- 
1.7.9.5

