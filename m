Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663Ab3DBJmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:42:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab3DBJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:42:22 -0400
Date: Tue, 2 Apr 2013 02:42:09 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-c3feedf2aaf9ac8bad6f19f5d21e4ee0b4b87e9c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1359040242-8269-5-git-send-email-eranian@google.com>
References: <1359040242-8269-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/core: Add weighted samples
Git-Commit-ID: c3feedf2aaf9ac8bad6f19f5d21e4ee0b4b87e9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:42:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3feedf2aaf9ac8bad6f19f5d21e4ee0b4b87e9c
Gitweb:     http://git.kernel.org/tip/c3feedf2aaf9ac8bad6f19f5d21e4ee0b4b87e9c
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 24 Jan 2013 16:10:28 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:15:44 -0300

perf/core: Add weighted samples

For some events it's useful to weight sample with a hardware
provided number. This expresses how expensive the action the
sample represent was.  This allows the profiler to scale
the samples to be more informative to the programmer.

There is already the period which is used similarly, but it
means something different, so I chose to not overload it.
Instead a new sample type for WEIGHT is added.

Can be used for multiple things. Initially it is used for TSX
abort costs and profiling by memory latencies (so to make
expensive load appear higher up in the histograms). The concept
is quite generic and can be extended to many other kinds of
events or architectures, as long as the hardware provides
suitable auxillary values. In principle it could be also used
for software tracepoints.

This adds the generic glue. A new optional sample format for a
64-bit weight value.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-5-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h      | 2 ++
 include/uapi/linux/perf_event.h | 6 +++++-
 kernel/events/core.c            | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cd3bb2c..7ce0b37 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -573,6 +573,7 @@ struct perf_sample_data {
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
+	u64				weight;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -586,6 +587,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
+	data->weight = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9fa9c62..cdc255d 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -132,8 +132,10 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 	PERF_SAMPLE_REGS_USER			= 1U << 12,
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
+	PERF_SAMPLE_WEIGHT			= 1U << 14,
+
+	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
 
-	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
 };
 
 /*
@@ -588,6 +590,8 @@ enum perf_event_type {
 	 * 	{ u64			size;
 	 * 	  char			data[size];
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
+	 *
+	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b4a55d..9e3edb2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -976,6 +976,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		size += sizeof(data->period);
 
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		size += sizeof(data->weight);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
@@ -4193,6 +4196,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
 					  data->regs_user.regs);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		perf_output_put(handle, data->weight);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
