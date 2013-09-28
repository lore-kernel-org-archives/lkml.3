Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3I1U2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:28:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58373 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3I1U2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:28:11 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf stat: Add units to nanosec-based counters
Date: Sat, 28 Sep 2013 14:28:00 -0600
Message-Id: <1380400080-9211-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo pointed out that the task-clock counter should have the units explicitly
stated since it is not a counter.

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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 60239fe..746a6db 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -628,10 +628,13 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
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
1.7.10.1

