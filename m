Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaKPMhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:37:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbaKPMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:37:32 -0500
Date: Sun, 16 Nov 2014 04:37:02 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2565711fb7d7c28e0cd93c8971b520d1b10b857c@git.kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org, acme@kernel.org, tglx@linutronix.de,
        hpa@zytor.com
Reply-To: hpa@zytor.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        acme@kernel.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
In-Reply-To: <1411559322-16548-7-git-send-email-eranian@google.com>
References: <1411559322-16548-7-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Improve the perf_sample_data struct layout
Git-Commit-ID: 2565711fb7d7c28e0cd93c8971b520d1b10b857c
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

Commit-ID:  2565711fb7d7c28e0cd93c8971b520d1b10b857c
Gitweb:     http://git.kernel.org/tip/2565711fb7d7c28e0cd93c8971b520d1b10b857c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 13:48:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:42:04 +0100

perf: Improve the perf_sample_data struct layout

This patch reorders fields in the perf_sample_data struct in order to
minimize the number of cachelines touched in perf_sample_data_init().
It also removes some intializations which are redundant with the code
in kernel/events/core.c

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1411559322-16548-7-git-send-email-eranian@google.com
Cc: cebbert.lkml@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: jolsa@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h | 34 +++++++++++++++++-----------------
 kernel/events/core.c       | 16 ++++++++--------
 2 files changed, 25 insertions(+), 25 deletions(-)

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
index c2be159..3e19d3e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4471,8 +4471,11 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
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
 
@@ -4947,12 +4950,13 @@ void perf_prepare_sample(struct perf_event_header *header,
 		header->size += size;
 	}
 
+	if (sample_type & (PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER))
+		perf_sample_regs_user(&data->regs_user, regs);
+
 	if (sample_type & PERF_SAMPLE_REGS_USER) {
 		/* regs dump ABI info */
 		int size = sizeof(u64);
 
-		perf_sample_regs_user(&data->regs_user, regs);
-
 		if (data->regs_user.regs) {
 			u64 mask = event->attr.sample_regs_user;
 			size += hweight64(mask) * sizeof(u64);
@@ -4968,15 +4972,11 @@ void perf_prepare_sample(struct perf_event_header *header,
 		 * in case new sample type is added, because we could eat
 		 * up the rest of the sample size.
 		 */
-		struct perf_regs *uregs = &data->regs_user;
 		u16 stack_size = event->attr.sample_stack_user;
 		u16 size = sizeof(u64);
 
-		if (!uregs->abi)
-			perf_sample_regs_user(uregs, regs);
-
 		stack_size = perf_sample_ustack_size(stack_size, header->size,
-						     uregs->regs);
+						     data->regs_user.regs);
 
 		/*
 		 * If there is something to dump, add space for the dump
