Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaHHAPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:15:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:31348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaHHAPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="369517300"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf, x86: Fix haswell mem hierarchy flags reporting
Date: Thu,  7 Aug 2014 17:15:40 -0700
Message-Id: <1407456941-16232-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
References: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This fixes a bug introduced with

commit 722e76e60f2775c21b087ff12c5e678cf0ebcaaf
Author: Stephane Eranian <eranian@google.com>
Date:   Thu May 15 17:56:44 2014 +0200

    fix Haswell precise store data source encoding

When returning early we need to return the complete value of the
memory hierarchy, not just the mem_lvl. Otherwise any load/store/na
flags set early get lost.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 855c19e..8096d24 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -121,7 +121,6 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status,
 		dse.mem_op = PERF_MEM_OP_STORE;
 	else
 		dse.mem_op = PERF_MEM_OP_NA;
-	dse.mem_lvl = PERF_MEM_LVL_NA;
 
 	/*
 	 * L1 info only valid for following events:
@@ -131,8 +130,10 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status,
 	 * MEM_UOPS_RETIRED.SPLIT_STORES
 	 * MEM_UOPS_RETIRED.ALL_STORES
 	 */
-	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
-		return dse.mem_lvl;
+	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0) {
+		dse.mem_lvl = PERF_MEM_LVL_NA;
+		return dse.val;
+	}
 
 	if (status & 1)
 		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
-- 
1.9.3

