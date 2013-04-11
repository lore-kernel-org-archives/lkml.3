Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3DKXvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:51:13 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:51747 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3DKXvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:51:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [RFC GIT PULL] sched; Fix a few missing rq clock updates
Date: Fri, 12 Apr 2013 01:50:57 +0200
Message-Id: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I revisited the rq clock series I had for dynticks. The patches
actually were about upstream issues so I refactored the fixes
under that angle and gave up with the wrong asumption that rq
clock relies on the tick for its updates.

Patches 1-4 fix some missing updates. Additionally I removed
2 of these updates from the previous set:

* No need to update the rq clock on idle_balance() because it should
follow a call to deactivate_task() (unless TIF_NEED_RESCHED is set
on idle without new task on the runqueue, not sure we want to cover that).

* No need to update for try_to_wake_up_local() -> ttwu_do_wakeup() -> check_preempt_curr()
  as it's following deactivate_task().

Patch 5 brings accessors that will be necessary to settle an rq clock
debugging engine. What remains is to tag scheduler's entry/exit points
and report missing or redundant update_rq_clock() before calls to
rq_clock() and rq_clock_task().

The branch is pullable from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/core

HEAD: 8b5fa0f1de7e41176dc68740de7548110a404538

Thanks.

---
Frederic Weisbecker (5):
  sched: Update rq clock before migrating tasks out of dying CPU
  sched: Update rq clock before setting fair group shares
  sched: Update rq clock before calling check_preempt_curr()
  sched: Update rq clock earlier in unthrottle_cfs_rq
  sched: Use an accessor to read rq clock

 kernel/sched/core.c      |   15 ++++++++++--
 kernel/sched/fair.c      |   51 +++++++++++++++++++++++++--------------------
 kernel/sched/rt.c        |    8 +++---
 kernel/sched/sched.h     |   10 +++++++++
 kernel/sched/stats.h     |    8 +++---
 kernel/sched/stop_task.c |    8 +++---
 6 files changed, 62 insertions(+), 38 deletions(-)

-- 
1.7.5.4

