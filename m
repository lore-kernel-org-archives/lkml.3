Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBJPjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:39:00 -0500
Received: from hofr.at ([212.69.189.236]:43855 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaBJPi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:38:57 -0500
Date: Mon, 10 Feb 2014 16:38:56 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: allow preemption in check_task_state
Message-ID: <20140210153856.GD20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A lockfree approach to check_task_state

This treates the state as an indicator variable and use it to probe 
saved_state lock free. There is actually no consistency demand on 
state/saved_state but rather a consistency demand on the transitions 
of the two variables but those transition, based on path inspection,
are not independent.

Its probably not faster than the lock/unlock case if uncontended - atleast
it does not show up in benchmark results, but it would never be hit by a 
full pi-boost cycle as there is no contention.

This also was tested against the test-case from Sebastian as well as 
rnning a few scripted gdb breakpoint debugging/single-stepping loops
to trigger this.

Tested-by: Andreas Platschek <platschek@ict.tuwien.ac.at>
Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 kernel/sched/core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bf93f63..5690ba3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1074,11 +1074,17 @@ static int migration_cpu_stop(void *data);
 static bool check_task_state(struct task_struct *p, long match_state)
 {
 	bool match = false;
+	long state, saved_state;
+
+	/* catch restored state */
+	do {
+		state = p->state;
+		saved_state = p->saved_state;
+		rmb();  /* make sure we actually catch updates */
+	} while (state != p->state);
 
-	raw_spin_lock_irq(&p->pi_lock);
 	if (p->state == match_state || p->saved_state == match_state)
 		match = true;
-	raw_spin_unlock_irq(&p->pi_lock);
 
 	return match;
 }
-- 
1.7.2.5

