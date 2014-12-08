Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaLHGxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:53:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaLHGxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:53:12 -0500
Date: Sun, 7 Dec 2014 22:52:53 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-6c0345b73b970078c3e71ecc614a007207a1428a@git.kernel.org>
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org,
        namhyung@kernel.org, jolsa@kernel.org, hpa@zytor.com, paulus@samba.org,
        matt.fleming@intel.com, dsahern@gmail.com, eranian@google.com,
        cjashfor@linux.vnet.ibm.com, ak@linux.intel.com
Reply-To: ak@linux.intel.com, matt.fleming@intel.com,
        cjashfor@linux.vnet.ibm.com, dsahern@gmail.com, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, namhyung@kernel.org,
        jolsa@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, acme@redhat.com
In-Reply-To: <1416562275-12404-12-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-12-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add support for snapshot counters
Git-Commit-ID: 6c0345b73b970078c3e71ecc614a007207a1428a
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

Commit-ID:  6c0345b73b970078c3e71ecc614a007207a1428a
Gitweb:     http://git.kernel.org/tip/6c0345b73b970078c3e71ecc614a007207a1428a
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:15 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:31 -0300

perf stat: Add support for snapshot counters

The .snapshot file indicates that the provided event value is a snapshot
value. Bypassing the delta computation logic for such event.

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
Link: http://lkml.kernel.org/r/1416562275-12404-12-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 860e8ad..8910863 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -443,7 +443,8 @@ static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
 	case AGGR_CORE:
 	case AGGR_SOCKET:
 	case AGGR_NONE:
-		perf_evsel__compute_deltas(evsel, cpu, count);
+		if (!evsel->snapshot)
+			perf_evsel__compute_deltas(evsel, cpu, count);
 		perf_counts_values__scale(count, scale, NULL);
 		evsel->counts->cpu[cpu] = *count;
 		update_shadow_stats(evsel, count->values);
@@ -479,7 +480,8 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	if (read_counter(counter))
 		return -1;
 
-	perf_evsel__compute_deltas(counter, -1, aggr);
+	if (!counter->snapshot)
+		perf_evsel__compute_deltas(counter, -1, aggr);
 	perf_counts_values__scale(aggr, scale, &counter->counts->scaled);
 
 	for (i = 0; i < 3; i++)
