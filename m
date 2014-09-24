Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaIXLuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:50:19 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48587 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaIXLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:50:17 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, cebbert.lkml@gmail.com
Subject: [PATCH v7 6/6] perf: improve perf_sample_data struct layout
Date: Wed, 24 Sep 2014 13:48:42 +0200
Message-Id: <1411559322-16548-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411559322-16548-1-git-send-email-eranian@google.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

This patch reorders fields in the perf_sample_data
struct in order to minimize the number of cachelines
touched in perf_sample_data_init(). It also removes
some intializations which are redundant with the
code in kernel/events/core.c

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/perf_event.h |   34 +++++++++++++++++-----------------
 kernel/events/core.c       |    5 ++++-
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 68d46d5..486e84c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -580,35 +580,40 @@ extern u64 perf_event_read_value(struct perf_event *event,
 
 
 struct perf_sample_data {
-	u64				type;
+	/*
+	 * Fields set by perf_sample_data_init(), group so as to
+	 * minimize the cachelines touched.
+	 */
+	u64				addr;
+	struct perf_raw_record		*raw;
+	struct perf_branch_stack	*br_stack;
+	u64				period;
+	u64				weight;
+	u64				txn;
+	union  perf_mem_data_src	data_src;
 
+	/*
+	 * The other fields, optionally {set,used} by
+	 * perf_{prepare,output}_sample().
+	 */
+	u64				type;
 	u64				ip;
 	struct {
 		u32	pid;
 		u32	tid;
 	}				tid_entry;
 	u64				time;
-	u64				addr;
 	u64				id;
 	u64				stream_id;
 	struct {
 		u32	cpu;
 		u32	reserved;
 	}				cpu_entry;
-	u64				period;
-	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
-	struct perf_raw_record		*raw;
-	struct perf_branch_stack	*br_stack;
 	struct perf_regs		regs_user;
 	struct perf_regs		regs_intr;
 	u64				stack_user_size;
-	u64				weight;
-	/*
-	 * Transaction flags for abort events:
-	 */
-	u64				txn;
-};
+} ____cacheline_aligned;
 
 /* default value for data source */
 #define PERF_MEM_NA (PERF_MEM_S(OP, NA)   |\
@@ -625,14 +630,9 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->raw  = NULL;
 	data->br_stack = NULL;
 	data->period = period;
-	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
-	data->regs_user.regs = NULL;
-	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
-	data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
-	data->regs_intr.regs = NULL;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7941343..64a95be 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4441,8 +4441,11 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	}
 
 	if (regs) {
-		regs_user->regs = regs;
 		regs_user->abi  = perf_reg_abi(current);
+		regs_user->regs = regs;
+	} else {
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
+		regs_user->regs = NULL;
 	}
 }
 
-- 
1.7.9.5

