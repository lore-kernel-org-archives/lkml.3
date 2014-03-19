Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaCSS2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:28:30 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:43341 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaCSS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:28:28 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jens Axboe <axboe@fb.com>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/3] nohz: Move nohz kick out of scheduler IPI
Date: Wed, 19 Mar 2014 19:28:19 +0100
Message-Id: <1395253702-12489-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a full dynticks CPU runs in single task mode then a new task gets
enqueued, we notify it through an IPI such that it restarts its tick.

The IPI used here is the scheduler IPI. There are a few reasons for that:
it can be called when interrupts are disabled, it can be called
concurrently... These properties altogether aren't offered by the IPI
subsystem.

Meanwhile, bloating that way the scheduler IPI with scheduler unrelated
code is an abuse of this fast path. We certainly don't want to start a
big kernel IPI (BKI, the new shiny piece of my collection of big kernel
things aside the big kernel tick, the big reiserfs lock, ..).

So this patchset adds a small helper to the IPI subsystem that allows
to queue an IPI from interrupt disabled code and handles concurrent
callers as well. Eventually the nohz kick gets converted to this new facility.

Partly inspired by a suggestion from Peter Zijlstra.

Comments?

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/ipi

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      smp: Non busy-waiting IPI queue
      nohz: Move full nohz kick to its own IPI
      nohz: Use IPI implicit full barrier against rq->nr_running r/w


 include/linux/smp.h      | 12 ++++++++++++
 include/linux/tick.h     |  2 ++
 kernel/sched/core.c      | 14 ++++++--------
 kernel/sched/sched.h     | 12 +++++++++---
 kernel/smp.c             | 24 ++++++++++++++++++++++++
 kernel/time/tick-sched.c | 20 ++++++++++++++++++++
 6 files changed, 73 insertions(+), 11 deletions(-)
