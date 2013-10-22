Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JVOdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:33:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3JVO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/26] perf trace: Improve event processing exit
Date: Tue, 22 Oct 2013 11:28:12 -0300
Message-Id: <1382452114-1243-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to differentiate SIGCHLD from SIGINT, the later should cause as
immediate as possible exit, while the former should wait to process the
events that may be perceived in the ring buffer after the SIGCHLD is
handled.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vf6n57ewm3mjy2sz6r491hus@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 86d2b1f2399c..ec8289570f4f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1098,10 +1098,12 @@ static size_t trace__fprintf_tstamp(struct trace *trace, u64 tstamp, FILE *fp)
 }
 
 static bool done = false;
+static bool interrupted = false;
 
-static void sig_handler(int sig __maybe_unused)
+static void sig_handler(int sig)
 {
 	done = true;
+	interrupted = sig == SIGINT;
 }
 
 static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thread,
@@ -1771,24 +1773,23 @@ again:
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 
-			if (done)
-				goto out_unmap_evlist;
+			if (interrupted)
+				goto out_disable;
 		}
 	}
 
 	if (trace->nr_events == before) {
-		if (done)
-			goto out_unmap_evlist;
+		int timeout = done ? 100 : -1;
 
-		poll(evlist->pollfd, evlist->nr_fds, -1);
+		if (poll(evlist->pollfd, evlist->nr_fds, timeout) > 0)
+			goto again;
+	} else {
+		goto again;
 	}
 
-	if (done)
-		perf_evlist__disable(evlist);
-	else
-		goto again;
+out_disable:
+	perf_evlist__disable(evlist);
 
-out_unmap_evlist:
 	if (!err) {
 		if (trace->summary)
 			trace__fprintf_thread_summary(trace, trace->output);
-- 
1.8.1.4

