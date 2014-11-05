Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaKEQMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:12:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34535 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004AbaKEQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:12:52 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: acme@kernel.org, drew.richardson@arm.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, vincent.weaver@maine.edu, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/1] perf: fix corruption of sibling list with hotplug
Date: Wed,  5 Nov 2014 16:11:44 +0000
Message-Id: <1415203904-25308-2-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415203904-25308-1-git-send-email-mark.rutland@arm.com>
References: <1415203904-25308-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU hotplugged out, we call perf_remove_from_context (via
perf_event_exit_cpu) to rip each CPU-bound event out of its PMU's cpu
context, but leave siblings grouped together. Freeing of these events is
left to the mercy of the usual refcounting.

When a CPU-bound event's refcount drops to zero we cross-call to
__perf_remove_from_context to clean it up, detaching grouped siblings.
This works when the relevant CPU is online, but will fail if the CPU is
currently offline, and we won't detach the event from its siblings
before freeing the event, leaving the sibling list corrupt. If the
sibling list is later walked (e.g. because the CPU cam online again
before a remaining sibling's refcount drops to zero), we will walk the
now corrupted siblings list, potentially dereferencing garbage values.

Given that the events should never be scheduled again (as we removed
them from their context), we can simply detatch siblings when the CPU
goes down in the first place. If the CPU comes back online, the
redundant call to __perf_remove_from_context is safe.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Drew Richardson <drew.richardson@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Will Deacon <will.deacon@arm.com>
---
 kernel/events/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2b02c9f..1cd5eef 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1562,8 +1562,10 @@ static void perf_remove_from_context(struct perf_event *event, bool detach_group
 
 	if (!task) {
 		/*
-		 * Per cpu events are removed via an smp call and
-		 * the removal is always successful.
+		 * Per cpu events are removed via an smp call. The removal can
+		 * fail if the CPU is currently offline, but in that case we
+		 * already called __perf_remove_from_context from
+		 * perf_event_exit_cpu.
 		 */
 		cpu_function_call(event->cpu, __perf_remove_from_context, &re);
 		return;
@@ -8117,7 +8119,7 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 
 static void __perf_event_exit_context(void *__info)
 {
-	struct remove_event re = { .detach_group = false };
+	struct remove_event re = { .detach_group = true };
 	struct perf_event_context *ctx = __info;
 
 	perf_pmu_rotate_stop(ctx->pmu);
-- 
1.9.1

