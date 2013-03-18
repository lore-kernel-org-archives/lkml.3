Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3CRTWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:22:39 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:42428 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3CRTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:22:38 -0400
Date: Mon, 18 Mar 2013 12:22:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] scheduler: convert BUG_ON()s in try_to_wake_up_local() to
 WARN_ON_ONCE()s
Message-ID: <20130318192234.GD3042@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_wake_up_local() should only be invoked to wake up another task
in the same runqueue and BUG_ON()s are used to enforce the rule.
Missing try_to_wake_up_local() can stall workqueue execution but such
stalls are likely to be finite either by another work item being
queued or the one blocked getting unblocked.  There's no reason to
trigger BUG while holding rq lock crashing the whole system.

Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..a2eda4d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1498,8 +1498,10 @@ static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
 
-	BUG_ON(rq != this_rq());
-	BUG_ON(p == current);
+	if (WARN_ON_ONCE(rq != this_rq()) ||
+	    WARN_ON_ONCE(p == current))
+		return;
+
 	lockdep_assert_held(&rq->lock);
 
 	if (!raw_spin_trylock(&p->pi_lock)) {
