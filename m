Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3AQUhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:37:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:33907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab3AQUhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:37:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="273439813"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 18/29] perf, x86: Add Haswell specific transaction flag reporting
Date: Thu, 17 Jan 2013 12:36:41 -0800
Message-Id: <1358455012-12287-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
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
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3094caa..4b657c2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -677,6 +677,15 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 			data.weight = ((struct pebs_record_v2 *)pebs)->nhm.lat;
 	}
 
+	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION) &&
+	    x86_pmu.intel_cap.pebs_format >= 2) {
+		data.transaction =
+		     ((struct pebs_record_v2 *)pebs)->tsx_tuning >> 32;
+		if ((data.transaction & PERF_SAMPLE_TXN_TRANSACTION) &&
+		    (pebs->ax & 1))
+			data.transaction |= pebs->ax & 0xff000000;
+	}
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.7.6

