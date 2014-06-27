Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaF0XKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:10:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:12742 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaF0XKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:10:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="554397036"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf, x86, ivb: Allow leaking events with ANY bit set
Date: Fri, 27 Jun 2014 16:10:12 -0700
Message-Id: <1403910612-8754-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Currently the leaking IVB events cannot be scheduled at all,
to avoid leaking information about other process.
When the ANY bit is set this does not matter: the process
already has all the needed priviledges and "leaking" is expected.
So allow these events with any bit set.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..db5cec3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -116,6 +116,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
+#define FLAGS_NOT_ANY (X86_ALL_EVENT_FLAGS & ~ARCH_PERFMON_EVENTSEL_ANY)
+
 static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
@@ -135,11 +137,12 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	 * Errata BV98 -- MEM_*_RETIRED events can leak between counters of SMT
 	 * siblings; disable these events because they can corrupt unrelated
 	 * counters.
+	 * But allow them with the ANY bit set.
 	 */
 	INTEL_EVENT_CONSTRAINT(0xd0, 0x0), /* MEM_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(FLAGS_NOT_ANY|0xd1, 0x0), /* MEM_LOAD_UOPS_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(FLAGS_NOT_ANY|0xd2, 0x0), /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(FLAGS_NOT_ANY|0xd3, 0x0), /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.9.3

