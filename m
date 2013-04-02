Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661Ab3DBJlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:41:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50888 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab3DBJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:41:13 -0400
Date: Tue, 2 Apr 2013 02:40:56 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-9fac2cf316b070ae43d2ae2525e381ff2d1d68aa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1359040242-8269-4-git-send-email-eranian@google.com>
References: <1359040242-8269-4-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Add flags to event constraints
Git-Commit-ID: 9fac2cf316b070ae43d2ae2525e381ff2d1d68aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:41:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fac2cf316b070ae43d2ae2525e381ff2d1d68aa
Gitweb:     http://git.kernel.org/tip/9fac2cf316b070ae43d2ae2525e381ff2d1d68aa
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:27 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:15:04 -0300

perf/x86: Add flags to event constraints

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
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-4-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c              | 2 +-
 arch/x86/kernel/cpu/perf_event.h              | 8 +++++---
 arch/x86/kernel/cpu/perf_event_intel.c        | 6 +++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     | 4 +++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 include/linux/perf_event.h                    | 1 +
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
