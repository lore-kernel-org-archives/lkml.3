Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab3D2SpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:45:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:46609 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236Ab3D2SpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:45:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,575,1363158000"; 
   d="scan'208";a="234409324"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Date: Mon, 29 Apr 2013 11:45:08 -0700
Message-Id: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On IvyBridge MEM_*_RETIRED can leak through to the same counter
on the other thread. Add a dummy extra_reg to handle this case.
The extra reg is allocated and makes sure nothing different
runs on the same counter in the other thread.

This is normally only visible when multiplexing.

This patch doesn't 100% plug the hole, as the event may still get lost
when the other CPU thread does not have an enabled counter
(e.g. with per thread counting). However it fixes it well enough
for the common global profiling case (e.g. perf top / perf stat -a)
In theory it would be possible to handle the other cases
too, but it would need far more changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index e46f932..5462d6b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -46,6 +46,7 @@ enum extra_reg_type {
 	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
 	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
 	EXTRA_REG_LBR   = 2,	/* lbr_select */
+	EXTRA_REG_MEM_RETIRED = 3, /* used to run MEM_*_RETIRED alone */
 
 	EXTRA_REG_MAX		/* number of entries needed */
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 73121ad..4803bf3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -160,6 +160,22 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
+static struct extra_reg intel_ivb_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	/* 
+	 * A number of MEM_*_RETIRED events can leak through to the same counter
+	 * on the other SMT thread. Use a dummy extra reg to make sure they run
+	 * alone.
+	 */
+	INTEL_EVENT_EXTRA_REG(0xd0, 0, 0, MEM_RETIRED),
+	INTEL_EVENT_EXTRA_REG(0xd1, 0, 0, MEM_RETIRED),
+	INTEL_EVENT_EXTRA_REG(0xd2, 0, 0, MEM_RETIRED),
+	INTEL_EVENT_EXTRA_REG(0xd3, 0, 0, MEM_RETIRED),
+	EVENT_EXTRA_END
+};
+
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -2141,7 +2157,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_ivb_event_constraints;
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		x86_pmu.extra_regs = intel_ivb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
-- 
1.7.7.6

