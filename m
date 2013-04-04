Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3DDCCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:29715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab3DDCCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534522"
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
Subject: [patch v7 16/21] sched: no balance for prefer_sibling in power scheduling
Date: Thu,  4 Apr 2013 10:00:57 +0800
Message-Id: <1365040862-8390-17-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
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
index 0dd29f4..86221e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4762,8 +4762,12 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * extra check prevents the case where you always pull from the
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
+		 *
+		 * In power aware scheduling, we don't care load weight and
+		 * want not to pull tasks just because local group has capacity.
 		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
+		if (prefer_sibling && !local_group && sds->this_has_capacity
+				&& env->flags & LBF_PERF_BAL)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
-- 
1.7.12

