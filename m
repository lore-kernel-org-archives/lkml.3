Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3BRFIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:08:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:23970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab3BRFII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:08:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258210100"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 13/15] sched: no balance for prefer_sibling in power scheduling
Date: Mon, 18 Feb 2013 13:07:40 +0800
Message-Id: <1361164062-20111-14-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power aware scheduling, we don't want to balance 'prefer_sibling'
groups just because local group has capacity.
If the local group has no tasks at the time, that is the power
balance hope so.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f3abb83..ffdf35d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4782,8 +4782,12 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
+		 *
+		 * In power aware scheduling, we don't care load weight and
+		 * want not to pull tasks just because local group has capacity.
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
+		if (prefer_sibling && !local_group && sds->this_has_capacity
+				&& env->perf_lb)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
-- 
1.7.12

