Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaEAGew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:34:52 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54391 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEAGev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:34:51 -0400
Date: Thu, 1 May 2014 08:34:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140501063442.GA21161@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 399f0c220a0ee97a5a9ea1a699a58fe2aacf2983 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/urgent

Mostly tooling fixes, plus an Intel RAPL PMU driver fix.

 Thanks,

	Ingo

------------------>
Jiri Olsa (5):
      perf tools: Disable libdw unwind for all but x86 arch
      perf tools: Use LDFLAGS instead of ALL_LDFLAGS
      perf tools: Fix bfd dependency libraries detection
      perf tests: Add static build make test
      perf tests x86: Fix stack map lookup in dwarf unwind test

Masanari Iida (1):
      perf tests x86: Fix memory leak in sample_ustack()

Mathias Krause (1):
      perf x86: Fix perf to use non-executable stack, again

Richard Yao (1):
      perf machine: Search for modules in %s/lib/modules/%s

Stephane Eranian (1):
      perf/x86: Fix RAPL rdmsrl_safe() usage

Steven Rostedt (2):
      tools lib traceevent: Fix backward compatibility macros for pevent filter enums
      tools lib traceevent: Fix memory leak in pretty_print()

Xia Kaixu (1):
      perf tools: Remove extra '/' character in events file path


 arch/x86/kernel/cpu/perf_event_intel_rapl.c |  3 +-
 tools/lib/api/fs/debugfs.c                  |  4 +--
 tools/lib/traceevent/event-parse.c          |  1 +
 tools/lib/traceevent/event-parse.h          |  4 +--
 tools/perf/Makefile.perf                    |  2 +-
 tools/perf/arch/x86/tests/dwarf-unwind.c    |  3 +-
 tools/perf/arch/x86/tests/regs_load.S       |  8 ++++-
 tools/perf/config/Makefile                  | 46 ++++++++++++++++++++++-------
 tools/perf/tests/make                       |  2 ++
 tools/perf/util/machine.c                   | 16 +++++++---
 10 files changed, 66 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 7c87424..619f769 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -543,7 +543,8 @@ static int rapl_cpu_prepare(int cpu)
 	if (phys_id < 0)
 		return -1;
 
-	if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
+	/* protect rdmsrl() to handle virtualization */
+	if (rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
 		return -1;
 
 	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index 7c43479..a74fba6 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -12,8 +12,8 @@
 char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
 
 static const char * const debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug/",
-	"/debug/",
+	"/sys/kernel/debug",
+	"/debug",
 	0,
 };
 
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index baec7d8..b83184f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4344,6 +4344,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 					      format, len_arg, arg);
 				trace_seq_terminate(&p);
 				trace_seq_puts(s, p.buffer);
+				trace_seq_destroy(&p);
 				arg = arg->next;
 				break;
 			default:
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 791c539..feab942 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -876,8 +876,8 @@ struct event_filter {
 struct event_filter *pevent_filter_alloc(struct pevent *pevent);
 
 /* for backward compatibility */
-#define FILTER_NONE		PEVENT_ERRNO__FILTER_NOT_FOUND
-#define FILTER_NOEXIST		PEVENT_ERRNO__NO_FILTER
+#define FILTER_NONE		PEVENT_ERRNO__NO_FILTER
+#define FILTER_NOEXIST		PEVENT_ERRNO__FILTER_NOT_FOUND
 #define FILTER_MISS		PEVENT_ERRNO__FILTER_MISS
 #define FILTER_MATCH		PEVENT_ERRNO__FILTER_MATCH
 
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e969233..895edd3 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -589,7 +589,7 @@ $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
 	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
 
 $(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) -o $@ -shared $(ALL_LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
+	$(QUIET_LINK)$(CC) -o $@ -shared $(LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index b602ad9..83bc238 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -23,9 +23,10 @@ static int sample_ustack(struct perf_sample *sample,
 
 	sp = (unsigned long) regs[PERF_REG_X86_SP];
 
-	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
+	map = map_groups__find(&thread->mg, MAP__VARIABLE, (u64) sp);
 	if (!map) {
 		pr_debug("failed to get stack map\n");
+		free(buf);
 		return -1;
 	}
 
diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
index 99167bf..60875d5 100644
--- a/tools/perf/arch/x86/tests/regs_load.S
+++ b/tools/perf/arch/x86/tests/regs_load.S
@@ -1,4 +1,3 @@
-
 #include <linux/linkage.h>
 
 #define AX	 0
@@ -90,3 +89,10 @@ ENTRY(perf_regs_load)
 	ret
 ENDPROC(perf_regs_load)
 #endif
+
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index ee21fa9..802cf54 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -34,6 +34,14 @@ ifeq ($(ARCH),arm)
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
+# So far there's only x86 libdw unwind support merged in perf.
+# Disable it on all other architectures in case libdw unwind
+# support is detected in system. Add supported architectures
+# to the check.
+ifneq ($(ARCH),x86)
+  NO_LIBDW_DWARF_UNWIND := 1
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
@@ -109,6 +117,10 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
+# Enforce a non-executable stack, as we may regress (again) in the future by
+# adding assembler files missing the .GNU-stack linker note.
+LDFLAGS += -Wl,-z,noexecstack
+
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifneq ($(OUTPUT),)
@@ -186,7 +198,10 @@ VF_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd				\
 	libunwind-debug-frame		\
-	bionic
+	bionic				\
+	liberty				\
+	liberty-z			\
+	cplus-demangle
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -504,7 +519,21 @@ else
 endif
 
 ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd -lz -liberty
+  EXTLIBS += -lbfd
+
+  # call all detections now so we get correct
+  # status in VF output
+  $(call feature_check,liberty)
+  $(call feature_check,liberty-z)
+  $(call feature_check,cplus-demangle)
+
+  ifeq ($(feature-liberty), 1)
+    EXTLIBS += -liberty
+  else
+    ifeq ($(feature-liberty-z), 1)
+      EXTLIBS += -liberty -lz
+    endif
+  endif
 endif
 
 ifdef NO_DEMANGLE
@@ -515,15 +544,10 @@ else
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
     ifneq ($(feature-libbfd), 1)
-      $(call feature_check,liberty)
-      ifeq ($(feature-liberty), 1)
-        EXTLIBS += -lbfd -liberty
-      else
-        $(call feature_check,liberty-z)
-        ifeq ($(feature-liberty-z), 1)
-          EXTLIBS += -lbfd -liberty -lz
-        else
-          $(call feature_check,cplus-demangle)
+      ifneq ($(feature-liberty), 1)
+        ifneq ($(feature-liberty-z), 1)
+          # we dont have neither HAVE_CPLUS_DEMANGLE_SUPPORT
+          # or any of 'bfd iberty z' trinity
           ifeq ($(feature-cplus-demangle), 1)
             EXTLIBS += -liberty
             CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 5daeae1..2f92d6e 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -46,6 +46,7 @@ make_install_man    := install-man
 make_install_html   := install-html
 make_install_info   := install-info
 make_install_pdf    := install-pdf
+make_static         := LDFLAGS=-static
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
@@ -87,6 +88,7 @@ run += make_install_bin
 # run += make_install_info
 # run += make_install_pdf
 run += make_minimal
+run += make_static
 
 ifneq ($(call has,ctags),)
 run += make_tags
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a53cd0b..27c2a5e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -717,7 +717,7 @@ static char *get_kernel_version(const char *root_dir)
 }
 
 static int map_groups__set_modules_path_dir(struct map_groups *mg,
-				const char *dir_name)
+				const char *dir_name, int depth)
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dir_name);
@@ -742,7 +742,15 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 			    !strcmp(dent->d_name, ".."))
 				continue;
 
-			ret = map_groups__set_modules_path_dir(mg, path);
+			/* Do not follow top-level source and build symlinks */
+			if (depth == 0) {
+				if (!strcmp(dent->d_name, "source") ||
+				    !strcmp(dent->d_name, "build"))
+					continue;
+			}
+
+			ret = map_groups__set_modules_path_dir(mg, path,
+							       depth + 1);
 			if (ret < 0)
 				goto out;
 		} else {
@@ -786,11 +794,11 @@ static int machine__set_modules_path(struct machine *machine)
 	if (!version)
 		return -1;
 
-	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
+	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s",
 		 machine->root_dir, version);
 	free(version);
 
-	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
+	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
 }
 
 static int machine__create_module(void *arg, const char *name, u64 start)
