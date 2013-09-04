Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab3IDQ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:28:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225Ab3IDQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:28:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: Separate progress bar update when processing events
Date: Wed,  4 Sep 2013 18:27:57 +0200
Message-Id: <1378312077-28374-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when processing events in __perf_session__process_events
function we we update progress based on the file_size. During the
same processing we update progress bar from within flush_sample_queue
which is based on number of samples count.

Having 2 different based updates is causing the progress bar to
jump heavily back and forth giving not much useful info.

Fixing this by keeping only __perf_session__process_events
based progress bar update. And turning on flush_sample_queue
progress bar update only for final flushing.

This reduces the number of times the progress bar update
function is called and it significantly reduces the loading
time for TUI, where the progress bar update takes quite a lot
of time.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1fc0c62..4df449c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -495,7 +495,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      u64 file_offset);
 
 static int flush_sample_queue(struct perf_session *s,
-		       struct perf_tool *tool)
+		       struct perf_tool *tool, bool final)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
@@ -526,7 +526,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (++idx >= progress_next) {
+		if (final && (++idx >= progress_next)) {
 			progress_next += os->nr_samples / 16;
 			ui_progress__update(idx, os->nr_samples,
 					    "Processing time ordered events...");
@@ -588,7 +588,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = flush_sample_queue(session, tool);
+	int ret = flush_sample_queue(session, tool, false);
 	if (!ret)
 		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
 
@@ -1354,7 +1354,7 @@ more:
 	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
-	err = flush_sample_queue(session, tool);
+	err = flush_sample_queue(session, tool, true);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-- 
1.7.11.7

