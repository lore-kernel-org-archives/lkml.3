Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3DTTWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:22:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:51316 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3DTTT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="229707690"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/15] perf, x86: Support PERF_SAMPLE_ADDR for all PEBS events v3
Date: Sat, 20 Apr 2013 12:19:17 -0700
Message-Id: <1366485563-16209-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell supplies the address for every PEBS memory event, so always fill it in
when the user requested it.  It will be 0 when not useful (no memory access)

v2: Now include fmt1 too, so it works on Nehalem and later.
v3: Remove extra code inside st|ld if.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e0a66f80..60683c4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -767,9 +767,6 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * if PEBS-LL or PreciseStore
 	 */
 	if (fll || fst) {
-		if (sample_type & PERF_SAMPLE_ADDR)
-			data.addr = pebs->dla;
-
 		/*
 		 * Use latency for weight (only avail with PEBS-LL)
 		 */
@@ -811,6 +808,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
+		x86_pmu.intel_cap.pebs_format >= 1)
+		data.addr = pebs->dla;
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.7.6

