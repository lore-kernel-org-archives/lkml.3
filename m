Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaKEDOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:14:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:27608 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbaKEDKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:10:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="617286986"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V7 06/17] perf, core: always switch pmu specific data during context switch
Date: Tue,  4 Nov 2014 21:56:02 -0500
Message-Id: <1415156173-10035-7-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yan, Zheng <zheng.z.yan@intel.com>

If two tasks were both forked from the same parent task, Events in
their perf task contexts can be the same. Perf core may leave out
switching the perf event contexts.

Previous patch inroduces pmu specific data. The data is for saving
the LBR stack, it is task specific. So we need to switch the data
even when context switch is optimized out.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 08d6671..4360c95 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2420,6 +2420,9 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
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

