Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3LKHLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:11:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:39406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3LKHLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352459"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 05/15] perf, core: Optimize context switch callback invoking
Date: Wed, 11 Dec 2013 15:10:50 +0800
Message-Id: <1386745860-21143-6-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

So far only CPU pmu uses context switch callback and it is the
first registered pmu. So we can avoid iterating the whole pmu list.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fc97ed6..c281265 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2373,6 +2373,10 @@ static void perf_pmu_sched_task(struct task_struct *prev,
 		perf_pmu_enable(pmu);
 
 		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+
+		/* so far only CPU pmu uses context switch callback */
+		if (++count >= __get_cpu_var(perf_sched_cb_usages))
+			break;
 	}
 
 	rcu_read_unlock();
@@ -6492,7 +6496,7 @@ got_cpu_context:
 	if (!pmu->event_idx)
 		pmu->event_idx = perf_event_idx_default;
 
-	list_add_rcu(&pmu->entry, &pmus);
+	list_add_tail_rcu(&pmu->entry, &pmus);
 	ret = 0;
 unlock:
 	mutex_unlock(&pmus_lock);
-- 
1.8.1.4

