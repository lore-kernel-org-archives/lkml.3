Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaIVV7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:59:31 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52448 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaIVVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:55:57 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, dsahern@gmail.com, mingo@kernel.org,
        sam@ravnborg.org, mmarek@suse.cz, namhyung@kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/15] perf tools: Kbuild source related fixies
Date: Mon, 22 Sep 2014 23:53:04 +0200
Message-Id: <1411422796-27049-4-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Fixing several sources config dependencies to allow
separate config builds.

This commit was originally created by Jiri Olsa in 2013. Minor changes
were needed to get it working one year later:
* Remove #ifdef directives related with GUI / TUI (because of code
  changes in ui/setup.c)
* Fix a link issue if the option BUILTIN_TRACE is disabled.
* Fix typo (CONFIG_BULTIN_ instead CONFIG_BUILTIN_)

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
---
 tools/perf/builtin-annotate.c    |  6 +++---
 tools/perf/builtin-lock.c        |  5 ++++-
 tools/perf/builtin-report.c      |  2 +-
 tools/perf/builtin-sched.c       |  3 +++
 tools/perf/builtin-top.c         |  4 ++--
 tools/perf/perf.c                | 10 ++++++++--
 tools/perf/ui/browsers/scripts.c |  4 ++++
 tools/perf/ui/setup.c            |  6 +++---
 8 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index d40070f..aea56c5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -154,7 +154,7 @@ find_next:
 
 			/* skip missing symbols */
 			nd = rb_next(nd);
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 		} else if (use_browser == 1) {
 			struct rb_node *next = NULL;
 			key = hist_entry__tui_annotate(he, evsel, NULL);
@@ -318,9 +318,9 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN(0, "gtk", &annotate.use_gtk, "Use the GTK interface"),
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	OPT_BOOLEAN(0, "tui", &annotate.use_tui, "Use the TUI interface"),
-#endif /* CONFIG_TUI */
+#endif
 	OPT_BOOLEAN(0, "stdio", &annotate.use_stdio, "Use the stdio interface"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6148afc..f5404dc 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,4 +1,5 @@
 #include "builtin.h"
+#include "builtin-cmds.h"
 #include "perf.h"
 
 #include "util/evlist.h"
@@ -994,9 +995,11 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 				usage_with_options(report_usage, report_options);
 		}
 		rc = __cmd_report(false);
+#ifdef CONFIG_BUILTIN_SCRIPT
 	} else if (!strcmp(argv[0], "script")) {
 		/* Aliased to 'perf script' */
-		return cmd_script(argc, argv, prefix);
+		rc = cmd_script(argc, argv, prefix);
+#endif
 	} else if (!strcmp(argv[0], "info")) {
 		if (argc) {
 			argc = parse_options(argc, argv,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c97410a..8dc8077 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -392,7 +392,7 @@ static int report__browse_hists(struct report *rep)
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	switch (use_browser) {
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		ret = perf_evlist__tui_browse_hists(evlist, help, NULL,
 						    rep->min_percent,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f83c08c..edda0b2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1,4 +1,5 @@
 #include "builtin.h"
+#include "builtin-cmds.h"
 #include "perf.h"
 
 #include "util/util.h"
@@ -1741,11 +1742,13 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+#ifdef CONFIG_BUILTIN_SCRIPT
 	/*
 	 * Aliased to 'perf script' for now:
 	 */
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
+#endif
 
 	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c668b0a..1c807c3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -535,7 +535,7 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 	return ret;
 }
 
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 static void perf_top__sort_new_samples(void *arg)
 {
 	struct perf_top *t = arg;
@@ -958,7 +958,7 @@ static int __cmd_top(struct perf_top *top)
 
 	ret = -1;
 
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	if (use_browser > 0)
 		display_fn = display_thread_tui;
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 7bd1d80..774b9b0 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -93,8 +93,10 @@ static struct cmd_struct commands[] = {
 #ifdef CONFIG_BUILTIN_KVM
 	{ "kvm",	cmd_kvm,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_TEST
 	{ "test",	cmd_test,	0 },
-#if defined HAVE_LIBAUDIT_SUPPORT && defined CONFIG_BUILTIN_TRACE
+#endif
+#ifdef CONFIG_BUILTIN_TRACE
 	{ "trace",	cmd_trace,	0 },
 #endif
 #ifdef CONFIG_BUILTIN_INJECT
@@ -535,7 +537,7 @@ int main(int argc, const char **argv)
 		goto out;
 	}
 	if (!prefixcmp(cmd, "trace")) {
-#ifdef HAVE_LIBAUDIT_SUPPORT
+#ifdef CONFIG_BUILTIN_TRACE
 		set_buildid_dir();
 		setup_path();
 		argv[0] = "trace";
@@ -559,13 +561,17 @@ int main(int argc, const char **argv)
 	} else {
 		/* The user didn't specify a command; give them help */
 		printf("\n usage: %s\n\n", perf_usage_string);
+#ifdef CONFIG_BUILTIN_HELP
 		list_common_cmds_help();
 		printf("\n %s\n\n", perf_more_info_string);
+#endif
 		goto out;
 	}
 	cmd = argv[0];
 
+#ifdef CONFIG_BUILTIN_TEST
 	test_attr__init();
+#endif
 
 	/*
 	 * We use PATH to find perf commands, but we prepend some higher
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index 402d2bd..128988d 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -59,7 +59,11 @@ static int list_scripts(char *script_name)
 		paths[i] = names[i] + SCRIPT_NAMELEN;
 	}
 
+#ifdef CONFIG_BUILTIN_SCRIPT
 	num = find_scripts(names, paths);
+#else
+	num = 0;
+#endif
 	if (num > 0) {
 		choice = ui__popup_menu(num, names);
 		if (choice < num && choice >= 0) {
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ec7fd36..efc2b21 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -77,7 +77,7 @@ void setup_browser(bool fallback_to_pager)
 		       PERF_GTK_DSO);
 		sleep(1);
 		/* fall through */
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		use_browser = 1;
 		if (ui__init() == 0)
@@ -92,13 +92,13 @@ void setup_browser(bool fallback_to_pager)
 	}
 }
 
-void exit_browser(bool wait_for_ok)
+void exit_browser(bool wait_for_ok __maybe_unused)
 {
 	switch (use_browser) {
 	case 2:
 		exit_gtk_browser(wait_for_ok);
 		break;
-#ifdef CONFIG_TUI
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		ui__exit(wait_for_ok);
 		break;
-- 
2.1.0

