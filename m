Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaF3Ivj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:51:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:53494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbaF3Ivf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="536451151"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V4 14/16] perf, x86: enable LBR callstack when recording callchain
Date: Mon, 30 Jun 2014 16:50:51 +0800
Message-Id: <1404118253-19532-15-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task specific event wants user space callchain but does not want
branch stack sampling, enable the LBR call stack facility implicitly.
The LBR call stack facility can help perf to get user space callchain
in case of there is no frame pointer.

Note: this feature only affects how to get user callchain. The kernel
callchain is always got by frame pointers.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cb2259f..7106c44 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -420,6 +420,18 @@ int x86_pmu_hw_config(struct perf_event *event)
 			if (!event->attr.exclude_kernel)
 				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
 		}
+	} else if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
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
 	}
 
 	/*
-- 
1.9.0

