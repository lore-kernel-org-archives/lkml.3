Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaKPMgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:36:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaKPMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:36:16 -0500
Date: Sun, 16 Nov 2014 04:35:43 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-60e2364e60e86e81bc6377f49779779e6120977f@git.kernel.org>
Cc: tglx@linutronix.de, acme@kernel.org, torvalds@linux-foundation.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com
Reply-To: tglx@linutronix.de, peterz@infradead.org,
        linux-kernel@vger.kernel.org, eranian@google.com, acme@kernel.org,
        hpa@zytor.com, torvalds@linux-foundation.org, mingo@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1411559322-16548-2-git-send-email-eranian@google.com>
References: <1411559322-16548-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add ability to sample machine state on interrupt
Git-Commit-ID: 60e2364e60e86e81bc6377f49779779e6120977f
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

Commit-ID:  60e2364e60e86e81bc6377f49779779e6120977f
Gitweb:     http://git.kernel.org/tip/60e2364e60e86e81bc6377f49779779e6120977f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 24 Sep 2014 13:48:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:41:57 +0100

perf: Add ability to sample machine state on interrupt

Enable capture of interrupted machine state for each sample.

Registers to sample are passed per event in the sample_regs_intr bitmask.

To sample interrupt machine state, the PERF_SAMPLE_INTR_REGS must be passed in
sample_type.

The list of available registers is arch dependent and provided by asm/perf_regs.h

Registers are laid out as u64 in the order of the bit order of sample_intr_regs.

This patch also adds a new ABI version PERF_ATTR_SIZE_VER4 because we extend
the perf_event_attr struct with a new u64 field.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: cebbert.lkml@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-api@vger.kernel.org
Link: http://lkml.kernel.org/r/1411559322-16548-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h      |  7 +++++--
 include/uapi/linux/perf_event.h | 15 +++++++++++++-
 kernel/events/core.c            | 46 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d0..68d46d5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -79,7 +79,7 @@ struct perf_branch_stack {
 	struct perf_branch_entry	entries[0];
 };
 
-struct perf_regs_user {
+struct perf_regs {
 	__u64		abi;
 	struct pt_regs	*regs;
 };
@@ -600,7 +600,8 @@ struct perf_sample_data {
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
-	struct perf_regs_user		regs_user;
+	struct perf_regs		regs_user;
+	struct perf_regs		regs_intr;
 	u64				stack_user_size;
 	u64				weight;
 	/*
@@ -630,6 +631,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->weight = 0;
 	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
+	data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
+	data->regs_intr.regs = NULL;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9d84540..9b79abb 100644
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
@@ -238,6 +239,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -334,6 +336,15 @@ struct perf_event_attr {
 
 	/* Align to u64. */
 	__u32	__reserved_2;
+	/*
+	 * Defines set of regs to dump for each sample
+	 * state captured on:
+	 *  - precise = 0: PMU interrupt
+	 *  - precise > 0: sampled instruction
+	 *
+	 * See asm/perf_regs.h for details.
+	 */
+	__u64	sample_regs_intr;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -686,6 +697,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			abi; # enum perf_sample_regs_abi
+	 *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cd5eef..c2be159 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4460,7 +4460,7 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs_user *regs_user,
+static void perf_sample_regs_user(struct perf_regs *regs_user,
 				  struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
@@ -4476,6 +4476,14 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 	}
 }
 
+static void perf_sample_regs_intr(struct perf_regs *regs_intr,
+				  struct pt_regs *regs)
+{
+	regs_intr->regs = regs;
+	regs_intr->abi  = perf_reg_abi(current);
+}
+
+
 /*
  * Get remaining task size from user stack pointer.
  *
@@ -4857,6 +4865,23 @@ void perf_output_sample(struct perf_output_handle *handle,
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
+
+			perf_output_sample_regs(handle,
+						data->regs_intr.regs,
+						mask);
+		}
+	}
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
@@ -4943,7 +4968,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 		 * in case new sample type is added, because we could eat
 		 * up the rest of the sample size.
 		 */
-		struct perf_regs_user *uregs = &data->regs_user;
+		struct perf_regs *uregs = &data->regs_user;
 		u16 stack_size = event->attr.sample_stack_user;
 		u16 size = sizeof(u64);
 
@@ -4964,6 +4989,21 @@ void perf_prepare_sample(struct perf_event_header *header,
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
+
+			size += hweight64(mask) * sizeof(u64);
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -7151,6 +7191,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			ret = -EINVAL;
 	}
 
+	if (attr->sample_type & PERF_SAMPLE_REGS_INTR)
+		ret = perf_reg_validate(attr->sample_regs_intr);
 out:
 	return ret;
 
