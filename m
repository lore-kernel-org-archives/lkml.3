Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab3HNSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:25:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab3HNSZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/21] perf sched: Simplify arguments to read_events
Date: Wed, 14 Aug 2013 15:24:57 -0300
Message-Id: <1376504715-28107-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Destroy argument is not necessary. If session is not returned to caller,
then clean it up.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 948183a..34ce57d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1445,7 +1445,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 	return err;
 }
 
-static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
+static int perf_sched__read_events(struct perf_sched *sched,
 				   struct perf_session **psession)
 {
 	const struct perf_evsel_str_handler handlers[] = {
@@ -1480,11 +1480,10 @@ static int perf_sched__read_events(struct perf_sched *sched, bool destroy,
 		sched->nr_lost_chunks = session->stats.nr_events[PERF_RECORD_LOST];
 	}
 
-	if (destroy)
-		perf_session__delete(session);
-
 	if (psession)
 		*psession = session;
+	else
+		perf_session__delete(session);
 
 	return 0;
 
@@ -1529,8 +1528,11 @@ static int perf_sched__lat(struct perf_sched *sched)
 	struct perf_session *session;
 
 	setup_pager();
-	if (perf_sched__read_events(sched, false, &session))
+
+	/* save session -- references to threads are held in work_list */
+	if (perf_sched__read_events(sched, &session))
 		return -1;
+
 	perf_sched__sort_lat(sched);
 
 	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
@@ -1565,7 +1567,7 @@ static int perf_sched__map(struct perf_sched *sched)
 	sched->max_cpu = sysconf(_SC_NPROCESSORS_CONF);
 
 	setup_pager();
-	if (perf_sched__read_events(sched, true, NULL))
+	if (perf_sched__read_events(sched, NULL))
 		return -1;
 	print_bad_events(sched);
 	return 0;
@@ -1580,7 +1582,7 @@ static int perf_sched__replay(struct perf_sched *sched)
 
 	test_calibrations(sched);
 
-	if (perf_sched__read_events(sched, true, NULL))
+	if (perf_sched__read_events(sched, NULL))
 		return -1;
 
 	printf("nr_run_events:        %ld\n", sched->nr_run_events);
-- 
1.8.1.4

