Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaJIQfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:35:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39126 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbaJIQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:35:31 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 03/12] perf/x86: add 3 new scheduling callbacks
Date: Thu,  9 Oct 2014 18:34:37 +0200
Message-Id: <1412872486-2930-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch adds 3 new PMU model specific callbacks
during the event scheduling done by x86_schedule_events().

- start_scheduling: invoked when entering the schedule routine.
- stop_scheduling: invoked at the end of the schedule routine
- commit_scheduling: invoked for each committed event

To be used optionally by model-specific code.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c | 9 +++++++++
 arch/x86/kernel/cpu/perf_event.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 542435f..ca44ba2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -734,6 +734,9 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
+	if (x86_pmu.start_scheduling)
+		x86_pmu.start_scheduling(cpuc);
+
 	for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
 		hwc = &cpuc->event_list[i]->hw;
 		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
@@ -780,6 +783,8 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		for (i = 0; i < n; i++) {
 			e = cpuc->event_list[i];
 			e->hw.flags |= PERF_X86_EVENT_COMMITTED;
+			if (x86_pmu.commit_scheduling)
+				x86_pmu.commit_scheduling(cpuc, e, assign[i]);
 		}
 	}
 	/*
@@ -800,6 +805,10 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 				x86_pmu.put_event_constraints(cpuc, e);
 		}
 	}
+
+	if (x86_pmu.stop_scheduling)
+		x86_pmu.stop_scheduling(cpuc);
+
 	return num ? -EINVAL : 0;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4c5a00c..b6848c3 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -447,6 +447,15 @@ struct x86_pmu {
 
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
+
+	void		(*commit_scheduling)(struct cpu_hw_events *cpuc,
+					     struct perf_event *event,
+					     int cntr);
+
+	void		(*start_scheduling)(struct cpu_hw_events *cpuc);
+
+	void		(*stop_scheduling)(struct cpu_hw_events *cpuc);
+
 	struct event_constraint *event_constraints;
 	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
-- 
1.9.1

