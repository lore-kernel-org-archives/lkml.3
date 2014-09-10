Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaIJOK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:38628 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaIJOKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:23 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/14] perf evlist: Introduce poll method for common code idiom
Date: Wed, 10 Sep 2014 11:08:45 -0300
Message-Id: <1410358129-9965-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we have access two evlist members in all these poll calls, provide
a helper.

This will also help to make the patch introducing the pollfd class more
clear, as the evlist specific uses will be hiden away
perf_evlist__poll().

Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-hizx410uqouefj52jujubv2y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c               | 2 +-
 tools/perf/builtin-top.c                  | 4 ++--
 tools/perf/builtin-trace.c                | 2 +-
 tools/perf/tests/open-syscall-tp-fields.c | 2 +-
 tools/perf/tests/perf-record.c            | 2 +-
 tools/perf/tests/task-exit.c              | 2 +-
 tools/perf/util/evlist.c                  | 5 +++++
 tools/perf/util/evlist.h                  | 2 ++
 tools/perf/util/python.c                  | 2 +-
 9 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b87708ce09c9..aac86600b89e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -459,7 +459,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (hits == rec->samples) {
 			if (done)
 				break;
-			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
+			err = perf_evlist__poll(rec->evlist, -1);
 			/*
 			 * Propagate error, only if there's any. Ignore positive
 			 * number of returned events and interrupt error.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9848e270b92c..ef7c808c8ce2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -964,7 +964,7 @@ static int __cmd_top(struct perf_top *top)
                 perf_evlist__enable(top->evlist);
 
 	/* Wait for a minimal set of events before starting the snapshot */
-	poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
+	perf_evlist__poll(top->evlist, 100);
 
 	perf_top__mmap_read(top);
 
@@ -991,7 +991,7 @@ static int __cmd_top(struct perf_top *top)
 		perf_top__mmap_read(top);
 
 		if (hits == top->samples)
-			ret = poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
+			ret = perf_evlist__poll(top->evlist, 100);
 	}
 
 	ret = 0;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 09d4bc44215e..970aa0297697 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2171,7 +2171,7 @@ next_event:
 	if (trace->nr_events == before) {
 		int timeout = done ? 100 : -1;
 
-		if (poll(evlist->pollfd, evlist->nr_fds, timeout) > 0 &&
+		if (perf_evlist__poll(evlist, timeout) > 0 &&
 		    perf_evlist__filter_pollfd(evlist, POLLERR | POLLHUP) > 0)
 			goto again;
 	} else {
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 922bdb627950..127dcae0b760 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -105,7 +105,7 @@ int test__syscall_open_tp_fields(void)
 		}
 
 		if (nr_events == before)
-			poll(evlist->pollfd, evlist->nr_fds, 10);
+			perf_evlist__poll(evlist, 10);
 
 		if (++nr_polls > 5) {
 			pr_debug("%s: no events!\n", __func__);
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 2ce753c1db63..7a228a2a070b 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -268,7 +268,7 @@ int test__PERF_RECORD(void)
 		 * perf_event_attr.wakeup_events, just PERF_EVENT_SAMPLE does.
 		 */
 		if (total_events == before && false)
-			poll(evlist->pollfd, evlist->nr_fds, -1);
+			perf_evlist__poll(evlist, -1);
 
 		sleep(1);
 		if (++wakeups > 5) {
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 87522f01c7ad..3a8fedef83bc 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -105,7 +105,7 @@ retry:
 	}
 
 	if (!exited || !nr_exit) {
-		poll(evlist->pollfd, evlist->nr_fds, -1);
+		perf_evlist__poll(evlist, -1);
 		goto retry;
 	}
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bcf157c8a9da..5ff3c667542f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -475,6 +475,11 @@ int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mas
 	return nr_fds;
 }
 
+int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
+{
+	return poll(evlist->pollfd, evlist->nr_fds, timeout);
+}
+
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
 				 struct perf_evsel *evsel,
 				 int cpu, int thread, u64 id)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index bbc2fd01b5c5..d7e99b67c94f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -87,6 +87,8 @@ int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist);
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask);
 
+int perf_evlist__poll(struct perf_evlist *evlist, int timeout);
+
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 12aa9b0d0ba1..4472f8be8e35 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -736,7 +736,7 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
 		return NULL;
 
-	n = poll(evlist->pollfd, evlist->nr_fds, timeout);
+	n = perf_evlist__poll(evlist, timeout);
 	if (n < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
-- 
1.9.3

