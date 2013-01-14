Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3ANRzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:55:45 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:42257 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756417Ab3ANRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:55:44 -0500
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: peterz@infradead.org, mingo@elte.hu
Cc: Mike Galbraith <bitbucket@online.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] sched_rt: Use root_domain of rt_rq not current processor
Date: Mon, 14 Jan 2013 11:55:31 -0600
Message-Id: <1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357884213.5716.35.camel@marge.simpson.net>
References: <1357884213.5716.35.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system has multiple domains do_sched_rt_period_timer() can run
on any CPU and may iterate over all rt_rq in cpu_online_mask.  This
means when balance_runtime() is run for a given rt_rq that rt_rq may be
in a different rd than the current processor.  Thus if we use
smp_processor_id() to get rd in do_balance_runtime() we may borrow
runtime from a rt_rq that is not part of our rd.

This changes do_balance_runtime to get the rd from the passed in rt_rq
ensuring that we borrow runtime only from the correct rd for the given
rt_rq.

This fixes a BUG at kernel/sched/rt.c:687! in __disable_runtime when we
try reclaim runtime lent to other rt_rq but runtime has been lent to
a rt_rq in another rd.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
 
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
