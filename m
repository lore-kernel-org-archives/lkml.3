Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaG3Voh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:44:37 -0400
Received: from forward3l.mail.yandex.net ([84.201.143.136]:40904 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaG3Vms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:42:48 -0400
X-Yandex-Uniq: 1a3369ed-4a13-4329-8f60-377b7f55cfe5
Authentication-Results: smtp1o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 0/5] sched: Add on_rq states and remove several double rq
 locks
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Thu, 31 Jul 2014 01:42:35 +0400
Message-ID: <20140730213219.27604.11218.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series aims to get rid of some places where locks of two RQs are held
at the same time.

Patch [1/5] is a preparation/cleanup. It replaces old (task_struct::on_rq == 1)
with new (task_struct::on_rq == ONRQ_QUEUED) everywhere. No functional changes.

Patch [2/5] is main in the series. It introduces new ONRQ_MIGRATING state and
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
	 * Now p os dequeued, and both
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

Patches [3,4,5/5] remove double locks and use new ONRQ_MIGRATING state.
They allow unlocked using of 3-4 function, which looks safe for me.

The profit is double_rq_lock() is not need now, so we reduce the
total time when RQs are locked.

---

Kirill Tkhai (5):
      sched: Wrapper for checking task_struct::on_rq
      sched: Teach scheduler to understand ONRQ_MIGRATING state
      sched: Remove double_rq_lock() from __migrate_task()
      sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
      sched/fair: Remove double_lock_balance() from load_balance()


 kernel/sched/core.c      |  115 +++++++++++++++++--------------
 kernel/sched/deadline.c  |   14 ++--
 kernel/sched/fair.c      |  172 +++++++++++++++++++++++++++++++---------------
 kernel/sched/rt.c        |   16 ++--
 kernel/sched/sched.h     |   13 +++
 kernel/sched/stop_task.c |    2 -
 6 files changed, 211 insertions(+), 121 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
