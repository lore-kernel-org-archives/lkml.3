Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbaGHWQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:16:49 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50032 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaGHWQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:16:45 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH 1/4] perf: add ability to sample machine state on interrupt
Date: Wed,  9 Jul 2014 00:15:56 +0200
Message-Id: <1404857759-25105-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404857759-25105-1-git-send-email-eranian@google.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable capture of interrupted machine state in each
sample.

Registers to sample are passed per event in the
sample_regs_intr bitmask.

To sample interrupt machine state, the 
PERF_SAMPLE_INTR_REGS must be passed in
sample_type.

The list of available registers is arch
dependent and provided by asm/perf_regs.h

Registers are laid out as u64 in the order
of the bit order of sample_intr_regs.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h      |  7 +++++--
 include/uapi/linux/perf_event.h | 14 ++++++++++++-
 kernel/events/core.c            | 44 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..4970c1d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -78,7 +78,7 @@ struct perf_branch_stack {
 	struct perf_branch_entry	entries[0];
 };
 
-struct perf_regs_user {
+struct perf_regs {
 	__u64		abi;
 	struct pt_regs	*regs;
 };
@@ -595,7 +595,8 @@ struct perf_sample_data {
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
-	struct perf_regs_user		regs_user;
+	struct perf_regs		regs_user;
+	struct perf_regs		regs_intr;
 	u64				stack_user_size;
 	u64				weight;
 	/*
@@ -618,6 +619,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->weight = 0;
 	data->data_src.val = 0;
 	data->txn = 0;
+	data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
+	data->regs_intr.regs = NULL;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9269de2..543cc19 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_REGS_INTR			= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -334,6 +335,15 @@ struct perf_event_attr {
 
 	/* Align to u64. */
 	__u32	__reserved_2;
+	/*
+	 * Defines set of user regs to dump on samples.
+	 * state capture on:
+	 *  - precise = 0: PMU interrupt
+	 *  - precise > 0: sampled instruction
+	 *
+	 * See asm/perf_regs.h for details.
+	 */
+	__u64	sample_regs_intr;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -686,6 +696,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 * 	{ u64			abi; # enum perf_sample_regs_abi
+	 * 	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 57e9190..018939c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4296,7 +4296,7 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs_user *regs_user,
+static void perf_sample_regs_user(struct perf_regs *regs_user,
 				  struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
@@ -4312,6 +4312,14 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 	}
 }
 
+static void perf_sample_regs_intr(struct perf_regs *regs_user,
+				  struct pt_regs *regs)
+{
+	regs_user->regs = regs;
+	regs_user->abi  = perf_reg_abi(current);
+}
+
+
 /*
  * Get remaining task size from user stack pointer.
  *
@@ -4693,6 +4701,22 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		u64 abi = data->regs_intr.abi;
+		/*
+		 * If there are no regs to dump, notice it through
+		 * first u64 being zero (PERF_SAMPLE_REGS_ABI_NONE).
+		 */
+		perf_output_put(handle, abi);
+
+		if (abi) {
+			u64 mask = event->attr.sample_regs_intr;
+			perf_output_sample_regs(handle,
+						data->regs_intr.regs,
+						mask);
+		}
+	}
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
@@ -4779,7 +4803,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 		 * in case new sample type is added, because we could eat
 		 * up the rest of the sample size.
 		 */
-		struct perf_regs_user *uregs = &data->regs_user;
+		struct perf_regs *uregs = &data->regs_user;
 		u16 stack_size = event->attr.sample_stack_user;
 		u16 size = sizeof(u64);
 
@@ -4800,6 +4824,20 @@ void perf_prepare_sample(struct perf_event_header *header,
 		data->stack_user_size = stack_size;
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		/* regs dump ABI info */
+		int size = sizeof(u64);
+
+		perf_sample_regs_intr(&data->regs_intr, regs);
+
+		if (data->regs_intr.regs) {
+			u64 mask = event->attr.sample_regs_intr;
+			size += hweight64(mask) * sizeof(u64);
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6994,6 +7032,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			ret = -EINVAL;
 	}
 
+	if (attr->sample_type & PERF_SAMPLE_REGS_INTR)
+		ret = perf_reg_validate(attr->sample_regs_intr);
 out:
 	return ret;
 
-- 
1.8.3.2

