Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3EUKxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:53:43 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:38480 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3EUKxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:53:41 -0400
Date: Tue, 21 May 2013 12:53:37 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com
Subject: [PATCH] perf: check branch sampling priv level in generic code
Message-ID: <20130521105337.GA2879@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch reverts commit 7cc23cd:
 perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

The check is now implemented in generic code
instead of x86 specific code. That way we
do not have to repeat the test in each arch
supporting branch sampling.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   13 +++----------
 kernel/events/core.c                       |    9 ++++-----
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d978353..de341d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -310,7 +310,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -318,11 +318,8 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
 		mask |= X86_BR_KERNEL;
-	}
 
 	/* we ignore BRANCH_HV here */
 
@@ -342,8 +339,6 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
-
-	return 0;
 }
 
 /*
@@ -391,9 +386,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	ret = intel_pmu_setup_sw_lbr_filter(event);
-	if (ret)
-		return ret;
+	intel_pmu_setup_sw_lbr_filter(event);
 
 	/*
 	 * setup HW LBR filter, if any
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..cf79c81 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6327,11 +6327,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 		if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
 			return -EINVAL;
 
-		/* kernel level capture: check permissions */
-		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
-		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-
 		/* propagate priv level, when not set for branch */
 		if (!(mask & PERF_SAMPLE_BRANCH_PLM_ALL)) {
 
@@ -6349,6 +6344,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			 */
 			attr->branch_sample_type = mask;
 		}
+		/* kernel level capture: check permissions */
+		if ((mask & PERF_SAMPLE_BRANCH_KERNEL)
+		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 	}
 
 	if (attr->sample_type & PERF_SAMPLE_REGS_USER) {
-- 
1.7.9.5

