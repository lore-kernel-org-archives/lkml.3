Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966902Ab3HIBQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:16:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:50853 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967072Ab3HIBPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,843,1367996400"; 
   d="scan'208";a="378363789"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf, x86: Report TSX transaction abort cost as weight
Date: Thu,  8 Aug 2013 18:15:44 -0700
Message-Id: <1376010946-28666-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the existing weight reporting facility to report the transaction
abort cost, that is the number of cycles wasted in aborts.
Haswell reports this in the PEBS record.

This was in fact the original user for weight.

This is a very useful sort key to concentrate on the most
costly aborts and a good metric for TSX tuning.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..8959cc7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -838,6 +838,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+	    !fll &&
+	    (x86_pmu.intel_cap.pebs_format >= 2) &&
+	    pebs_hsw->tsx_tuning)
+		data.weight = pebs_hsw->tsx_tuning & 0xffffffff;
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.8.3.1

