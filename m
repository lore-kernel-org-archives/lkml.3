Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3HaIOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3HaIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:14:45 -0400
Date: Sat, 31 Aug 2013 01:13:49 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-ff3d527cebc1fa3707c617bfe9e74f53fcfb0955@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-6-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: make events stream always parsable
Git-Commit-ID: ff3d527cebc1fa3707c617bfe9e74f53fcfb0955
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:13:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff3d527cebc1fa3707c617bfe9e74f53fcfb0955
Gitweb:     http://git.kernel.org/tip/ff3d527cebc1fa3707c617bfe9e74f53fcfb0955
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:07 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 15:40:03 -0300

perf: make events stream always parsable

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
 
