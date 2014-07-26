Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaGZO65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:58:57 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:51539 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaGZO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:58:55 -0400
X-Yandex-Uniq: fcb660ba-908e-496b-9c39-bc4f6e4c5be0
Authentication-Results: smtp7.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 0/5] sched: Add on_rq states and remove several double rq
 locks
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Sat, 26 Jul 2014 18:58:48 +0400
Message-ID: <20140726145508.6308.69121.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

v2: Changes in [2/5] and [5/5].

---

Kirill Tkhai (5):
      sched: Wrapper for checking task_struct's .on_rq
      sched: Teach scheduler to understand ONRQ_MIGRATING state
      sched: Remove double_rq_lock() from __migrate_task()
      sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
      sched/fair: Remove double_lock_balance() from load_balance()


 kernel/sched/core.c      |  123 +++++++++++++++++++++++--------------
 kernel/sched/deadline.c  |   14 ++--
 kernel/sched/fair.c      |  155 ++++++++++++++++++++++++++++++----------------
 kernel/sched/rt.c        |   16 ++---
 kernel/sched/sched.h     |   13 ++++
 kernel/sched/stop_task.c |    2 -
 6 files changed, 206 insertions(+), 117 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
