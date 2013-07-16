Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab3GPPKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:10:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab3GPPKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:10:14 -0400
Date: Tue, 16 Jul 2013 17:09:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 09/12] perf: make events stream always parsable
Message-ID: <20130716150907.GL23818@dyad.programming.kicks-ass.net>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
 <1373548341-24119-10-git-send-email-adrian.hunter@intel.com>
 <20130712095600.GT25631@dyad.programming.kicks-ass.net>
 <51DFFCE1.1070203@intel.com>
 <20130712145515.GI17211@twins.programming.kicks-ass.net>
 <51E3932C.5000905@intel.com>
 <51E4ECFB.6000104@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E4ECFB.6000104@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:49:31AM +0300, Adrian Hunter wrote:

> If you want the ID at the first position in the ID sample, it is do-able.
> It means perf tools will have to be changed to calculate the variable start
> position of the ID sample, and then parse the ID sample forwards from there.
> Please advise.

Oh urgh I see.. how about I merge something like the below first?

Re-reading your patch; you add something to struct sample_id; which means that
events which 'forget' to set perf_event_attr::sample_id_all while setting
PERF_SAMPLE_IDENTIFIER are 'funny'. Should we refuse them?


---
Subject: perf: Update perf_event_type documentation

Due to a discussion with Adrian I had a good look at the perf_event_type record
layout and found the documentation to be somewhat unclear.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/uapi/linux/perf_event.h | 21 +++++++++++++++++++--
 kernel/events/core.c            | 31 ++++++++++++++++---------------
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..335016c 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -478,6 +478,16 @@ enum perf_event_type {
 	 * file will be supported by older perf tools, with these new optional
 	 * fields being ignored.
 	 *
+	 * struct sample_id {
+	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
+	 * 	{ u64			id;       } && PERF_SAMPLE_ID
+	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
+	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 * } && perf_event_attr::sample_id_all
+	 */
+
+	/*
 	 * The MMAP events record the PROT_EXEC mappings so that we can
 	 * correlate userspace IPs to code. They have the following structure:
 	 *
@@ -488,7 +498,8 @@ enum perf_event_type {
 	 *	u64				addr;
 	 *	u64				len;
 	 *	u64				pgoff;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_MMAP			= 1,
@@ -498,6 +509,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u64				id;
 	 *	u64				lost;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_LOST			= 2,
@@ -508,6 +520,7 @@ enum perf_event_type {
 	 *
 	 *	u32				pid, tid;
 	 *	char				comm[];
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_COMM			= 3,
@@ -518,6 +531,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_EXIT			= 4,
@@ -528,6 +542,7 @@ enum perf_event_type {
 	 *	u64				time;
 	 *	u64				id;
 	 *	u64				stream_id;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_THROTTLE			= 5,
@@ -539,6 +554,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
@@ -549,6 +565,7 @@ enum perf_event_type {
 	 *	u32				pid, tid;
 	 *
 	 *	struct read_format		values;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_READ			= 8,
@@ -596,7 +613,7 @@ enum perf_event_type {
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
-	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 708ab70..c9ef899 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4462,20 +4462,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (!event->attr.watermark) {
-		int wakeup_events = event->attr.wakeup_events;
-
-		if (wakeup_events) {
-			struct ring_buffer *rb = handle->rb;
-			int events = local_inc_return(&rb->events);
-
-			if (events >= wakeup_events) {
-				local_sub(wakeup_events, &rb->events);
-				local_inc(&rb->wakeup);
-			}
-		}
-	}
-
 	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
 		if (data->br_stack) {
 			size_t size;
@@ -4511,16 +4497,31 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (sample_type & PERF_SAMPLE_STACK_USER)
+	if (sample_type & PERF_SAMPLE_STACK_USER) {
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
 					  data->regs_user.regs);
+	}
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		perf_output_put(handle, data->weight);
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		perf_output_put(handle, data->data_src.val);
+
+	if (!event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			struct ring_buffer *rb = handle->rb;
+			int events = local_inc_return(&rb->events);
+
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,

