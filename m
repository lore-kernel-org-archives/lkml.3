Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaBUVN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:13:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbaBUVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:13:24 -0500
Date: Fri, 21 Feb 2014 13:12:53 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-d64b25b6a08d95e973160689320504faed62be4a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-3-git-send-email-eranian@google.com>
References: <1392132015-14521-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore:
  add ability to customize pmu callbacks
Git-Commit-ID: d64b25b6a08d95e973160689320504faed62be4a
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

Commit-ID:  d64b25b6a08d95e973160689320504faed62be4a
Gitweb:     http://git.kernel.org/tip/d64b25b6a08d95e973160689320504faed62be4a
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:08 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:07 +0100

perf/x86/uncore: add ability to customize pmu callbacks

This patch enables custom struct pmu callbacks per uncore
PMU types. This feature may be used to simplify counter
setup for certain uncore PMUs which have free running
counters for instance. It becomes possible to bypass
the event scheduling phase of the configuration.

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-3-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 25 +++++++++++++++----------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  1 +
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
