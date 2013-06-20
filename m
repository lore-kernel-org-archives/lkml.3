Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754Ab3FTUpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:45:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48996 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965700Ab3FTUpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:45:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH 0/4] sched: Disabled LB_BIAS with full dynticks
Date: Thu, 20 Jun 2013 22:45:37 +0200
Message-Id: <1371761141-25386-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

So I've been looking at update_cpu_load_active(),
update_idle_cpu_load() and update_cpu_load_nohz() to
conclude that dynticks are well handled by decay_load_missed()
which catch up with the missed nohz load.

However decay_load_missed() seem to always assume that the nohz
load was zero. So it works well for dynticks idle but it doesn't
seem to fit well for full dynticks. (My understanding of the maths involved
in decay_load_missed might be wrong though, so correct me if
I brainfarted).

Moreover even if we had a mathematical solution to catch up with
full dynticks load like decay_load_missed() does for dynticks idle, we
would need to be able to perform the update from remote readers such as
source_load() or target_load(), which is another problem on its own.

So this patchset propose a simple solution as a start: disable LB_BIAS
sched feature in full dynticks. LB_BIAS is the only user of these
decayed cpu load stats.

LB_BIAS sched feature is quite an obfuscated feature though
so I'm not sure about all the implication of that. It seems to
be about the selection of CPU targets from the different enqueuing
places that each have a different timeslice zooming weight while observing
a target load. And that weight influence the CPU selection.

May be for HPC loads that run only one task per CPU it doesn't matter
much. But some other workloads may suffer from that, especially when
full dynticks will be usable when more than a single task compete on
the CPUs.

Anyway at least this patchset can help starting a discussion.

Those who want to play can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/core


Thanks,
	Frederic
---

Frederic Weisbecker (4):
      sched: Disable lb_bias feature for full dynticks
      sched: Consolidate nohz cpu load prelude code
      sched: Conditionally build decaying cpu load stats
      sched: Consolidate open coded preemptible() checks


 kernel/context_tracking.c |    3 +-
 kernel/sched/core.c       |    4 +--
 kernel/sched/fair.c       |   13 ++++++-
 kernel/sched/features.h   |    3 ++
 kernel/sched/proc.c       |   75 ++++++++++++++++++++++-----------------------
 kernel/sched/sched.h      |    4 ++
 6 files changed, 57 insertions(+), 45 deletions(-)
