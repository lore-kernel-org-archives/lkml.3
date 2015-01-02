Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbbABPiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:38:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbbABPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:38:09 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/30] perf tools: Add support to configure builtin commands inclusion
Date: Fri,  2 Jan 2015 16:36:11 +0100
Message-Id: <1420212972-21595-30-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: hack

Adding support to configure builtin commands inclusion
in the build, so we could later disable particular
builtin command.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Build                    | 53 ++++++++++++++++++++-----------------
 tools/perf/Makefile.build           |  3 +++
 tools/perf/Makefile.perf            |  7 +++--
 tools/perf/builtin-cmds.h           | 29 ++++++++++++++++++++
 tools/perf/builtin-help.c           |  1 +
 tools/perf/config.default           | 23 ++++++++++++++++
 tools/perf/perf.c                   |  1 +
 tools/perf/util/generate-cmdlist.sh | 10 +++++++
 8 files changed, 101 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/builtin-cmds.h
 create mode 100644 tools/perf/config.default

diff --git a/tools/perf/Build b/tools/perf/Build
index c95d6378ad65..8e8f2c58f2b0 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -1,29 +1,34 @@
-perf-y += builtin-bench.o
-perf-y += builtin-annotate.o
-perf-y += builtin-diff.o
-perf-y += builtin-evlist.o
-perf-y += builtin-help.o
-perf-y += builtin-sched.o
-perf-y += builtin-buildid-list.o
-perf-y += builtin-buildid-cache.o
-perf-y += builtin-list.o
-perf-y += builtin-record.o
-perf-y += builtin-report.o
-perf-y += builtin-stat.o
-perf-y += builtin-timechart.o
-perf-y += builtin-top.o
-perf-y += builtin-script.o
-perf-y += builtin-kmem.o
-perf-y += builtin-lock.o
-perf-y += builtin-kvm.o
-perf-y += builtin-inject.o
-perf-y += builtin-mem.o
-
-perf-$(CONFIG_AUDIT) += builtin-trace.o
-perf-$(CONFIG_LIBELF) += builtin-probe.o
+perf-$(CONFIG_BUILTIN_BENCH)         += builtin-bench.o
+perf-$(CONFIG_BUILTIN_ANNOTATE)      += builtin-annotate.o
+perf-$(CONFIG_BUILTIN_DIFF)          += builtin-diff.o
+perf-$(CONFIG_BUILTIN_EVLIST)        += builtin-evlist.o
+perf-$(CONFIG_BUILTIN_HELP)          += builtin-help.o
+perf-$(CONFIG_BUILTIN_SCHED)         += builtin-sched.o
+perf-$(CONFIG_BUILTIN_BUILDID_LIST)  += builtin-buildid-list.o
+perf-$(CONFIG_BUILTIN_BUILDID_CACHE) += builtin-buildid-cache.o
+perf-$(CONFIG_BUILTIN_LIST)          += builtin-list.o
+perf-$(CONFIG_BUILTIN_RECORD)        += builtin-record.o
+perf-$(CONFIG_BUILTIN_REPORT)        += builtin-report.o
+perf-$(CONFIG_BUILTIN_STAT)          += builtin-stat.o
+perf-$(CONFIG_BUILTIN_TIMECHART)     += builtin-timechart.o
+perf-$(CONFIG_BUILTIN_TOP)           += builtin-top.o
+perf-$(CONFIG_BUILTIN_SCRIPT)        += builtin-script.o
+perf-$(CONFIG_BUILTIN_KMEM)          += builtin-kmem.o
+perf-$(CONFIG_BUILTIN_LOCK)          += builtin-lock.o
+perf-$(CONFIG_BUILTIN_KVM)           += builtin-kvm.o
+perf-$(CONFIG_BUILTIN_INJECT)        += builtin-inject.o
+perf-$(CONFIG_BUILTIN_MEM)           += builtin-mem.o
+
+ifeq ($(CONFIG_AUDIT),y)
+perf-$(CONFIG_BUILTIN_TRACE)         += builtin-trace.o
+endif
+
+ifeq ($(CONFIG_LIBELF),y)
+perf-$(CONFIG_BUILTIN_PROBE)         += builtin-probe.o
+endif
 
 perf-y += bench/
-perf-y += tests/
+perf-$(CONFIG_BUILTIN_TEST) += tests/
 
 perf-y += perf.o
 
diff --git a/tools/perf/Makefile.build b/tools/perf/Makefile.build
index 54dc27e0acac..7c50b44e53f9 100644
--- a/tools/perf/Makefile.build
+++ b/tools/perf/Makefile.build
@@ -18,6 +18,9 @@ include Build.include
 # do not force detected configuration
 -include .config-detected
 
+# do not force user's configuration
+-include .config-user
+
 # Init all relevant variables used in build files so
 # 1) they have correct type
 # 2) they do not inherit any value from the environment
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 45d30b8f947e..8203777120cd 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -250,7 +250,10 @@ export INSTALL SHELL_PATH
 
 SHELL = $(SHELL_PATH)
 
-all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
+config_def:
+	@cp config.default .config-user
+
+all: config_def shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
 
 please_set_SHELL_PATH_to_a_more_modern_shell:
 	@$$(:)
@@ -554,5 +557,5 @@ FORCE:
 
 .PHONY: all install clean config-clean strip install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope FORCE single_dep
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope FORCE single_dep config_def
 
diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
new file mode 100644
index 000000000000..5ceb4b58cfdd
--- /dev/null
+++ b/tools/perf/builtin-cmds.h
@@ -0,0 +1,29 @@
+#ifndef BUILTIN_CMDS_H
+#define BUILTIN_CMDS_H
+
+#define CONFIG_BUILTIN_REPORT
+#define CONFIG_BUILTIN_SCRIPT
+#define CONFIG_BUILTIN_BENCH
+#define CONFIG_BUILTIN_SCHED
+#define CONFIG_BUILTIN_TRACE
+#define CONFIG_BUILTIN_TOP
+#define CONFIG_BUILTIN_RECORD
+#define CONFIG_BUILTIN_BUILDID_LIST
+#define CONFIG_BUILTIN_INJECT
+#define CONFIG_BUILTIN_LOCK
+#define CONFIG_BUILTIN_KVM
+#define CONFIG_BUILTIN_BUILDID_CACHE
+#define CONFIG_BUILTIN_EVLIST
+#define CONFIG_BUILTIN_KMEM
+#define CONFIG_BUILTIN_STAT
+#define CONFIG_BUILTIN_DIFF
+#define CONFIG_BUILTIN_ANNOTATE
+#define CONFIG_BUILTIN_TIMECHART
+#define CONFIG_BUILTIN_LIST
+#define CONFIG_BUILTIN_HELP
+#define CONFIG_BUILTIN_PROBE
+#define CONFIG_BUILTIN_MEM
+#define CONFIG_BUILTIN_TEST
+
+#endif /* BUILTIN_CMDS_H */
+
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 25d20628212e..2aa88a040bde 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -6,6 +6,7 @@
 #include "perf.h"
 #include "util/cache.h"
 #include "builtin.h"
+#include "builtin-cmds.h"
 #include "util/exec_cmd.h"
 #include "common-cmds.h"
 #include "util/parse-options.h"
diff --git a/tools/perf/config.default b/tools/perf/config.default
new file mode 100644
index 000000000000..2781af21b70b
--- /dev/null
+++ b/tools/perf/config.default
@@ -0,0 +1,23 @@
+CONFIG_BUILTIN_BENCH         := y
+CONFIG_BUILTIN_ANNOTATE      := y
+CONFIG_BUILTIN_DIFF          := y
+CONFIG_BUILTIN_EVLIST        := y
+CONFIG_BUILTIN_HELP          := y
+CONFIG_BUILTIN_SCHED         := y
+CONFIG_BUILTIN_BUILDID_LIST  := y
+CONFIG_BUILTIN_BUILDID_CACHE := y
+CONFIG_BUILTIN_LIST          := y
+CONFIG_BUILTIN_RECORD        := y
+CONFIG_BUILTIN_REPORT        := y
+CONFIG_BUILTIN_STAT          := y
+CONFIG_BUILTIN_TIMECHART     := y
+CONFIG_BUILTIN_TOP           := y
+CONFIG_BUILTIN_SCRIPT        := y
+CONFIG_BUILTIN_KMEM          := y
+CONFIG_BUILTIN_LOCK          := y
+CONFIG_BUILTIN_KVM           := y
+CONFIG_BUILTIN_INJECT        := y
+CONFIG_BUILTIN_MEM           := y
+CONFIG_BUILTIN_TRACE         := y
+CONFIG_BUILTIN_PROBE         := y
+CONFIG_BUILTIN_TEST          := y
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 3700a7faca6c..7c5ceff22d47 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -7,6 +7,7 @@
  * perf top, perf record, perf report, etc.) are started.
  */
 #include "builtin.h"
+#include "builtin-cmds.h"
 
 #include "util/exec_cmd.h"
 #include "util/cache.h"
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 36a885d2cd22..05ee30f724e0 100755
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
1.9.3

