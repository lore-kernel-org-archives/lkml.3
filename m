Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaHNItH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:49:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaHNItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:49:03 -0400
Date: Thu, 14 Aug 2014 01:48:40 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-0a7e6d1b6844bec2d6817615a693c7fce447b80d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-14-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-14-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Check recorded kernel version when finding vmlinux
Git-Commit-ID: 0a7e6d1b6844bec2d6817615a693c7fce447b80d
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

Commit-ID:  0a7e6d1b6844bec2d6817615a693c7fce447b80d
Gitweb:     http://git.kernel.org/tip/0a7e6d1b6844bec2d6817615a693c7fce447b80d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:42:21 -0300

perf tools: Check recorded kernel version when finding vmlinux

Currently vmlinux_path__init() only tries to find vmlinux file from
current directory, /boot and some canonical directories with version
number of the running kernel.  This can be a problem when reporting old
data recorded on a kernel version not running currently.

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
  # ........  ..........  .................  ..............................
      71.87%     swapper  [kernel.kallsyms]  [k] recover_probed_instruction

After:

  # Overhead  Command     Shared Object      Symbol
  # ........  ..........  .................  ....................
      71.87%     swapper  [kernel.kallsyms]  [k] native_safe_halt

This requires to change signature of symbol__init() to receive struct
perf_session_env *.

Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407825645-24586-14-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c      |  2 +-
 tools/perf/builtin-buildid-cache.c |  2 +-
 tools/perf/builtin-diff.c          |  2 +-
 tools/perf/builtin-inject.c        |  2 +-
 tools/perf/builtin-kmem.c          |  4 ++--
 tools/perf/builtin-kvm.c           |  4 ++--
 tools/perf/builtin-lock.c          |  2 +-
 tools/perf/builtin-mem.c           |  2 +-
 tools/perf/builtin-record.c        |  2 +-
 tools/perf/builtin-report.c        |  2 +-
 tools/perf/builtin-sched.c         |  2 +-
 tools/perf/builtin-script.c        |  2 +-
 tools/perf/builtin-timechart.c     |  2 +-
 tools/perf/builtin-top.c           |  2 +-
 tools/perf/builtin-trace.c         |  4 ++--
 tools/perf/tests/builtin-test.c    |  2 +-
 tools/perf/util/probe-event.c      |  2 +-
 tools/perf/util/symbol.c           | 26 +++++++++++++++++---------
 tools/perf/util/symbol.h           |  3 ++-
 19 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c0464dc..d4da692 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -345,7 +345,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 	symbol_conf.priv_size = sizeof(struct annotation);
 	symbol_conf.try_vmlinux_path = true;
 
-	ret = symbol__init();
+	ret = symbol__init(&annotate.session->header.env);
 	if (ret < 0)
 		goto out_delete;
 
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index d91bfa6..ac5838e 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -329,7 +329,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 			return -1;
 	}
 
-	if (symbol__init() < 0)
+	if (symbol__init(session ? &session->header.env : NULL) < 0)
 		goto out;
 
 	setup_pager();
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index c10cc44..190d0b6 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1143,7 +1143,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	if (data_init(argc, argv) < 0)
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 18eaefd..3a62b6b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -462,7 +462,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (inject.session == NULL)
 		return -ENOMEM;
 
-	if (symbol__init() < 0)
+	if (symbol__init(&inject.session->header.env) < 0)
 		return -1;
 
 	ret = __cmd_inject(&inject);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 349d9b4..2376218 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -692,7 +692,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(kmem_usage, kmem_options);
 
 	if (!strncmp(argv[0], "rec", 3)) {
-		symbol__init();
+		symbol__init(NULL);
 		return __cmd_record(argc, argv);
 	}
 
@@ -700,7 +700,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (session == NULL)
 		return -ENOMEM;
 
-	symbol__init();
+	symbol__init(&session->header.env);
 
 	if (!strcmp(argv[0], "stat")) {
 		if (cpu__setup_cpunode_map())
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7f2b555..14d03ed 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1064,7 +1064,7 @@ static int read_events(struct perf_kvm_stat *kvm)
 		return -EINVAL;
 	}
 
-	symbol__init();
+	symbol__init(&kvm->session->header.env);
 
 	if (!perf_session__has_traces(kvm->session, "kvm record"))
 		return -EINVAL;
@@ -1314,7 +1314,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	kvm->opts.target.uid_str = NULL;
 	kvm->opts.target.uid = UINT_MAX;
 
-	symbol__init();
+	symbol__init(NULL);
 	disable_buildid_cache();
 
 	use_browser = 0;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d73580b..92790ed 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -865,7 +865,7 @@ static int __cmd_report(bool display_info)
 		return -ENOMEM;
 	}
 
-	symbol__init();
+	symbol__init(&session->header.env);
 
 	if (!perf_session__has_traces(session, "lock record"))
 		goto out_delete;
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 80e57c8..8b4a87f 100644
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
index ca0251e..4db670d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -908,7 +908,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(record_usage, record_options);
 	}
 
-	symbol__init();
+	symbol__init(NULL);
 
 	if (symbol_conf.kptr_restrict)
 		pr_warning(
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 041e93d..b9e0fca 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -798,7 +798,7 @@ repeat:
 		}
 	}
 
-	if (symbol__init() < 0)
+	if (symbol__init(&session->header.env) < 0)
 		goto error;
 
 	if (argc) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index dcd9ebf..f5874a2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1462,7 +1462,7 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		return -1;
 	}
 
-	symbol__init();
+	symbol__init(&session->header.env);
 
 	if (perf_session__set_tracepoints_handlers(session, handlers))
 		goto out_delete;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9ca7a2d..37d2b60 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1732,7 +1732,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			goto out_delete;
 	}
 
-	if (symbol__init() < 0)
+	if (symbol__init(&session->header.env) < 0)
 		goto out_delete;
 
 	script.session = session;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index df3b1c5..48eea6c 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1607,7 +1607,7 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 	if (session == NULL)
 		return -ENOMEM;
 
-	symbol__init();
+	symbol__init(&session->header.env);
 
 	(void)perf_header__process_sections(&session->header,
 					    perf_data_file__fd(session->file),
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0ab3ea7..4b0e15c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1234,7 +1234,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	symbol_conf.priv_size = sizeof(struct annotation);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
-	if (symbol__init() < 0)
+	if (symbol__init(NULL) < 0)
 		return -1;
 
 	sort__setup_elide(stdout);
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8a83bd8..d080b9c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1411,7 +1411,7 @@ static int trace__tool_process(struct perf_tool *tool,
 
 static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 {
-	int err = symbol__init();
+	int err = symbol__init(NULL);
 
 	if (err)
 		return err;
@@ -2245,7 +2245,7 @@ static int trace__replay(struct trace *trace)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (symbol__init() < 0)
+	if (symbol__init(&session->header.env) < 0)
 		goto out;
 
 	trace->host = &session->machines.host;
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01b..c6796d2 100644
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
index 443225c..784ea42 100644
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
index 009a9d0..ac098a3 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -15,6 +15,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "strlist.h"
+#include "header.h"
 
 #include <elf.h>
 #include <limits.h>
@@ -1749,10 +1750,11 @@ static void vmlinux_path__exit(void)
 	zfree(&vmlinux_path);
 }
 
-static int vmlinux_path__init(void)
+static int vmlinux_path__init(struct perf_session_env *env)
 {
 	struct utsname uts;
 	char bf[PATH_MAX];
+	char *kernel_version;
 
 	vmlinux_path = malloc(sizeof(char *) * 5);
 	if (vmlinux_path == NULL)
@@ -1767,25 +1769,31 @@ static int vmlinux_path__init(void)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
 
-	/* only try running kernel version if no symfs was given */
+	/* only try kernel version if no symfs was given */
 	if (symbol_conf.symfs[0] != 0)
 		return 0;
 
-	if (uname(&uts) < 0)
-		goto out_fail;
+	if (env) {
+		kernel_version = env->os_release;
+	} else {
+		if (uname(&uts) < 0)
+			goto out_fail;
+
+		kernel_version = uts.release;
+	}
 
-	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
+	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", kernel_version);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
-	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
+	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", kernel_version);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
 	snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
-		 uts.release);
+		 kernel_version);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
@@ -1831,7 +1839,7 @@ static bool symbol__read_kptr_restrict(void)
 	return value;
 }
 
-int symbol__init(void)
+int symbol__init(struct perf_session_env *env)
 {
 	const char *symfs;
 
@@ -1846,7 +1854,7 @@ int symbol__init(void)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
 					  sizeof(struct symbol));
 
-	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
+	if (symbol_conf.try_vmlinux_path && vmlinux_path__init(env) < 0)
 		return -1;
 
 	if (symbol_conf.field_sep && *symbol_conf.field_sep == '.') {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 196b291..b95e3a3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -262,7 +262,8 @@ int modules__parse(const char *filename, void *arg,
 int filename__read_debuglink(const char *filename, char *debuglink,
 			     size_t size);
 
-int symbol__init(void);
+struct perf_session_env;
+int symbol__init(struct perf_session_env *env);
 void symbol__exit(void);
 void symbol__elf_init(void);
 struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name);
