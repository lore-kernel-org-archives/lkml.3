Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaGaUsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:48:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:40686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaGaUsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:48:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,774,1400050800"; 
   d="scan'208";a="463739857"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Handle extended offcore mask on Haswell
Date: Thu, 31 Jul 2014 13:48:09 -0700
Message-Id: <1406839689-23491-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

HSW-EP has a larger offcore mask than the client Haswell CPUs.
It is the same mask as on Sandy/IvyBridge-EP.

On the client parts some bits were also missing compared
to Sandy/IvyBridge, in particular the bits to match on a L4
cache hit.

Specifying extra bits is ignored by the CPU.

So use the snbep extended mask, which is a superset of the
client and the server, for all of Haswell.

This allows specifying a number of extra offcore events, like
for example for HSW-EP.

% perf stat -e cpu/event=0xb7,umask=0x1,offcore_rsp=0x3fffc00100,name=offcore_response_pf_l3_rfo_l3_miss_any_response/ true

which were <not counted> before.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2502d0d..42cd9bc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2552,7 +2552,10 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
 		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 63)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-- 
1.9.3

