Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3CUSPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:15:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3CUSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:15:27 -0400
Date: Thu, 21 Mar 2013 11:14:05 -0700
From: tip-bot for Tejun Heo <tipbot@zytor.com>
Message-ID: <tip-383efcd00053ec40023010ce5034bd702e7ab373@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tj@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20130318192234.GD3042@htj.dyndns.org>
References: <20130318192234.GD3042@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Convert BUG_ON()
 s in try_to_wake_up_local() to WARN_ON_ONCE()s
Git-Commit-ID: 383efcd00053ec40023010ce5034bd702e7ab373
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 11:14:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  383efcd00053ec40023010ce5034bd702e7ab373
Gitweb:     http://git.kernel.org/tip/383efcd00053ec40023010ce5034bd702e7ab373
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 18 Mar 2013 12:22:34 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 21 Mar 2013 11:48:20 +0100

sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

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
---
 kernel/sched/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7b03cd..306943f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1488,8 +1488,10 @@ static void try_to_wake_up_local(struct task_struct *p)
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
