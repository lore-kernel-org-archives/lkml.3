Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaKGQ1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:05 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48296 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbaKGQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:03 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH 02/11] perf: allow for PMU-specific event filtering
Date: Fri,  7 Nov 2014 16:25:27 +0000
Message-Id: <1415377536-12841-3-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain circumstances it may not be possible to schedule particular
events due to constraints other than a lack of hardware counters (e.g.
on big.LITTLE systems where CPUs support different events). The core
perf event code does not distinguish these cases and pessimistically
assumes that any failure to schedule an events is due to a lack of
hardware counters, ending event group scheduling early despite hardware
counters remaining available.

When such an unschedulable event exists in a ctx->flexible_groups list
it can unnecessarily prevent event groups following it in the list from
being scheduled until it is rotated to the end of the list. This can
result in events being scheduled for only a portion of the time they
would otherwise be eligible, and for short running programs unfortunate
initial list ordering can result in no events being counted.

This patch adds a new (optional) filter_match function pointer to struct
pmu which backends can use to tell the perf core whether or not it is
worth attempting to schedule an event. This plugs into the existing
event_filter_match logic, and makes it possible to avoid the scheduling
problem described above.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
---
 include/linux/perf_event.h | 5 +++++
 kernel/events/core.c       | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d0..80c5f5f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -263,6 +263,11 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * Filter events for PMU-specific reasons.
+	 */
+	int (*filter_match)		(struct perf_event *event); /* optional */
 };
 
 /**
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2b02c9f..770b276 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1428,11 +1428,17 @@ static int __init perf_workqueue_init(void)
 
 core_initcall(perf_workqueue_init);
 
+static inline int pmu_filter_match(struct perf_event *event)
+{
+	struct pmu *pmu = event->pmu;
+	return pmu->filter_match ? pmu->filter_match(event) : 1;
+}
+
 static inline int
 event_filter_match(struct perf_event *event)
 {
 	return (event->cpu == -1 || event->cpu == smp_processor_id())
-	    && perf_cgroup_match(event);
+	    && perf_cgroup_match(event) && pmu_filter_match(event);
 }
 
 static void
-- 
1.9.1

