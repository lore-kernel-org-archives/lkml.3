Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab3HHCvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:18 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42677 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab3HHCvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:15 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/19] perf sched: Simplify arguments to read_events
Date: Wed,  7 Aug 2013 22:50:44 -0400
Message-Id: <1375930261-77273-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Destroy argument is not necessary. If session is not returned to caller,
then clean it up.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |   16 +++++++++-------
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
1.7.10.1

