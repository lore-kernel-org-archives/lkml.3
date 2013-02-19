Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab3BSSua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857Ab3BSSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>, peterz@infradead.org,
        Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 07/81] sched/rt: Use root_domain of rt_rq not current processor
Date: Tue, 19 Feb 2013 15:48:30 -0300
Message-Id: <1361299784-8830-8-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Bohrer <sbohrer@rgmadvisors.com>

commit aa7f67304d1a03180f463258aa6f15a8b434e77d upstream.

When the system has multiple domains do_sched_rt_period_timer()
can run on any CPU and may iterate over all rt_rq in
cpu_online_mask.  This means when balance_runtime() is run for a
given rt_rq that rt_rq may be in a different rd than the current
processor.  Thus if we use smp_processor_id() to get rd in
do_balance_runtime() we may borrow runtime from a rt_rq that is
not part of our rd.

This changes do_balance_runtime to get the rd from the passed in
rt_rq ensuring that we borrow runtime only from the correct rd
for the given rt_rq.

This fixes a BUG at kernel/sched/rt.c:687! in __disable_runtime
when we try reclaim runtime lent to other rt_rq but runtime has
been lent to a rt_rq in another rd.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Mike Galbraith <bitbucket@online.de>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/sched/rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 573e1ca..2a05e56 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -566,7 +566,7 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more = 0;
 	u64 rt_period;
 
-- 
1.7.9.5

