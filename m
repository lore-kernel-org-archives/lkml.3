Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab3GRXFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:05:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:25685 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab3GRXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="372649843"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Report TSX transaction abort cost as weight
Date: Thu, 18 Jul 2013 16:05:29 -0700
Message-Id: <1374188729-19860-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[This requires one patch to the user space code to revert
afab87b91f3f331d so that --weight works again without perf mem.
The patch has been submitted separately]

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
1.8.1.4

