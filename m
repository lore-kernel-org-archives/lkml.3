Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaFJPPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:15:22 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61474 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaFJPPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:15:21 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 0/6] nohz: Move nohz kick out of scheduler IPI, v8
Date: Tue, 10 Jun 2014 17:15:03 +0200
Message-Id: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this set happens to have more changes than expected because I
found out that the timer list full nohz kick also relies on the scheduler
IPI. So I had to convert it as well, hence a few more change splitups.

Changes:

* Check also raised lists from irq_work_needs_cpu() (thanks Peterz)

* Comment on SMP functions priority in
  generic_smp_call_function_single_interrupt() because IPI callbacks there
  are often synchronous as opposed to irq works. (thanks Peterz)

* s/native_send_call_func_single_ipi/native_send_call_func_single_ipi
  (thanks Eric Dumazet)

* Only build irq_work_queue_on() on CONFIG_SMP, fixes some broken builds

* Convert full nohz timer list kick

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-irq-work-v6

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
