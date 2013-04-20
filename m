Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3DTTUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:20:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:52670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3DTTT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="325492677"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/15] perf, x86: Disable software LBR filter for Sandy Bridge/Haswell
Date: Sat, 20 Apr 2013 12:19:10 -0700
Message-Id: <1366485563-16209-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

Sandy Bridge and Haswell support all required LBR filters natively,
so there is no need to do instruction decoding in branch_type.
This lowers the overhead of LBR sampling with filters.

We enable far calls for call, so calls include exceptions, but that
seems like a acceptable trade off for much faster LBR sampling.

[Description and changes from AK]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |    1 +
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 563d6e8..2341d9f 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -428,6 +428,7 @@ struct x86_pmu {
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
 	bool		lbr_double_abort;	   /* duplicated lbr aborts */
+	bool		lbr_no_sw_filter;	   /* HW does all filters */
 
 	/*
 	 * Extra registers for events
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 33b6b5f..18f5a08 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -608,6 +608,9 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 	int i, j, type;
 	bool compress = false;
 
+	if (x86_pmu.lbr_no_sw_filter)
+		return;
+
 	/* if sampling all branches, then nothing to filter */
 	if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
 		return;
@@ -727,12 +730,13 @@ void intel_pmu_lbr_init_snb(void)
 
 	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
 	x86_pmu.lbr_sel_map  = snb_lbr_sel_map;
+	x86_pmu.lbr_no_sw_filter = true;
 
 	/*
-	 * SW branch filter usage:
-	 * - support syscall, sysret capture.
-	 *   That requires LBR_FAR but that means far
-	 *   jmp need to be filtered out
+	 * We include interrupts/exceptions
+	 * with calls. While technically they are not,
+	 * it's not worth extra filtering just to
+	 * get rid of them.
 	 */
 	pr_cont("16-deep LBR, ");
 }
-- 
1.7.7.6

