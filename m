Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaKRXCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:02:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:23467 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbaKRXCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:02:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418373140"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2] sched/deadline: fix rt runtime corrupt when dl refuse a smaller bandwidth
Date: Wed, 19 Nov 2014 07:02:01 +0800
Message-Id: <1416351721-100675-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dl class will refuse the bandwidth being set to some value smaller
than the currently allocated bandwidth in any of the root_domains
through sched_rt_runtime_us and sched_rt_period_us. RT runtime will
be set according to sched_rt_runtime_us before dl class verify if
the new bandwidth is suitable in the case of !CONFIG_RT_GROUP_SCHED.

However, rt runtime will be corrupt if dl refuse the new bandwidth
since there is no undo to reset the rt runtime to the old value.

This patch fix it by verifying new bandwidth for deadline in advance.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * move sched_dl_global_constraints before sched_rt_global_constraints,
   and change the name of the former to sched_dl_global_validate().

 kernel/sched/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7578a..6690778 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7812,7 +7812,7 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static int sched_dl_global_constraints(void)
+static int sched_dl_global_validate(void)
 {
 	u64 runtime = global_rt_runtime();
 	u64 period = global_rt_period();
@@ -7913,11 +7913,11 @@ int sched_rt_handler(struct ctl_table *table, int write,
 		if (ret)
 			goto undo;
 
-		ret = sched_rt_global_constraints();
+		ret = sched_dl_global_validate();
 		if (ret)
 			goto undo;
 
-		ret = sched_dl_global_constraints();
+		ret = sched_rt_global_constraints();
 		if (ret)
 			goto undo;
 
-- 
1.9.1

