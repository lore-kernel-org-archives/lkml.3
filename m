Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3H3TBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:01:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3H3S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:14 -0400
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
Subject: [PATCH 10/15] perf tools: Add a function to calculate sample event size
Date: Fri, 30 Aug 2013 15:58:53 -0300
Message-Id: <1377889138-8793-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add perf_event__sample_event_size() which can be used when synthesizing
sample events to determine how big the resulting event will be, and
therefore how much memory to allocate.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-11-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h |  2 ++
 tools/perf/util/evsel.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1c80e13..93130d8 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -229,6 +229,8 @@ int perf_event__preprocess_sample(const union perf_event *self,
 
 const char *perf_event__name(unsigned int id);
 
+size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
+				     u64 sample_regs_user, u64 read_format);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  u64 sample_regs_user, u64 read_format,
 				  const struct perf_sample *sample,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7d62373..e8745fb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1465,6 +1465,98 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	return 0;
 }
 
+size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
+				     u64 sample_regs_user, u64 read_format)
+{
+	size_t sz, result = sizeof(struct sample_event);
+
+	if (type & PERF_SAMPLE_IDENTIFIER)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_IP)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_TID)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_TIME)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_ADDR)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_ID)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_STREAM_ID)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_CPU)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_PERIOD)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_READ) {
+		result += sizeof(u64);
+		if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+			result += sizeof(u64);
+		if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+			result += sizeof(u64);
+		/* PERF_FORMAT_ID is forced for PERF_SAMPLE_READ */
+		if (read_format & PERF_FORMAT_GROUP) {
+			sz = sample->read.group.nr *
+			     sizeof(struct sample_read_value);
+			result += sz;
+		} else {
+			result += sizeof(u64);
+		}
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		result += sz;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		result += sizeof(u32);
+		result += sample->raw_size;
+	}
+
+	if (type & PERF_SAMPLE_BRANCH_STACK) {
+		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
+		sz += sizeof(u64);
+		result += sz;
+	}
+
+	if (type & PERF_SAMPLE_REGS_USER) {
+		if (sample->user_regs.abi) {
+			result += sizeof(u64);
+			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			result += sz;
+		} else {
+			result += sizeof(u64);
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK_USER) {
+		sz = sample->user_stack.size;
+		result += sizeof(u64);
+		if (sz) {
+			result += sz;
+			result += sizeof(u64);
+		}
+	}
+
+	if (type & PERF_SAMPLE_WEIGHT)
+		result += sizeof(u64);
+
+	if (type & PERF_SAMPLE_DATA_SRC)
+		result += sizeof(u64);
+
+	return result;
+}
+
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  u64 sample_regs_user, u64 read_format,
 				  const struct perf_sample *sample,
-- 
1.8.1.4

