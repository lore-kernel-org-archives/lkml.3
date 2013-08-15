Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab3HOIBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:01:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3HOHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:55:36 -0400
Date: Thu, 15 Aug 2013 00:55:05 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-ad9def7ca020ef5b54968c89194f52d18ef1ef49@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-3-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Simplify arguments to read_events
Git-Commit-ID: ad9def7ca020ef5b54968c89194f52d18ef1ef49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:55:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad9def7ca020ef5b54968c89194f52d18ef1ef49
Gitweb:     http://git.kernel.org/tip/ad9def7ca020ef5b54968c89194f52d18ef1ef49
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:44 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:05 -0300

perf sched: Simplify arguments to read_events

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
