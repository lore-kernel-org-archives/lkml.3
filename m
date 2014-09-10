Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaIJOLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:11:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:28748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaIJOLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="589215304"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 14/16] perf, x86: enable LBR callstack when recording callchain
Date: Wed, 10 Sep 2014 10:09:11 -0400
Message-Id: <1410358153-421-15-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410358153-421-1-git-send-email-kan.liang@intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

If a task specific event wants user space callchain but does not want
branch stack sampling, enable the LBR call stack facility implicitly.
The LBR call stack facility can help perf to get user space callchain
in case of there is no frame pointer.

Note: this feature only affects how to get user callchain. The kernel
callchain is always got by frame pointers.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 418e953..186f909 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -423,10 +423,23 @@ int x86_pmu_hw_config(struct perf_event *event)
 			if (!event->attr.exclude_kernel)
 				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
 		}
-	}
+	} else if (x86_pmu_has_lbr_callstack() &&
+		   (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+		   !has_branch_stack(event) &&
+		   !event->attr.exclude_user &&
+		   (event->attach_state & PERF_ATTACH_TASK)) {
+		/*
+		 * user did not specify branch_sample_type,
+		 * try using the LBR call stack facility to
+		 * record call chains of user program.
+		 */
+		event->attr.branch_sample_type =
+			PERF_SAMPLE_BRANCH_USER |
+			PERF_SAMPLE_BRANCH_CALL_STACK;
 
-	if (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
+		/* needs PMU specific data to save LBR stack */
 		event->attach_state |= PERF_ATTACH_TASK_DATA;
+	}
 
 	/*
 	 * Generate PMC IRQs:
-- 
1.8.3.2

