Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaDCQRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:17:22 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52973 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaDCQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:17:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@fb.com>,
        Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL v2] nohz: Move nohz kick out of scheduler IPI
Date: Thu,  3 Apr 2014 18:17:10 +0200
Message-Id: <1396541832-459-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull the timers/nohz-ipi-for-tip-v3 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-ipi-for-tip-v3

It is based on 7a48837732f87a574ee3e1855927dc250117f565 
("Merge branch 'for-3.15/core' of git://git.kernel.dk/linux-block")
due to dependencies on the block tree containing IPI core changes.

This v2 addresses Paul review and add his reviewed-by tags.

I'm trying to get these 2 patches in before the merge window ends
otherwise we'll have to do tricky branch split on the next cycle.

---
When a full dynticks CPU runs in single task mode then a new task gets
enqueued, we notify it through an IPI such that it restarts its tick.

The IPI used here is the scheduler IPI. There are a few reasons for that:
it can be called when interrupts are disabled, it can be called
concurrently... These convenient properties altogether aren't yet offered
by the IPI subsystem.

Meanwhile, bloating that way the scheduler IPI with scheduler unrelated
code is an abuse of this fast path. We certainly don't want to start a
big kernel IPI.

So this patchset adds a small helper to the IPI subsystem that allows
to queue an IPI from interrupt disabled code while handling concurrent
callers as well. Eventually the nohz kick gets converted to this new facility.

Partly inspired by a suggestion from Peter Zijlstra.

* Patch 1/2 brings the IPI infrastructure to support this
* Patch 2/2 does the nohz IPI conversion


Thanks,
	Frederic
---

Frederic Weisbecker (2):
      smp: Non busy-waiting IPI queue
      nohz: Move full nohz kick to its own IPI


 include/linux/smp.h      | 11 +++++++++++
 include/linux/tick.h     |  2 ++
 kernel/sched/core.c      |  5 +----
 kernel/sched/sched.h     |  2 +-
 kernel/smp.c             | 42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c | 21 +++++++++++++++++++++
 6 files changed, 78 insertions(+), 5 deletions(-)
