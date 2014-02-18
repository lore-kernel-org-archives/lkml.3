Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaBRGH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:07:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:43042 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbaBRGHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:07:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,500,1389772800"; 
   d="scan'208";a="483239667"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v3 06/14] perf, core: always switch pmu specific data during context switch
Date: Tue, 18 Feb 2014 14:07:33 +0800
Message-Id: <1392703661-15104-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two tasks were both forked from the same parent task, Events in
their perf task contexts can be the same. Perf core optimizes context
switch out in this case.

Previous patch inroduces pmu specific data. The data is task specific,
so we should switch the data even when context switch is optimized out.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index da551c5..d5417e5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2331,6 +2331,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock(&ctx->lock);
 		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
+			void *ctx_data;
 			/*
 			 * XXX do we need a memory barrier of sorts
 			 * wrt to rcu_dereference() of perf_event_ctxp
@@ -2339,6 +2340,11 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
+
+			ctx_data = next_ctx->task_ctx_data;
+			next_ctx->task_ctx_data = ctx->task_ctx_data;
+			ctx->task_ctx_data = ctx_data;
+
 			do_switch = 0;
 
 			perf_event_sync_stat(ctx, next_ctx);
-- 
1.8.5.3

