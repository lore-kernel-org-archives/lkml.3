Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3K0UT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:19:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3K0URG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/34] perf script: Move evname print code to process_event()
Date: Wed, 27 Nov 2013 17:16:09 -0300
Message-Id: <1385583394-3703-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The print_sample_start() will be reused by other printing routine for
internal events like COMM, FORK and EXIT from next patch.  And because
they're not tied to a specific event, move the evname print code to its
caller.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384752894-10974-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index baf17989a216..b392770766dd 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -288,7 +288,6 @@ static void print_sample_start(struct perf_sample *sample,
 			       struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
-	const char *evname = NULL;
 	unsigned long secs;
 	unsigned long usecs;
 	unsigned long long nsecs;
@@ -323,11 +322,6 @@ static void print_sample_start(struct perf_sample *sample,
 		usecs = nsecs / NSECS_PER_USEC;
 		printf("%5lu.%06lu: ", secs, usecs);
 	}
-
-	if (PRINT_FIELD(EVNAME)) {
-		evname = perf_evsel__name(evsel);
-		printf("%s: ", evname ? evname : "[unknown]");
-	}
 }
 
 static bool is_bts_event(struct perf_event_attr *attr)
@@ -434,6 +428,11 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 
 	print_sample_start(sample, thread, evsel);
 
+	if (PRINT_FIELD(EVNAME)) {
+		const char *evname = perf_evsel__name(evsel);
+		printf("%s: ", evname ? evname : "[unknown]");
+	}
+
 	if (is_bts_event(attr)) {
 		print_sample_bts(event, sample, evsel, machine, thread);
 		return;
-- 
1.8.1.4

