Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaHKIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaHKIvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:20 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/20] perf trace: Add support to see event's ERR and HUP poll errors
Date: Mon, 11 Aug 2014 10:50:11 +0200
Message-Id: <1407747014-18394-18-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding trace command support to see when all events
are down and forcing it to stop in that case.

Like following trace session will stop if the
monitored pid (1234) exits:

  $ perf trace -p 1234

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-trace.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 36ae51d61be2..d465f4519a66 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2011,6 +2011,18 @@ static int perf_evlist__add_pgfault(struct perf_evlist *evlist,
 	return 0;
 }
 
+static int data_error(struct poller *p, struct poller_item *item)
+{
+	pr_debug("got HUP/ERROR on fd %d\n", item->fd);
+
+	poller__del(p, item);
+	if (poller__empty(p)) {
+		pr_debug("All events closed, shutting down.\n");
+		done = true;
+	}
+	return 0;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -2018,6 +2030,11 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	int err = -1, i;
 	unsigned long before;
 	const bool forks = argc > 0;
+	struct poller *poller = &evlist->poller;
+	struct poller_ops poller_ops = {
+		.error  = data_error,
+		.hup    = data_error,
+	};
 
 	trace->live = true;
 
@@ -2077,6 +2094,10 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	if (err < 0)
 		goto out_error_open;
 
+	err = perf_evlist__set_poller(evlist);
+	if (err < 0)
+		goto out_delete_evlist;
+
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
 		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
@@ -2088,6 +2109,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(evlist);
 
+	poller__set_ops(poller, &poller_ops);
+
 	trace->multiple_threads = evlist->threads->map[0] == -1 || evlist->threads->nr > 1;
 again:
 	before = trace->nr_events;
@@ -2143,7 +2166,7 @@ next_event:
 	if (trace->nr_events == before) {
 		int timeout = done ? 100 : -1;
 
-		if (poll(evlist->pollfd, evlist->nr_fds, timeout) > 0)
+		if (poller__poll(poller, timeout) > 0)
 			goto again;
 	} else {
 		goto again;
-- 
1.8.3.1

