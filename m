Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIJOOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:14:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:58890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbaIJOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="589215265"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 06/16] perf, core: always switch pmu specific data during context switch
Date: Wed, 10 Sep 2014 10:09:03 -0400
Message-Id: <1410358153-421-7-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410358153-421-1-git-send-email-kan.liang@intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

If two tasks were both forked from the same parent task, Events in
their perf task contexts can be the same. Perf core may leave out
switching the perf event contexts.

Previous patch inroduces pmu specific data. The data is for saving
the LBR stack, it is task specific. So we need to switch the data
even when context switch is optimized out.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3a1458c..5f49df2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2412,6 +2412,9 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
+
+			swap(ctx->task_ctx_data, next_ctx->task_ctx_data);
+
 			do_switch = 0;
 
 			perf_event_sync_stat(ctx, next_ctx);
-- 
1.8.3.2

