Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3AQPZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:25:09 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:35178 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3AQPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:25:03 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 1/2] perf tools: add evsel prev_raw_count field
Date: Thu, 17 Jan 2013 16:24:46 +0100
Message-Id: <1358436287-22883-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358436287-22883-1-git-send-email-eranian@google.com>
References: <1358436287-22883-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field will be used by commands which print
counter deltas on regular timer intervals,
such as perf stat -T.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evsel.c |   21 +++++++++++++++++++++
 tools/perf/util/evsel.h |    1 +
 2 files changed, 22 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..132da7c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -646,6 +646,17 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
+	if (evsel->prev_raw_counts) {
+		struct perf_counts_values tmp;
+
+		tmp = evsel->prev_raw_counts->cpu[cpu];
+		evsel->prev_raw_counts->cpu[cpu] = count;
+
+		count.val = count.val - tmp.val;
+		count.ena = count.ena - tmp.ena;
+		count.run = count.run - tmp.run;
+	}
+
 	if (scale) {
 		if (count.run == 0)
 			count.val = 0;
@@ -684,6 +695,16 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 		}
 	}
 
+	if (evsel->prev_raw_counts) {
+		struct perf_counts_values tmp = evsel->prev_raw_counts->aggr;
+
+		evsel->prev_raw_counts->aggr = *aggr;
+
+		aggr->val = aggr->val - tmp.val;
+		aggr->ena = aggr->ena - tmp.ena;
+		aggr->run = aggr->run - tmp.run;
+	}
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

