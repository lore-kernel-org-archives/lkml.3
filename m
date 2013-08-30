Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3H3S77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:59:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45604 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3H3S7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/15] perf: make events stream always parsable
Date: Fri, 30 Aug 2013 15:58:48 -0300
Message-Id: <1377889138-8793-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The event stream is not always parsable because the format of a sample
is dependent on the sample_type of the selected event.  When there is
more than one selected event and the sample_types are not the same then
parsing becomes problematic.  A sample can be matched to its selected
event using the ID that is allocated when the event is opened.
Unfortunately, to get the ID from the sample means first parsing it.

This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
the ID at a fixed position so that the ID can be retrieved without
parsing the sample.  For sample events, that is the first position
immediately after the header.  For non-sample events, that is the last
position.

In this respect parsing samples requires that the sample_type and ID
values are recorded.  For example, perf tools records struct
perf_event_attr and the IDs within the perf.data file.  Those must be
read first before it is possible to parse samples found later in the
perf.data file.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/uapi/linux/perf_event.h | 27 ++++++++++++++++++++-------
 kernel/events/core.c            | 11 ++++++++++-
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 62c25a2..42cb7b6 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -134,8 +134,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
+	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 
-	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
 };
 
 /*
@@ -492,12 +493,12 @@ enum perf_event_type {
 	/*
 	 * If perf_event_attr.sample_id_all is set then all event types will
 	 * have the sample_type selected fields related to where/when
-	 * (identity) an event took place (TID, TIME, ID, CPU, STREAM_ID)
-	 * described in PERF_RECORD_SAMPLE below, it will be stashed just after
-	 * the perf_event_header and the fields already present for the existing
-	 * fields, i.e. at the end of the payload. That way a newer perf.data
-	 * file will be supported by older perf tools, with these new optional
-	 * fields being ignored.
+	 * (identity) an event took place (TID, TIME, ID, STREAM_ID, CPU,
+	 * IDENTIFIER) described in PERF_RECORD_SAMPLE below, it will be stashed
+	 * just after the perf_event_header and the fields already present for
+	 * the existing fields, i.e. at the end of the payload. That way a newer
+	 * perf.data file will be supported by older perf tools, with these new
+	 * optional fields being ignored.
 	 *
 	 * struct sample_id {
 	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
@@ -505,7 +506,12 @@ enum perf_event_type {
 	 * 	{ u64			id;       } && PERF_SAMPLE_ID
 	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
 	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 *	{ u64			id;	  } && PERF_SAMPLE_IDENTIFIER
 	 * } && perf_event_attr::sample_id_all
+	 *
+	 * Note that PERF_SAMPLE_IDENTIFIER duplicates PERF_SAMPLE_ID.  The
+	 * advantage of PERF_SAMPLE_IDENTIFIER is that its position is fixed
+	 * relative to header.size.
 	 */
 
 	/*
@@ -594,6 +600,13 @@ enum perf_event_type {
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
+	 *	#
+	 *	# Note that PERF_SAMPLE_IDENTIFIER duplicates PERF_SAMPLE_ID.
+	 *	# The advantage of PERF_SAMPLE_IDENTIFIER is that its position
+	 *	# is fixed relative to header.
+	 *	#
+	 *
+	 *	{ u64			id;	  } && PERF_SAMPLE_IDENTIFIER
 	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
 	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
 	 *	{ u64			time;     } && PERF_SAMPLE_TIME
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 928fae7..15d0f24 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1213,6 +1213,9 @@ static void perf_event__id_header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_TIME)
 		size += sizeof(data->time);
 
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		size += sizeof(data->id);
+
 	if (sample_type & PERF_SAMPLE_ID)
 		size += sizeof(data->id);
 
@@ -4280,7 +4283,7 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_TIME)
 		data->time = perf_clock();
 
-	if (sample_type & PERF_SAMPLE_ID)
+	if (sample_type & (PERF_SAMPLE_ID | PERF_SAMPLE_IDENTIFIER))
 		data->id = primary_event_id(event);
 
 	if (sample_type & PERF_SAMPLE_STREAM_ID)
@@ -4319,6 +4322,9 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		perf_output_put(handle, data->id);
 }
 
 void perf_event__output_id_sample(struct perf_event *event,
@@ -4432,6 +4438,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	perf_output_put(handle, *header);
 
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		perf_output_put(handle, data->id);
+
 	if (sample_type & PERF_SAMPLE_IP)
 		perf_output_put(handle, data->ip);
 
-- 
1.8.1.4

