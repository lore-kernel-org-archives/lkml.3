Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3CUUAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:00:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:32540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3CUUA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,888,1355126400"; 
   d="scan'208";a="282899612"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de, eranian@google.com,
        torvalds@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86: Move NMI clearing to end of PMI handler after the counter registers are reset
Date: Thu, 21 Mar 2013 12:59:54 -0700
Message-Id: <1363895995-12967-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
References: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This avoids some problems with spurious PMIs on Haswell.
Haswell seems to behave more like P4 in this regard. Do
the same thing as the P4 perf handler by unmasking
the NMI only at the end. Shouldn't make any difference
for earlier family 6 cores.

Tested on Haswell, IvyBridge, Westmere, Saltwell (Atom)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c5262ab..d440a4f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1148,16 +1148,6 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	/*
-	 * Some chipsets need to unmask the LVTPC in a particular spot
-	 * inside the nmi handler.  As a result, the unmasking was pushed
-	 * into all the nmi handlers.
-	 *
-	 * This handler doesn't seem to have any issues with the unmasking
-	 * so it was left at the top.
-	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
@@ -1217,6 +1207,12 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
+	/*
+	 * Only unmask the NMI after the overflow counters
+	 * have been reset. This avoids spurious NMIs on
+	 * Haswell CPUs.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	return handled;
 }
 
-- 
1.7.7.6

