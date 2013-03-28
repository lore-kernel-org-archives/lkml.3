Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3C1RGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:06:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47754
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924Ab3C1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        peterz@infradead.org, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 17/36] perf/x86: Add flags to event constraints
Date: Thu, 28 Mar 2013 14:02:17 -0300
Message-Id: <1364490156-32064-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch adds a flags field to each event constraint.
It can be used to store event specific features which can
then later be used by scheduling code or low-level x86 code.

The flags are propagated into event->hw.flags during the
get_event_constraint() call. They are cleared during the
put_event_constraint() call.

This mechanism is going to be used by the PEBS-LL patches.
It avoids defining yet another table to hold event specific
information.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-4-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c              |    2 +-
 arch/x86/kernel/cpu/perf_event.h              |    8 +++++---
 arch/x86/kernel/cpu/perf_event_intel.c        |    6 +++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     |    4 +++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 include/linux/perf_event.h                    |    1 +
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6e8ab04..8ba5151 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1489,7 +1489,7 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters, 0);
+				   0, x86_pmu.num_counters, 0, 0);
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b1518ee..9686d38 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -59,6 +59,7 @@ struct event_constraint {
 	u64	cmask;
 	int	weight;
 	int	overlap;
+	int	flags;
 };
 
 struct amd_nb {
@@ -170,16 +171,17 @@ struct cpu_hw_events {
 	void				*kfree_on_online;
 };
 
-#define __EVENT_CONSTRAINT(c, n, m, w, o) {\
+#define __EVENT_CONSTRAINT(c, n, m, w, o, f) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
 	.overlap = (o),			\
+	.flags = f,			\
 }
 
 #define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0)
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0, 0)
 
 /*
  * The overlap flag marks event constraints with overlapping counter
@@ -203,7 +205,7 @@ struct cpu_hw_events {
  * and its counter masks must be kept at a minimum.
  */
 #define EVENT_CONSTRAINT_OVERLAP(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1)
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1, 0)
 
 /*
  * Constraint on the Event code.
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dab7580..df3beaa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1392,8 +1392,11 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
+			if ((event->hw.config & c->cmask) == c->code) {
+				/* hw.flags zeroed at initialization */
+				event->hw.flags |= c->flags;
 				return c;
+			}
 		}
 	}
 
@@ -1438,6 +1441,7 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
+	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 826054a..f30d85b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -430,8 +430,10 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 
 	if (x86_pmu.pebs_constraints) {
 		for_each_event_constraint(c, x86_pmu.pebs_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
+			if ((event->hw.config & c->cmask) == c->code) {
+				event->hw.flags |= c->flags;
 				return c;
+			}
 		}
 	}
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b43200d..75da9e1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2438,7 +2438,7 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 
 	type->unconstrainted = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << type->num_counters) - 1,
-				0, type->num_counters, 0);
+				0, type->num_counters, 0, 0);
 
 	for (i = 0; i < type->num_boxes; i++) {
 		pmus[i].func_id = -1;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1c59211..cd3bb2c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -127,6 +127,7 @@ struct hw_perf_event {
 			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
+			int		flags;
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;
-- 
1.7.1

