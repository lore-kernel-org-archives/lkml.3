Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbbAONQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:16:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbbAOM4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:56:35 -0500
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
Subject: [PATCH 01/36] tools build: Add new build support
Date: Thu, 15 Jan 2015 13:54:57 +0100
Message-Id: <1421326532-25660-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new build framework into 'tools/build' to be used
by tools.

There's no change for actual building at this point, it comes
in the next patches.

The idea and more details are explained in the
'tools/build/Documentation/Build' file.

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
 tools/build/Build.include           | 75 ++++++++++++++++++++++++++++++
 tools/build/Documentation/Build.txt | 75 ++++++++++++++++++++++++++++++
 tools/build/Makefile.build          | 91 +++++++++++++++++++++++++++++++++++++
 tools/perf/MANIFEST                 |  1 +
 4 files changed, 242 insertions(+)
 create mode 100644 tools/build/Build.include
 create mode 100644 tools/build/Documentation/Build.txt
 create mode 100644 tools/build/Makefile.build

diff --git a/tools/build/Build.include b/tools/build/Build.include
new file mode 100644
index 000000000000..6a990b018e6d
--- /dev/null
+++ b/tools/build/Build.include
@@ -0,0 +1,75 @@
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
+# - per object C flags
+# - BUILD_STR macro to allow '-D"$(variable)"' constructs
+c_flags = -Wp,-MD,$(depfile),-MT,$@ $(CFLAGS) -D"BUILD_STR(s)=\#s" $(CFLAGS_$(basetarget).o) $(CFLAGS_$(obj))
diff --git a/tools/build/Documentation/Build.txt b/tools/build/Documentation/Build.txt
new file mode 100644
index 000000000000..8a11facc1838
--- /dev/null
+++ b/tools/build/Documentation/Build.txt
@@ -0,0 +1,75 @@
+build framework
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
diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
new file mode 100644
index 000000000000..afd2266e0935
--- /dev/null
+++ b/tools/build/Makefile.build
@@ -0,0 +1,91 @@
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
+build-dir := $(srctree)/tools/build
+
+# Generic definitions
+include $(build-dir)/Build.include
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
+	@$(MAKE) -f $(build-dir)/Makefile.build dir=$(dir)/$@ obj=$(obj)
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
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 83e2887f91a3..6702c9f57fd6 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,5 +1,6 @@
 tools/perf
 tools/scripts
+tools/build
 tools/lib/traceevent
 tools/lib/api
 tools/lib/symbol/kallsyms.c
-- 
1.9.3

