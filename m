Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3C3Ohy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:37:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab3C3OgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568337"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 16/21] sched: pull all tasks from source group
Date: Sat, 30 Mar 2013 22:35:03 +0800
Message-Id: <1364654108-16307-17-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
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
index adccdb8..d25fb3b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5115,7 +5115,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (rq->nr_running == 0 ||
+			(!(env->flags & LBF_POWER_BAL) && capacity &&
+				rq->nr_running == 1 && wl > env->imbalance))
 			continue;
 
 		/*
@@ -5218,7 +5220,8 @@ redo:
 
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

