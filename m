Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825Ab3ECMU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:20:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761377Ab3ECMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:20:23 -0400
Message-Id: <20130503121256.083340271@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 03 May 2013 14:11:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, eranian@google.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
References: <20130503121122.931661809@chello.nl>
Content-Disposition: inline; filename=peterz-perf-x86-ivb-mem-retired.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errata BV98 states that all MEM_*_RETIRED events corrupt the counter
value of the SMT sibling's counters. Blacklist these events

Cc: eranian@google.com
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-jwra43mujrv1oq9xk6mfe57v@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -128,10 +128,15 @@ static struct event_constraint intel_ivb
 	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	INTEL_EVENT_CONSTRAINT(0xd0, 0xf), /* MEM_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0xf), /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0xf), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0xf), /*  MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	/*
+	 * Errata BV98 -- MEM_*_RETIRED events can leak between counters of SMT
+	 * siblings; disable these events because they can corrupt unrelated
+	 * counters.
+	 */
+	INTEL_EVENT_CONSTRAINT(0xd0, 0x0), /* MEM_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 


