Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaIBHlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:41:39 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:44341 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBHli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:41:38 -0400
Message-ID: <1409643684.19197.15.camel@j-VirtualBox>
Subject: Re: [PATCH v2] sched: Reduce contention in
 update_cfs_rq_blocked_load
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Ben Segall <bsegall@google.com>,
        LKML <linux-kernel@vger.kernel.org>, jason.low2@hp.com
Date: Tue, 02 Sep 2014 00:41:24 -0700
In-Reply-To: <20140901125505.GK27892@worktop.ger.corp.intel.com>
References: <1409094682.29189.23.camel@j-VirtualBox>
	 <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
	 <1409160893.31379.24.camel@j-VirtualBox>
	 <1409182369.27939.9.camel@schen9-desk2.jf.intel.com>
	 <1409255196.4945.7.camel@j-VirtualBox>
	 <20140901125505.GK27892@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 14:55 +0200, Peter Zijlstra wrote:
> But yes, unbounded errors here are a problem, sure relaxing the updates
> makes things go fast, they also make things go skew.

Okay. In that case, would you like to take our original patch which
avoids unnecessary updates?

-----
Subject: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load

When running workloads on 2+ socket systems, based on perf profiles, the
update_cfs_rq_blocked_load function often shows up as taking up a
noticeable % of run time.

Much of the contention is in __update_cfs_rq_tg_load_contrib when we
update the tg load contribution stats.  However, it turns out that in many
cases, they don't need to be updated and "tg_contrib" is 0.

This patch adds a check in __update_cfs_rq_tg_load_contrib to skip updating
tg load contribution stats when nothing needs to be updated. This reduces the
cacheline contention that would be unnecessary.

Cc: Yuyang Du <yuyang.du@intel.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Scott J Norton <scott.norton@hp.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d3427a8..45e346c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2382,6 +2382,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
+	if (!tg_contrib)
+		return;
+
 	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
 		atomic_long_add(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
-- 
1.7.1



