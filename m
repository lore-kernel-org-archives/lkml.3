Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab3HaIPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:15:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab3HaIP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:15:28 -0400
Date: Sat, 31 Aug 2013 01:14:44 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-b1cf6f65aa7096984836addab7cec6b5b6d4393a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-11-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-11-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add a function to calculate sample event size
Git-Commit-ID: b1cf6f65aa7096984836addab7cec6b5b6d4393a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:14:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1cf6f65aa7096984836addab7cec6b5b6d4393a
Gitweb:     http://git.kernel.org/tip/b1cf6f65aa7096984836addab7cec6b5b6d4393a
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:12 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 16:44:26 -0300

perf tools: Add a function to calculate sample event size

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
