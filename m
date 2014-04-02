Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbaDBQ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:26:15 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40042 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbaDBQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:26:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] nohz: Move nohz kick out of scheduler IPI
Date: Wed,  2 Apr 2014 18:26:04 +0200
Message-Id: <1396455966-21128-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull the timers/nohz-ipi-for-mingo branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-ipi-for-tip

1st post got no objection: https://lkml.org/lkml/2014/3/19/453

I held it up until the block bits from Jens got pulled because this
set had a dependency on core IPI contained in the block branch.

I hope we can still get these two patches for the current merge window,
otherwise I'll have to split the core IPI change residing in the 1st patch
into a seperate branch for the next cycle (Linus will kill me if I
merge unrelated topics again: https://lkml.org/lkml/2014/4/1/888).

Now tell me if you think that these changes are too invasive at this stage.
Maybe we can just take the first patch that only does the IPI code
preparation work. That's the most important. The 2nd patch can wait.
Or we can just wait another cycle and split things in different branches.
Any way you prefer.


Thanks,
	Frederic

-----

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

---

Frederic Weisbecker (2):
      smp: Non busy-waiting IPI queue
      nohz: Move full nohz kick to its own IPI


 include/linux/smp.h      | 12 ++++++++++++
 include/linux/tick.h     |  2 ++
 kernel/sched/core.c      |  5 +----
 kernel/sched/sched.h     |  2 +-
 kernel/smp.c             | 44 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c | 20 ++++++++++++++++++++
 6 files changed, 80 insertions(+), 5 deletions(-)
