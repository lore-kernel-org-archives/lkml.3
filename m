Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3IEToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:44:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3IETm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:42:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf session: Separate progress bar update when processing events
Date: Thu,  5 Sep 2013 16:42:43 -0300
Message-Id: <1378410163-2606-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378410163-2606-1-git-send-email-acme@infradead.org>
References: <1378410163-2606-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently when processing events in the __perf_session__process_events
function we update a progress bar based on the file_size. During the
same processing we update the progress bar from within
flush_sample_queue which is based on number of samples count.

Having 2 different based updates is causing the progress bar to jump
heavily back and forth giving not much usefull info.

Fixing this by keeping only __perf_session__process_events based
progress bar update. And turning on flush_sample_queue progress bar
update only for final flushing.

This reduces the number of time the progress bar update function is
called and it significantly reduces the loading time for TUI, where the
progress bar update takes quite a lot of time.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130905091449.GC1100@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1fc0c62..476caa1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -504,6 +504,7 @@ static int flush_sample_queue(struct perf_session *s,
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 	unsigned idx = 0, progress_next = os->nr_samples / 16;
+	bool show_progress = limit == ULLONG_MAX;
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
@@ -526,7 +527,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (++idx >= progress_next) {
+		if (show_progress && (++idx >= progress_next)) {
 			progress_next += os->nr_samples / 16;
 			ui_progress__update(idx, os->nr_samples,
 					    "Processing time ordered events...");
-- 
1.8.1.4

