Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3JWHxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:53:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3JWHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:13 -0400
Date: Wed, 23 Oct 2013 00:52:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-vf6n57ewm3mjy2sz6r491hus@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Improve event processing exit
Git-Commit-ID: ba209f856380891a6ea6cdb07b2b068faccbff73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:52:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba209f856380891a6ea6cdb07b2b068faccbff73
Gitweb:     http://git.kernel.org/tip/ba209f856380891a6ea6cdb07b2b068faccbff73
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 16 Oct 2013 11:57:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Oct 2013 16:12:24 -0300

perf trace: Improve event processing exit

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
index 86d2b1f..ec82895 100644
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
