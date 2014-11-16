Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaKPJv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:51:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34372 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaKPJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:50:16 -0500
Date: Sun, 16 Nov 2014 01:49:11 -0800
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-226424eee809251ec23bd4b09d8efba09c10fc3c@git.kernel.org>
Cc: vincent.weaver@maine.edu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        mingo@kernel.org, will.deacon@arm.com, acme@kernel.org, hpa@zytor.com,
        peterz@infradead.org, drew.richardson@arm.com, mark.rutland@arm.com,
        torvalds@linux-foundation.org
Reply-To: tglx@linutronix.de, vincent.weaver@maine.edu, mingo@kernel.org,
        linux-kernel@vger.kernel.org, acme@kernel.org, hpa@zytor.com,
        will.deacon@arm.com, peterz@infradead.org, drew.richardson@arm.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org
In-Reply-To: <1415203904-25308-2-git-send-email-mark.rutland@arm.com>
References: <1415203904-25308-2-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Fix corruption of sibling list with hotplug
Git-Commit-ID: 226424eee809251ec23bd4b09d8efba09c10fc3c
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

Commit-ID:  226424eee809251ec23bd4b09d8efba09c10fc3c
Gitweb:     http://git.kernel.org/tip/226424eee809251ec23bd4b09d8efba09c10fc3c
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Wed, 5 Nov 2014 16:11:44 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 09:45:46 +0100

perf: Fix corruption of sibling list with hotplug

When a CPU hotplugged out, we call perf_remove_from_context() (via
perf_event_exit_cpu()) to rip each CPU-bound event out of its PMU's cpu
context, but leave siblings grouped together. Freeing of these events is
left to the mercy of the usual refcounting.

When a CPU-bound event's refcount drops to zero we cross-call to
__perf_remove_from_context() to clean it up, detaching grouped siblings.

This works when the relevant CPU is online, but will fail if the CPU is
currently offline, and we won't detach the event from its siblings
before freeing the event, leaving the sibling list corrupt. If the
sibling list is later walked (e.g. because the CPU cam online again
before a remaining sibling's refcount drops to zero), we will walk the
now corrupted siblings list, potentially dereferencing garbage values.

Given that the events should never be scheduled again (as we removed
them from their context), we can simply detatch siblings when the CPU
goes down in the first place. If the CPU comes back online, the
redundant call to __perf_remove_from_context() is safe.

Reported-by: Drew Richardson <drew.richardson@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: vincent.weaver@maine.edu
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415203904-25308-2-git-send-email-mark.rutland@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
