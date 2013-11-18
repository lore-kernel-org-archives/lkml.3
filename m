Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079Ab3KRFfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 00:35:03 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44291 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3KRFe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 00:34:56 -0500
X-AuditID: 9c93017d-b7b15ae000000e52-13-5289a6feb002
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 1/3] perf script: Move evname print code to process_event()
Date: Mon, 18 Nov 2013 14:34:52 +0900
Message-Id: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The print_sample_start() will be reused by other printing routine for
internal events like COMM, FORK and EXIT from next patch.  And because
they're not tied to a specific event, move the evname print code to
its caller.

Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

