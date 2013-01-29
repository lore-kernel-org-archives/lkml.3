Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3A2LsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:48:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51837 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3A2LsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:48:06 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v7 1/2] perf tools: add evsel prev_raw_count field
Date: Tue, 29 Jan 2013 12:47:43 +0100
Message-Id: <1359460064-3060-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359460064-3060-1-git-send-email-eranian@google.com>
References: <1359460064-3060-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field will be used by commands which print
counter deltas on regular timer intervals,
such as perf stat -I.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evsel.c |   26 ++++++++++++++++++++++++++
 tools/perf/util/evsel.h |    1 +
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
1.7.10.4

