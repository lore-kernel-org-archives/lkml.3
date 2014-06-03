Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738AbaFCWSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:18:17 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62606 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbaFCWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:40 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, dsahern@gmail.com, mingo@kernel.org,
        sam@ravnborg.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kbuild@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/32] perf tools: Kbuild source related fixies
Date: Wed,  4 Jun 2014 00:05:56 +0200
Message-Id: <1401833185-10347-4-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
 tools/perf/builtin-lock.c        |  4 +++-
 tools/perf/builtin-sched.c       |  2 ++
 tools/perf/perf.c                |  6 ++++++
 tools/perf/perf.h                |  2 ++
 tools/perf/ui/browsers/scripts.c |  4 ++++
 tools/perf/ui/setup.c            | 10 +++++++++-
 6 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c852c7a..b255c20 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -992,9 +992,11 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 				usage_with_options(report_usage, report_options);
 		}
 		rc = __cmd_report(false);
+#ifdef CONFIG_BULTIN_SCRIPT
 	} else if (!strcmp(argv[0], "script")) {
 		/* Aliased to 'perf script' */
-		return cmd_script(argc, argv, prefix);
+		rc = cmd_script(argc, argv, prefix);
+#endif
 	} else if (!strcmp(argv[0], "info")) {
 		if (argc) {
 			argc = parse_options(argc, argv,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9ac0a49..cb77a4e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1741,11 +1741,13 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
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
index c39470b..74a1269 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -92,7 +92,9 @@ static struct cmd_struct commands[] = {
 #ifdef CONFIG_BUILTIN_KVM
 	{ "kvm",	cmd_kvm,	0 },
 #endif
+#ifdef CONFIG_BUILTIN_TEST
 	{ "test",	cmd_test,	0 },
+#endif
 #if defined HAVE_LIBAUDIT_SUPPORT && defined CONFIG_BUILTIN_TRACE
 	{ "trace",	cmd_trace,	0 },
 #endif
@@ -543,13 +545,17 @@ int main(int argc, const char **argv)
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
index 5c11eca..8487a30 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -221,8 +221,10 @@ sys_perf_event_open(struct perf_event_attr *attr,
 	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
 		     group_fd, flags);
 
+#ifdef CONFIG_BUILTIN_TEST
 	if (unlikely(test_attr__enabled))
 		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
+#endif
 
 	return fd;
 }
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
index 5df5140..66ecd08 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -71,16 +71,20 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
+#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
 		if (setup_gtk_browser() == 0)
 			break;
 		printf("GTK browser requested but could not find %s\n",
 		       PERF_GTK_DSO);
 		sleep(1);
+#endif
 		/* fall through */
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		use_browser = 1;
 		if (ui__init() == 0)
 			break;
+#endif
 		/* fall through */
 	default:
 		use_browser = 0;
@@ -92,16 +96,20 @@ void setup_browser(bool fallback_to_pager)
 	}
 }
 
-void exit_browser(bool wait_for_ok)
+void exit_browser(bool wait_for_ok __maybe_unused)
 {
 	switch (use_browser) {
 	case 2:
+#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
 		exit_gtk_browser(wait_for_ok);
 		break;
+#endif
 
+#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		ui__exit(wait_for_ok);
 		break;
+#endif
 
 	default:
 		break;
-- 
1.9.3

