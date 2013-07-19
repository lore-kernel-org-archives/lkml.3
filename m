Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab3GSHoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:44:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759649Ab3GSHo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:44:29 -0400
Date: Fri, 19 Jul 2013 00:44:08 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e7c93f09b83be25281cf129674e0035664715033@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1372230862-15861-3-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util: Use evsel->
 name to get tracepoint_paths
Git-Commit-ID: e7c93f09b83be25281cf129674e0035664715033
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:44:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7c93f09b83be25281cf129674e0035664715033
Gitweb:     http://git.kernel.org/tip/e7c93f09b83be25281cf129674e0035664715033
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 26 Jun 2013 16:14:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:02 -0300

perf util: Use evsel->name to get tracepoint_paths

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
 
