Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbbAZKPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:15:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbbAZKOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:53 -0500
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
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 34/36] tools lib traceevent: Use tools build framework
Date: Mon, 26 Jan 2015 11:12:34 +0100
Message-Id: <1422267156-13873-35-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the libtraceevent library building under tools
build framework.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
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
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/Build    |  17 +++++
 tools/lib/traceevent/Makefile | 161 ++++++++++--------------------------------
 tools/perf/Makefile.perf      |  10 +--
 3 files changed, 59 insertions(+), 129 deletions(-)
 create mode 100644 tools/lib/traceevent/Build

diff --git a/tools/lib/traceevent/Build b/tools/lib/traceevent/Build
new file mode 100644
index 000000000000..c681d0575d16
--- /dev/null
+++ b/tools/lib/traceevent/Build
@@ -0,0 +1,17 @@
+libtraceevent-y += event-parse.o
+libtraceevent-y += event-plugin.o
+libtraceevent-y += trace-seq.o
+libtraceevent-y += parse-filter.o
+libtraceevent-y += parse-utils.o
+libtraceevent-y += kbuffer-parse.o
+
+plugin_jbd2-y         += plugin_jbd2.o
+plugin_hrtimer-y      += plugin_hrtimer.o
+plugin_kmem-y         += plugin_kmem.o
+plugin_kvm-y          += plugin_kvm.o
+plugin_mac80211-y     += plugin_mac80211.o
+plugin_sched_switch-y += plugin_sched_switch.o
+plugin_function-y     += plugin_function.o
+plugin_xen-y          += plugin_xen.o
+plugin_scsi-y         += plugin_scsi.o
+plugin_cfg80211-y     += plugin_cfg80211.o
diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 005c9cc06935..8c44ece033d9 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -67,7 +67,7 @@ PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif
 
-include $(if $(BUILD_SRC),$(BUILD_SRC)/)../../scripts/Makefile.include
+include ../../scripts/Makefile.include
 
 # copy a bit from Linux kbuild
 
@@ -78,40 +78,13 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
-ifeq ("$(origin O)", "command line")
-  BUILD_OUTPUT := $(O)
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
 endif
 
-ifeq ($(BUILD_SRC),)
-ifneq ($(OUTPUT),)
-
-define build_output
-  $(if $(VERBOSE:1=),@)+$(MAKE) -C $(OUTPUT) \
-  BUILD_SRC=$(CURDIR)/ -f $(CURDIR)/Makefile $1
-endef
-
-all: sub-make
-
-$(MAKECMDGOALS): sub-make
-
-sub-make: force
-	$(call build_output, $(MAKECMDGOALS))
-
-
-# Leave processing to above invocation of make
-skip-makefile := 1
-
-endif # OUTPUT
-endif # BUILD_SRC
-
-# We process the rest of the Makefile if this is the final invocation of make
-ifeq ($(skip-makefile),)
-
-srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
-src		:= $(srctree)
-obj		:= $(objtree)
-
 export prefix bindir src obj
 
 # Shell quotes
@@ -132,16 +105,15 @@ EXTRAVERSION	= $(EP_EXTRAVERSION)
 OBJ		= $@
 N		=
 
-export Q VERBOSE
-
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-INCLUDES = -I. -I $(srctree)/../../include $(CONFIG_INCLUDES)
+INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
 
 # Append required CFLAGS
+override CFLAGS += -fPIC
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
 override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 
@@ -151,74 +123,58 @@ else
   Q = @
 endif
 
-do_compile_shared_library =			\
-	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -o $@)
-
-do_plugin_build =				\
-	($(print_plugin_build)			\
-	$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $<)
-
-do_build_static_lib =				\
-	($(print_static_lib_build)		\
-	$(RM) $@;  $(AR) rcs $@ $^)
-
-
-do_compile = $(QUIET_CC)$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;
-
-$(obj)/%.o: $(src)/%.c
-	$(call do_compile)
+# Disable command line variables (CFLAGS) overide from top
+# level Makefile (perf), otherwise build Makefile will get
+# the same command line setup.
+MAKEOVERRIDES=
 
-%.o: $(src)/%.c
-	$(call do_compile)
+export srctree OUTPUT CC LD CFLAGS V
+build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 
-PEVENT_LIB_OBJS  = event-parse.o
-PEVENT_LIB_OBJS += event-plugin.o
-PEVENT_LIB_OBJS += trace-seq.o
-PEVENT_LIB_OBJS += parse-filter.o
-PEVENT_LIB_OBJS += parse-utils.o
-PEVENT_LIB_OBJS += kbuffer-parse.o
+PLUGINS  = plugin_jbd2.so
+PLUGINS += plugin_hrtimer.so
+PLUGINS += plugin_kmem.so
+PLUGINS += plugin_kvm.so
+PLUGINS += plugin_mac80211.so
+PLUGINS += plugin_sched_switch.so
+PLUGINS += plugin_function.so
+PLUGINS += plugin_xen.so
+PLUGINS += plugin_scsi.so
+PLUGINS += plugin_cfg80211.so
 
-PLUGIN_OBJS  = plugin_jbd2.o
-PLUGIN_OBJS += plugin_hrtimer.o
-PLUGIN_OBJS += plugin_kmem.o
-PLUGIN_OBJS += plugin_kvm.o
-PLUGIN_OBJS += plugin_mac80211.o
-PLUGIN_OBJS += plugin_sched_switch.o
-PLUGIN_OBJS += plugin_function.o
-PLUGIN_OBJS += plugin_xen.o
-PLUGIN_OBJS += plugin_scsi.o
-PLUGIN_OBJS += plugin_cfg80211.o
+PLUGINS    := $(addprefix $(OUTPUT),$(PLUGINS))
+PLUGINS_IN := $(PLUGINS:.so=-in.o)
 
-PLUGINS := $(PLUGIN_OBJS:.o=.so)
-
-ALL_OBJS = $(PEVENT_LIB_OBJS) $(PLUGIN_OBJS)
+TE_IN    := $(OUTPUT)libtraceevent-in.o
+LIB_FILE := $(addprefix $(OUTPUT),$(LIB_FILE))
 
 CMD_TARGETS = $(LIB_FILE) $(PLUGINS)
 
 TARGETS = $(CMD_TARGETS)
 
-
 all: all_cmd
 
 all_cmd: $(CMD_TARGETS)
 
-libtraceevent.so: $(PEVENT_LIB_OBJS)
+$(TE_IN): force
+	$(Q)$(MAKE) $(build)=libtraceevent
+
+$(OUTPUT)libtraceevent.so: $(TE_IN)
 	$(QUIET_LINK)$(CC) --shared $^ -o $@
 
-libtraceevent.a: $(PEVENT_LIB_OBJS)
+$(OUTPUT)libtraceevent.a: $(TE_IN)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
 plugins: $(PLUGINS)
 
-$(PEVENT_LIB_OBJS): %.o: $(src)/%.c TRACEEVENT-CFLAGS
-	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@
+__plugin_obj = $(notdir $@)
+  plugin_obj = $(__plugin_obj:-in.o=)
 
-$(PLUGIN_OBJS): %.o : $(src)/%.c
-	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) -fPIC -o $@ $<
+$(PLUGINS_IN): force
+	$(Q)$(MAKE) $(build)=$(plugin_obj)
 
-$(PLUGINS): %.so: %.o
-	$(QUIET_LINK)$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $<
+$(OUTPUT)%.so: $(OUTPUT)%-in.o
+	$(QUIET_LINK)$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $^
 
 define make_version.h
   (echo '/* This file is automatically generated. Do not modify. */';		\
@@ -255,40 +211,6 @@ define update_dir
    fi);
 endef
 
-## make deps
-
-all_objs := $(sort $(ALL_OBJS))
-all_deps := $(all_objs:%.o=.%.d)
-
-# let .d file also depends on the source and header files
-define check_deps
-  @set -e; $(RM) $@; \
-  $(CC) -MM $(CFLAGS) $< > $@.$$$$; \
-  sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
-  $(RM) $@.$$$$
-endef
-
-$(all_deps): .%.d: $(src)/%.c
-	$(Q)$(call check_deps)
-
-$(all_objs) : %.o : .%.d
-
-dep_includes := $(wildcard $(all_deps))
-
-ifneq ($(dep_includes),)
- include $(dep_includes)
-endif
-
-### Detect environment changes
-TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
-
-TRACEEVENT-CFLAGS: force
-	@FLAGS='$(TRACK_CFLAGS)'; \
-	    if test x"$$FLAGS" != x"`cat TRACEEVENT-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "  FLAGS:   * new build flags or cross compiler"; \
-		echo "$$FLAGS" >TRACEEVENT-CFLAGS; \
-            fi
-
 tags:	force
 	$(RM) tags
 	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
@@ -327,14 +249,9 @@ clean:
 		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d \
 		$(RM) TRACEEVENT-CFLAGS tags TAGS
 
-endif # skip-makefile
-
 PHONY += force plugins
 force:
 
-plugins:
-	@echo > /dev/null
-
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 0e8ff8fbc10c..5b083da3b934 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -358,22 +358,18 @@ $(LIBPERF_IN): FORCE
 $(LIB_FILE): $(LIBPERF_IN)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIBPERF_IN) $(LIB_OBJS)
 
-# libtraceevent.a
-TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
-
-LIBTRACEEVENT_FLAGS  = $(QUIET_SUBDIR1) O=$(OUTPUT)
 LIBTRACEEVENT_FLAGS += CFLAGS="-g -Wall $(EXTRA_CFLAGS)"
 LIBTRACEEVENT_FLAGS += plugin_dir=$(plugindir_SQ)
 
-$(LIBTRACEEVENT): $(TE_SOURCES)
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) libtraceevent.a plugins
+$(LIBTRACEEVENT): FORCE
+	@$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)libtraceevent.a plugins
 
 $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)
 	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
 install-traceevent-plugins: $(LIBTRACEEVENT)
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
+	@$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) install_plugins
 
 $(LIBAPIKFS): FORCE
 	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) $(OUTPUT)libapi.a
-- 
1.9.3

