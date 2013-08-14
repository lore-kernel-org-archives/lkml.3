Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3HNS37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:29:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34335 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760198Ab3HNSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/21] perf evsel: Add option to limit stack depth in callchain dumps
Date: Wed, 14 Aug 2013 15:25:03 -0300
Message-Id: <1376504715-28107-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Option is used by upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-12-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 6 ++++--
 tools/perf/util/session.c   | 6 ++++--
 tools/perf/util/session.h   | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ee5d6f8..33b2d83 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -402,7 +402,8 @@ static void print_sample_bts(union perf_event *event,
 		else
 			printf("\n");
 		perf_evsel__print_ip(evsel, event, sample, machine,
-				     output[attr->type].print_ip_opts);
+				     output[attr->type].print_ip_opts,
+				     PERF_MAX_STACK_DEPTH);
 	}
 
 	printf(" => ");
@@ -444,7 +445,8 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 			printf("\n");
 
 		perf_evsel__print_ip(evsel, event, sample, machine,
-				     output[attr->type].print_ip_opts);
+				     output[attr->type].print_ip_opts,
+				     PERF_MAX_STACK_DEPTH);
 	}
 
 	printf("\n");
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0d895e7..5a89964 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1489,7 +1489,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  unsigned int print_opts)
+			  unsigned int print_opts, unsigned int stack_depth)
 {
 	struct addr_location al;
 	struct callchain_cursor_node *node;
@@ -1517,7 +1517,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 		}
 		callchain_cursor_commit(&callchain_cursor);
 
-		while (1) {
+		while (stack_depth) {
 			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
 				break;
@@ -1544,6 +1544,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				printf("\n");
 
 			callchain_cursor_advance(&callchain_cursor);
+
+			stack_depth--;
 		}
 
 	} else {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7c00ccb..3aa75fb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -109,7 +109,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  unsigned int print_opts);
+			  unsigned int print_opts, unsigned int stack_depth);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
-- 
1.8.1.4

