Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439Ab3KMPot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:44:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab3KMPos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:44:48 -0500
Date: Wed, 13 Nov 2013 16:45:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sched: Check TASK_DEAD rather than EXIT_DEAD in
	schedule_debug()
Message-ID: <20131113154538.GB15810@redhat.com>
References: <20131113143552.GA10517@redhat.com> <20131113144856.GL26898@twins.programming.kicks-ass.net> <20131113154516.GA15810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113154516.GA15810@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_debug() ignores in_atomic() if prev->exit_state != 0.
This is not what we want, ->exit_state is set by exit_notify()
but we should complain until the task does the last schedule()
in TASK_DEAD.

See also 7407251a0e2e "PF_DEAD cleanup", I think this ancient
commit explains why schedule() had to rely on ->exit_state,
until that commit exit_notify() disabled preemption and set
PF_DEAD which was used to detect the exiting task.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..7184357 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2287,10 +2287,10 @@ static inline void schedule_debug(struct task_struct *prev)
 {
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
-	 * schedule() atomically, we ignore that path for now.
-	 * Otherwise, whine if we are scheduling when we should not be.
+	 * schedule() atomically, we ignore that path. Otherwise whine
+	 * if we are scheduling when we should not.
 	 */
-	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
+	if (unlikely(in_atomic_preempt_off() && prev->state != TASK_DEAD))
 		__schedule_bug(prev);
 	rcu_sleep_check();
 
-- 
1.5.5.1


