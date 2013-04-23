Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3DWWOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:14:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab3DWVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [ 21/42] sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s
Date: Tue, 23 Apr 2013 14:52:19 -0700
Message-Id: <20130423215207.685554756@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1488,8 +1488,10 @@ static void try_to_wake_up_local(struct
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


