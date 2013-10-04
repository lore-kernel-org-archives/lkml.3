Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3JDRd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:33:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3JDRdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:33:23 -0400
Date: Fri, 4 Oct 2013 10:32:27 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-fdfbbd07e91f8fe387140776f3fd94605f0c89e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1379688044-14173-2-git-send-email-andi@firstfloor.org>
References: <1379688044-14173-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add generic transaction flags
Git-Commit-ID: fdfbbd07e91f8fe387140776f3fd94605f0c89e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:32:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdfbbd07e91f8fe387140776f3fd94605f0c89e5
Gitweb:     http://git.kernel.org/tip/fdfbbd07e91f8fe387140776f3fd94605f0c89e5
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 20 Sep 2013 07:40:39 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:06:08 +0200

perf: Add generic transaction flags

Add a generic qualifier for transaction events, as a new sample
type that returns a flag word. This is particularly useful
for qualifying aborts: to distinguish aborts which happen
due to asynchronous events (like conflicts caused by another
CPU) versus instructions that lead to an abort.

The tuning strategies are very different for those cases,
so it's important to distinguish them easily and early.

Since it's inconvenient and inflexible to filter for this
in the kernel we report all the events out and allow
some post processing in user space.

The flags are based on the Intel TSX events, but should be fairly
generic and mostly applicable to other HTM architectures too. In addition
to various flag words there's also reserved space to report an
program supplied abort code. For TSX this is used to distinguish specific
classes of aborts, like a lock busy abort when doing lock elision.

Flags:

Elision and generic transactions 		   (ELISION vs TRANSACTION)
(HLE vs RTM on TSX; IBM etc.  would likely only use TRANSACTION)
Aborts caused by current thread vs aborts caused by others (SYNC vs ASYNC)
Retryable transaction				   (RETRY)
Conflicts with other threads			   (CONFLICT)
Transaction write capacity overflow		   (CAPACITY WRITE)
Transaction read capacity overflow		   (CAPACITY READ)

Transactions implicitely aborted can also return an abort code.
This can be used to signal specific events to the profiler. A common
case is abort on lock busy in a RTM eliding library (code 0xff)
To handle this case we include the TSX abort code

Common example aborts in TSX would be:

- Data conflict with another thread on memory read.
                                      Flags: TRANSACTION|ASYNC|CONFLICT
- executing a WRMSR in a transaction. Flags: TRANSACTION|SYNC
- HLE transaction in user space is too large
                                      Flags: ELISION|SYNC|CAPACITY-WRITE

The only flag that is somewhat TSX specific is ELISION.

This adds the perf core glue needed for reporting the new flag word out.

v2: Add MEM/MISC
v3: Move transaction to the end
v4: Separate capacity-read/write and remove misc
v5: Remove _SAMPLE. Move abort flags to 32bit. Rename
    transaction to txn
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379688044-14173-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h      |  5 +++++
 include/uapi/linux/perf_event.h | 25 ++++++++++++++++++++++++-
 kernel/events/core.c            |  6 ++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c8ba627..2e069d1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -584,6 +584,10 @@ struct perf_sample_data {
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
 	u64				weight;
+	/*
+	 * Transaction flags for abort events:
+	 */
+	u64				txn;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -599,6 +603,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
+	data->txn = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 009a655..da48837 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -136,8 +136,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
+	PERF_SAMPLE_TRANSACTION			= 1U << 17,
 
-	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
 };
 
 /*
@@ -181,6 +182,28 @@ enum perf_sample_regs_abi {
 };
 
 /*
+ * Values for the memory transaction event qualifier, mostly for
+ * abort events. Multiple bits can be set.
+ */
+enum {
+	PERF_TXN_ELISION        = (1 << 0), /* From elision */
+	PERF_TXN_TRANSACTION    = (1 << 1), /* From transaction */
+	PERF_TXN_SYNC           = (1 << 2), /* Instruction is related */
+	PERF_TXN_ASYNC          = (1 << 3), /* Instruction not related */
+	PERF_TXN_RETRY          = (1 << 4), /* Retry possible */
+	PERF_TXN_CONFLICT       = (1 << 5), /* Conflict abort */
+	PERF_TXN_CAPACITY_WRITE = (1 << 6), /* Capacity write abort */
+	PERF_TXN_CAPACITY_READ  = (1 << 7), /* Capacity read abort */
+
+	PERF_TXN_MAX	        = (1 << 8), /* non-ABI */
+
+	/* bits 32..63 are reserved for the abort code */
+
+	PERF_TXN_ABORT_MASK  = (0xffffffffULL << 32),
+	PERF_TXN_ABORT_SHIFT = 32,
+};
+
+/*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
  *
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b25d65c..c716385 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1201,6 +1201,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		size += sizeof(data->data_src.val);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		size += sizeof(data->txn);
+
 	event->header_size = size;
 }
 
@@ -4572,6 +4575,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		perf_output_put(handle, data->data_src.val);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		perf_output_put(handle, data->txn);
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
