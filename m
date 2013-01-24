Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161003Ab3AXUdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:33:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50146 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3AXUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/74] perf evsel: Introduce event fallback method
Date: Thu, 24 Jan 2013 17:07:17 -0300
Message-Id: <1359058103-31645-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The only fallback right now is for HW cpu-cycles -> SW cpu-clock, that
was done in the same way in both 'top' and 'record'.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-58l1mgibh9oa9m0pd3fasxa5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 23 +++--------------------
 tools/perf/builtin-top.c    | 20 +++-----------------
 tools/perf/util/evsel.c     | 28 ++++++++++++++++++++++++++++
 tools/perf/util/evsel.h     |  3 +++
 4 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a4b9726..b8d0a39 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -224,6 +224,7 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
 static int perf_record__open(struct perf_record *rec)
 {
+	char msg[128];
 	struct perf_evsel *pos;
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
@@ -249,27 +250,9 @@ try_again:
 				goto out;
 			}
 
-			/*
-			 * If it's cycles then fall back to hrtimer
-			 * based cpu-clock-tick sw counter, which
-			 * is always available even if no PMU support.
-			 *
-			 * PPC returns ENXIO until 2.6.37 (behavior changed
-			 * with commit b0a873e).
-			 */
-			if ((err == ENOENT || err == ENXIO)
-					&& attr->type == PERF_TYPE_HARDWARE
-					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
-
+			if (perf_evsel__fallback(pos, err, msg, sizeof(msg))) {
 				if (verbose)
-					ui__warning("The cycles event is not supported, "
-						    "trying to fall back to cpu-clock-ticks\n");
-				attr->type = PERF_TYPE_SOFTWARE;
-				attr->config = PERF_COUNT_SW_CPU_CLOCK;
-				if (pos->name) {
-					free(pos->name);
-					pos->name = NULL;
-				}
+					ui__warning("%s\n", msg);
 				goto try_again;
 			}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 74fca61..8d41d0b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -892,6 +892,7 @@ static void perf_top__mmap_read(struct perf_top *top)
 
 static void perf_top__start_counters(struct perf_top *top)
 {
+	char msg[128];
 	struct perf_evsel *counter;
 	struct perf_evlist *evlist = top->evlist;
 	struct perf_record_opts *opts = &top->record_opts;
@@ -909,25 +910,10 @@ try_again:
 				ui__error_paranoid();
 				goto out_err;
 			}
-			/*
-			 * If it's cycles then fall back to hrtimer
-			 * based cpu-clock-tick sw counter, which
-			 * is always available even if no PMU support:
-			 */
-			if ((err == ENOENT || err == ENXIO) &&
-			    (attr->type == PERF_TYPE_HARDWARE) &&
-			    (attr->config == PERF_COUNT_HW_CPU_CYCLES)) {
 
+			if (perf_evsel__fallback(counter, err, msg, sizeof(msg))) {
 				if (verbose)
-					ui__warning("Cycles event not supported,\n"
-						    "trying to fall back to cpu-clock-ticks\n");
-
-				attr->type = PERF_TYPE_SOFTWARE;
-				attr->config = PERF_COUNT_SW_CPU_CLOCK;
-				if (counter->name) {
-					free(counter->name);
-					counter->name = NULL;
-				}
+					ui__warning("%s\n", msg);
 				goto try_again;
 			}
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ee6ee3f..0c88e5c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1378,3 +1378,31 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 	fputc('\n', fp);
 	return ++printed;
 }
+
+bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
+			  char *msg, size_t msgsize)
+{
+	if ((err == ENOENT || err == ENXIO) &&
+	    evsel->attr.type   == PERF_TYPE_HARDWARE &&
+	    evsel->attr.config == PERF_COUNT_HW_CPU_CYCLES) {
+		/*
+		 * If it's cycles then fall back to hrtimer based
+		 * cpu-clock-tick sw counter, which is always available even if
+		 * no PMU support.
+		 *
+		 * PPC returns ENXIO until 2.6.37 (behavior changed with commit
+		 * b0a873e).
+		 */
+		scnprintf(msg, msgsize, "%s",
+"The cycles event is not supported, trying to fall back to cpu-clock-ticks");
+
+		evsel->attr.type   = PERF_TYPE_SOFTWARE;
+		evsel->attr.config = PERF_COUNT_SW_CPU_CLOCK;
+
+		free(evsel->name);
+		evsel->name = NULL;
+		return true;
+	}
+
+	return false;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 9cb8a02..26d8cfd 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -251,4 +251,7 @@ struct perf_attr_details {
 
 int perf_evsel__fprintf(struct perf_evsel *evsel,
 			struct perf_attr_details *details, FILE *fp);
+
+bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
+			  char *msg, size_t msgsize);
 #endif /* __PERF_EVSEL_H */
-- 
1.8.1.1.361.gec3ae6e

