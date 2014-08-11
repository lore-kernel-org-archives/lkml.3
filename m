Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaHKIyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKIuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:52 -0400
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
Subject: [PATCH 07/20] perf record: Add support to see event's ERR and HUP poll errors
Date: Mon, 11 Aug 2014 10:50:01 +0200
Message-Id: <1407747014-18394-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding record command support to see when all events
are down and forcing it to stop in that case.

Like following record session will stop if the
monitored pid (1234) exits:

  $ perf record -p 1234

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
 tools/perf/builtin-record.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ca0251e8470d..dfcc470a9b4a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -25,6 +25,7 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 #include "util/data.h"
+#include "util/poller.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -157,6 +158,13 @@ try_again:
 			ui__error("%s\n", msg);
 			goto out;
 		}
+
+		if (perf_evsel__set_poller(pos, &evlist->poller)) {
+			error("failed to set poller with %d (%s)\n", errno,
+				strerror(errno));
+			rc = -1;
+			goto out;
+		}
 	}
 
 	if (perf_evlist__apply_filters(evlist)) {
@@ -296,6 +304,18 @@ static void workload_exec_failed_signal(int signo __maybe_unused,
 	child_finished = 1;
 }
 
+static int data_error(struct poller *p, struct poller_item *item)
+{
+	pr_debug("got HUP/ERROR on fd %d\n", item->fd);
+
+	poller__del(p, item);
+	if (poller__empty(p)) {
+		pr_debug("All events closed, shutting down.\n");
+		done = 1;
+	}
+	return 0;
+}
+
 static int __cmd_record(struct record *rec, int argc, const char **argv)
 {
 	int err;
@@ -308,6 +328,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	struct perf_data_file *file = &rec->file;
 	struct perf_session *session;
 	bool disabled = false;
+	struct poller *poller = &rec->evlist->poller;
+	struct poller_ops poller_ops = {
+		.error	= data_error,
+		.hup	= data_error,
+	};
 
 	rec->progname = argv[0];
 
@@ -447,6 +472,8 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		perf_evlist__enable(rec->evlist);
 	}
 
+	poller__set_ops(poller, &poller_ops);
+
 	for (;;) {
 		int hits = rec->samples;
 
@@ -458,7 +485,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (hits == rec->samples) {
 			if (done)
 				break;
-			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
+			err = poller__poll(poller, -1);
 			/*
 			 * Propagate error, only if there's any. Ignore positive
 			 * number of returned events and interrupt error.
-- 
1.8.3.1

