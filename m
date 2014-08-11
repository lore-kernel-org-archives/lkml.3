Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaHKIvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaHKIvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:19 -0400
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
Subject: [PATCH 18/20] perf python: Use poller object for polling
Date: Mon, 11 Aug 2014 10:50:12 +0200
Message-Id: <1407747014-18394-19-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change python polling guts using evlist->pollfd for
poller object.

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
 tools/perf/util/python-ext-sources |  2 ++
 tools/perf/util/python.c           | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 16a475a7d492..a2d584126eb1 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -20,3 +20,5 @@ util/strlist.c
 ../lib/api/fs/fs.c
 util/trace-event.c
 ../../lib/rbtree.c
+util/poller.c
+util/string.c
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 12aa9b0d0ba1..5903b6c30c16 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -7,6 +7,7 @@
 #include "event.h"
 #include "cpumap.h"
 #include "thread_map.h"
+#include "poller.h"
 
 /*
  * Support debug printing even though util/debug.c is not linked.  That means
@@ -730,13 +731,22 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
+	struct poller *poller = &evlist->poller;
 	static char *kwlist[] = { "timeout", NULL };
-	int timeout = -1, n;
+	int timeout = -1, n, err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
 		return NULL;
 
-	n = poll(evlist->pollfd, evlist->nr_fds, timeout);
+	if (poller__empty(poller)) {
+		err = perf_evlist__set_poller(evlist);
+		if (err) {
+			PyErr_SetFromErrno(PyExc_OSError);
+			return NULL;
+		}
+	}
+
+	n = poller__poll(poller, timeout);
 	if (n < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
@@ -750,12 +760,13 @@ static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
 					 PyObject *kwargs __maybe_unused)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
+	struct poller *poller = &evlist->poller;
         PyObject *list = PyList_New(0);
 	int i;
 
-	for (i = 0; i < evlist->nr_fds; ++i) {
+	for (i = 0; i < poller->n; ++i) {
 		PyObject *file;
-		FILE *fp = fdopen(evlist->pollfd[i].fd, "r");
+		FILE *fp = fdopen(poller->ptr[i].fd, "r");
 
 		if (fp == NULL)
 			goto free_list;
-- 
1.8.3.1

