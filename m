Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab3DATVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759524Ab3DATVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:21:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 26/27] perf tools: Kbuild source related fixies
Date: Mon,  1 Apr 2013 21:18:49 +0200
Message-Id: <1364843930-17974-27-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing several sources config dependencies to allow
separate config builds.

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
 tools/perf/builtin-lock.c        |  2 ++
 tools/perf/builtin-report.c      |  9 ++++++++-
 tools/perf/builtin-sched.c       |  2 ++
 tools/perf/perf.c                |  6 ++++++
 tools/perf/perf.h                |  2 ++
 tools/perf/ui/browsers/scripts.c |  4 ++++
 tools/perf/ui/setup.c            | 10 +++++++++-
 7 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 4258300..bb1f729 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -972,9 +972,11 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 				usage_with_options(report_usage, report_options);
 		}
 		__cmd_report();
+#ifdef CONFIG_BULTIN_SCRIPT
 	} else if (!strcmp(argv[0], "script")) {
 		/* Aliased to 'perf script' */
 		return cmd_script(argc, argv, prefix);
+#endif
 	} else if (!strcmp(argv[0], "info")) {
 		if (argc) {
 			argc = parse_options(argc, argv,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd0ca81..87690f5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -573,6 +573,7 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (use_browser > 0) {
 		if (use_browser == 1) {
+#ifdef CONFIG_TUI
 			ret = perf_evlist__tui_browse_hists(session->evlist,
 							help,
 							NULL,
@@ -583,10 +584,16 @@ static int __cmd_report(struct perf_report *rep)
 			 */
 			if (ret != K_SWITCH_INPUT_DATA)
 				ret = 0;
-
+#else
+				ret = -1;
+#endif
 		} else if (use_browser == 2) {
+#ifdef CONFIG_GUI
 			perf_evlist__gtk_browse_hists(session->evlist, help,
 						      NULL);
+#else
+			ret = -1;
+#endif
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6c..4c4046a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1747,11 +1747,13 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+#ifdef CONFIG_BULTIN_SCRIPT
 	/*
 	 * Aliased to 'perf script' for now:
 	 */
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
+#endif
 
 	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index ccc6c52..f277b98 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -92,7 +92,9 @@ static struct cmd_struct commands[] = {
 #ifdef CONFIG_BUILTIN_KVM
 	{ "kvm",	cmd_kvm,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_TEST
 	{ "test",	cmd_test,	0 },
+#endif
 #if defined LIBAUDIT_SUPPORT && defined CONFIG_BUILTIN_TRACE
 	{ "trace",	cmd_trace,	0 },
 #endif
@@ -535,13 +537,17 @@ int main(int argc, const char **argv)
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
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32bd102..978659e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -162,8 +162,10 @@ sys_perf_event_open(struct perf_event_attr *attr,
 	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
 		     group_fd, flags);
 
+#ifdef CONFIG_BUILTIN_TEST
 	if (unlikely(test_attr__enabled))
 		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
+#endif
 
 	return fd;
 }
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index 12f009e..effdf38 100644
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
index ae6a789..6775665 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -17,13 +17,17 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
+#ifdef CONFIG_GUI
 		if (perf_gtk__init() == 0)
 			break;
+#endif
 		/* fall through */
+#ifdef CONFIG_TUI
 	case 1:
 		use_browser = 1;
 		if (ui__init() == 0)
 			break;
+#endif
 		/* fall through */
 	default:
 		use_browser = 0;
@@ -36,16 +40,20 @@ void setup_browser(bool fallback_to_pager)
 	}
 }
 
-void exit_browser(bool wait_for_ok)
+void exit_browser(bool wait_for_ok __maybe_unused)
 {
 	switch (use_browser) {
 	case 2:
+#ifdef CONFIG_GUI
 		perf_gtk__exit(wait_for_ok);
 		break;
+#endif
 
+#ifdef CONFIG_TUI
 	case 1:
 		ui__exit(wait_for_ok);
 		break;
+#endif
 
 	default:
 		break;
-- 
1.7.11.7

