Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaG2IPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:15:30 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64472 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaG2IP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:15:26 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: [RFC/PATCH] perf tools: Check recorded kernel version when finding vmlinux
Date: Tue, 29 Jul 2014 17:15:15 +0900
Message-Id: <1406621715-27819-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vmlinux_path__init() only tries to find vmlinux file from
current directory, /boot and some canonical directories with version
number of the running kernel.  This can be a problem when reporting old
data recorded on a custom kernel not running currently.

We can use --symfs option for this but it's annoying for user to do it
always.  As we already have the info in the perf.data file, it can be
changed to use it for the search automatically.

Before:

  $ perf report
  ...
  # Samples: 4K of event 'cpu-clock'
  # Event count (approx.): 1067250000
  #
  # Overhead  Command     Shared Object      Symbol
  # ........  ..........  .................  ...............................
      71.87%     swapper  [kernel.kallsyms]  [k] recover_probed_instructtion

After:

  # Overhead  Command     Shared Object      Symbol
  # ........  ..........  .................  ....................
      71.87%     swapper  [kernel.kallsyms]  [k] native_safe_halt

This requires to change signature of symbol__init() to receive struct
perf_session_env *.  This patch only does some trivial changes - some
tools might want to change their structure to setup session info
before calling symbol__init() later.

Reported-by: Minchan Kim <minchan@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c      |  2 +-
 tools/perf/builtin-buildid-cache.c |  2 +-
 tools/perf/builtin-diff.c          |  2 +-
 tools/perf/builtin-inject.c        |  2 +-
 tools/perf/builtin-kmem.c          |  2 +-
 tools/perf/builtin-kvm.c           |  4 ++--
 tools/perf/builtin-lock.c          |  2 +-
 tools/perf/builtin-mem.c           |  2 +-
 tools/perf/builtin-record.c        |  2 +-
 tools/perf/builtin-report.c        |  2 +-
 tools/perf/builtin-sched.c         |  2 +-
 tools/perf/builtin-script.c        | 10 +++++-----
 tools/perf/builtin-timechart.c     |  2 +-
 tools/perf/builtin-top.c           |  2 +-
 tools/perf/builtin-trace.c         |  8 ++++----
 tools/perf/tests/builtin-test.c    |  2 +-
 tools/perf/util/probe-event.c      |  2 +-
 tools/perf/util/symbol.c           | 18 ++++++++++++++----
 tools/perf/util/symbol.h           |  3 ++-
 19 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1ec429fef2be..bd0e52136253 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -356,7 +356,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 	symbol_conf.priv_size = sizeof(struct annotation);
 	symbol_conf.try_vmlinux_path = true;
 
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	if (setup_sorting() < 0)
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 2a2c78f80876..373f1f0797e5 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -326,7 +326,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 	argc = parse_options(argc, argv, buildid_cache_options,
 			     buildid_cache_usage, 0);
 
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	setup_pager();
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9a5a035cb426..62700681f6b9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1143,7 +1143,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	if (data_init(argc, argv) < 0)
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index cf6a605a13e8..42a61cc0ac5b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -459,7 +459,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		return -1;
 	}
 
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	return __cmd_inject(&inject);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index bef3376bfaf3..41bbb46d67a3 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -695,7 +695,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
-	symbol__init();
+	symbol__init(NULL);
 
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43367eb00510..24bce87aaa0c 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1201,7 +1201,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		NULL
 	};
 
-	symbol__init();
+	symbol__init(NULL);
 
 	if (argc) {
 		argc = parse_options(argc, argv,
@@ -1322,7 +1322,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	kvm->opts.target.uid_str = NULL;
 	kvm->opts.target.uid = UINT_MAX;
 
-	symbol__init();
+	symbol__init(NULL);
 	disable_buildid_cache();
 
 	use_browser = 0;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6148afc995c6..dd7112f4bc35 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -974,7 +974,7 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	unsigned int i;
 	int rc = 0;
 
-	symbol__init();
+	symbol__init(NULL);
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 4a1a6c94a5eb..9521347f2461 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -133,7 +133,7 @@ static int report_raw_events(struct perf_mem *mem)
 			goto out_delete;
 	}
 
-	if (symbol__init() < 0)
+	if (symbol__init(&session->header.env) < 0)
 		return -1;
 
 	printf("# PID, TID, IP, ADDR, LOCAL WEIGHT, DSRC, SYMBOL\n");
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b731a7..91a03a703b72 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -902,7 +902,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(record_usage, record_options);
 	}
 
-	symbol__init();
+	symbol__init(NULL);
 
 	if (symbol_conf.kptr_restrict)
 		pr_warning(
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21d830bafff3..294a527df154 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -787,7 +787,7 @@ repeat:
 		}
 	}
 
-	if (symbol__init() < 0)
+	if (symbol__init(&session->header.env) < 0)
 		goto error;
 
 	if (argc) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f83c08c0dd87..99dadc7765a8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1747,7 +1747,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
 
-	symbol__init();
+	symbol__init(NULL);
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9e9c91f5b7fa..def2f61640af 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1740,11 +1740,6 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		exit(-1);
 	}
 
-	if (symbol__init() < 0)
-		return -1;
-	if (!script_name)
-		setup_pager();
-
 	session = perf_session__new(&file, false, &script.tool);
 	if (session == NULL)
 		return -ENOMEM;
@@ -1757,6 +1752,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	script.session = session;
 
+	if (symbol__init(&session->header.env) < 0)
+		return -1;
+	if (!script_name)
+		setup_pager();
+
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 2f1a5220c090..92d301973bf8 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1982,7 +1982,7 @@ int cmd_timechart(int argc, const char **argv,
 		return -1;
 	}
 
-	symbol__init();
+	symbol__init(NULL);
 
 	if (argc && !strncmp(argv[0], "rec", 3)) {
 		argc = parse_options(argc, argv, record_options, record_usage,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 377971dc89a3..58bed31f6404 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1217,7 +1217,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	symbol_conf.priv_size = sizeof(struct annotation);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	sort__setup_elide(stdout);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c4a5a7d7b2cf..f19ca9a9aeec 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1385,7 +1385,7 @@ static int trace__tool_process(struct perf_tool *tool,
 
 static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 {
-	int err = symbol__init();
+	int err = symbol__init(NULL);
 
 	if (err)
 		return err;
@@ -2215,13 +2215,13 @@ static int trace__replay(struct trace *trace)
 	/* add tid to output */
 	trace->multiple_threads = true;
 
-	if (symbol__init() < 0)
-		return -1;
-
 	session = perf_session__new(&file, false, &trace->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (symbol__init(&session->header.env) < 0)
+		goto out;
+
 	trace->host = &session->machines.host;
 
 	err = perf_session__set_tracepoints_handlers(session, handlers);
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01bc6033..c6796d22423a 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -297,7 +297,7 @@ int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
 	symbol_conf.sort_by_name = true;
 	symbol_conf.try_vmlinux_path = true;
 
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	if (skip != NULL)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9a0a1839a377..fe2d22068d19 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -79,7 +79,7 @@ static int init_symbol_maps(bool user_only)
 	int ret;
 
 	symbol_conf.sort_by_name = true;
-	ret = symbol__init();
+	ret = symbol__init(NULL);
 	if (ret < 0) {
 		pr_debug("Failed to init symbol map.\n");
 		goto out;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 95186185c1d5..58d53e1b0339 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -15,6 +15,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "strlist.h"
+#include "header.h"
 
 #include <elf.h>
 #include <limits.h>
@@ -1745,12 +1746,12 @@ static void vmlinux_path__exit(void)
 	zfree(&vmlinux_path);
 }
 
-static int vmlinux_path__init(void)
+static int vmlinux_path__init(struct perf_session_env *env)
 {
 	struct utsname uts;
 	char bf[PATH_MAX];
 
-	vmlinux_path = malloc(sizeof(char *) * 5);
+	vmlinux_path = malloc(sizeof(char *) * 6);
 	if (vmlinux_path == NULL)
 		return -1;
 
@@ -1763,6 +1764,15 @@ static int vmlinux_path__init(void)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
 
+	if (env) {
+		snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux",
+			 env->os_release);
+		vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+		if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+			goto out_fail;
+		++vmlinux_path__nr_entries;
+	}
+
 	/* only try running kernel version if no symfs was given */
 	if (symbol_conf.symfs[0] != 0)
 		return 0;
@@ -1827,7 +1837,7 @@ static bool symbol__read_kptr_restrict(void)
 	return value;
 }
 
-int symbol__init(void)
+int symbol__init(struct perf_session_env *env)
 {
 	char *symfs;
 
@@ -1842,7 +1852,7 @@ int symbol__init(void)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
 					  sizeof(struct symbol));
 
-	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
+	if (symbol_conf.try_vmlinux_path && vmlinux_path__init(env) < 0)
 		return -1;
 
 	if (symbol_conf.field_sep && *symbol_conf.field_sep == '.') {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ee2d3ccd3ad1..9a84481d90b1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -251,7 +251,8 @@ int modules__parse(const char *filename, void *arg,
 int filename__read_debuglink(const char *filename, char *debuglink,
 			     size_t size);
 
-int symbol__init(void);
+struct perf_session_env;
+int symbol__init(struct perf_session_env *env);
 void symbol__exit(void);
 void symbol__elf_init(void);
 struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name);
-- 
2.0.0

