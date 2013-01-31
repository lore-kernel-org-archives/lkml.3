Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3AaK4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:56:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3AaK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:56:07 -0500
Date: Thu, 31 Jan 2013 02:55:37 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-c7a79c47c683de6979a3e1a96dc723b0606c07ca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1359460064-3060-2-git-send-email-eranian@google.com>
References: <1359460064-3060-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Add prev_raw_count field
Git-Commit-ID: c7a79c47c683de6979a3e1a96dc723b0606c07ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:55:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7a79c47c683de6979a3e1a96dc723b0606c07ca
Gitweb:     http://git.kernel.org/tip/c7a79c47c683de6979a3e1a96dc723b0606c07ca
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 29 Jan 2013 12:47:43 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:36:38 -0300

perf evsel: Add prev_raw_count field

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
