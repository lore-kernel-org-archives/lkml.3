Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaGGG3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:29:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:36667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaGGG3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:29:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="539565520"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v5 06/16] perf, core: always switch pmu specific data during context switch
Date: Mon,  7 Jul 2014 14:28:35 +0800
Message-Id: <1404714527-18603-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
References: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 51e221e..df14a4e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2347,6 +2347,9 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
+
+			swap(ctx->task_ctx_data, next_ctx->task_ctx_data);
+
 			do_switch = 0;
 
 			perf_event_sync_stat(ctx, next_ctx);
-- 
1.9.3

