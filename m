Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaALSks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:40:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaALSko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:40:44 -0500
Date: Sun, 12 Jan 2014 10:40:03 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-uux5wpvevlerd42gqer13e7n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  No need to test against NULL before calling free()
Git-Commit-ID: f5385650c02cd4373c4124c8a8fac3b5f9851e7f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:40:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5385650c02cd4373c4124c8a8fac3b5f9851e7f
Gitweb:     http://git.kernel.org/tip/f5385650c02cd4373c4124c8a8fac3b5f9851e7f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 26 Dec 2013 15:54:57 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Dec 2013 15:58:52 -0300

perf tools: No need to test against NULL before calling free()

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
index 5a80da6..a6ec105 100644
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
index d63c68e..402d2bd 100644
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
index 61c5421..10730b0 100644
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
index 72b56ae..095a98e 100644
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
index 7db7e05..8c08735 100644
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
index 3773c48..e108207 100644
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
index b258de6..cd9774d 100644
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
