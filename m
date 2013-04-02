Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab3DBDzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52787 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3DBDzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:36 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/23] perf: deprecate DWARF_SUPPORT in favor of CONFIG_DWARF
Date: Mon,  1 Apr 2013 21:54:33 -0600
Message-Id: <1364874877-5618-20-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile                  |    2 +-
 tools/perf/builtin-probe.c           |   15 ++++++++-------
 tools/perf/util/include/dwarf-regs.h |    4 +++-
 tools/perf/util/probe-event.c        |    5 +++--
 tools/perf/util/probe-finder.h       |    5 +++--
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f9847db..e76fa2f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -593,7 +593,7 @@ ifdef CONFIG_LIBELF
         ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	        msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
         else
-            BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
+            BASIC_CFLAGS := $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
             BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
             EXTLIBS += -lelf -ldw
             LIB_OBJS += $(OUTPUT)util/probe-finder.o
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index de38a03..c86faf0 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -41,6 +41,7 @@
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
+#include <linux/kconfig.h>
 
 #define DEFAULT_VAR_FILTER "!__k???tab_* & !__crc_*"
 #define DEFAULT_FUNC_FILTER "!_*"
@@ -173,7 +174,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
 			params.uprobes = true;
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 		else if (!strcmp(opt->long_name, "module"))
 			params.uprobes = false;
 #endif
@@ -187,7 +188,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	return ret;
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 static int opt_show_lines(const struct option *opt __maybe_unused,
 			  const char *str, int unset __maybe_unused)
 {
@@ -257,7 +258,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 		"perf probe --list",
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 		"perf probe [<options>] --line 'LINEDESC'",
 		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
@@ -271,7 +272,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [[NAME=]ARG ...]",
 #else
@@ -283,7 +284,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
@@ -296,7 +297,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -408,7 +409,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 	if (params.show_lines && !params.uprobes) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
diff --git a/tools/perf/util/include/dwarf-regs.h b/tools/perf/util/include/dwarf-regs.h
index cf6727e..f77a851 100644
--- a/tools/perf/util/include/dwarf-regs.h
+++ b/tools/perf/util/include/dwarf-regs.h
@@ -1,7 +1,9 @@
 #ifndef _PERF_DWARF_REGS_H_
 #define _PERF_DWARF_REGS_H_
 
-#ifdef DWARF_SUPPORT
+#include <linux/kconfig.h>
+
+#ifdef CONFIG_DWARF
 const char *get_arch_regstr(unsigned int n);
 #endif
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 49a256e..1aed7a6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -45,6 +45,7 @@
 #include "probe-event.h"
 #include "probe-finder.h"
 #include "session.h"
+#include <linux/kconfig.h>
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -201,7 +202,7 @@ static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 	return 0;
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
@@ -630,7 +631,7 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	return ret;
 }
 
-#else	/* !DWARF_SUPPORT */
+#else	/* !CONFIG_DWARF */
 
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 17e94d0..5e4621e 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -4,6 +4,7 @@
 #include <stdbool.h>
 #include "util.h"
 #include "probe-event.h"
+#include <linux/kconfig.h>
 
 #define MAX_PROBE_BUFFER	1024
 #define MAX_PROBES		 128
@@ -14,7 +15,7 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef CONFIG_DWARF
 
 #include "dwarf-aux.h"
 
@@ -102,6 +103,6 @@ struct line_finder {
 	int			found;
 };
 
-#endif /* DWARF_SUPPORT */
+#endif /* CONFIG_DWARF */
 
 #endif /*_PROBE_FINDER_H */
-- 
1.7.10.1

