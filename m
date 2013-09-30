Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3I3WAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:00:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:33880 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3I3V7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="367935970"
From: Andi Kleen <andi@firstfloor.org>
To: acma@infradead.org
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/6] perf, core: Add generic transaction flags v5
Date: Mon, 30 Sep 2013 14:58:58 -0700
Message-Id: <1380578343-31301-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
---
 include/linux/perf_event.h      |  5 +++++
 include/uapi/linux/perf_event.h | 25 ++++++++++++++++++++++++-
 kernel/events/core.c            |  6 ++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 866e85c..ee96093 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -562,6 +562,10 @@ struct perf_sample_data {
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
 	u64				weight;
+	/*
+	 * Transaction flags for abort events:
+	 */
+	u64				txn;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -577,6 +581,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
+	data->txn = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ca1d90b..fee1264 100644
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
index dd236b6..fe2d7c8 100644
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
 
@@ -4551,6 +4554,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		perf_output_put(handle, data->data_src.val);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		perf_output_put(handle, data->txn);
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
-- 
1.8.3.1

