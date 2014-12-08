Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaLHGuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:50:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaLHGuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:50:51 -0500
Date: Sun, 7 Dec 2014 22:50:31 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-13112bbf595d4081f291f7061bb096dbf4401d41@git.kernel.org>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, dsahern@gmail.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, cjashfor@linux.vnet.ibm.com,
        eranian@google.com, hpa@zytor.com, paulus@samba.org,
        ak@linux.intel.com
Reply-To: dsahern@gmail.com, namhyung@kernel.org, jolsa@kernel.org,
        mingo@kernel.org, tglx@linutronix.de, matt.fleming@intel.com,
        ak@linux.intel.com, paulus@samba.org, hpa@zytor.com,
        eranian@google.com, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, acme@redhat.com
In-Reply-To: <1416562275-12404-3-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Introduce perf_counts_values__scale function
Git-Commit-ID: 13112bbf595d4081f291f7061bb096dbf4401d41
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

Commit-ID:  13112bbf595d4081f291f7061bb096dbf4401d41
Gitweb:     http://git.kernel.org/tip/13112bbf595d4081f291f7061bb096dbf4401d41
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:06 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:50 -0300

perf evsel: Introduce perf_counts_values__scale function

Factoring out scale login into perf_counts_values__scale function.

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
Link: http://lkml.kernel.org/r/1416562275-12404-3-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 47 ++++++++++++++++++++++-------------------------
 tools/perf/util/evsel.h |  3 +++
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1c73bc4..6dc7a67 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -897,6 +897,26 @@ void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
 	count->run = count->run - tmp.run;
 }
 
+void perf_counts_values__scale(struct perf_counts_values *count,
+			       bool scale, s8 *pscaled)
+{
+	s8 scaled = 0;
+
+	if (scale) {
+		if (count->run == 0) {
+			scaled = -1;
+			count->val = 0;
+		} else if (count->run < count->ena) {
+			scaled = 1;
+			count->val = (u64)((double) count->val * count->ena / count->run + 0.5);
+		}
+	} else
+		count->ena = count->run = 0;
+
+	if (pscaled)
+		*pscaled = scaled;
+}
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale)
 {
@@ -913,15 +933,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 		return -errno;
 
 	perf_evsel__compute_deltas(evsel, cpu, &count);
-
-	if (scale) {
-		if (count.run == 0)
-			count.val = 0;
-		else if (count.run < count.ena)
-			count.val = (u64)((double)count.val * count.ena / count.run + 0.5);
-	} else
-		count.ena = count.run = 0;
-
+	perf_counts_values__scale(&count, scale, NULL);
 	evsel->counts->cpu[cpu] = count;
 	return 0;
 }
@@ -956,22 +968,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	}
 
 	perf_evsel__compute_deltas(evsel, -1, aggr);
-
-	evsel->counts->scaled = 0;
-	if (scale) {
-		if (aggr->run == 0) {
-			evsel->counts->scaled = -1;
-			aggr->val = 0;
-			return 0;
-		}
-
-		if (aggr->run < aggr->ena) {
-			evsel->counts->scaled = 1;
-			aggr->val = (u64)((double)aggr->val * aggr->ena / aggr->run + 0.5);
-		}
-	} else
-		aggr->ena = aggr->run = 0;
-
+	perf_counts_values__scale(aggr, scale, &evsel->counts->scaled);
 	return 0;
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 746b7ea..7af0377 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -110,6 +110,9 @@ struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+void perf_counts_values__scale(struct perf_counts_values *count,
+			       bool scale, s8 *pscaled);
+
 void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
 				struct perf_counts_values *count);
 
