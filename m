Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbaCQGAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:00:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:25426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbaCQF6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:58:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,667,1389772800"; 
   d="scan'208";a="473898424"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 14/16] perf, x86: enable LBR callstack when recording callchain
Date: Mon, 17 Mar 2014 13:57:34 +0800
Message-Id: <1395035856-15411-15-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
References: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
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
index ec972ea..92a61a6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -429,6 +429,18 @@ int x86_pmu_hw_config(struct perf_event *event)
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
1.8.5.3

