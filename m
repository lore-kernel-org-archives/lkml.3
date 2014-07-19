Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaGSAo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:44:29 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47672 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaGSAo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:44:28 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC PATCH 00/10] nohz: Support sysidle (and some more cleanups)
Date: Sat, 19 Jul 2014 02:44:11 +0200
Message-Id: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when nohz full is active, the CPU 0 handles timekeeping on
behalf of all other CPUs. This prevents it from ever entering in dynticks
idle mode.

This patchset uses the RCU sysidle feature to allow that. The CPU 0 can
know safely when to sleep and when to wake up, the sysidle code determines
that and takes care of races along the way.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/sysidle

Thanks,
	Frederic
---

Frederic Weisbecker (10):
      irq_work: Introduce void irq work
      nohz: Kick full dynticks timer targets with an empty IPI
      rcu: Kick full dynticks CPU on extended grace period with a void IRQ
      nohz: Appropriate timekeeper kick on sysidle break
      smp: Fast path check on IPI list
      nohz: Define meaningful symbol for nohz full timekeeper
      nohz: Enforce timekeeping on CPU 0
      nohz: Fetch timekeeping max deferment only for timekeeper
      nohz: Switch nohz full timekeeper to dynticks idle on top of sysidle detection
      nohz: Warn on illegal timekeeper switch in nohz full


 include/linux/irq_work.h    |  1 +
 kernel/irq_work.c           | 21 +++++++++++++
 kernel/rcu/tree_plugin.h    | 10 ++++---
 kernel/sched/core.c         |  2 +-
 kernel/smp.c                | 11 ++++++-
 kernel/time/tick-common.c   | 11 ++++---
 kernel/time/tick-internal.h |  8 +++++
 kernel/time/tick-sched.c    | 72 ++++++++++++++++++++++-----------------------
 8 files changed, 88 insertions(+), 48 deletions(-)
