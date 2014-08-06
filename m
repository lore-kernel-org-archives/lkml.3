Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaHFIGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:06:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:51356 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaHFIGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:06:04 -0400
Message-ID: <1407312354.8424.34.camel@tkhai>
Subject: [PATCH v4 0/6] sched: Add on_rq states and remove several double rq
 locks
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <peterz@infradead.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>, <tkhai@yandex.ru>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>,
        <nicolas.pitre@linaro.org>
Date: Wed, 6 Aug 2014 12:05:54 +0400
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

Patch [1/6] is a fix/preparation. It's new in v4 version of series.

Patch [2/6] is a preparation/cleanup. It replaces old (task_struct::on_rq == 1)
with new (task_struct::on_rq == ONRQ_QUEUED) everywhere. No functional changes.

Patch [3/6] is main in the series. It introduces new ONRQ_MIGRATING state and
teaches scheduler to understand it (we need little changes in try_to_wake_up()
and task_rq_lock() family). This will be used in the following way:

        (we are changing task's rq)

        raw_spin_lock(&src_rq->lock);

        p = ...; /* Some src_rq task */

        dequeue_task(src_rq, p, 0);
        p->on_rq = ONRQ_MIGRATING;
        set_task_cpu(p, dst_cpu);
        raw_spin_unlock(&src_rq->lock);

        /*
         * Now p is dequeued, and both
         * RQ locks are unlocked, but
         * its on_rq is not zero.
         * Nobody can manipulate p
         * while it's migrating,
         * even when spinlocks are
         * unlocked.
         */

        raw_spin_lock(&dst_rq->lock);
        p->on_rq = ONRQ_QUEUED;
        enqueue_task(dst_rq, p, 0);
        raw_spin_unlock(&dst_rq->lock);

Patches [4,5,6/6] remove double locks and use new ONRQ_MIGRATING state.
They allow unlocked using of 3-4 function, which looks safe for me.

The profit is double_rq_lock() is not need now, so we reduce the
total time when RQs are locked.



---

v4: New patch [1/6]

Kirill Tkhai (6):
      sched/fair: Fix reschedule which is generated on throttled cfs_rq
      sched: Wrapper for checking task_struct::on_rq
      sched: Teach scheduler to understand ONRQ_MIGRATING state
      sched: Remove double_rq_lock() from __migrate_task()
      sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
      sched/fair: Remove double_lock_balance() from load_balance()


 kernel/sched/core.c      |  115 +++++++++++++++++-------------
 kernel/sched/deadline.c  |   14 ++--
 kernel/sched/fair.c      |  174 +++++++++++++++++++++++++++++++---------------
 kernel/sched/rt.c        |   16 ++--
 kernel/sched/sched.h     |   13 +++
 kernel/sched/stop_task.c |    2 -
 6 files changed, 212 insertions(+), 122 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>


