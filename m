Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaFPQXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:23:22 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:32998 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbaFPQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:23:17 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [GIT PULL] nohz: Move nohz kick out of scheduler IPI, v9
Date: Mon, 16 Jun 2014 18:23:10 +0200
Message-Id: <1402935790-19860-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/nohz-irq-work-v7 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work-v7

It has been acked by Peterz.

--- Summary ---

This set moves the nohz kick, used to notify a full dynticks CPU when
events require tick rescheduling, out of the scheduler tick to a
dedicated IPI.

This debloats a bit the scheduler IPI from off-topic work that was
abusing that scheduler fast path for its convenient asynchronous
properties. Now the nohz kick uses irq work for its own needs.

Of course this implied quite some background infrastructure rework,
including:

* Clean up some irq work internals
* Implement remote irq work
* Implement nohz kick on top of remote irq work
* Move full dynticks timer enqueue notification to new kick
* Move multi-task notification to new kick
* Remove unecessary barriers on multi-task notification

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      irq_work: Split raised and lazy lists
      irq_work: Implement remote queueing
      nohz: Support nohz full remote kick
      nohz: Switch to nohz full remote kick on timer enqueue
      nohz: Use nohz own full kick on 2nd task enqueue
      nohz: Use IPI implicit full barrier against rq->nr_running r/w


 include/linux/irq_work.h |  5 ++++
 include/linux/tick.h     |  9 +++++-
 kernel/irq_work.c        | 76 ++++++++++++++++++++++++++++++------------------
 kernel/sched/core.c      | 22 ++++++++------
 kernel/sched/sched.h     | 12 ++++++--
 kernel/smp.c             |  9 ++++++
 kernel/time/tick-sched.c | 10 ++++---
 7 files changed, 97 insertions(+), 46 deletions(-)
