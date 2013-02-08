Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab3BHA5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:57:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111Ab3BHA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org
Subject: [ 12/34] sched/rt: Use root_domain of rt_rq not current processor
Date: Thu,  7 Feb 2013 16:57:08 -0800
Message-Id: <20130208004629.553493961@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -566,7 +566,7 @@ static inline struct rt_bandwidth *sched
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more = 0;
 	u64 rt_period;
 


