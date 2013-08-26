Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3HZMzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:55:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:52649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab3HZMy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:54:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="392111886"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V12 12/13] perf tools: add a function to calculate sample event size
Date: Mon, 26 Aug 2013 16:00:29 +0300
Message-Id: <1377522030-27870-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
References: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add perf_event__sample_event_size() which can be used when
synthesizing sample events to determine how big the resulting
event will be, and therefore how much memory to allocate.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.h |  2 ++
 tools/perf/util/evsel.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 84f704f..a452504 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -245,6 +245,8 @@ int perf_event__preprocess_sample(const union perf_event *self,
 
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
1.7.11.7

