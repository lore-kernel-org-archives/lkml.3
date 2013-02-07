Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab3BGTXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:23:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:61556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943Ab3BGTXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:23:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="282303428"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] perf, x86: Move NMI clearing to end of PMI handler after the counter registers are reset
Date: Thu,  7 Feb 2013 11:23:39 -0800
Message-Id: <1360265019-23865-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This avoids some problems with spurious PMIs on Haswell.
Haswell seems to behave more like P4 in this regard. Do
the same thing as the P4 perf handler by unmasking
the NMI only at the end. Shouldn't make any difference
for earlier non P4 cores.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 06dcc0c..00144a5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1122,16 +1122,6 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
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
@@ -1191,6 +1181,12 @@ again:
 
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

