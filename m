Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaGVLaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:30:13 -0400
Received: from relay.parallels.com ([195.214.232.42]:55826 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaGVLaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:30:11 -0400
Message-ID: <1406028601.3526.18.camel@tkhai>
Subject: [PATCH 0/5] sched: Add on_rq states and remove several double rq
 locks
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Ingo Molnar" <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>
Date: Tue, 22 Jul 2014 15:30:01 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series aims to get rid of some places where locks of two RQs are held
at the same time.

Patch [1/5] is a preparation/cleanup. It replaces old (.on_rq == 1) with new
(.on_rq == ONRQ_QUEUED) everywhere. No functional changes.

Patch [2/5] is main in the series. It introduces new state: ONRQ_MIGRATING
and teaches scheduler to understand it (we need a little changes predominantly
in try_to_wake_up()). This will be used in the following way:

	(we are changing task's rq)

        raw_spin_lock(&src_rq->lock);
        dequeue_task(src_rq, p, 0);
        p->on_rq = ONRQ_MIGRATING;
        set_task_cpu(p, dst_cpu);
        raw_spin_unlock(&src_rq->lock);
    
        raw_spin_lock(&dst_rq->lock);
        p->on_rq = ONRQ_QUEUED;
        enqueue_task(dst_rq, p, 0);
        raw_spin_unlock(&dst_rq->lock);

Patches [3-5/5] remove double locks and use new ONRQ_MIGRATING state.
They allow unlocked using of 3-4 function, which looks safe for me.

The series doesn't add any overhead, and it shouldn't worsen performance,
I think. It improves granularity, and it's possible to imagine situations,
which will be happier without double rq lock.

I tested the reliability for 2-3 week (in sum, with breaks) on my work laptop,
and bugs did not happen. Looks like, it's ready for people's review.

Commentaries are welcome. Thanks!

---

Kirill Tkhai (5):
      sched: Wrapper for checking task_struct's .on_rq
      sched: Teach scheduler to understand ONRQ_MIGRATING state
      sched: Remove double_rq_lock() from __migrate_task()
      sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
      sched/fair: Remove double_lock_balance() from load_balance()


 kernel/sched/core.c      |  109 +++++++++++++++++++-------------
 kernel/sched/deadline.c  |   14 ++--
 kernel/sched/fair.c      |  156 +++++++++++++++++++++++++++++-----------------
 kernel/sched/rt.c        |   16 ++---
 kernel/sched/sched.h     |    8 ++
 kernel/sched/stop_task.c |    2 -
 6 files changed, 187 insertions(+), 118 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>


