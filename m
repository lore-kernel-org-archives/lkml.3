Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3AYWg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:36:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:48890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab3AYWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="252629024"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/18] perf, core: Add generic transaction flags v3
Date: Fri, 25 Jan 2013 14:33:01 -0800
Message-Id: <1359153192-13409-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
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

This adds the perf core glue needed for reporting the new flag word out.

v2: Add MEM/MISC
v3: Move transaction to the end
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h      |    2 ++
 include/uapi/linux/perf_event.h |   26 ++++++++++++++++++++++++--
 kernel/events/core.c            |    6 ++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c9686c8..c32fba3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -589,6 +589,7 @@ struct perf_sample_data {
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
 	u64				weight;
+	u64				transaction;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -603,6 +604,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
+	data->transaction = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 309968a..6b47798 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -133,9 +133,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_REGS_USER			= 1U << 12,
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
+	PERF_SAMPLE_TRANSACTION			= 1U << 15,
 
-	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
-
+	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
 };
 
 /*
@@ -179,6 +179,28 @@ enum perf_sample_regs_abi {
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
index 749bdf4..b4078a0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -955,6 +955,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		size += sizeof(data->weight);
 
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		size += sizeof(data->transaction);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -4175,6 +4178,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		perf_output_put(handle, data->weight);
+
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		perf_output_put(handle, data->transaction);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
-- 
1.7.7.6

