Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaHKIvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaHKIvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:23 -0400
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
Subject: [PATCH 19/20] perf tests: Use poller object for polling
Date: Mon, 11 Aug 2014 10:50:13 +0200
Message-Id: <1407747014-18394-20-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several tests are using evlist->pollfd means for
polling events. Changing them to use poller object.

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
 tools/perf/tests/open-syscall-tp-fields.c | 9 ++++++++-
 tools/perf/tests/perf-record.c            | 4 ----
 tools/perf/tests/task-exit.c              | 9 ++++++++-
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 0785b64ffd6c..b0fc35d23244 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -4,6 +4,7 @@
 #include "thread_map.h"
 #include "tests.h"
 #include "debug.h"
+#include "poller.h"
 
 int test__syscall_open_tp_fields(void)
 {
@@ -58,6 +59,12 @@ int test__syscall_open_tp_fields(void)
 		goto out_delete_evlist;
 	}
 
+	err = perf_evlist__set_poller(evlist);
+	if (err < 0) {
+		pr_debug("perf_evlist__set_poller: %s\n", strerror(errno));
+		goto out_delete_evlist;
+	};
+
 	perf_evlist__enable(evlist);
 
 	/*
@@ -102,7 +109,7 @@ int test__syscall_open_tp_fields(void)
 		}
 
 		if (nr_events == before)
-			poll(evlist->pollfd, evlist->nr_fds, 10);
+			poller__poll(&evlist->poller, 10);
 
 		if (++nr_polls > 5) {
 			pr_debug("%s: no events!\n", __func__);
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index aca1a83dd13a..ee5d2881e3fe 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -147,8 +147,6 @@ int test__PERF_RECORD(void)
 	perf_evlist__start_workload(evlist);
 
 	while (1) {
-		int before = total_events;
-
 		for (i = 0; i < evlist->nr_mmaps; i++) {
 			union perf_event *event;
 
@@ -262,8 +260,6 @@ int test__PERF_RECORD(void)
 		 * PERF_RECORD_{!SAMPLE} events don't honour
 		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
 		 */
-		if (total_events == before && false)
-			poll(evlist->pollfd, evlist->nr_fds, -1);
 
 		sleep(1);
 		if (++wakeups > 5) {
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 5ff3db318f12..bc858c799ff2 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -3,6 +3,7 @@
 #include "thread_map.h"
 #include "cpumap.h"
 #include "tests.h"
+#include "poller.h"
 
 #include <signal.h>
 
@@ -92,6 +93,12 @@ int test__task_exit(void)
 		goto out_delete_evlist;
 	}
 
+	if (perf_evlist__set_poller(evlist)) {
+		pr_debug("failed to set poller: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_delete_evlist;
+	}
+
 	perf_evlist__start_workload(evlist);
 
 retry:
@@ -103,7 +110,7 @@ retry:
 	}
 
 	if (!exited || !nr_exit) {
-		poll(evlist->pollfd, evlist->nr_fds, -1);
+		poller__poll(&evlist->poller, -1);
 		goto retry;
 	}
 
-- 
1.8.3.1

