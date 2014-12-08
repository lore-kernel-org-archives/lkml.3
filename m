Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaLHGuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:50:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaLHGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:50:35 -0500
Date: Sun, 7 Dec 2014 22:50:15 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-857a94a226d7d345c3f492d5679e802e59f824a9@git.kernel.org>
Cc: cjashfor@linux.vnet.ibm.com, acme@redhat.com, tglx@linutronix.de,
        eranian@google.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        ak@linux.intel.com, hpa@zytor.com, matt.fleming@intel.com,
        paulus@samba.org, jolsa@kernel.org, dsahern@gmail.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org, fweisbec@gmail.com
Reply-To: jolsa@kernel.org, dsahern@gmail.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, matt.fleming@intel.com,
        paulus@samba.org, eranian@google.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, hpa@zytor.com,
        cjashfor@linux.vnet.ibm.com, tglx@linutronix.de, acme@redhat.com
In-Reply-To: <1416562275-12404-2-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Introduce perf_evsel__compute_deltas function
Git-Commit-ID: 857a94a226d7d345c3f492d5679e802e59f824a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  857a94a226d7d345c3f492d5679e802e59f824a9
Gitweb:     http://git.kernel.org/tip/857a94a226d7d345c3f492d5679e802e59f824a9
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:49 -0300

perf evsel: Introduce perf_evsel__compute_deltas function

Making compute_deltas functions global and renaming it to
perf_evsel__compute_deltas.

It will be used in stat command in later patch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1416562275-12404-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 9 ++++-----
 tools/perf/util/evsel.h | 3 +++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f2dc91f..1c73bc4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -876,9 +876,8 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	free(evsel);
 }
 
-static inline void compute_deltas(struct perf_evsel *evsel,
-				  int cpu,
-				  struct perf_counts_values *count)
+void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
+				struct perf_counts_values *count)
 {
 	struct perf_counts_values tmp;
 
@@ -913,7 +912,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
-	compute_deltas(evsel, cpu, &count);
+	perf_evsel__compute_deltas(evsel, cpu, &count);
 
 	if (scale) {
 		if (count.run == 0)
@@ -956,7 +955,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 		}
 	}
 
-	compute_deltas(evsel, -1, aggr);
+	perf_evsel__compute_deltas(evsel, -1, aggr);
 
 	evsel->counts->scaled = 0;
 	if (scale) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 9797909..746b7ea 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -110,6 +110,9 @@ struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
+				struct perf_counts_values *count);
+
 int perf_evsel__object_config(size_t object_size,
 			      int (*init)(struct perf_evsel *evsel),
 			      void (*fini)(struct perf_evsel *evsel));
