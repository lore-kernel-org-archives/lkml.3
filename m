Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3FZHO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:14:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57313 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3FZHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:26 -0400
X-AuditID: 9c930179-b7cafae000004567-74-51ca94d05998
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/19] perf util: Use evsel->name to get tracepoint_paths
Date: Wed, 26 Jun 2013 16:14:05 +0900
Message-Id: <1372230862-15861-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Most tracepoint events already have their system and event name in
->name field so that searching whole event tracing directory for each
evsel to match given id is suboptimal.

Factor out this routine into tracepoint_name_to_path().  In case of en
invalid name, it'll try to find path using id again.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/parse-events.c     | 23 +++++++++++++++++++++++
 tools/perf/util/parse-events.h     |  1 +
 tools/perf/util/trace-event-info.c | 15 +++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0fb189b..1ae166c9da79 100644
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
index 8a4859315fd9..080f7cf25d99 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -23,6 +23,7 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+extern struct tracepoint_path *tracepoint_name_to_path(const char *name);
 extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_type(int type);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index ab18bf12d54a..f3c9e551bd35 100644
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
1.7.11.7

