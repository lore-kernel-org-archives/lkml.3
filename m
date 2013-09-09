Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3IITx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:53:56 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51623 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab3IITxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:53:52 -0400
Date: Mon, 9 Sep 2013 12:53:50 -0700
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, zheng.z.yan@intel.com,
        ak@linux.intel.com
Subject: [PATCH] perf/x86: fix uncore PCI fixed counter handling
Message-ID: <20130909195350.GA17643@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There was a bug in the handling of SNB-EP/IVB-EP uncore PCI
fixed counters, e.g., IMC. It would cause erratic values to
be returned for the IMC clockticks event. This was due to
a bogus hwc->config value which was then written to PCI
config space. The fixed counter has most fields marked as
reserved with hw reset values of 0. Yet the kernel was
defaulting to a hwc->config = ~0 and that was causing
the issues. The patch sets the hwc->config values for fixed
uncore event to 0. Now, the values of imc clockticks is
correct.
    
$ perf stat -a -C 0 -e uncore_imc_0/clockticks/ -I 1000 sleep 10
    
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index f14d9df..dfb4aa54 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2707,7 +2707,7 @@ uncore_get_event_constraint(struct intel_uncore_box *box, struct perf_event *eve
 			return c;
 	}
 
-	if (event->hw.config == ~0ULL)
+	if (event->attr.config == UNCORE_FIXED_EVENT)
 		return &constraint_fixed;
 
 	if (type->constraints) {
@@ -3011,7 +3011,9 @@ static int uncore_pmu_event_init(struct perf_event *event)
 		 */
 		if (pmu->type->single_fixed && pmu->pmu_idx > 0)
 			return -EINVAL;
-		hwc->config = ~0ULL;
+
+		/* fixed counters have event field hardcoded to zero */
+		hwc->config = 0ULL;
 	} else {
 		hwc->config = event->attr.config & pmu->type->event_mask;
 		if (pmu->type->ops->hw_config) {
