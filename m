Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaKDXpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:45:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:24205 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaKDXpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:45:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411513680"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2] sched/fair: fix use stale overloaded status to find busiest group
Date: Wed,  5 Nov 2014 07:44:50 +0800
Message-Id: <1415144690-25196-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit caeb178c60f4 ("sched/fair: Make update_sd_pick_busiest() return 
'true' on a busier sd") makes groups are ranked in the order overloaded > 
imbalance > other and busiest group is picked according to this order. 
sgs->group_capacity_factor is used to check if group is overloaded. 

In the case of the child domain prefers tasks go to siblings first, the 
sgs->group_capacity_factor will be set lower to one in order to move all 
the excess tasks away. 

However, group overloaded status is not updated in the case of 
sgs->group_capacity_factor be set lower to one which leads to miss find 
the busiest group. 

This patch fix it by updating group overloaded status in the case of sg 
capacity factor is set to one in order to find busiest group accurately.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * introduce some newlines in the changelog.

 kernel/sched/fair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ec32c26d..c603e50 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6344,8 +6344,10 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_free_capacity)
+		    sds->local_stat.group_has_free_capacity) {
 			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
+			sgs->group_type = group_classify(sg, sgs);
+		}
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
-- 
1.9.1

