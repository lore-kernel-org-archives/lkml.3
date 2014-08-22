Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaHVQdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:33:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:33743 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbaHVQaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:09 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/16] perf scripting: Add 'flush' callback to scripting API
Date: Fri, 22 Aug 2014 13:29:19 -0300
Message-Id: <1408724968-3441-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

In order to defer some output via the scripting API, there needs to be a
callback after session processing but before the session is deleted.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408129739-17368-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c                            | 13 +++++++++++++
 tools/perf/util/scripting-engines/trace-event-perl.c   |  6 ++++++
 tools/perf/util/scripting-engines/trace-event-python.c |  6 ++++++
 tools/perf/util/trace-event-scripting.c                |  7 +++++++
 tools/perf/util/trace-event.h                          |  1 +
 5 files changed, 33 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c1b7029884b1..02dce9295e2c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -485,6 +485,11 @@ static int default_start_script(const char *script __maybe_unused,
 	return 0;
 }
 
+static int default_flush_script(void)
+{
+	return 0;
+}
+
 static int default_stop_script(void)
 {
 	return 0;
@@ -498,6 +503,7 @@ static int default_generate_script(struct pevent *pevent __maybe_unused,
 
 static struct scripting_ops default_scripting_ops = {
 	.start_script		= default_start_script,
+	.flush_script		= default_flush_script,
 	.stop_script		= default_stop_script,
 	.process_event		= process_event,
 	.generate_script	= default_generate_script,
@@ -513,6 +519,11 @@ static void setup_scripting(void)
 	scripting_ops = &default_scripting_ops;
 }
 
+static int flush_scripting(void)
+{
+	return scripting_ops->flush_script();
+}
+
 static int cleanup_scripting(void)
 {
 	pr_debug("\nperf script stopped\n");
@@ -1813,6 +1824,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_script(&script);
 
+	flush_scripting();
+
 out_delete:
 	perf_session__delete(session);
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b2dba9c0a3a1..0a01bac4ce02 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -432,6 +432,11 @@ error:
 	return err;
 }
 
+static int perl_flush_script(void)
+{
+	return 0;
+}
+
 /*
  * Stop trace script
  */
@@ -633,6 +638,7 @@ static int perl_generate_script(struct pevent *pevent, const char *outfile)
 struct scripting_ops perl_scripting_ops = {
 	.name = "Perl",
 	.start_script = perl_start_script,
+	.flush_script = perl_flush_script,
 	.stop_script = perl_stop_script,
 	.process_event = perl_process_event,
 	.generate_script = perl_generate_script,
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 26e5f14239ed..56ba07cce549 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -639,6 +639,11 @@ error:
 	return err;
 }
 
+static int python_flush_script(void)
+{
+	return 0;
+}
+
 /*
  * Stop trace script
  */
@@ -823,6 +828,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 struct scripting_ops python_scripting_ops = {
 	.name = "Python",
 	.start_script = python_start_script,
+	.flush_script = python_flush_script,
 	.stop_script = python_stop_script,
 	.process_event = python_process_event,
 	.generate_script = python_generate_script,
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 57aaccc1692e..5c9bdd1591a9 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -30,6 +30,11 @@
 
 struct scripting_context *scripting_context;
 
+static int flush_script_unsupported(void)
+{
+	return 0;
+}
+
 static int stop_script_unsupported(void)
 {
 	return 0;
@@ -74,6 +79,7 @@ static int python_generate_script_unsupported(struct pevent *pevent
 struct scripting_ops python_scripting_unsupported_ops = {
 	.name = "Python",
 	.start_script = python_start_script_unsupported,
+	.flush_script = flush_script_unsupported,
 	.stop_script = stop_script_unsupported,
 	.process_event = process_event_unsupported,
 	.generate_script = python_generate_script_unsupported,
@@ -137,6 +143,7 @@ static int perl_generate_script_unsupported(struct pevent *pevent
 struct scripting_ops perl_scripting_unsupported_ops = {
 	.name = "Perl",
 	.start_script = perl_start_script_unsupported,
+	.flush_script = flush_script_unsupported,
 	.stop_script = stop_script_unsupported,
 	.process_event = process_event_unsupported,
 	.generate_script = perl_generate_script_unsupported,
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 7b6d68688327..52aaa19e1eb1 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -64,6 +64,7 @@ struct perf_session;
 struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
+	int (*flush_script) (void);
 	int (*stop_script) (void);
 	void (*process_event) (union perf_event *event,
 			       struct perf_sample *sample,
-- 
1.9.3

