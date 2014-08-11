Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaHKIyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaHKIu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:56 -0400
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
Subject: [PATCH 10/20] perf top: Add support to see event's ERR and HUP poll errors
Date: Mon, 11 Aug 2014 10:50:04 +0200
Message-Id: <1407747014-18394-11-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding top command support to see when all events
are down and forcing it to stop in that case.

Like following top session will stop if the
monitored pid (1234) exits:

  $ perf top -p 1234

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
 tools/perf/builtin-top.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4cd56c9ddedc..d0eeeb7ca5ff 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -40,6 +40,7 @@
 #include "util/xyarray.h"
 #include "util/sort.h"
 #include "util/intlist.h"
+#include "util/poller.h"
 #include "arch/common.h"
 
 #include "util/debug.h"
@@ -875,6 +876,12 @@ try_again:
 			ui__error("%s\n", msg);
 			goto out_err;
 		}
+
+		if (perf_evsel__set_poller(counter, &evlist->poller)) {
+			error("failed to set poller with %d (%s)\n", errno,
+			      strerror(errno));
+			goto out_err;
+		}
 	}
 
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
@@ -906,11 +913,28 @@ static int perf_top__setup_sample_type(struct perf_top *top __maybe_unused)
 	return 0;
 }
 
+static int data_error(struct poller *p, struct poller_item *item)
+{
+	pr_debug("got HUP/ERROR on fd %d\n", item->fd);
+
+	poller__del(p, item);
+	if (poller__empty(p)) {
+		pr_debug("All events closed shutting down.\n");
+		done = 1;
+	}
+	return 0;
+}
+
 static int __cmd_top(struct perf_top *top)
 {
 	struct record_opts *opts = &top->record_opts;
 	pthread_t thread;
 	int ret;
+	struct poller *poller = &top->evlist->poller;
+	struct poller_ops poller_ops = {
+		.error  = data_error,
+		.hup    = data_error,
+	};
 
 	top->session = perf_session__new(NULL, false, NULL);
 	if (top->session == NULL)
@@ -948,8 +972,10 @@ static int __cmd_top(struct perf_top *top)
         if (!target__none(&opts->target))
                 perf_evlist__enable(top->evlist);
 
+	poller__set_ops(poller, &poller_ops);
+
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
+	poller__poll(poller, 100);
 
 	perf_top__mmap_read(top);
 
@@ -976,7 +1002,7 @@ static int __cmd_top(struct perf_top *top)
 		perf_top__mmap_read(top);
 
 		if (hits == top->samples)
-			ret = poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
+			ret = poller__poll(poller, 100);
 	}
 
 	ret = 0;
-- 
1.8.3.1

