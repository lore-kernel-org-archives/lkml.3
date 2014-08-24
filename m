Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaHXPAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:00:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaHXPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:00:08 -0400
Date: Sun, 24 Aug 2014 07:58:16 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d445dd2a78eed884adf3b3426b078fe69d2516d8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1408129739-17368-3-git-send-email-adrian.hunter@intel.com>
References: <1408129739-17368-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripting: Add 'flush'
  callback to scripting API
Git-Commit-ID: d445dd2a78eed884adf3b3426b078fe69d2516d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d445dd2a78eed884adf3b3426b078fe69d2516d8
Gitweb:     http://git.kernel.org/tip/d445dd2a78eed884adf3b3426b078fe69d2516d8
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 15 Aug 2014 22:08:37 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 22 Aug 2014 13:12:11 -0300

perf scripting: Add 'flush' callback to scripting API

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
index c1b7029..02dce92 100644
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
index 26e5f14..56ba07c 100644
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
