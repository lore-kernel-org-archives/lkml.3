Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbA1Uul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762191AbbA1Uu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:29 -0500
Date: Wed, 28 Jan 2015 06:30:07 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c3c87e770458aa004bd7ed3f29945ff436fd6511@git.kernel.org>
Cc: acme@kernel.org, tglx@linutronix.de, hpa@zytor.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        torvalds@linux-foundation.org
Reply-To: peterz@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jolsa@redhat.com, torvalds@linux-foundation.org, mingo@kernel.org,
        acme@kernel.org, tglx@linutronix.de
In-Reply-To: <20150123125834.090683288@infradead.org>
References: <20150123125834.090683288@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Tighten (and fix) the grouping condition
Git-Commit-ID: c3c87e770458aa004bd7ed3f29945ff436fd6511
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

Commit-ID:  c3c87e770458aa004bd7ed3f29945ff436fd6511
Gitweb:     http://git.kernel.org/tip/c3c87e770458aa004bd7ed3f29945ff436fd6511
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 23 Jan 2015 11:19:48 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Jan 2015 13:17:35 +0100

perf: Tighten (and fix) the grouping condition

The fix from 9fc81d87420d ("perf: Fix events installation during
moving group") was incomplete in that it failed to recognise that
creating a group with events for different CPUs is semantically
broken -- they cannot be co-scheduled.

Furthermore, it leads to real breakage where, when we create an event
for CPU Y and then migrate it to form a group on CPU X, the code gets
confused where the counter is programmed -- triggered in practice
as well by me via the perf fuzzer.

Fix this by tightening the rules for creating groups. Only allow
grouping of counters that can be co-scheduled in the same context.
This means for the same task and/or the same cpu.

Fixes: 9fc81d87420d ("perf: Fix events installation during moving group")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20150123125834.090683288@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |  6 ------
 kernel/events/core.c       | 15 +++++++++++++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4f7a61c..664de5a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -450,11 +450,6 @@ struct perf_event {
 #endif /* CONFIG_PERF_EVENTS */
 };
 
-enum perf_event_context_type {
-	task_context,
-	cpu_context,
-};
-
 /**
  * struct perf_event_context - event context structure
  *
@@ -462,7 +457,6 @@ enum perf_event_context_type {
  */
 struct perf_event_context {
 	struct pmu			*pmu;
-	enum perf_event_context_type	type;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 882f835..19efcf1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6776,7 +6776,6 @@ skip_type:
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
-		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 
 		__perf_cpu_hrtimer_init(cpuctx, cpu);
@@ -7420,7 +7419,19 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * task or CPU context:
 		 */
 		if (move_group) {
-			if (group_leader->ctx->type != ctx->type)
+			/*
+			 * Make sure we're both on the same task, or both
+			 * per-cpu events.
+			 */
+			if (group_leader->ctx->task != ctx->task)
+				goto err_context;
+
+			/*
+			 * Make sure we're both events for the same CPU;
+			 * grouping events for different CPUs is broken; since
+			 * you can never concurrently schedule them anyhow.
+			 */
+			if (group_leader->cpu != event->cpu)
 				goto err_context;
 		} else {
 			if (group_leader->ctx != ctx)
