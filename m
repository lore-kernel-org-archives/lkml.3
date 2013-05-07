Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3EGOZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:25:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3EGNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/118] sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s
Date: Tue,  7 May 2013 14:37:37 +0100
Message-Id: <1367933964-1564-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 383efcd00053ec40023010ce5034bd702e7ab373 upstream.

try_to_wake_up_local() should only be invoked to wake up another
task in the same runqueue and BUG_ON()s are used to enforce the
rule. Missing try_to_wake_up_local() can stall workqueue
execution but such stalls are likely to be finite either by
another work item being queued or the one blocked getting
unblocked.  There's no reason to trigger BUG while holding rq
lock crashing the whole system.

Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130318192234.GD3042@htj.dyndns.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3231df8..473cac3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1651,8 +1651,10 @@ static void try_to_wake_up_local(struct task_struct *p)
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
-- 
1.8.1.2

