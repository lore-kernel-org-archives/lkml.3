Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3DTTUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:20:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:3737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab3DTTT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="289106975"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/15] perf, core: Add generic transaction flags v3
Date: Sat, 20 Apr 2013 12:19:18 -0700
Message-Id: <1366485563-16209-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
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
generic and mostly applicable to other architectures too. In addition
to various flag words there's also reserved space to report an
program supplied abort code. For TSX this is used to distinguish specific
classes of aborts, like a lock busy abort when doing lock elision.

Flags:

Elision and generic transactions 		   (ELISION vs TRANSACTION)
Aborts caused by current thread vs aborts caused by others (SYNC vs ASYNC)
Retryable transaction				   (RETRY)
Conflicts with other threads			   (CONFLICT)
Transaction capacity overflow			   (CAPACITY)
Memory related abort				   (MEMORY)
Other unknown aborts				   (MISC)

Transactions implicitely aborted can also return an abort code.
This can be used to signal specific events to the profiler. A common
case is abort on lock busy in a RTM eliding library (code 0xff)
To handle this case we include the TSX abort code

Common example aborts in TSX would be:

- Conflict with another thread on memory read.
                                      Flags: TRANSACTION|ASYNC|CONFLICT|MEMORY
- executing a WRMSR in a transaction. Flags: TRANSACTION|SYNC|MISC
- aborting on a MMIO in a driver.     Flags: TRANSACTION|MEMORY|SYNC
- HLE transaction in user space is too large
                                      Flags: ELISION|SYNC|MEMORY|CAPACITY

The only flag that is somewhat TSX specific is ELISION.

This adds the perf core glue needed for reporting the new flag word out.

v2: Add MEM/MISC
v3: Move transaction to the end
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h      |    5 +++++
 include/uapi/linux/perf_event.h |   25 ++++++++++++++++++++++++-
 kernel/events/core.c            |    6 ++++++
 3 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 466e378..29f3420 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -580,6 +580,10 @@ struct perf_sample_data {
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
 	u64				weight;
+	/*
+	 * Transaction flags for abort events:
+	 */
+	u64				transaction;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -595,6 +599,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
+	data->transaction = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..44be18d 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -134,8 +134,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
+	PERF_SAMPLE_TRANSACTION			= 1U << 16,
 
-	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
 };
 
 /*
@@ -179,6 +180,28 @@ enum perf_sample_regs_abi {
 };
 
 /*
+ * Values for the transaction event qualifier, mostly for abort events.
+ */
+enum {
+	PERF_SAMPLE_TXN_ELISION     = (1 << 0), /* From elision */
+	PERF_SAMPLE_TXN_TRANSACTION = (1 << 1), /* From transaction */
+	PERF_SAMPLE_TXN_SYNC        = (1 << 2), /* Instruction is related */
+	PERF_SAMPLE_TXN_ASYNC       = (1 << 3), /* Instruction not related */
+	PERF_SAMPLE_TXN_RETRY       = (1 << 4), /* Retry possible */
+	PERF_SAMPLE_TXN_CONFLICT    = (1 << 5), /* Conflict abort */
+	PERF_SAMPLE_TXN_CAPACITY    = (1 << 6), /* Capacity abort */
+	PERF_SAMPLE_TXN_MEMORY      = (1 << 7), /* Memory related abort */
+	PERF_SAMPLE_TXN_MISC        = (1 << 8), /* Misc aborts */
+
+	PERF_SAMPLE_TXN_MAX	    = (1 << 9),  /* non-ABI */
+
+	/* bits 24..31 are reserved for the abort code */
+
+	PERF_SAMPLE_TXN_ABORT_MASK  = 0xff000000,
+	PERF_SAMPLE_TXN_ABORT_SHIFT = 24,
+};
+
+/*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
  *
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 98c0845..658760b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -979,6 +979,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		size += sizeof(data->weight);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		size += sizeof(data->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -4205,6 +4208,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		perf_output_put(handle, data->data_src.val);
+
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		perf_output_put(handle, data->transaction);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
-- 
1.7.7.6

