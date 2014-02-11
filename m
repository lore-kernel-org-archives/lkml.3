Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBKPWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:22:35 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61610 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaBKPUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:20:37 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v2 2/8] perf/x86/uncore: add ability to customize pmu callbacks
Date: Tue, 11 Feb 2014 16:20:08 +0100
Message-Id: <1392132015-14521-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392132015-14521-1-git-send-email-eranian@google.com>
References: <1392132015-14521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables custom struct pmu callbacks per uncore
PMU types. This feature may be used to simplify counter
setup for certain uncore PMUs which have free running
counters for instance. It becomes possible to bypass
the event scheduling phase of the configuration.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   25 +++++++++++++++----------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fe4255b..e6f32b3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3271,16 +3271,21 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
 
-	pmu->pmu = (struct pmu) {
-		.attr_groups	= pmu->type->attr_groups,
-		.task_ctx_nr	= perf_invalid_context,
-		.event_init	= uncore_pmu_event_init,
-		.add		= uncore_pmu_event_add,
-		.del		= uncore_pmu_event_del,
-		.start		= uncore_pmu_event_start,
-		.stop		= uncore_pmu_event_stop,
-		.read		= uncore_pmu_event_read,
-	};
+	if (!pmu->type->pmu) {
+		pmu->pmu = (struct pmu) {
+			.attr_groups	= pmu->type->attr_groups,
+			.task_ctx_nr	= perf_invalid_context,
+			.event_init	= uncore_pmu_event_init,
+			.add		= uncore_pmu_event_add,
+			.del		= uncore_pmu_event_del,
+			.start		= uncore_pmu_event_start,
+			.stop		= uncore_pmu_event_stop,
+			.read		= uncore_pmu_event_read,
+		};
+	} else {
+		pmu->pmu = *pmu->type->pmu;
+		pmu->pmu.attr_groups = pmu->type->attr_groups;
+	}
 
 	if (pmu->type->num_boxes == 1) {
 		if (strlen(pmu->type->name) > 0)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index a80ab71..77dc9a5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -440,6 +440,7 @@ struct intel_uncore_type {
 	struct intel_uncore_ops *ops;
 	struct uncore_event_desc *event_descs;
 	const struct attribute_group *attr_groups[4];
+	struct pmu *pmu; /* for custom pmu ops */
 };
 
 #define pmu_group attr_groups[0]
-- 
1.7.9.5

