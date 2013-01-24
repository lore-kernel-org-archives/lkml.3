Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3AXUer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:34:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3AXUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:33:29 -0500
Date: Thu, 24 Jan 2013 12:33:10 -0800
From: tip-bot for Shawn Bohrer <sbohrer@rgmadvisors.com>
Message-ID: <tip-df42ae62b3a0bd1a04b68f467a84150af6274a09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bitbucket@online.de, sbohrer@rgmadvisors.com, rostedt@goodmis.org,
        stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, sbohrer@rgmadvisors.com, stable@kernel.org,
        bitbucket@online.de, tglx@linutronix.de
In-Reply-To: <1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/rt:
  Use root_domain of rt_rq not current processor
Git-Commit-ID: df42ae62b3a0bd1a04b68f467a84150af6274a09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:33:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df42ae62b3a0bd1a04b68f467a84150af6274a09
Gitweb:     http://git.kernel.org/tip/df42ae62b3a0bd1a04b68f467a84150af6274a09
Author:     Shawn Bohrer <sbohrer@rgmadvisors.com>
AuthorDate: Mon, 14 Jan 2013 11:55:31 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 16:37:57 +0100

sched/rt: Use root_domain of rt_rq not current processor

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
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..4f02b28 100644
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
 
