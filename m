Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3BQXH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:07:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45632 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab3BQWzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:04 -0500
Message-Id: <20130217225002.379301902@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>
Subject: [ 06/66] sched/rt: Use root_domain of rt_rq not current processor
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -384,7 +384,7 @@ static inline struct rt_bandwidth *sched
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more = 0;
 	u64 rt_period;
 


