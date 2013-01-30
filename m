Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3A3Orc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:47:32 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54446
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477Ab3A3OrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/21] perf evsel: Add prev_raw_count field
Date: Wed, 30 Jan 2013 11:46:54 -0300
Message-Id: <1359557222-17547-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This field will be used by commands which print counter deltas on
regular timer intervals, such as perf stat -I.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359460064-3060-2-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 26 ++++++++++++++++++++++++++
 tools/perf/util/evsel.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e45332d..dbdcca4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -659,6 +659,28 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	free(evsel);
 }
 
+static inline void compute_deltas(struct perf_evsel *evsel,
+				  int cpu,
+				  struct perf_counts_values *count)
+{
+	struct perf_counts_values tmp;
+
+	if (!evsel->prev_raw_counts)
+		return;
+
+	if (cpu == -1) {
+		tmp = evsel->prev_raw_counts->aggr;
+		evsel->prev_raw_counts->aggr = *count;
+	} else {
+		tmp = evsel->prev_raw_counts->cpu[cpu];
+		evsel->prev_raw_counts->cpu[cpu] = *count;
+	}
+
+	count->val = count->val - tmp.val;
+	count->ena = count->ena - tmp.ena;
+	count->run = count->run - tmp.run;
+}
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale)
 {
@@ -674,6 +696,8 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
+	compute_deltas(evsel, cpu, &count);
+
 	if (scale) {
 		if (count.run == 0)
 			count.val = 0;
@@ -712,6 +736,8 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 		}
 	}
 
+	compute_deltas(evsel, -1, aggr);
+
 	evsel->counts->scaled = 0;
 	if (scale) {
 		if (aggr->run == 0) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index c68d1b8..3a4cd60 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -53,6 +53,7 @@ struct perf_evsel {
 	struct xyarray		*sample_id;
 	u64			*id;
 	struct perf_counts	*counts;
+	struct perf_counts	*prev_raw_counts;
 	int			idx;
 	u32			ids;
 	struct hists		hists;
-- 
1.8.1.1.361.gec3ae6e

