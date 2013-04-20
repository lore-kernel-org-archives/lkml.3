Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3DTTTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:19:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:3737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab3DTTT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="229707691"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/15] perf, x86: Add Haswell specific transaction flag reporting
Date: Sat, 20 Apr 2013 12:19:19 -0700
Message-Id: <1366485563-16209-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In the PEBS handler report the transaction flags using the new
generic transaction flags facility. Most of them come from
the "tsx_tuning" field in PEBSv2, but the abort code is derived
from the RAX register reported in the PEBS record.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 60683c4..f9bb903 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -812,6 +812,19 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+	    (x86_pmu.intel_cap.pebs_format >= 2) &&
+	    pebs_hsw->tsx_tuning)
+		data.weight = pebs_hsw->tsx_tuning & 0xffffffff;
+
+	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION) &&
+	    x86_pmu.intel_cap.pebs_format >= 2) {
+		data.transaction = pebs_hsw->tsx_tuning >> 32;
+		if ((data.transaction & PERF_SAMPLE_TXN_TRANSACTION) &&
+		    (pebs->ax & 1))
+			data.transaction |= pebs->ax & 0xff000000;
+	}
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.7.6

