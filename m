Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab3EGEcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:32:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3EGEZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:54 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KFk0wb-63oAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=h79IpjeT3TgA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=76lol7B0AAAA:8 a=1OPJJPltxralJJD8QtwA:9 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035853.299653350@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [074/126] sched: Convert BUG_ON()s in try_to_wake_up_local() to
 WARN_ON_ONCE()s
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0074-sched-Convert-BUG_ON-s-in-try_to_wake_up_local-to-WA.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 383efcd00053ec40023010ce5034bd702e7ab373 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a48cdb..2f88246 100644
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
1.7.10.4


