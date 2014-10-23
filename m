Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaJWWbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:31:06 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64724 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaJWWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:31:03 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, dsahern@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        namhyung@kernel.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>
Subject: [PATCH v3 02/14] perf tools: Kbuild builtin source related fixies
Date: Fri, 24 Oct 2014 00:28:10 +0200
Message-Id: <1414103302-14906-3-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding CONFIG_BUILTIN_* defines to govern builtin commands.
This will be useful for kbuild process switch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/builtin-annotate.c       |  8 ++++++-
 tools/perf/builtin-cmds.h           | 27 ++++++++++++++++++++++
 tools/perf/builtin-help.c           |  1 +
 tools/perf/builtin-kvm.c            | 19 ++++++++++------
 tools/perf/builtin-report.c         |  3 +++
 tools/perf/builtin-top.c            | 19 ++++++++++++----
 tools/perf/perf.c                   | 45 +++++++++++++++++++++++++++++++++++--
 tools/perf/ui/setup.c               |  6 +++--
 tools/perf/util/generate-cmdlist.sh | 10 +++++++++
 9 files changed, 122 insertions(+), 16 deletions(-)
 create mode 100644 tools/perf/builtin-cmds.h

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e7417fe..19cb967 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -5,6 +5,7 @@
  * look up and read DSOs and symbol information and display
  * a histogram of results, along various sorting keys.
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "util/util.h"
@@ -115,7 +116,7 @@ static void hists__find_annotations(struct hists *hists,
 				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
-	struct rb_node *nd = rb_first(&hists->entries), *next;
+	struct rb_node *nd = rb_first(&hists->entries);
 	int key = K_RIGHT;
 
 	while (nd) {
@@ -154,7 +155,9 @@ find_next:
 
 			/* skip missing symbols */
 			nd = rb_next(nd);
+#ifdef CONFIG_TUI
 		} else if (use_browser == 1) {
+			struct rb_node *next = NULL;
 			key = hist_entry__tui_annotate(he, evsel, NULL);
 			switch (key) {
 			case -1:
@@ -173,6 +176,7 @@ find_next:
 
 			if (next != NULL)
 				nd = next;
+#endif /* CONFIG_TUI */
 		} else {
 			hist_entry__tty_annotate(he, evsel, ann);
 			nd = rb_next(nd);
@@ -299,7 +303,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN(0, "gtk", &annotate.use_gtk, "Use the GTK interface"),
+#ifdef CONFIG_TUI
 	OPT_BOOLEAN(0, "tui", &annotate.use_tui, "Use the TUI interface"),
+#endif /* CONFIG_TUI */
 	OPT_BOOLEAN(0, "stdio", &annotate.use_stdio, "Use the stdio interface"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
new file mode 100644
index 0000000..fec342a
--- /dev/null
+++ b/tools/perf/builtin-cmds.h
@@ -0,0 +1,27 @@
+#ifndef BUILTIN_CMDS_H
+#define BUILTIN_CMDS_H
+
+#define CONFIG_BUILTIN_REPORT 1
+#define CONFIG_BUILTIN_SCRIPT 1
+#define CONFIG_BUILTIN_BENCH 1
+#define CONFIG_BUILTIN_SCHED 1
+#define CONFIG_BUILTIN_TRACE 1
+#define CONFIG_BUILTIN_TOP 1
+#define CONFIG_BUILTIN_RECORD 1
+#define CONFIG_BUILTIN_BUILDID_LIST 1
+#define CONFIG_BUILTIN_INJECT 1
+#define CONFIG_BUILTIN_LOCK 1
+#define CONFIG_BUILTIN_KVM 1
+#define CONFIG_BUILTIN_BUILDID_CACHE 1
+#define CONFIG_BUILTIN_EVLIST 1
+#define CONFIG_BUILTIN_KMEM 1
+#define CONFIG_BUILTIN_STAT 1
+#define CONFIG_BUILTIN_DIFF 1
+#define CONFIG_BUILTIN_ANNOTATE 1
+#define CONFIG_BUILTIN_TIMECHART 1
+#define CONFIG_BUILTIN_LIST 1
+#define CONFIG_BUILTIN_HELP 1
+#define CONFIG_BUILTIN_PROBE 1
+#define CONFIG_BUILTIN_MEM 1
+
+#endif /* BUILTIN_CMDS_H */
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 25d2062..fbbbaa4 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -7,6 +7,7 @@
 #include "util/cache.h"
 #include "builtin.h"
 #include "util/exec_cmd.h"
+#include "builtin-cmds.h"
 #include "common-cmds.h"
 #include "util/parse-options.h"
 #include "util/run-command.h"
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b65eb050..400e92e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1531,20 +1531,25 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (!strncmp(argv[0], "rec", 3))
 		return __cmd_record(file_name, argc, argv);
-	else if (!strncmp(argv[0], "rep", 3))
+
+	if (!strncmp(argv[0], "rep", 3))
 		return __cmd_report(file_name, argc, argv);
-	else if (!strncmp(argv[0], "diff", 4))
+
+	if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv, NULL);
-	else if (!strncmp(argv[0], "top", 3))
+
+	if (!strncmp(argv[0], "top", 3))
 		return cmd_top(argc, argv, NULL);
-	else if (!strncmp(argv[0], "buildid-list", 12))
+
+	if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
+
 #ifdef HAVE_KVM_STAT_SUPPORT
-	else if (!strncmp(argv[0], "stat", 4))
+	if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
 #endif
-	else
-		usage_with_options(kvm_usage, kvm_options);
+
+	usage_with_options(kvm_usage, kvm_options);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 140a6cd..00d93ff 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -5,6 +5,7 @@
  * look up and read DSOs and symbol information and display
  * a histogram of results, along various sorting keys.
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "util/util.h"
@@ -406,6 +407,7 @@ static int report__browse_hists(struct report *rep)
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	switch (use_browser) {
+#ifdef CONFIG_TUI
 	case 1:
 		ret = perf_evlist__tui_browse_hists(evlist, help, NULL,
 						    rep->min_percent,
@@ -417,6 +419,7 @@ static int report__browse_hists(struct report *rep)
 		if (ret != K_SWITCH_INPUT_DATA)
 			ret = 0;
 		break;
+#endif /* CONFIG_TUI */
 	case 2:
 		ret = report__gtk_browse_hists(rep, help);
 		break;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0aa7747..a2ff8b7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -17,6 +17,7 @@
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
+#include "generated/autoconf.h"
 #include "builtin.h"
 
 #include "perf.h"
@@ -534,6 +535,7 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 	return ret;
 }
 
+#ifdef CONFIG_TUI
 static void perf_top__sort_new_samples(void *arg)
 {
 	struct perf_top *t = arg;
@@ -586,6 +588,7 @@ static void *display_thread_tui(void *arg)
 	done = 1;
 	return NULL;
 }
+#endif /* CONFIG_TUI */
 
 static void display_sig(int sig __maybe_unused)
 {
@@ -926,9 +929,12 @@ static int perf_top__setup_sample_type(struct perf_top *top __maybe_unused)
 	return 0;
 }
 
+typedef void* (*display_fn_t)(void *);
+
 static int __cmd_top(struct perf_top *top)
 {
 	struct record_opts *opts = &top->record_opts;
+	display_fn_t display_fn = display_thread;
 	pthread_t thread;
 	int ret;
 
@@ -965,8 +971,8 @@ static int __cmd_top(struct perf_top *top)
 	 * XXX 'top' still doesn't start workloads like record, trace, but should,
 	 * so leave the check here.
 	 */
-        if (!target__none(&opts->target))
-                perf_evlist__enable(top->evlist);
+	if (!target__none(&opts->target))
+		perf_evlist__enable(top->evlist);
 
 	/* Wait for a minimal set of events before starting the snapshot */
 	perf_evlist__poll(top->evlist, 100);
@@ -974,8 +980,13 @@ static int __cmd_top(struct perf_top *top)
 	perf_top__mmap_read(top);
 
 	ret = -1;
-	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
-							    display_thread), top)) {
+
+#ifdef CONFIG_TUI
+	if (use_browser > 0)
+		display_fn = display_thread_tui;
+#endif
+
+	if (pthread_create(&thread, NULL, display_fn, top)) {
 		ui__error("Could not create display thread.\n");
 		goto out_delete;
 	}
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 452a847..ab363b5 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -7,6 +7,7 @@
  * perf top, perf record, perf report, etc.) are started.
  */
 #include "builtin.h"
+#include "builtin-cmds.h"
 
 #include "util/exec_cmd.h"
 #include "util/cache.h"
@@ -34,34 +35,74 @@ struct cmd_struct {
 };
 
 static struct cmd_struct commands[] = {
+#ifdef CONFIG_BUILTIN_BUILDID_CACHE
 	{ "buildid-cache", cmd_buildid_cache, 0 },
+#endif
+#ifdef CONFIG_BUILTIN_BUILDID_LIST
 	{ "buildid-list", cmd_buildid_list, 0 },
+#endif
+#ifdef CONFIG_BUILTIN_DIFF
 	{ "diff",	cmd_diff,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_EVLIST
 	{ "evlist",	cmd_evlist,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_HELP
 	{ "help",	cmd_help,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_LIST
 	{ "list",	cmd_list,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_RECORD
 	{ "record",	cmd_record,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_REPORT
 	{ "report",	cmd_report,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_BENCH
 	{ "bench",	cmd_bench,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_STAT
 	{ "stat",	cmd_stat,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_TIMECHART
 	{ "timechart",	cmd_timechart,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_TOP
 	{ "top",	cmd_top,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_ANNOTATE
 	{ "annotate",	cmd_annotate,	0 },
+#endif
 	{ "version",	cmd_version,	0 },
+#ifdef CONFIG_BUILTIN_SCRIPT
 	{ "script",	cmd_script,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_SCHED
 	{ "sched",	cmd_sched,	0 },
-#ifdef HAVE_LIBELF_SUPPORT
+#endif
+#if defined HAVE_LIBELF_SUPPORT && defined CONFIG_BUILTIN_PROBE
 	{ "probe",	cmd_probe,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_KMEM
 	{ "kmem",	cmd_kmem,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_LOCK
 	{ "lock",	cmd_lock,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_KVM
 	{ "kvm",	cmd_kvm,	0 },
+#endif
 	{ "test",	cmd_test,	0 },
-#ifdef HAVE_LIBAUDIT_SUPPORT
+#if defined HAVE_LIBAUDIT_SUPPORT && defined CONFIG_BUILTIN_TRACE
 	{ "trace",	cmd_trace,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_INJECT
 	{ "inject",	cmd_inject,	0 },
+#endif
+#ifdef CONFIG_BUILTIN_MEM
 	{ "mem",	cmd_mem,	0 },
+#endif
 };
 
 struct pager_config {
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ba51fa8..ec7fd36 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -77,11 +77,13 @@ void setup_browser(bool fallback_to_pager)
 		       PERF_GTK_DSO);
 		sleep(1);
 		/* fall through */
+#ifdef CONFIG_TUI
 	case 1:
 		use_browser = 1;
 		if (ui__init() == 0)
 			break;
 		/* fall through */
+#endif
 	default:
 		use_browser = 0;
 		if (fallback_to_pager)
@@ -96,11 +98,11 @@ void exit_browser(bool wait_for_ok)
 	case 2:
 		exit_gtk_browser(wait_for_ok);
 		break;
-
+#ifdef CONFIG_TUI
 	case 1:
 		ui__exit(wait_for_ok);
 		break;
-
+#endif
 	default:
 		break;
 	}
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 36a885d..05ee30f 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -1,5 +1,11 @@
 #!/bin/sh
 
+function cfg()
+{
+     cfg=`echo $1 | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g'`
+     echo "$cfg"
+}
+
 echo "/* Automatically generated by $0 */
 struct cmdname_help
 {
@@ -13,6 +19,7 @@ sed -n -e 's/^perf-\([^ 	]*\)[ 	].* common.*/\1/p' command-list.txt |
 sort |
 while read cmd
 do
+     echo "#ifdef CONFIG_BUILTIN_$(cfg $cmd)"
      sed -n '
      /^NAME/,/perf-'"$cmd"'/H
      ${
@@ -20,6 +27,7 @@ do
             s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
 	    p
      }' "Documentation/perf-$cmd.txt"
+     echo "#endif"
 done
 
 echo "#ifdef HAVE_LIBELF_SUPPORT"
@@ -27,6 +35,7 @@ sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
 do
+     echo "#ifdef CONFIG_BUILTIN_$(cfg $cmd)"
      sed -n '
      /^NAME/,/perf-'"$cmd"'/H
      ${
@@ -34,6 +43,7 @@ do
             s/.*perf-'"$cmd"' - \(.*\)/  {"'"$cmd"'", "\1"},/
 	    p
      }' "Documentation/perf-$cmd.txt"
+     echo "#endif"
 done
 echo "#endif /* HAVE_LIBELF_SUPPORT */"
 echo "};"
-- 
2.1.1

