Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaB0NeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:34:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaB0NeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:34:17 -0500
Date: Thu, 27 Feb 2014 05:33:38 -0800
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-fdded676c3ef680bf1abc415d307d7e69a6768d1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, will.deacon@arm.com, peterz@infradead.org,
        mark.rutland@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com,
        peterz@infradead.org, mark.rutland@arm.com, tglx@linutronix.de
In-Reply-To: <1392054264-23570-3-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-3-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove redundant PMU assignment
Git-Commit-ID: fdded676c3ef680bf1abc415d307d7e69a6768d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdded676c3ef680bf1abc415d307d7e69a6768d1
Gitweb:     http://git.kernel.org/tip/fdded676c3ef680bf1abc415d307d7e69a6768d1
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Mon, 10 Feb 2014 17:44:19 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:43:24 +0100

perf: Remove redundant PMU assignment

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1392054264-23570-3-git-send-email-mark.rutland@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4251598..823a53d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2582,8 +2582,6 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
 		if (cpuctx->ctx.nr_branch_stack > 0
 		    && pmu->flush_branch_stack) {
 
-			pmu = cpuctx->ctx.pmu;
-
 			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 
 			perf_pmu_disable(pmu);
