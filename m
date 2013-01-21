Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3AUOKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:10:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61708 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3AUOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:09:07 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v5 1/2] perf tools: add evsel prev_raw_count field
Date: Mon, 21 Jan 2013 15:06:53 +0100
Message-Id: <1358777214-14220-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358777214-14220-1-git-send-email-eranian@google.com>
References: <1358777214-14220-1-git-send-email-eranian@google.com>
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
index 1b16dd1..371e93d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -631,6 +631,28 @@ void perf_evsel__delete(struct perf_evsel *evsel)
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
@@ -646,6 +668,8 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
+	compute_deltas(evsel, cpu, &count);
+
 	if (scale) {
 		if (count.run == 0)
 			count.val = 0;
@@ -684,6 +708,8 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 		}
 	}
 
+	compute_deltas(evsel, -1, aggr);
+
 	evsel->counts->scaled = 0;
 	if (scale) {
 		if (aggr->run == 0) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3d2b801..63ea570 100644
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
1.7.9.5

