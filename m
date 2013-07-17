Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3GQMiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:38:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:49447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab3GQMhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:37:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="371625999"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V7 13/14] perf tools: add a function to calculate sample event size
Date: Wed, 17 Jul 2013 15:43:13 +0300
Message-Id: <1374064994-17810-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374064994-17810-1-git-send-email-adrian.hunter@intel.com>
References: <1374064994-17810-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/util/evsel.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 7f5c36b..c49cb4c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -227,6 +227,8 @@ int perf_event__preprocess_sample(const union perf_event *self,
 
 const char *perf_event__name(unsigned int id);
 
+size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
+				     u64 sample_regs_user);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  u64 sample_regs_user,
 				  const struct perf_sample *sample,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 047ab02..7a5ff06 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1348,6 +1348,87 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	return 0;
 }
 
+size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
+				     u64 sample_regs_user)
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
+		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
+		result += 8192; /* To be on the safe side */
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
+		if (sample->user_regs.regs && sample_regs_user) {
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
 				  u64 sample_regs_user,
 				  const struct perf_sample *sample,
-- 
1.7.11.7

