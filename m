Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbbATQkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:40:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbATQke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:40:34 -0500
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
Date: Tue, 20 Jan 2015 17:38:58 +0100
Message-Id: <1421771973-6022-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new build framework into 'tools/build' to be used
by tools.

There's no change for actual building at this point, it comes
in the next patches.

The idea and more details are explained in the
'tools/build/Documentation/Build.txt' file.

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
 tools/build/Build.include           |  74 ++++++++++++++++++++
 tools/build/Documentation/Build.txt | 132 ++++++++++++++++++++++++++++++++++++
 tools/build/Makefile.build          |  92 +++++++++++++++++++++++++
 tools/build/tests/ex/Build          |   8 +++
 tools/build/tests/ex/Makefile       |  23 +++++++
 tools/build/tests/ex/a.c            |   5 ++
 tools/build/tests/ex/arch/Build     |   2 +
 tools/build/tests/ex/arch/e.c       |   5 ++
 tools/build/tests/ex/arch/f.c       |   5 ++
 tools/build/tests/ex/b.c            |   5 ++
 tools/build/tests/ex/c.c            |   5 ++
 tools/build/tests/ex/d.c            |   5 ++
 tools/build/tests/ex/empty/Build    |   0
 tools/build/tests/ex/ex.c           |  19 ++++++
 tools/build/tests/run.sh            |  42 ++++++++++++
 tools/perf/MANIFEST                 |   1 +
 16 files changed, 423 insertions(+)
 create mode 100644 tools/build/Build.include
 create mode 100644 tools/build/Documentation/Build.txt
 create mode 100644 tools/build/Makefile.build
 create mode 100644 tools/build/tests/ex/Build
 create mode 100644 tools/build/tests/ex/Makefile
 create mode 100644 tools/build/tests/ex/a.c
 create mode 100644 tools/build/tests/ex/arch/Build
 create mode 100644 tools/build/tests/ex/arch/e.c
 create mode 100644 tools/build/tests/ex/arch/f.c
 create mode 100644 tools/build/tests/ex/b.c
 create mode 100644 tools/build/tests/ex/c.c
 create mode 100644 tools/build/tests/ex/d.c
 create mode 100644 tools/build/tests/ex/empty/Build
 create mode 100644 tools/build/tests/ex/ex.c
 create mode 100755 tools/build/tests/run.sh

diff --git a/tools/build/Build.include b/tools/build/Build.include
new file mode 100644
index 000000000000..976dd44f1074
--- /dev/null
+++ b/tools/build/Build.include
@@ -0,0 +1,74 @@
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
index 000000000000..2de0533f8980
--- /dev/null
+++ b/tools/build/Documentation/Build.txt
@@ -0,0 +1,132 @@
+build framework
+===============
+The perf build framework is stolen from kernel build system,
+hence the idea and the way how objects are built is the same.
+
+Basically user provides set of 'Build' files that list objects
+and directories to nest for specific target to be build.
+
+Unlike kernel we don't have single build object 'obj-y' list that
+we setup source objects, but we support more. This allows one
+'Build' file to carry sources list for multiple build objects.
+
+
+a) build framework makefiles
+----------------------------
+The build framework consists of 2 Makefiles:
+  Build.include
+  Makefile.build
+
+While 'Build.include' contains just some generic definitions,
+the 'Makefile.build is makefile users use from outside. It's
+interface/usage is following:
+
+  $ make -f tools/build/Makefile srctree=$(KSRC) dir=$(DIR) obj=$(OBJECT)
+
+where:
+  KSRC   - is the path to kernel sources
+  DIR    - is the path to the project to be built
+  OBJECT - is the name of the build object
+
+When succefully finished the $(DIR) directory contains
+final object file called $(OBJECT)-in.o:
+
+  $ ls $(DIR)/$(OBJECT)-in.o
+
+which includes all compiled sources described in 'Build' makefiles.
+
+
+a) Build makefiles
+------------------
+User supplies 'Build' makefiles that contains objects list,
+and connects build to nested directories.
+
+Assume we have following project structure:
+
+  ex/a.c
+    /b.c
+    /c.c
+    /d.c
+    /arch/e.c
+    /arch/f.c
+
+Out of which you build binary 'ex' and library 'libex.a':
+  'ex'      - consists of 'a.o', 'b.o' and libex.a
+  'libex.a' - consists of 'c.o', 'd.o', 'e.o' and 'f.o'
+
+The build framework does not create 'ex' and 'libex.a'
+binaries for you, it only prepares proper objects to be
+compiled and grouped together.
+
+to follow above example, user provides following 'Build' files:
+
+  ex/Build:
+    ex-y += a.o
+    ex-y += b.o
+
+    libex-y += c.o
+    libex-y += d.o
+    libex-y += arch/
+
+  ex/arch/Build:
+    libex-y += e.o
+    libex-y += f.o
+
+and runs:
+  $ make -f tools/build/Makefile.build dir=. obj=ex
+  $ make -f tools/build/Makefile.build dir=. obj=libex
+
+which creates following objects:
+  ex/ex-in.o
+  ex/libex-in.o
+
+that contain request objects names in Build files.
+
+It's only matter of 2 single commands to create final binaries:
+  $ ar  rcs libex.a libex-in.o
+  $ gcc -o ex ex-in.o libex.a
+
+You can check 'ex' example in 'tools/build/tests/ex' for
+more details.
+
+
+b) rules
+--------
+The build framework provides standard compilation rules
+to handle .S and .c compilation.
+
+It's possible to include special rule if needed
+(like we do for flex or bison code generation).
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
index 000000000000..ba8b77978f5e
--- /dev/null
+++ b/tools/build/Makefile.build
@@ -0,0 +1,92 @@
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
+# If there's nothing to link, create empty $@ object.
+quiet_cmd_ld_multi = LD       $@
+      cmd_ld_multi = $(if $(strip $(obj-y)),\
+		       $(LD) -r -o $@ $(obj-y),rm -f $@; $(AR) rcs $@)
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
+in-target := $(prefix)$(obj)-in.o
+
+PHONY += $(subdir-y)
+
+$(subdir-y):
+	@$(MAKE) -f $(build-dir)/Makefile.build dir=$(dir)/$@ obj=$(obj)
+
+$(sort $(subdir-obj-y)): $(subdir-y) ;
+
+$(in-target): $(obj-y) FORCE
+	$(call rule_mkdir)
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
+targets   := $(wildcard $(sort $(obj-y) $(in-target)))
+cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
+
+ifneq ($(cmd_files),)
+  include $(cmd_files)
+endif
+
+.PHONY: $(PHONY)
diff --git a/tools/build/tests/ex/Build b/tools/build/tests/ex/Build
new file mode 100644
index 000000000000..0e6c3e6767e6
--- /dev/null
+++ b/tools/build/tests/ex/Build
@@ -0,0 +1,8 @@
+ex-y += ex.o
+ex-y += a.o
+ex-y += b.o
+ex-y += empty/
+
+libex-y += c.o
+libex-y += d.o
+libex-y += arch/
diff --git a/tools/build/tests/ex/Makefile b/tools/build/tests/ex/Makefile
new file mode 100644
index 000000000000..52d2476073a3
--- /dev/null
+++ b/tools/build/tests/ex/Makefile
@@ -0,0 +1,23 @@
+export srctree := ../../../..
+export CC      := gcc
+export LD      := ld
+export AR      := ar
+
+build := -f $(srctree)/tools/build/Makefile.build dir=. obj
+ex: ex-in.o libex-in.o
+	gcc -o $@ $^
+
+ex.%: FORCE
+	make -f $(srctree)/tools/build/Makefile.build dir=. $@
+
+ex-in.o: FORCE
+	make $(build)=ex
+
+libex-in.o: FORCE
+	make $(build)=libex
+
+clean:
+	find . -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
+	rm -f ex ex.i ex.s
+
+.PHONY: FORCE
diff --git a/tools/build/tests/ex/a.c b/tools/build/tests/ex/a.c
new file mode 100644
index 000000000000..851762798c83
--- /dev/null
+++ b/tools/build/tests/ex/a.c
@@ -0,0 +1,5 @@
+
+int a(void)
+{
+	return 0;
+}
diff --git a/tools/build/tests/ex/arch/Build b/tools/build/tests/ex/arch/Build
new file mode 100644
index 000000000000..55506189efae
--- /dev/null
+++ b/tools/build/tests/ex/arch/Build
@@ -0,0 +1,2 @@
+libex-y += e.o
+libex-y += f.o
diff --git a/tools/build/tests/ex/arch/e.c b/tools/build/tests/ex/arch/e.c
new file mode 100644
index 000000000000..beaa4a1d7ba8
--- /dev/null
+++ b/tools/build/tests/ex/arch/e.c
@@ -0,0 +1,5 @@
+
+int e(void)
+{
+	return 0;
+}
diff --git a/tools/build/tests/ex/arch/f.c b/tools/build/tests/ex/arch/f.c
new file mode 100644
index 000000000000..7c3e9e9da5b7
--- /dev/null
+++ b/tools/build/tests/ex/arch/f.c
@@ -0,0 +1,5 @@
+
+int f(void)
+{
+	return 0;
+}
diff --git a/tools/build/tests/ex/b.c b/tools/build/tests/ex/b.c
new file mode 100644
index 000000000000..c24ff9ca9a97
--- /dev/null
+++ b/tools/build/tests/ex/b.c
@@ -0,0 +1,5 @@
+
+int b(void)
+{
+	return 0;
+}
diff --git a/tools/build/tests/ex/c.c b/tools/build/tests/ex/c.c
new file mode 100644
index 000000000000..e216d0217499
--- /dev/null
+++ b/tools/build/tests/ex/c.c
@@ -0,0 +1,5 @@
+
+int c(void)
+{
+	return 0;
+}
diff --git a/tools/build/tests/ex/d.c b/tools/build/tests/ex/d.c
new file mode 100644
index 000000000000..80dc0f06151b
--- /dev/null
+++ b/tools/build/tests/ex/d.c
@@ -0,0 +1,5 @@
+
+int d(void)
+{
+	return 0;
+}
diff --git a/tools/build/tests/ex/empty/Build b/tools/build/tests/ex/empty/Build
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tools/build/tests/ex/ex.c b/tools/build/tests/ex/ex.c
new file mode 100644
index 000000000000..dc42eb2e1a67
--- /dev/null
+++ b/tools/build/tests/ex/ex.c
@@ -0,0 +1,19 @@
+
+int a(void);
+int b(void);
+int c(void);
+int d(void);
+int e(void);
+int f(void);
+
+int main(void)
+{
+	a();
+	b();
+	c();
+	d();
+	e();
+	f();
+
+	return 0;
+}
diff --git a/tools/build/tests/run.sh b/tools/build/tests/run.sh
new file mode 100755
index 000000000000..5494f8ea7567
--- /dev/null
+++ b/tools/build/tests/run.sh
@@ -0,0 +1,42 @@
+#!/bin/sh
+
+function test_ex {
+	make -C ex V=1 clean > ex.out 2>&1
+	make -C ex V=1 >> ex.out 2>&1
+
+	if [ ! -x ./ex/ex ]; then
+	  echo FAILED
+	  exit -1
+	fi
+
+	make -C ex V=1 clean > /dev/null 2>&1
+	rm -f ex.out
+}
+
+function test_ex_suffix {
+	make -C ex V=1 clean > ex.out 2>&1
+
+	# use -rR to disable make's builtin rules
+	make -rR -C ex V=1 ex.o >> ex.out 2>&1
+	make -rR -C ex V=1 ex.i >> ex.out 2>&1
+	make -rR -C ex V=1 ex.s >> ex.out 2>&1
+
+	if [ -x ./ex/ex ]; then
+	  echo FAILED
+	  exit -1
+	fi
+
+	if [ ! -f ./ex/ex.o -o ! -f ./ex/ex.i -o ! -f ./ex/ex.s ]; then
+	  echo FAILED
+	  exit -1
+	fi
+
+	make -C ex V=1 clean > /dev/null 2>&1
+	rm -f ex.out
+}
+echo -n Testing..
+
+test_ex
+test_ex_suffix
+
+echo OK
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index fbbfdc39271d..11ccbb22ea2b 100644
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

