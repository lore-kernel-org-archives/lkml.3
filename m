Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3I3QmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:42:21 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60165 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3I3QmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:42:16 -0400
Date: Mon, 30 Sep 2013 18:42:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] perf auto-dep: Speed up feature tests by building them in
 parallel
Message-ID: <20130930164210.GA22342@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130915091029.GA21465@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series (with combo patch attached) implements (much) faster 
perf-tools feature-auto-detection.

I used 3 tricks to implement feature auto-dependencies and to speed up 
feature detection:

  - standalone Makefile in config/feature-checks/ built in parallel

  - split-out standalone .c files in config/feature-checks/*.c

  - used GCC's auto-dependency generation feature (-MD) to track the
    effects of system library addition/removal.

Before the changes a fully cached re-build of an already built tree took 
2.6 second:

    $ perf stat --null --sync --repeat 3 -a make Makefile

       2.669467209 seconds time elapsed                                          ( +-  0.07% )

After the changes it takes only 0.6 seconds:

       0.599161560 seconds time elapsed                                          ( +-  0.25% )

So the empty build got 4.4x faster.

The 'cache cold' full rebuild got faster as well:

    $ perf stat --null --sync --pre 'make clean; make -C config/feature-checks/ clean' --repeat 3 -a make Makefile

   before:  2.671373213 seconds time elapsed                                          ( +-  0.12% )
    after:  0.959772417 seconds time elapsed                                          ( +-  0.22% )

That's 2.7x faster.

The series also implements new feature detection output, which looks like 
this:

 Auto-detecting system features:

 ...            stackprotector-all: [ on  ]
 ...         volatile-register-var: [ on  ]
 ...                fortify-source: [ on  ]
 ...                        libelf: [ on  ]
 ...                   libelf-mmap: [ on  ]
 ...                         glibc: [ on  ]
 ...                         dwarf: [ on  ]
 ...             libelf-getphdrnum: [ on  ]
 ...                     libunwind: [ on  ]
 ...                      libaudit: [ on  ]
 ...                      libslang: [ on  ]
 ...                          gtk2: [ on  ]
 ...                  gtk2-infobar: [ on  ]
 ...                       libperl: [ OFF ]
 ...                     libpython: [ on  ]
 ...             libpython-version: [ on  ]
 ...                        libbfd: [ on  ]
 ...                       strlcpy: [ OFF ]
 ...                       on-exit: [ on  ]
 ...                     backtrace: [ on  ]
 ...                       libnuma: [ on  ]

This can be used to get an overview about feature detection status. Users 
will want to maximize the number of 'on' entries.

An 'on' feature is 'cached' in that its feature-check binary is present 
during future builds:

 $ ls -l config/feature-checks/test-libaudit
 -rwxrwxr-x 1 mingo mingo 7264 Sep 30 18:31 config/feature-checks/test-libaudit

and it's only remade if its underlying system libraries are changed: 
removed or updated. Note that unlike the hack-version I sent before, 
cached features immediately turn into 'OFF' state once a dependent package 
is removed.

'OFF' features failed to pass due to missing dependencies. Those are 
re-made on every build. The fewer of them, the faster the build gets.

The series also streamlines feature names as exposed to the rest of perf: 
it standardizes on the HAVE_{FEATURE}_SUPPORT pattern. We used to have a 
mixture of HAVE_{FEATURE} and {FEATURE}_SUPPORT constants.

There's still the annoyance left that Linus reported originally: that the 
config pass is repeated twice on 'make install' - this results in the 
feature matrix to be output twice.

Comments, suggestions, bugreports are welcome.

Thanks,

	Ingo

----------------------->

Subject: perf autodep: Implement faster auto-detection of features
From: Ingo Molnar <mingo@kernel.org>
Date: Mon Sep 30 18:14:50 CEST 2013

---
 tools/perf/Makefile                                           |    1 
 tools/perf/arch/x86/include/perf_regs.h                       |    6 
 tools/perf/arch/x86/util/unwind.c                             |    4 
 tools/perf/bench/mem-memcpy-arch.h                            |    2 
 tools/perf/bench/mem-memcpy.c                                 |    2 
 tools/perf/bench/mem-memset-arch.h                            |    2 
 tools/perf/bench/mem-memset.c                                 |    2 
 tools/perf/builtin-bench.c                                    |    4 
 tools/perf/builtin-inject.c                                   |    2 
 tools/perf/builtin-probe.c                                    |   14 
 tools/perf/builtin-record.c                                   |   12 
 tools/perf/config/Makefile                                    |  237 +++++-----
 tools/perf/config/feature-checks/Makefile                     |  110 ++++
 tools/perf/config/feature-checks/test-backtrace.c             |   10 
 tools/perf/config/feature-checks/test-bionic.c                |    6 
 tools/perf/config/feature-checks/test-dwarf.c                 |    9 
 tools/perf/config/feature-checks/test-fortify-source.c        |    6 
 tools/perf/config/feature-checks/test-glibc.c                 |    8 
 tools/perf/config/feature-checks/test-gtk2-infobar.c          |   10 
 tools/perf/config/feature-checks/test-gtk2.c                  |   10 
 tools/perf/config/feature-checks/test-hello.c                 |    6 
 tools/perf/config/feature-checks/test-libaudit.c              |    7 
 tools/perf/config/feature-checks/test-libbfd.c                |    7 
 tools/perf/config/feature-checks/test-libelf-getphdrnum.c     |    7 
 tools/perf/config/feature-checks/test-libelf-mmap.c           |    7 
 tools/perf/config/feature-checks/test-libelf.c                |    7 
 tools/perf/config/feature-checks/test-libnuma.c               |    8 
 tools/perf/config/feature-checks/test-libperl.c               |    9 
 tools/perf/config/feature-checks/test-libpython-version.c     |   10 
 tools/perf/config/feature-checks/test-libpython.c             |    7 
 tools/perf/config/feature-checks/test-libslang.c              |    6 
 tools/perf/config/feature-checks/test-libunwind.c             |   20 
 tools/perf/config/feature-checks/test-on-exit.c               |    6 
 tools/perf/config/feature-checks/test-stackprotector-all.c    |    6 
 tools/perf/config/feature-checks/test-stackprotector.c        |    6 
 tools/perf/config/feature-checks/test-strlcpy.c               |    8 
 tools/perf/config/feature-checks/test-volatile-register-var.c |    6 
 tools/perf/perf.c                                             |    4 
 tools/perf/ui/gtk/browser.c                                   |    2 
 tools/perf/ui/gtk/gtk.h                                       |    4 
 tools/perf/ui/gtk/util.c                                      |    4 
 tools/perf/ui/ui.h                                            |    4 
 tools/perf/util/annotate.h                                    |    4 
 tools/perf/util/cache.h                                       |    2 
 tools/perf/util/generate-cmdlist.sh                           |    4 
 tools/perf/util/hist.h                                        |    4 
 tools/perf/util/include/dwarf-regs.h                          |    2 
 tools/perf/util/map.c                                         |    2 
 tools/perf/util/path.c                                        |    2 
 tools/perf/util/perf_regs.h                                   |    4 
 tools/perf/util/probe-event.c                                 |    4 
 tools/perf/util/probe-finder.h                                |    4 
 tools/perf/util/symbol-elf.c                                  |    2 
 tools/perf/util/symbol.h                                      |    8 
 tools/perf/util/unwind.h                                      |    4 
 tools/perf/util/util.c                                        |    4 
 56 files changed, 491 insertions(+), 167 deletions(-)

Index: tip/tools/perf/Makefile
===================================================================
--- tip.orig/tools/perf/Makefile
+++ tip/tools/perf/Makefile
@@ -816,3 +816,4 @@ clean: $(LIBTRACEEVENT)-clean $(LIBLK)-c
 .PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
+
Index: tip/tools/perf/arch/x86/include/perf_regs.h
===================================================================
--- tip.orig/tools/perf/arch/x86/include/perf_regs.h
+++ tip/tools/perf/arch/x86/include/perf_regs.h
@@ -5,7 +5,7 @@
 #include "../../util/types.h"
 #include <asm/perf_regs.h>
 
-#ifndef ARCH_X86_64
+#ifndef HAVE_ARCH_X86_64_SUPPORT
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
 #else
 #define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
@@ -52,7 +52,7 @@ static inline const char *perf_reg_name(
 		return "FS";
 	case PERF_REG_X86_GS:
 		return "GS";
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 	case PERF_REG_X86_R8:
 		return "R8";
 	case PERF_REG_X86_R9:
@@ -69,7 +69,7 @@ static inline const char *perf_reg_name(
 		return "R14";
 	case PERF_REG_X86_R15:
 		return "R15";
-#endif /* ARCH_X86_64 */
+#endif /* HAVE_ARCH_X86_64_SUPPORT */
 	default:
 		return NULL;
 	}
Index: tip/tools/perf/arch/x86/util/unwind.c
===================================================================
--- tip.orig/tools/perf/arch/x86/util/unwind.c
+++ tip/tools/perf/arch/x86/util/unwind.c
@@ -4,7 +4,7 @@
 #include "perf_regs.h"
 #include "../../util/unwind.h"
 
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 int unwind__arch_reg_id(int regnum)
 {
 	int id;
@@ -108,4 +108,4 @@ int unwind__arch_reg_id(int regnum)
 
 	return id;
 }
-#endif /* ARCH_X86_64 */
+#endif /* HAVE_ARCH_X86_64_SUPPORT */
Index: tip/tools/perf/bench/mem-memcpy-arch.h
===================================================================
--- tip.orig/tools/perf/bench/mem-memcpy-arch.h
+++ tip/tools/perf/bench/mem-memcpy-arch.h
@@ -1,5 +1,5 @@
 
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMCPY_FN(fn, name, desc)		\
 	extern void *fn(void *, const void *, size_t);
Index: tip/tools/perf/bench/mem-memcpy.c
===================================================================
--- tip.orig/tools/perf/bench/mem-memcpy.c
+++ tip/tools/perf/bench/mem-memcpy.c
@@ -58,7 +58,7 @@ struct routine routines[] = {
 	{ "default",
 	  "Default memcpy() provided by glibc",
 	  memcpy },
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMCPY_FN(fn, name, desc) { name, desc, fn },
 #include "mem-memcpy-x86-64-asm-def.h"
Index: tip/tools/perf/bench/mem-memset-arch.h
===================================================================
--- tip.orig/tools/perf/bench/mem-memset-arch.h
+++ tip/tools/perf/bench/mem-memset-arch.h
@@ -1,5 +1,5 @@
 
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMSET_FN(fn, name, desc)		\
 	extern void *fn(void *, int, size_t);
Index: tip/tools/perf/bench/mem-memset.c
===================================================================
--- tip.orig/tools/perf/bench/mem-memset.c
+++ tip/tools/perf/bench/mem-memset.c
@@ -58,7 +58,7 @@ static const struct routine routines[] =
 	{ "default",
 	  "Default memset() provided by glibc",
 	  memset },
-#ifdef ARCH_X86_64
+#ifdef HAVE_ARCH_X86_64_SUPPORT
 
 #define MEMSET_FN(fn, name, desc) { name, desc, fn },
 #include "mem-memset-x86-64-asm-def.h"
Index: tip/tools/perf/builtin-bench.c
===================================================================
--- tip.orig/tools/perf/builtin-bench.c
+++ tip/tools/perf/builtin-bench.c
@@ -35,7 +35,7 @@ struct bench_suite {
 /* sentinel: easy for help */
 #define suite_all { "all", "Test all benchmark suites", NULL }
 
-#ifdef LIBNUMA_SUPPORT
+#ifdef HAVE_LIBNUMA_SUPPORT
 static struct bench_suite numa_suites[] = {
 	{ "mem",
 	  "Benchmark for NUMA workloads",
@@ -80,7 +80,7 @@ struct bench_subsys {
 };
 
 static struct bench_subsys subsystems[] = {
-#ifdef LIBNUMA_SUPPORT
+#ifdef HAVE_LIBNUMA_SUPPORT
 	{ "numa",
 	  "NUMA scheduling and MM behavior",
 	  numa_suites },
Index: tip/tools/perf/builtin-inject.c
===================================================================
--- tip.orig/tools/perf/builtin-inject.c
+++ tip/tools/perf/builtin-inject.c
@@ -231,7 +231,7 @@ static int perf_event__inject_buildid(st
 				 * account this as unresolved.
 				 */
 			} else {
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
Index: tip/tools/perf/builtin-probe.c
===================================================================
--- tip.orig/tools/perf/builtin-probe.c
+++ tip/tools/perf/builtin-probe.c
@@ -173,7 +173,7 @@ static int opt_set_target(const struct o
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
 			params.uprobes = true;
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		else if (!strcmp(opt->long_name, "module"))
 			params.uprobes = false;
 #endif
@@ -187,7 +187,7 @@ static int opt_set_target(const struct o
 	return ret;
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 static int opt_show_lines(const struct option *opt __maybe_unused,
 			  const char *str, int unset __maybe_unused)
 {
@@ -257,7 +257,7 @@ int cmd_probe(int argc, const char **arg
 		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 		"perf probe --list",
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		"perf probe [<options>] --line 'LINEDESC'",
 		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
@@ -271,7 +271,7 @@ int cmd_probe(int argc, const char **arg
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [[NAME=]ARG ...]",
 #else
@@ -283,7 +283,7 @@ int cmd_probe(int argc, const char **arg
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
@@ -296,7 +296,7 @@ int cmd_probe(int argc, const char **arg
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -408,7 +408,7 @@ int cmd_probe(int argc, const char **arg
 		return ret;
 	}
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 	if (params.show_lines && !params.uprobes) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
Index: tip/tools/perf/builtin-record.c
===================================================================
--- tip.orig/tools/perf/builtin-record.c
+++ tip/tools/perf/builtin-record.c
@@ -29,7 +29,7 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#ifndef HAVE_ON_EXIT
+#ifndef HAVE_ON_EXIT_SUPPORT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
 #endif
@@ -684,7 +684,7 @@ error:
 	return ret;
 }
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -710,7 +710,7 @@ static int get_stack_size(char *str, uns
 	       max_size, str);
 	return -1;
 }
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* HAVE_LIBUNWIND_SUPPORT */
 
 int record_parse_callchain_opt(const struct option *opt,
 			       const char *arg, int unset)
@@ -748,7 +748,7 @@ int record_parse_callchain_opt(const str
 				       "needed for -g fp\n");
 			break;
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -768,7 +768,7 @@ int record_parse_callchain_opt(const str
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 opts->stack_dump_size);
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* HAVE_LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
 			       "value: %s\n", arg);
@@ -815,7 +815,7 @@ static struct perf_record record = {
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
Index: tip/tools/perf/config/Makefile
===================================================================
--- tip.orig/tools/perf/config/Makefile
+++ tip/tools/perf/config/Makefile
@@ -23,7 +23,7 @@ ifeq ($(ARCH),x86_64)
   endif
   ifeq (${IS_X86_64}, 1)
     RAW_ARCH := x86_64
-    CFLAGS += -DARCH_X86_64
+    CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
   endif
   NO_PERF_REGS := 0
@@ -31,7 +31,7 @@ ifeq ($(ARCH),x86_64)
 endif
 
 ifeq ($(NO_PERF_REGS),0)
-  CFLAGS += -DHAVE_PERF_REGS
+  CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
 
 ifeq ($(src-perf),)
@@ -89,20 +89,55 @@ CFLAGS += -std=gnu99
 
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
+feature_check = $(eval $(feature_check_code))
+define feature_check_code
+  feature-$(1) := $(shell make -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+endef
+
+#
+# Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
+#
+$(info )
+$(info Auto-detecting system features:)
+$(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
+
+FEATURE_TESTS = stackprotector-all volatile-register-var fortify-source libelf libelf-mmap glibc dwarf libelf-getphdrnum libunwind libaudit libslang gtk2 gtk2-infobar libperl libpython libpython-version libbfd strlcpy on-exit backtrace libnuma
+
+$(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
+
+feature_print = $(eval $(feature_print_code))
+
+#
+# Print the result of the feature test:
+#
+define feature_print_code
+  ifeq ($(feature-$(1)), 1)
+    MSG := $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+  else
+    MSG := $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+  endif
+  $(info $(MSG))
+endef
+
+$(foreach feat,$(FEATURE_TESTS) DUMMY,$(call feature_print,$(feat)))
+
+# newline at the end of the feature printouts:
+$(info )
+
+ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
+ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
+ifeq ($(feature-volatile-register-var), 1)
   CFLAGS += -Wvolatile-register-var
 endif
 
 ifndef PERF_DEBUG
-  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+  ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
   endif
 endif
@@ -128,84 +163,82 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-  BIONIC := 1
-  EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
-  EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  $(feature_check,bionic)
+  ifeq ($(feature-bionic), 1)
+    BIONIC := 1
+    EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+    EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  endif
 endif
-endif # NO_BIONIC
 
 ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
 else
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
-  FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
-  ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
-    LIBC_SUPPORT := 1
-  endif
-  ifeq ($(BIONIC),1)
-    LIBC_SUPPORT := 1
-  endif
-  ifeq ($(LIBC_SUPPORT),1)
-    msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
-
-    NO_LIBELF := 1
-    NO_DWARF := 1
-    NO_DEMANGLE := 1
+  ifeq ($(feature-libelf), 0)
+    ifeq ($(feature-glibc), 1)
+      LIBC_SUPPORT := 1
+    endif
+    ifeq ($(BIONIC),1)
+      LIBC_SUPPORT := 1
+    endif
+    ifeq ($(LIBC_SUPPORT),1)
+      msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+  
+      NO_LIBELF := 1
+      NO_DWARF := 1
+      NO_DEMANGLE := 1
+    else
+      msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+    endif
   else
-    msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-  endif
-else
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-  ifdef LIBDW_DIR
-    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-  endif
-
-  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lz -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
-  ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-    msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-    NO_DWARF := 1
-  endif # Dwarf support
-endif # SOURCE_LIBELF
+    # for linking with debug library, run like:
+    # make DEBUG=1 LIBDW_DIR=/opt/libdw/
+    ifdef LIBDW_DIR
+      LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+      LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+    endif
+  
+    ifneq ($(feature-dwarf), 1)
+      msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+      NO_DWARF := 1
+    endif # Dwarf support
+  endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-CFLAGS += -DLIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-  CFLAGS += -DLIBELF_MMAP
-endif
-ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM),y)
-  CFLAGS += -DHAVE_ELF_GETPHDRNUM
-endif
+  CFLAGS += -DHAVE_LIBELF_SUPPORT
+  FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 
-# include ARCH specific config
--include $(src-perf)/arch/$(ARCH)/Makefile
+  ifeq ($(feature-libelf-mmap), 1)
+    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  endif
 
-ifndef NO_DWARF
-ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-  msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-  NO_DWARF := 1
-else
-  CFLAGS += -DDWARF_SUPPORT $(LIBDW_CFLAGS)
-  LDFLAGS += $(LIBDW_LDFLAGS)
-  EXTLIBS += -lelf -ldw
-endif # PERF_HAVE_DWARF_REGS
-endif # NO_DWARF
+  ifeq ($(feature-libelf-getphdrnum), 1)
+    CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
+  endif
+
+  # include ARCH specific config
+  -include $(src-perf)/arch/$(ARCH)/Makefile
 
+  ifndef NO_DWARF
+    ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+      msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+      NO_DWARF := 1
+    else
+      CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+      LDFLAGS += $(LIBDW_LDFLAGS)
+      EXTLIBS += -lelf -ldw
+    endif # PERF_HAVE_DWARF_REGS
+  endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBELF
-CFLAGS += -DLIBELF_SUPPORT
-FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-  CFLAGS += -DLIBELF_MMAP
-endif # try-cc
+  CFLAGS += -DHAVE_LIBELF_SUPPORT
+  ifeq ($(feature-libelf-mmap), 1)
+    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  endif
 endif # NO_LIBELF
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
@@ -214,34 +247,25 @@ ifneq ($(ARCH),x86)
 endif
 
 ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-  LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-  LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+  ifneq ($(feature-libunwind), 1)
+    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+    NO_LIBUNWIND := 1
+  endif
 endif
 
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-  NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
-
 ifndef NO_LIBUNWIND
-  CFLAGS += -DLIBUNWIND_SUPPORT
+  CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
   EXTLIBS += $(LIBUNWIND_LIBS)
   CFLAGS += $(LIBUNWIND_CFLAGS)
   LDFLAGS += $(LIBUNWIND_LDFLAGS)
-endif # NO_LIBUNWIND
+endif
 
 ifndef NO_LIBAUDIT
-  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
-  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+  ifneq ($(feature-libaudit), 1)
     msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
     NO_LIBAUDIT := 1
   else
-    CFLAGS += -DLIBAUDIT_SUPPORT
+    CFLAGS += -DHAVE_LIBAUDIT_SUPPORT
     EXTLIBS += -laudit
   endif
 endif
@@ -251,28 +275,27 @@ ifdef NO_NEWT
 endif
 
 ifndef NO_SLANG
-  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+  ifneq ($(feature-libslang), 1)
     msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
     NO_SLANG := 1
   else
     # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
     CFLAGS += -I/usr/include/slang
-    CFLAGS += -DSLANG_SUPPORT
+    CFLAGS += -DHAVE_SLANG_SUPPORT
     EXTLIBS += -lslang
   endif
 endif
 
 ifndef NO_GTK2
   FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+  ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
-    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-      CFLAGS += -DHAVE_GTK_INFO_BAR
+    ifeq ($(feature-gtk2-infobar), 1)
+      CFLAGS += -DHAVE_GTK_INFO_BAR_SUPPORT
     endif
-    CFLAGS += -DGTK2_SUPPORT
+    CFLAGS += -DHAVE_GTK2_SUPPORT
     CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
   endif
@@ -290,7 +313,7 @@ else
   PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-  ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+  ifneq ($(feature-libperl), 1)
     CFLAGS += -DNO_LIBPERL
     NO_LIBPERL := 1
   else
@@ -335,11 +358,11 @@ else
       PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
       FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
+      ifneq ($(feature-libpython), 1)
         $(call disable-python,Python.h (for Python 2.x))
       else
 
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+        ifneq ($(feature-libpython-version), 1)
           $(warning Python 3 is not yet supported; please set)
           $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
           $(warning If you also have Python 2 installed, then)
@@ -365,13 +388,12 @@ endif
 ifdef NO_DEMANGLE
   CFLAGS += -DNO_DEMANGLE
 else
-  ifdef HAVE_CPLUS_DEMANGLE
+  ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
     EXTLIBS += -liberty
-    CFLAGS += -DHAVE_CPLUS_DEMANGLE
+    CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-    ifeq ($(has_bfd),y)
+    ifeq ($(feature-libbfd), 1)
       EXTLIBS += -lbfd
     else
       FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
@@ -388,7 +410,7 @@ else
           has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
           ifeq ($(has_cplus_demangle),y)
             EXTLIBS += -liberty
-            CFLAGS += -DHAVE_CPLUS_DEMANGLE
+            CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
           else
             msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
             CFLAGS += -DNO_DEMANGLE
@@ -400,30 +422,29 @@ else
 endif
 
 ifndef NO_STRLCPY
-  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
-    CFLAGS += -DHAVE_STRLCPY
+  ifeq ($(feature-strlcpy), 1)
+    CFLAGS += -DHAVE_STRLCPY_SUPPORT
   endif
 endif
 
 ifndef NO_ON_EXIT
-  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
-    CFLAGS += -DHAVE_ON_EXIT
+  ifeq ($(feature-on-exit), 1)
+    CFLAGS += -DHAVE_ON_EXIT_SUPPORT
   endif
 endif
 
 ifndef NO_BACKTRACE
-  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
-    CFLAGS += -DBACKTRACE_SUPPORT
+  ifeq ($(feature-backtrace), 1)
+    CFLAGS += -DHAVE_BACKTRACE_SUPPORT
   endif
 endif
 
 ifndef NO_LIBNUMA
-  FLAGS_LIBNUMA = $(CFLAGS) $(LDFLAGS) -lnuma
-  ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+  ifeq ($(feature-libnuma), 0)
     msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
     NO_LIBNUMA := 1
   else
-    CFLAGS += -DLIBNUMA_SUPPORT
+    CFLAGS += -DHAVE_LIBNUMA_SUPPORT
     EXTLIBS += -lnuma
   endif
 endif
Index: tip/tools/perf/config/feature-checks/Makefile
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/Makefile
@@ -0,0 +1,110 @@
+
+FILES=test-hello test-dwarf test-libelf test-glibc test-bionic test-libnuma test-stackprotector-all test-stackprotector test-volatile-register-var test-fortify-source test-libelf-mmap test-libelf-getphdrnum test-libunwind test-libaudit test-libslang test-gtk2 test-gtk2-infobar test-libperl test-libpython test-libpython-version test-libbfd test-strlcp test-on-exit backtrace
+
+CC := $(CC) -MD
+
+all: $(FILES)
+
+###############################
+
+test-hello: test-hello.c
+	$(CC) -o $@ $@.c
+
+test-stackprotector-all: test-stackprotector-all.c
+	$(CC) -o $@ $@.c -Werror -fstack-protector-all
+
+test-stackprotector: test-stackprotector.c
+	$(CC) -o $@ $@.c -Werror -fstack-protector
+
+test-volatile-register-var: test-volatile-register-var.c
+	$(CC) -o $@ $@.c -Werror -Wvolatile-register-var
+
+test-fortify-source: test-fortify-source.c
+	$(CC) -o $@ $@.c -O2 -Werror -D_FORTIFY_SOURCE=2
+
+test-dwarf: test-dwarf.c
+	$(CC) -o $@ $@.c -ldw
+
+test-libelf: test-libelf.c
+	$(CC) -o $@ $@.c -lelf
+
+test-libelf-mmap: test-libelf-mmap.c
+	$(CC) -o $@ $@.c -lelf
+
+test-libelf-getphdrnum: test-libelf-getphdrnum.c
+	$(CC) -o $@ $@.c -lelf
+
+test-glibc: test-glibc.c
+	$(CC) -o $@ $@.c
+
+test-bionic: test-bionic.c
+	$(CC) -o $@ $@.c
+
+test-libnuma: test-libnuma.c
+	$(CC) -o $@ $@.c -lnuma
+
+test-libunwind: test-libunwind.c
+	$(CC) -o $@ $@.c -lunwind -lunwind-x86_64 -lelf
+
+test-libaudit: test-libaudit.c
+	$(CC) -o $@ $@.c -laudit
+
+test-libslang: test-libslang.c
+	$(CC) -o $@ $@.c -I/usr/include/slang -lslang
+
+test-gtk2: test-gtk2.c
+	$(CC) -o $@ $@.c $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+
+test-gtk2-infobar: test-gtk2-infobar.c
+	$(CC) -o $@ $@.c $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+
+grep-libs  = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+test-libperl: test-libperl.c
+	$(CC) -o $@ $@.c $(FLAGS_PERL_EMBED)
+
+override PYTHON := python
+override PYTHON_CONFIG := python-config
+
+escape-for-shell-sq =  $(subst ','\'',$(1))
+shell-sq = '$(escape-for-shell-sq)'
+
+PYTHON_CONFIG_SQ = $(call shell-sq,$(PYTHON_CONFIG))
+
+PYTHON_EMBED_LDOPTS = $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+test-libpython: test-libpython.c
+	$(CC) -o $@ $@.c $(FLAGS_PYTHON_EMBED)
+
+test-libpython-version: test-libpython-version.c
+	$(CC) -o $@ $@.c $(FLAGS_PYTHON_EMBED)
+
+test-libbfd: test-libbfd.c
+	$(CC) -o $@ $@.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
+test-strlcpy: test-strlcpy.c
+	$(CC) -o $@ $@.c
+
+test-on-exit: test-on-exit.c
+	$(CC) -o $@ $@.c
+
+test-backtrace: test-backtrace.c
+	$(CC) -o $@ $@.c
+
+-include *.d */*.d
+
+###############################
+
+clean:
+	rm -f $(FILES) *.d
Index: tip/tools/perf/config/feature-checks/test-backtrace.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-backtrace.c
@@ -0,0 +1,10 @@
+#include <execinfo.h>
+#include <stdio.h>
+
+int main(void)
+{
+	backtrace(NULL, 0);
+	backtrace_symbols(NULL, 0);
+
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-bionic.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-bionic.c
@@ -0,0 +1,6 @@
+#include <android/api-level.h>
+
+int main(void)
+{
+	return __ANDROID_API__;
+}
Index: tip/tools/perf/config/feature-checks/test-dwarf.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-dwarf.c
@@ -0,0 +1,9 @@
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+
+int main(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+	return (long)dbg;
+}
Index: tip/tools/perf/config/feature-checks/test-fortify-source.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-fortify-source.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
Index: tip/tools/perf/config/feature-checks/test-glibc.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-glibc.c
@@ -0,0 +1,8 @@
+#include <gnu/libc-version.h>
+
+int main(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+
Index: tip/tools/perf/config/feature-checks/test-gtk2-infobar.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-gtk2-infobar.c
@@ -0,0 +1,10 @@
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main(void)
+{
+	gtk_info_bar_new();
+
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-gtk2.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-gtk2.c
@@ -0,0 +1,10 @@
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main(int argc, char *argv[])
+{
+        gtk_init(&argc, &argv);
+
+        return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-hello.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-hello.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
Index: tip/tools/perf/config/feature-checks/test-libaudit.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libaudit.c
@@ -0,0 +1,7 @@
+#include <libaudit.h>
+
+int main(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+	return audit_open();
+}
Index: tip/tools/perf/config/feature-checks/test-libbfd.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libbfd.c
@@ -0,0 +1,7 @@
+#include <bfd.h>
+
+int main(void)
+{
+	bfd_demangle(0, 0, 0);
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+#
+int main(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
Index: tip/tools/perf/config/feature-checks/test-libelf-mmap.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libelf-mmap.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+#
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+	return (long)elf;
+}
Index: tip/tools/perf/config/feature-checks/test-libelf.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libelf.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
Index: tip/tools/perf/config/feature-checks/test-libnuma.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libnuma.c
@@ -0,0 +1,8 @@
+#include <numa.h>
+#include <numaif.h>
+
+int main(void)
+{
+	numa_available();
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-libperl.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libperl.c
@@ -0,0 +1,9 @@
+#include <EXTERN.h>
+#include <perl.h>
+
+int main(void)
+{
+	perl_alloc();
+
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-libpython-version.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libpython-version.c
@@ -0,0 +1,10 @@
+#include <Python.h>
+
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+
+int main(void)
+{
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-libpython.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libpython.c
@@ -0,0 +1,7 @@
+#include <Python.h>
+#
+int main(void)
+{
+	Py_Initialize();
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-libslang.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libslang.c
@@ -0,0 +1,6 @@
+#include <slang.h>
+
+int main(void)
+{
+	return SLsmg_init_smg();
+}
Index: tip/tools/perf/config/feature-checks/test-libunwind.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-libunwind.c
@@ -0,0 +1,20 @@
+#include <libunwind.h>
+#include <stdlib.h>
+
+extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+                                      unw_word_t ip,
+                                      unw_dyn_info_t *di,
+                                      unw_proc_info_t *pi,
+                                      int need_unwind_info, void *arg);
+
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+int main(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-on-exit.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-on-exit.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return on_exit(NULL, NULL);
+}
Index: tip/tools/perf/config/feature-checks/test-stackprotector-all.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-stackprotector-all.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
Index: tip/tools/perf/config/feature-checks/test-stackprotector.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-stackprotector.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
Index: tip/tools/perf/config/feature-checks/test-strlcpy.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-strlcpy.c
@@ -0,0 +1,8 @@
+#include <stdlib.h>
+extern size_t strlcpy(char *dest, const char *src, size_t size);
+
+int main(void)
+{
+	strlcpy(NULL, NULL, 0);
+	return 0;
+}
Index: tip/tools/perf/config/feature-checks/test-volatile-register-var.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-volatile-register-var.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
Index: tip/tools/perf/perf.c
===================================================================
--- tip.orig/tools/perf/perf.c
+++ tip/tools/perf/perf.c
@@ -49,14 +49,14 @@ static struct cmd_struct commands[] = {
 	{ "version",	cmd_version,	0 },
 	{ "script",	cmd_script,	0 },
 	{ "sched",	cmd_sched,	0 },
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 	{ "probe",	cmd_probe,	0 },
 #endif
 	{ "kmem",	cmd_kmem,	0 },
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
 	{ "test",	cmd_test,	0 },
-#ifdef LIBAUDIT_SUPPORT
+#ifdef HAVE_LIBAUDIT_SUPPORT
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
Index: tip/tools/perf/ui/gtk/browser.c
===================================================================
--- tip.orig/tools/perf/ui/gtk/browser.c
+++ tip/tools/perf/ui/gtk/browser.c
@@ -43,7 +43,7 @@ const char *perf_gtk__get_percent_color(
 	return NULL;
 }
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 GtkWidget *perf_gtk__setup_info_bar(void)
 {
 	GtkWidget *info_bar;
Index: tip/tools/perf/ui/gtk/gtk.h
===================================================================
--- tip.orig/tools/perf/ui/gtk/gtk.h
+++ tip/tools/perf/ui/gtk/gtk.h
@@ -12,7 +12,7 @@ struct perf_gtk_context {
 	GtkWidget *main_window;
 	GtkWidget *notebook;
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 	GtkWidget *info_bar;
 	GtkWidget *message_label;
 #endif
@@ -39,7 +39,7 @@ void perf_gtk__resize_window(GtkWidget *
 const char *perf_gtk__get_percent_color(double percent);
 GtkWidget *perf_gtk__setup_statusbar(void);
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 GtkWidget *perf_gtk__setup_info_bar(void);
 #else
 static inline GtkWidget *perf_gtk__setup_info_bar(void)
Index: tip/tools/perf/ui/gtk/util.c
===================================================================
--- tip.orig/tools/perf/ui/gtk/util.c
+++ tip/tools/perf/ui/gtk/util.c
@@ -53,7 +53,7 @@ static int perf_gtk__error(const char *f
 	return 0;
 }
 
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 static int perf_gtk__warning_info_bar(const char *format, va_list args)
 {
 	char *msg;
@@ -105,7 +105,7 @@ static int perf_gtk__warning_statusbar(c
 
 struct perf_error_ops perf_gtk_eops = {
 	.error		= perf_gtk__error,
-#ifdef HAVE_GTK_INFO_BAR
+#ifdef HAVE_GTK_INFO_BAR_SUPPORT
 	.warning	= perf_gtk__warning_info_bar,
 #else
 	.warning	= perf_gtk__warning_statusbar,
Index: tip/tools/perf/ui/ui.h
===================================================================
--- tip.orig/tools/perf/ui/ui.h
+++ tip/tools/perf/ui/ui.h
@@ -12,7 +12,7 @@ extern int use_browser;
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef SLANG_SUPPORT
+#ifdef HAVE_SLANG_SUPPORT
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #else
@@ -23,7 +23,7 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef HAVE_GTK2_SUPPORT
 int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
 #else
Index: tip/tools/perf/util/annotate.h
===================================================================
--- tip.orig/tools/perf/util/annotate.h
+++ tip/tools/perf/util/annotate.h
@@ -150,7 +150,7 @@ int symbol__tty_annotate(struct symbol *
 			 struct perf_evsel *evsel, bool print_lines,
 			 bool full_paths, int min_pcnt, int max_lines);
 
-#ifdef SLANG_SUPPORT
+#ifdef HAVE_SLANG_SUPPORT
 int symbol__tui_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
@@ -165,7 +165,7 @@ static inline int symbol__tui_annotate(s
 }
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef HAVE_GTK2_SUPPORT
 int symbol__gtk_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
Index: tip/tools/perf/util/cache.h
===================================================================
--- tip.orig/tools/perf/util/cache.h
+++ tip/tools/perf/util/cache.h
@@ -70,7 +70,7 @@ extern char *perf_path(const char *fmt,
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
-#ifndef HAVE_STRLCPY
+#ifndef HAVE_STRLCPY_SUPPORT
 extern size_t strlcpy(char *dest, const char *src, size_t size);
 #endif
 
Index: tip/tools/perf/util/generate-cmdlist.sh
===================================================================
--- tip.orig/tools/perf/util/generate-cmdlist.sh
+++ tip/tools/perf/util/generate-cmdlist.sh
@@ -22,7 +22,7 @@ do
      }' "Documentation/perf-$cmd.txt"
 done
 
-echo "#ifdef LIBELF_SUPPORT"
+echo "#ifdef HAVE_LIBELF_SUPPORT"
 sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
@@ -35,5 +35,5 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
-echo "#endif /* LIBELF_SUPPORT */"
+echo "#endif /* HAVE_LIBELF_SUPPORT */"
 echo "};"
Index: tip/tools/perf/util/hist.h
===================================================================
--- tip.orig/tools/perf/util/hist.h
+++ tip/tools/perf/util/hist.h
@@ -183,7 +183,7 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef SLANG_SUPPORT
+#ifdef HAVE_SLANG_SUPPORT
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
@@ -224,7 +224,7 @@ static inline int script_browse(const ch
 #define K_SWITCH_INPUT_DATA -3000
 #endif
 
-#ifdef GTK2_SUPPORT
+#ifdef HAVE_GTK2_SUPPORT
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt __maybe_unused,
 				  float min_pcnt);
Index: tip/tools/perf/util/include/dwarf-regs.h
===================================================================
--- tip.orig/tools/perf/util/include/dwarf-regs.h
+++ tip/tools/perf/util/include/dwarf-regs.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_DWARF_REGS_H_
 #define _PERF_DWARF_REGS_H_
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 const char *get_arch_regstr(unsigned int n);
 #endif
 
Index: tip/tools/perf/util/map.c
===================================================================
--- tip.orig/tools/perf/util/map.c
+++ tip/tools/perf/util/map.c
@@ -172,7 +172,7 @@ int map__load(struct map *map, symbol_fi
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
Index: tip/tools/perf/util/path.c
===================================================================
--- tip.orig/tools/perf/util/path.c
+++ tip/tools/perf/util/path.c
@@ -22,7 +22,7 @@ static const char *get_perf_dir(void)
 	return ".";
 }
 
-#ifndef HAVE_STRLCPY
+#ifndef HAVE_STRLCPY_SUPPORT
 size_t strlcpy(char *dest, const char *src, size_t size)
 {
 	size_t ret = strlen(src);
Index: tip/tools/perf/util/perf_regs.h
===================================================================
--- tip.orig/tools/perf/util/perf_regs.h
+++ tip/tools/perf/util/perf_regs.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
-#ifdef HAVE_PERF_REGS
+#ifdef HAVE_PERF_REGS_SUPPORT
 #include <perf_regs.h>
 #else
 #define PERF_REGS_MASK	0
@@ -10,5 +10,5 @@ static inline const char *perf_reg_name(
 {
 	return NULL;
 }
-#endif /* HAVE_PERF_REGS */
+#endif /* HAVE_PERF_REGS_SUPPORT */
 #endif /* __PERF_REGS_H */
Index: tip/tools/perf/util/probe-event.c
===================================================================
--- tip.orig/tools/perf/util/probe-event.c
+++ tip/tools/perf/util/probe-event.c
@@ -201,7 +201,7 @@ static int convert_to_perf_probe_point(s
 	return 0;
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
@@ -630,7 +630,7 @@ int show_available_vars(struct perf_prob
 	return ret;
 }
 
-#else	/* !DWARF_SUPPORT */
+#else	/* !HAVE_DWARF_SUPPORT */
 
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
Index: tip/tools/perf/util/probe-finder.h
===================================================================
--- tip.orig/tools/perf/util/probe-finder.h
+++ tip/tools/perf/util/probe-finder.h
@@ -14,7 +14,7 @@ static inline int is_c_varname(const cha
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-#ifdef DWARF_SUPPORT
+#ifdef HAVE_DWARF_SUPPORT
 
 #include "dwarf-aux.h"
 
@@ -105,6 +105,6 @@ struct line_finder {
 	int			found;
 };
 
-#endif /* DWARF_SUPPORT */
+#endif /* HAVE_DWARF_SUPPORT */
 
 #endif /*_PROBE_FINDER_H */
Index: tip/tools/perf/util/symbol-elf.c
===================================================================
--- tip.orig/tools/perf/util/symbol-elf.c
+++ tip/tools/perf/util/symbol-elf.c
@@ -8,7 +8,7 @@
 #include "symbol.h"
 #include "debug.h"
 
-#ifndef HAVE_ELF_GETPHDRNUM
+#ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
 static int elf_getphdrnum(Elf *elf, size_t *dst)
 {
 	GElf_Ehdr gehdr;
Index: tip/tools/perf/util/symbol.h
===================================================================
--- tip.orig/tools/perf/util/symbol.h
+++ tip/tools/perf/util/symbol.h
@@ -13,7 +13,7 @@
 #include <libgen.h>
 #include "build-id.h"
 
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
 #endif
@@ -21,7 +21,7 @@
 
 #include "dso.h"
 
-#ifdef HAVE_CPLUS_DEMANGLE
+#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
 extern char *cplus_demangle(const char *, int);
 
 static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
@@ -46,7 +46,7 @@ static inline char *bfd_demangle(void __
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
  */
-#ifdef LIBELF_MMAP
+#ifdef HAVE_LIBELF_MMAP_SUPPORT
 # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
 #else
 # define PERF_ELF_C_READ_MMAP ELF_C_READ
@@ -178,7 +178,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifdef LIBELF_SUPPORT
+#ifdef HAVE_LIBELF_SUPPORT
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
Index: tip/tools/perf/util/unwind.h
===================================================================
--- tip.orig/tools/perf/util/unwind.h
+++ tip/tools/perf/util/unwind.h
@@ -13,7 +13,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef HAVE_LIBUNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -31,5 +31,5 @@ unwind__get_entries(unwind_entry_cb_t cb
 {
 	return 0;
 }
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* HAVE_LIBUNWIND_SUPPORT */
 #endif /* __UNWIND_H */
Index: tip/tools/perf/util/util.c
===================================================================
--- tip.orig/tools/perf/util/util.c
+++ tip/tools/perf/util/util.c
@@ -1,7 +1,7 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
-#ifdef BACKTRACE_SUPPORT
+#ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -204,7 +204,7 @@ int hex2u64(const char *ptr, u64 *long_v
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifdef BACKTRACE_SUPPORT
+#ifdef HAVE_BACKTRACE_SUPPORT
 void dump_stack(void)
 {
 	void *array[16];
