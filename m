Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaHMIZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:25:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaHMIZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:25:35 -0400
Date: Wed, 13 Aug 2014 01:24:48 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-770eee1fd38c70a009b321f5dbe64358f42511fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1407785233-32193-4-git-send-email-eranian@google.com>
References: <1407785233-32193-4-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix data source encoding issues for load latency/precise store
Git-Commit-ID: 770eee1fd38c70a009b321f5dbe64358f42511fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  770eee1fd38c70a009b321f5dbe64358f42511fd
Gitweb:     http://git.kernel.org/tip/770eee1fd38c70a009b321f5dbe64358f42511fd
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 11 Aug 2014 21:27:12 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:15 +0200

perf/x86: Fix data source encoding issues for load latency/precise store

This patch fixes issues introuduce by Andi's previous patch 'Revamp PEBS'
series.

This patch fixes the following:

 - precise_store_data_hsw() encode the mem op type whenever we can
 - precise_store_data_hsw set the default data source correctly

 - 0 is not a valid init value for data source. Define PERF_MEM_NA as the
   default value

This bug was actually introduced by

    commit 722e76e60f2775c21b087ff12c5e678cf0ebcaaf
    Author: Stephane Eranian <eranian@google.com>
    Date:   Thu May 15 17:56:44 2014 +0200

        fix Haswell precise store data source encoding

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1407785233-32193-4-git-send-email-eranian@google.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: ak@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 11 +++++++----
 include/linux/perf_event.h                |  9 ++++++++-
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
index ef5b62b..f0a1036 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -608,6 +608,13 @@ struct perf_sample_data {
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
@@ -620,7 +627,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
-	data->data_src.val = 0;
+	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
 }
 
