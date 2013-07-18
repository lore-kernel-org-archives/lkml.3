Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab3GRTu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:50:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41437 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab3GRTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/76] perf util: Use evsel->name to get tracepoint_paths
Date: Thu, 18 Jul 2013 16:48:57 -0300
Message-Id: <1374177003-3706-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Most tracepoint events already have their system and event name in
->name field so that searching whole event tracing directory for each
evsel to match given id is suboptimal.

Factor out this routine into tracepoint_name_to_path().  In case of en
invalid name, it'll try to find path using id again.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1372230862-15861-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c     | 23 +++++++++++++++++++++++
 tools/perf/util/parse-events.h     |  1 +
 tools/perf/util/trace-event-info.c | 15 +++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 995fc25..ef72e98 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -217,6 +217,29 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	return NULL;
 }
 
+struct tracepoint_path *tracepoint_name_to_path(const char *name)
+{
+	struct tracepoint_path *path = zalloc(sizeof(*path));
+	char *str = strchr(name, ':');
+
+	if (path == NULL || str == NULL) {
+		free(path);
+		return NULL;
+	}
+
+	path->system = strndup(name, str - name);
+	path->name = strdup(str+1);
+
+	if (path->system == NULL || path->name == NULL) {
+		free(path->system);
+		free(path->name);
+		free(path);
+		path = NULL;
+	}
+
+	return path;
+}
+
 const char *event_type(int type)
 {
 	switch (type) {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8a48593..080f7cf 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -23,6 +23,7 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+extern struct tracepoint_path *tracepoint_name_to_path(const char *name);
 extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_type(int type);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 615c062..a42624a 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -414,12 +414,27 @@ get_tracepoints_path(struct list_head *pattrs)
 		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
 			continue;
 		++nr_tracepoints;
+
+		if (pos->name) {
+			ppath->next = tracepoint_name_to_path(pos->name);
+			if (ppath->next)
+				goto next;
+
+			if (strchr(pos->name, ':') == NULL)
+				goto try_id;
+
+			goto error;
+		}
+
+try_id:
 		ppath->next = tracepoint_id_to_path(pos->attr.config);
 		if (!ppath->next) {
+error:
 			pr_debug("No memory to alloc tracepoints list\n");
 			put_tracepoints_path(&path);
 			return NULL;
 		}
+next:
 		ppath = ppath->next;
 	}
 
-- 
1.8.1.4

