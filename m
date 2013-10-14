Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab3JNUU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39035 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 122/161] perf stat: Add units to nanosec-based counters
Date: Mon, 14 Oct 2013 17:01:51 -0300
Message-Id: <1381780950-25642-123-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Ingo pointed out that the task-clock counter should have the units
explicitly stated since it is not a counter.

Before:

perf stat -a -- sleep 1

 Performance counter stats for 'sleep 1':

      16186.874834 task-clock          #   16.154 CPUs utilized
...

After:

perf stat -a -- sleep 1

 Performance counter stats for 'system wide':

      16146.402138 task-clock (msec)   #   16.125 CPUs utilized
...

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380400080-9211-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2178e6636f71..1a9c95d270aa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -706,10 +706,13 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	const char *fmt = csv_output ? "%.6f%s%s" : "%18.6f%s%-25s";
+	char name[25];
 
 	aggr_printout(evsel, cpu, nr);
 
-	fprintf(output, fmt, msecs, csv_sep, perf_evsel__name(evsel));
+	scnprintf(name, sizeof(name), "%s%s",
+		  perf_evsel__name(evsel), csv_output ? "" : " (msec)");
+	fprintf(output, fmt, msecs, csv_sep, name);
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
-- 
1.8.1.4

