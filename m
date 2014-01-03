Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaACFse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:48:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:47972 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaACFs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:48:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="scan'208";a="459449352"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 06/14] perf, core: always switch pmu specific data during context switch
Date: Fri,  3 Jan 2014 13:48:03 +0800
Message-Id: <1388728091-18564-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two tasks were both forked from the same parent task, Events in their perf
task contexts can be the same. Perf core optimizes context switch oout in this
case.

Previous patch inroduces pmu specific data. The data is task specific, so we
should switch the data even when context switch is optimized out.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b6650ab..d6d8dea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2319,6 +2319,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
+			ctx->task_ctx_data = xchg(&next_ctx->task_ctx_data,
+						  ctx->task_ctx_data);
 			do_switch = 0;
 
 			perf_event_sync_stat(ctx, next_ctx);
-- 
1.8.4.2

