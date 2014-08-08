Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaHHUlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:41:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55206 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaHHUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:40:32 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com
Subject: [PATCH 3/4] perf/x86: fix data source encoding issues for load latency/precise store
Date: Fri,  8 Aug 2014 22:40:51 +0200
Message-Id: <1407530452-19774-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407530452-19774-1-git-send-email-eranian@google.com>
References: <1407530452-19774-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes issues introuduce by Andi's previous patch 'Revamp PEBS'
series.

This patch fixes the following:
 - 0 is not a valid init value for data source. Define PERF_MEM_NA as the
   default value

- precise_store_data_hsw() encode the mem op type whenever we can
- precise_store_data_hsw set the default data source correctly

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   11 +++++++----
 include/linux/perf_event.h                |    9 ++++++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index a9b60f3..67919ce 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -113,9 +113,12 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 	union perf_mem_data_src dse;
 	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
-	dse.val = 0;
-	dse.mem_op = PERF_MEM_OP_NA;
-	dse.mem_lvl = PERF_MEM_LVL_NA;
+	dse.val = PERF_MEM_NA;
+
+	if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+		dse.mem_op = PERF_MEM_OP_STORE;
+	else if (event->hw.flags & PERF_X86_EVENT_PEBS_LD_HSW)
+		dse.mem_op = PERF_MEM_OP_LOAD;
 
 	/*
 	 * L1 info only valid for following events:
@@ -126,7 +129,7 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 	 * MEM_UOPS_RETIRED.ALL_STORES
 	 */
 	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
-		return dse.mem_lvl;
+		return dse.val;
 
 	if (status & 1)
 		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..8b206aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -604,6 +604,13 @@ struct perf_sample_data {
 	u64				txn;
 };
 
+/* default value for data source */
+#define PERF_MEM_NA (PERF_MEM_S(OP, NA)   |\
+		    PERF_MEM_S(LVL, NA)   |\
+		    PERF_MEM_S(SNOOP, NA) |\
+		    PERF_MEM_S(LOCK, NA)  |\
+		    PERF_MEM_S(TLB, NA))
+
 static inline void perf_sample_data_init(struct perf_sample_data *data,
 					 u64 addr, u64 period)
 {
@@ -616,7 +623,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
-	data->data_src.val = 0;
+	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
 }
 
-- 
1.7.9.5

