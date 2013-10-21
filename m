Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3JUI7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:59:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39855 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517Ab3JUIxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Stephane Eranian" <eranian@google.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.749867309@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 132/149] perf: Clarify perf_cpu_context::active_pmu
 usage by renaming it to ::unique_pmu
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 3f1f33206c16c7b3839d71372bc2ac3f305aa802 upstream.

Stephane thought the perf_cpu_context::active_pmu name confusing and
suggested using 'unique_pmu' instead.

This pointer is a pointer to a 'random' pmu sharing the cpuctx
instance, therefore limiting a for_each_pmu loop to those where
cpuctx->unique_pmu matches the pmu we get a loop over unique cpuctx
instances.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-kxyjqpfj2fn9gt7kwu5ag9ks@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -927,7 +927,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
-	struct pmu			*active_pmu;
+	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4381,7 +4381,7 @@ static void perf_event_task_event(struct
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
@@ -4527,7 +4527,7 @@ static void perf_event_comm_event(struct
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
@@ -4723,7 +4723,7 @@ got_name:
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
@@ -5745,8 +5745,8 @@ static void update_pmu_context(struct pm
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 
-		if (cpuctx->active_pmu == old_pmu)
-			cpuctx->active_pmu = pmu;
+		if (cpuctx->unique_pmu == old_pmu)
+			cpuctx->unique_pmu = pmu;
 	}
 }
 
@@ -5881,7 +5881,7 @@ skip_type:
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
-		cpuctx->active_pmu = pmu;
+		cpuctx->unique_pmu = pmu;
 	}
 
 got_cpu_context:

