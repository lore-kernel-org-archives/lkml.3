Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaBJRox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:44:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63569 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaBJRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:44:51 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/7] perf: remove redundant pmu assignment
Date: Mon, 10 Feb 2014 17:44:19 +0000
Message-Id: <1392054264-23570-3-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf_branch_stack_sched_in iterates over the set of pmus,
checks that each pmu has a flush_branch_stack callback, then overwrites
the pmu before calling the callback. This is either redundant or broken.

In systems with a single hw pmu, pmu == cpuctx->ctx.pmu, and thus the
assignment is redundant.

In systems with multiple hw pmus (i.e. multiple pmus with task_ctx_nr ==
perf_hw_context) the pmus share the same perf_cpu_context. Thus the
assignment can cause one of the pmus to flush its branch stack
repeatedly rather than causing each of the pmus to flush their branch
stacks. Worse still, if only some pmus have the callback the assignment
can result in a branch to NULL.

This patch removes the redundant assignment.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 08659d1..15fe6fc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2563,8 +2563,6 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
 		if (cpuctx->ctx.nr_branch_stack > 0
 		    && pmu->flush_branch_stack) {
 
-			pmu = cpuctx->ctx.pmu;
-
 			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 
 			perf_pmu_disable(pmu);
-- 
1.8.1.1

