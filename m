Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaGaGDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:03:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538AbaGaGDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:03:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569800240"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 27/31] perf tools: Add 'flush' callback to scripting API
Date: Thu, 31 Jul 2014 09:01:10 +0300
Message-Id: <1406786474-9306-28-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to defer some output via the scripting API,
there needs to be a callback after session processing
but before the session is deleted.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c                            | 12 ++++++++++++
 tools/perf/util/scripting-engines/trace-event-perl.c   |  6 ++++++
 tools/perf/util/scripting-engines/trace-event-python.c |  6 ++++++
 tools/perf/util/trace-event-scripting.c                |  7 +++++++
 tools/perf/util/trace-event.h                          |  1 +
 5 files changed, 32 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 163d12b..4d4fe4e 100644
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
@@ -1806,6 +1817,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_script(&script);
 
+	flush_scripting();
 	perf_session__delete(session);
 	cleanup_scripting();
 out:
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b2dba9c..0a01bac 100644
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
index 5f7b76b..ed754d0 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1022,6 +1022,11 @@ error:
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
@@ -1210,6 +1215,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 struct scripting_ops python_scripting_ops = {
 	.name = "Python",
 	.start_script = python_start_script,
+	.flush_script = python_flush_script,
 	.stop_script = python_stop_script,
 	.process_event = python_process_event,
 	.generate_script = python_generate_script,
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 57aaccc..5c9bdd1 100644
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
index 7b6d686..52aaa19 100644
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
1.8.3.2

