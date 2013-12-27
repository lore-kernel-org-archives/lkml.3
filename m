Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3L0Utu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:49:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35718 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3L0UrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 47/49] perf tools: No need to test against NULL before calling free()
Date: Fri, 27 Dec 2013 17:47:03 -0300
Message-Id: <1388177225-17349-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its perfectly fine to call free(NULL), so no need to clutter the source
code with all those superfluous testing.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-uux5wpvevlerd42gqer13e7n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c                           |  4 +-
 tools/perf/ui/browsers/scripts.c                   |  3 +-
 tools/perf/util/header.c                           |  6 +--
 tools/perf/util/probe-event.c                      | 62 ++++++++--------------
 tools/perf/util/probe-finder.c                     | 12 ++---
 .../perf/util/scripting-engines/trace-event-perl.c |  3 +-
 .../util/scripting-engines/trace-event-python.c    |  3 +-
 7 files changed, 31 insertions(+), 62 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 5a80da6ba413..a6ec1052c291 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1158,9 +1158,7 @@ out:
 	if (kvm->timerfd >= 0)
 		close(kvm->timerfd);
 
-	if (pollfds)
-		free(pollfds);
-
+	free(pollfds);
 	return err;
 }
 
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index d63c68ea02a8..402d2bd30b09 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -173,8 +173,7 @@ int script_browse(const char *script_opt)
 	if (script.b.width > AVERAGE_LINE_LEN)
 		script.b.width = AVERAGE_LINE_LEN;
 
-	if (line)
-		free(line);
+	free(line);
 	pclose(fp);
 
 	script.nr_lines = nr_entries;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 61c54213704b..10730b0af804 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1232,10 +1232,8 @@ static void free_event_desc(struct perf_evsel *events)
 		return;
 
 	for (evsel = events; evsel->attr.size; evsel++) {
-		if (evsel->name)
-			free(evsel->name);
-		if (evsel->id)
-			free(evsel->id);
+		free(evsel->name);
+		free(evsel->id);
 	}
 
 	free(events);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 72b56aef105e..095a98ec7444 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -401,9 +401,7 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 		}
 	}
 
-	if (tmp)
-		free(tmp);
-
+	free(tmp);
 	return ret;
 }
 
@@ -1382,8 +1380,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 error:
 	pr_debug("Failed to synthesize perf probe point: %s\n",
 		 strerror(-ret));
-	if (buf)
-		free(buf);
+	free(buf);
 	return NULL;
 }
 
@@ -1584,34 +1581,25 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 	struct perf_probe_arg_field *field, *next;
 	int i;
 
-	if (pev->event)
-		free(pev->event);
-	if (pev->group)
-		free(pev->group);
-	if (pp->file)
-		free(pp->file);
-	if (pp->function)
-		free(pp->function);
-	if (pp->lazy_line)
-		free(pp->lazy_line);
+	free(pev->event);
+	free(pev->group);
+	free(pp->file);
+	free(pp->function);
+	free(pp->lazy_line);
+
 	for (i = 0; i < pev->nargs; i++) {
-		if (pev->args[i].name)
-			free(pev->args[i].name);
-		if (pev->args[i].var)
-			free(pev->args[i].var);
-		if (pev->args[i].type)
-			free(pev->args[i].type);
+		free(pev->args[i].name);
+		free(pev->args[i].var);
+		free(pev->args[i].type);
 		field = pev->args[i].field;
 		while (field) {
 			next = field->next;
-			if (field->name)
-				free(field->name);
+			free(field->name);
 			free(field);
 			field = next;
 		}
 	}
-	if (pev->args)
-		free(pev->args);
+	free(pev->args);
 	memset(pev, 0, sizeof(*pev));
 }
 
@@ -1620,21 +1608,14 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 	struct probe_trace_arg_ref *ref, *next;
 	int i;
 
-	if (tev->event)
-		free(tev->event);
-	if (tev->group)
-		free(tev->group);
-	if (tev->point.symbol)
-		free(tev->point.symbol);
-	if (tev->point.module)
-		free(tev->point.module);
+	free(tev->event);
+	free(tev->group);
+	free(tev->point.symbol);
+	free(tev->point.module);
 	for (i = 0; i < tev->nargs; i++) {
-		if (tev->args[i].name)
-			free(tev->args[i].name);
-		if (tev->args[i].value)
-			free(tev->args[i].value);
-		if (tev->args[i].type)
-			free(tev->args[i].type);
+		free(tev->args[i].name);
+		free(tev->args[i].value);
+		free(tev->args[i].type);
 		ref = tev->args[i].ref;
 		while (ref) {
 			next = ref->next;
@@ -1642,8 +1623,7 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 			ref = next;
 		}
 	}
-	if (tev->args)
-		free(tev->args);
+	free(tev->args);
 	memset(tev, 0, sizeof(*tev));
 }
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 7db7e05ccb89..8c087359b7ce 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1414,10 +1414,8 @@ int debuginfo__find_available_vars_at(struct debuginfo *dbg,
 	if (ret < 0) {
 		/* Free vlist for error */
 		while (af.nvls--) {
-			if (af.vls[af.nvls].point.symbol)
-				free(af.vls[af.nvls].point.symbol);
-			if (af.vls[af.nvls].vars)
-				strlist__delete(af.vls[af.nvls].vars);
+			free(af.vls[af.nvls].point.symbol);
+			strlist__delete(af.vls[af.nvls].vars);
 		}
 		free(af.vls);
 		*vls = NULL;
@@ -1524,10 +1522,8 @@ post:
 	if (fname) {
 		ppt->file = strdup(fname);
 		if (ppt->file == NULL) {
-			if (ppt->function) {
-				free(ppt->function);
-				ppt->function = NULL;
-			}
+			free(ppt->function);
+			ppt->function = NULL;
 			ret = -ENOMEM;
 			goto end;
 		}
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 3773c4841cab..e108207c5de0 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -194,8 +194,7 @@ static void define_event_symbols(struct event_format *event,
 		zero_flag_atom = 0;
 		break;
 	case PRINT_FIELD:
-		if (cur_field_name)
-			free(cur_field_name);
+		free(cur_field_name);
 		cur_field_name = strdup(args->field.name);
 		break;
 	case PRINT_FLAGS:
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index b258de6357ac..cd9774df3750 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -161,8 +161,7 @@ static void define_event_symbols(struct event_format *event,
 		zero_flag_atom = 0;
 		break;
 	case PRINT_FIELD:
-		if (cur_field_name)
-			free(cur_field_name);
+		free(cur_field_name);
 		cur_field_name = strdup(args->field.name);
 		break;
 	case PRINT_FLAGS:
-- 
1.8.1.4

