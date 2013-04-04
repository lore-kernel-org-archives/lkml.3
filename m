Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3DDCCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:29715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab3DDCCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534510"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 15/21] sched: pull all tasks from source group
Date: Thu,  4 Apr 2013 10:00:56 +0800
Message-Id: <1365040862-8390-16-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power balance, we hope some sched groups are fully empty to save
CPU power of them. So, we want to move any tasks from them.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f861427..0dd29f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5105,7 +5105,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (rq->nr_running == 0 ||
+			(!(env->flags & LBF_POWER_BAL) && capacity &&
+				rq->nr_running == 1 && wl > env->imbalance))
 			continue;
 
 		/*
@@ -5208,7 +5210,8 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
-	if (busiest->nr_running > 1) {
+	if (busiest->nr_running > 1 ||
+		(busiest->nr_running == 1 && env.flags & LBF_POWER_BAL)) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
 		 * an imbalance but busiest->nr_running <= 1, the group is
-- 
1.7.12

