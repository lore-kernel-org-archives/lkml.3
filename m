Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbbABPhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:37:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbbABPhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:37:17 -0500
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
Subject: [PATCH 01/30] perf tools: Add new build framework support
Date: Fri,  2 Jan 2015 16:35:43 +0100
Message-Id: <1420212972-21595-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new build framework. There's no change for actual
building at this point, it comes in the next patches.

The idea and more details are explained in the
'Documentation/Build' file.

I stole everything from the kernel build system, with some
changes to allow for multiple binaries build definitions.

While the kernel's build output is single image (forget modules)
we need to be able to build several binaries/libraries.

The basic idea is that sser provides 'Build' files with objects
definitions like:
  perf-y += a.o
  perf-y += b.o
  libperf-y += c.o
  libperf-y += d.o

and the build framework outputs files:
  perf-in.o    # a.o, b.o compiled in
  libperf-in.o # c.o, d.o compiled in

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
 tools/perf/Build               |   0
 tools/perf/Build.include       |  73 ++++++++++++++++++++++++
 tools/perf/Documentation/Build | 123 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/Makefile.build      |  89 +++++++++++++++++++++++++++++
 tools/perf/Makefile.perf       |  14 ++++-
 5 files changed, 298 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/Build
 create mode 100644 tools/perf/Build.include
 create mode 100644 tools/perf/Documentation/Build
 create mode 100644 tools/perf/Makefile.build

diff --git a/tools/perf/Build b/tools/perf/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/perf/Build.include b/tools/perf/Build.include
new file mode 100644
index 000000000000..5947f8a5a6b1
--- /dev/null
+++ b/tools/perf/Build.include
@@ -0,0 +1,73 @@
+###
+# build: Generic definitions
+
+###
+# Convenient variables
+comma   := ,
+squote  := '
+
+###
+# Name of target with a '.' as filename prefix. foo/bar.o => foo/.bar.o
+dot-target = $(dir $@).$(notdir $@)
+
+###
+# filename of target with directory and extension stripped
+basetarget = $(basename $(notdir $@))
+
+###
+# The temporary file to save gcc -MD generated dependencies must not
+# contain a comma
+depfile = $(subst $(comma),_,$(dot-target).d)
+
+###
+# Check if both arguments has same arguments. Result is empty string if equal.
+arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
+                    $(filter-out $(cmd_$@),   $(cmd_$(1))) )
+
+###
+# Escape single quote for use in echo statements
+escsq = $(subst $(squote),'\$(squote)',$1)
+
+# Echo command
+# Short version is used, if $(quiet) equals `quiet_', otherwise full one.
+echo-cmd = $(if $($(quiet)cmd_$(1)),\
+           echo '  $(call escsq,$($(quiet)cmd_$(1)))';)
+
+###
+# Replace >$< with >$$< to preserve $ when reloading the .cmd file
+# (needed for make)
+# Replace >#< with >\#< to avoid starting a comment in the .cmd file
+# (needed for make)
+# Replace >'< with >'\''< to be able to enclose the whole string in '...'
+# (needed for the shell)
+make-cmd = $(call escsq,$(subst \#,\\\#,$(subst $$,$$$$,$(cmd_$(1)))))
+
+###
+# Find any prerequisites that is newer than target or that does not exist.
+# PHONY targets skipped in both cases.
+any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
+
+###
+# if_changed_dep  - execute command if any prerequisite is newer than
+#                   target, or command line has changed and update
+#                   dependencies in the cmd file
+if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),         \
+	@set -e;                                                   \
+	$(echo-cmd) $(cmd_$(1));                                   \
+	cat $(depfile) > $(dot-target).cmd;                        \
+	printf '%s\n' 'cmd_$@ := $(make-cmd)' >> $(dot-target).cmd)
+
+###
+# if_changed      - execute command if any prerequisite is newer than
+#                   target, or command line has changed
+if_changed = $(if $(strip $(any-prereq) $(arg-check)),             \
+	@set -e;                                                   \
+	$(echo-cmd) $(cmd_$(1));                                   \
+	printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
+
+###
+# C flags to be used in rule definitions, includes:
+# - depfile generation
+# - global $(CFLAGS)
+# - per target C flags
+c_flags = -Wp,-MD,$(depfile),-MT,$@ $(CFLAGS) $(CFLAGS_$(basetarget).o)
diff --git a/tools/perf/Documentation/Build b/tools/perf/Documentation/Build
new file mode 100644
index 000000000000..7008520600eb
--- /dev/null
+++ b/tools/perf/Documentation/Build
@@ -0,0 +1,123 @@
+
+1) perf build
+=============
+The perf build process consists of several separated building blocks,
+which are linked together to form the perf binary:
+  - libperf library (static)
+  - perf builtin commands
+  - traceevent library (static)
+  - GTK ui library
+
+Several makefiles govern the perf build:
+
+  - Makefile
+    top level Makefile working as a wrapper that calls the main
+    Makefile.perf with a -j option to do parallel builds.
+
+  - Makefile.perf
+    main makefile that triggers build of all perf objects including
+    installation and documentation processing.
+
+  - Makefile.build
+    main makefile of the build framework
+
+  - Build.include
+    build framework generic definitions
+
+  - Build makefiles
+    makefiles that defines build objects
+
+
+2) build framework
+==================
+The perf build framework is stolen from kernel build system,
+so the idea and the way how objects are built is the same.
+
+
+a) Build makefiles
+------------------
+User supplies 'Build' makefiles that contains objects summary,
+like for example following 'krava/Build' file:
+
+  perf-y += a.o
+  perf-y += b.o
+
+The build framework is triggered by:
+  $ make -f Makefile.build dir=krava obj=perf
+
+which produces 'krava/perf-in.o' object file that has both
+a.o and b.o objects compiled in linked together.
+
+The 'Build' makefile can contains multiple objects definitions
+to allow building separated binaries, like:
+
+  perf-y += a.o
+  perf-y += b.o
+
+  libperf-y += c.o
+  libperf-y += d.o
+
+If the build framework is triggered by:
+  $ make -f Makefile.build dir=krava obj=libperf
+
+it produces 'krava/libperf-in.o' object file that has both
+a.o and b.o objects compiled in linked together.
+
+
+b) rules
+--------
+The build framework provides standard compilation rules
+to handle .S and .c compilation.
+
+It's possible to include special rule if needed (like we
+do for flex or bison code generation).
+
+
+c) cflags
+---------
+It's possible to alter standard object C flags in following way:
+  CFLAGS_perf.o += '...' - alters CFLAGS for perf.o object
+  CFLAGS_gtk += '...'    - alters CFLAGS for gtk build object
+
+This C flags changes has the scope of the Build makefile they
+are defined in.
+
+
+d) dependencies
+---------------
+For each built object file 'a.o' the '.a.cmd' is created and
+holds:
+  - command line used to built that object
+    (for each object)
+  - dependency rules generated by 'gcc -Wp,-MD,...'
+    (for compiled object)
+
+All existing '.cmd' files are included in the Build process
+to follow properly the dependencies and trigger rebuild when
+necessary.
+
+e) single rules
+---------------
+It's possible to build single object file by choice, like:
+
+  $ make util/map.o    # objects
+  $ make util/map.i    # preprocessor
+  $ make util/map.s    # assembly
+
+
+3) perf build
+=============
+The Makefile.perf triggers the build framework for build objects:
+   perf, libperf, gtk
+
+resulting in following objects:
+  $ ls  *-in.o
+  gtk-in.o  libperf-in.o  perf-in.o
+
+Those objects are then used in final linking:
+  libperf-gtk.so <- gtk-in.o  libperf-in.o
+  perf           <- perf-in.o libperf-in.o
+
+
+NOTE omitting other libraries involved, only focusing on build
+     framework outcomes
diff --git a/tools/perf/Makefile.build b/tools/perf/Makefile.build
new file mode 100644
index 000000000000..123de33e163d
--- /dev/null
+++ b/tools/perf/Makefile.build
@@ -0,0 +1,89 @@
+###
+# This code is stolen from kernel kbuild system. I haven't
+# found any copyright message in kbuild code to give credits
+# to in here so.. just wanted to say thanks ;-)
+
+PHONY := __build
+__build:
+
+ifeq ($(V),1)
+  quiet =
+else
+  quiet=quiet_
+endif
+
+# Generic definitions
+include Build.include
+
+# Init all relevant variables used in build files so
+# 1) they have correct type
+# 2) they do not inherit any value from the environment
+subdir-y     :=
+obj-y        :=
+subdir-y     :=
+subdir-obj-y :=
+
+# Build definitions
+build-file := $(dir)/Build
+include $(build-file)
+
+# Compile command
+quiet_cmd_cc_o_c = CC       $@
+      cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
+
+# Link agregate command
+quiet_cmd_ld_multi = LD       $@
+      cmd_ld_multi = $(LD) -r -o $@ $^
+
+# Build rules
+$(OUTPUT)%.o: %.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)%.o: %.S FORCE
+	$(call if_changed_dep,cc_o_c)
+
+# Gather build data:
+#   obj-y        - list of build objects
+#   subdir-y     - list of directories to nest
+#   subdir-obj-y - list of directories objects 'dir/$(obj)-in.o'
+obj-y        := $($(obj)-y)
+subdir-y     := $(patsubst %/,%,$(filter %/, $(obj-y)))
+obj-y        := $(patsubst %/, %/$(obj)-in.o, $(obj-y))
+subdir-obj-y := $(filter %/$(obj)-in.o, $(obj-y))
+
+# '$(OUTPUT)/dir' prefix to all objects
+prefix       := $(subst ./,,$(OUTPUT)$(dir)/)
+obj-y        := $(addprefix $(prefix),$(obj-y))
+subdir-obj-y := $(addprefix $(prefix),$(subdir-obj-y))
+
+# Final '$(obj)-in.o' object
+ifneq ($(strip $(obj-y)),)
+  in-target := $(prefix)$(obj)-in.o
+endif
+
+PHONY += $(subdir-y)
+
+$(subdir-y):
+	@$(MAKE) -f Makefile.build dir=$(dir)/$@ obj=$(obj)
+
+$(sort $(subdir-obj-y)): $(subdir-y) ;
+
+$(in-target): $(obj-y)
+	$(call if_changed,ld_multi)
+
+__build: $(in-target)
+	@:
+
+PHONY += FORCE
+FORCE:
+
+# Include all cmd files to get all the dependency rules
+# for all objects included
+targets   := $(wildcard $(sort $(obj-y)))
+cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
+
+ifneq ($(cmd_files),)
+  include $(cmd_files)
+endif
+
+.PHONY: $(PHONY)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 67a03a825b3c..54edd4ac9409 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -89,6 +89,7 @@ $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 	@touch $(OUTPUT)PERF-VERSION-FILE
 
 CC = $(CROSS_COMPILE)gcc
+LD = $(CROSS_COMPILE)ld
 AR = $(CROSS_COMPILE)ar
 PKG_CONFIG = $(CROSS_COMPILE)pkg-config
 
@@ -619,6 +620,14 @@ shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
 strip: $(PROGRAMS) $(OUTPUT)perf
 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
 
+PERF_IN := $(OUTPUT)perf-in.o
+
+export OUTPUT RM CC LD CFLAGS V
+build := -f Makefile.build dir=. obj
+
+$(PERF_IN): FORCE
+	@$(MAKE) $(build)=perf
+
 $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
@@ -978,6 +987,7 @@ config-clean:
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	@find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o | xargs $(RM)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
@@ -993,7 +1003,9 @@ else
     GIT-HEAD-PHONY =
 endif
 
+FORCE:
+
 .PHONY: all install clean config-clean strip install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS FORCE
 
-- 
1.9.3

