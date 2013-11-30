Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3K3Muz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:50:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3K3Mut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:50:49 -0500
Date: Sat, 30 Nov 2013 04:50:25 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e944d3d7d151eea149c62310eaff7b92c7732f58@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
References: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Move evname print code to process_event()
Git-Commit-ID: e944d3d7d151eea149c62310eaff7b92c7732f58
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:50:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e944d3d7d151eea149c62310eaff7b92c7732f58
Gitweb:     http://git.kernel.org/tip/e944d3d7d151eea149c62310eaff7b92c7732f58
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 18 Nov 2013 14:34:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:35 -0300

perf script: Move evname print code to process_event()

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
index baf1798..b392770 100644
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
