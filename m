Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaBXT7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:59:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaBXT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/12] perf tools: Setup default dwarf post unwinder
Date: Mon, 24 Feb 2014 16:56:37 -0300
Message-Id: <1393271800-17505-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Factor NO_LIBDW_DWARF_UNWIND makefile variable and code that selects
default DWARf post unwinder based on detected features (libdw and
libunwind support)

If both are detected the libunwind is selected as default.  Simple
'make' will try to add:

  - libunwind unwinder if present
  - libdw unwinder if present
  - disable dwarf unwind if non of libunwind and libdw
    libraries are present

If one of the DWARF unwind libraries is detected, message is displayed
which one (libunwind/libdw) is compiled in.

Examples:
  - compile in libdw unwinder if present:

    $ make NO_LIBUNWIND=1

  - compile in libdw (with libdw installation directory) unwinder if present:

    $ make LIBDW_DIR=/opt/elfutils/ NO_LIBUNWIND=1
      BUILD:   Doing 'make -j4' parallel build

    Auto-detecting system features:
    ...                         dwarf: [ on  ]
    ...                         glibc: [ on  ]
    ...                          gtk2: [ on  ]
    ...                      libaudit: [ on  ]
    ...                        libbfd: [ on  ]
    ...                        libelf: [ on  ]
    ...                       libnuma: [ on  ]
    ...                       libperl: [ on  ]
    ...                     libpython: [ on  ]
    ...                      libslang: [ on  ]
    ...                     libunwind: [ on  ]
    ...            libdw-dwarf-unwind: [ on  ]
    ...     DWARF post unwind library: libdw

  - disable post dwarf unwind completely:

    $ make NO_LIBUNWIND=1 NO_LIBDW_DWARF_UNWIND=1
      BUILD:   Doing 'make -j4' parallel build

    Auto-detecting system features:
    ...                         dwarf: [ on  ]
    ...                         glibc: [ on  ]
    ...                          gtk2: [ on  ]
    ...                      libaudit: [ on  ]
    ...                        libbfd: [ on  ]
    ...                        libelf: [ on  ]
    ...                       libnuma: [ on  ]
    ...                       libperl: [ on  ]
    ...                     libpython: [ on  ]
    ...                      libslang: [ on  ]
    ...                     libunwind: [ on  ]
    ...            libdw-dwarf-unwind: [ on  ]
    ...     DWARF post unwind library: libunwind

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392825179-5228-6-git-send-email-jolsa@redhat.com
[ Add suggestion about setting LIBDW_DIR when not finding libdw ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf     |  5 +--
 tools/perf/arch/x86/Makefile |  6 ++--
 tools/perf/config/Makefile   | 78 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 66 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2dff0b8ed611..1f7ec48ac959 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -61,9 +61,6 @@ include config/utilities.mak
 # Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
 # for dwarf backtrace post unwind.
 
-# temporarily disabled
-NO_LIBDW_DWARF_UNWIND := 1
-
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
@@ -412,7 +409,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
-ifndef NO_LIBUNWIND
+ifndef NO_DWARF_UNWIND
 ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 37c4652cc48a..1641542e3636 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -4,12 +4,14 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
 ifndef NO_LIBDW_DWARF_UNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
 endif
+ifndef NO_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
+endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
 LIB_H += arch/$(ARCH)/util/tsc.h
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c040d8618793..f7c81d3e2422 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -159,7 +159,8 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	on-exit				\
 	stackprotector-all		\
-	timerfd
+	timerfd				\
+	libdw-dwarf-unwind
 
 LIB_FEATURE_TESTS =			\
 	dwarf				\
@@ -172,7 +173,8 @@ LIB_FEATURE_TESTS =			\
 	libperl				\
 	libpython			\
 	libslang			\
-	libunwind
+	libunwind			\
+	libdw-dwarf-unwind
 
 VF_FEATURE_TESTS =			\
 	backtrace			\
@@ -280,6 +282,12 @@ else
       msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
     endif
   else
+    ifndef NO_LIBDW_DWARF_UNWIND
+      ifneq ($(feature-libdw-dwarf-unwind),1)
+        NO_LIBDW_DWARF_UNWIND := 1
+        msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
+      endif
+    endif
     ifneq ($(feature-dwarf), 1)
       msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
       NO_DWARF := 1
@@ -315,25 +323,51 @@ endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
   ifneq ($(feature-libunwind), 1)
-    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
+    msg := $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
     NO_LIBUNWIND := 1
+  endif
+endif
+
+dwarf-post-unwind := 1
+dwarf-post-unwind-text := BUG
+
+# setup DWARF post unwinder
+ifdef NO_LIBUNWIND
+  ifdef NO_LIBDW_DWARF_UNWIND
+    msg := $(warning Disabling post unwind, no support found.);
+    dwarf-post-unwind := 0
   else
-    ifeq ($(ARCH),arm)
-      $(call feature_check,libunwind-debug-frame)
-      ifneq ($(feature-libunwind-debug-frame), 1)
-        msg := $(warning No debug_frame support found in libunwind);
-        CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
-      endif
-    else
-      # non-ARM has no dwarf_find_debug_frame() function:
+    dwarf-post-unwind-text := libdw
+  endif
+else
+  dwarf-post-unwind-text := libunwind
+  # Enable libunwind support by default.
+  ifndef NO_LIBDW_DWARF_UNWIND
+    NO_LIBDW_DWARF_UNWIND := 1
+  endif
+endif
+
+ifeq ($(dwarf-post-unwind),1)
+  CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT
+else
+  NO_DWARF_UNWIND := 1
+endif
+
+ifndef NO_LIBUNWIND
+  ifeq ($(ARCH),arm)
+    $(call feature_check,libunwind-debug-frame)
+    ifneq ($(feature-libunwind-debug-frame), 1)
+      msg := $(warning No debug_frame support found in libunwind);
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
-
-    CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT -DHAVE_LIBUNWIND_SUPPORT
-    EXTLIBS += $(LIBUNWIND_LIBS)
-    CFLAGS += $(LIBUNWIND_CFLAGS)
-    LDFLAGS += $(LIBUNWIND_LDFLAGS)
-  endif # ifneq ($(feature-libunwind), 1)
+  else
+    # non-ARM has no dwarf_find_debug_frame() function:
+    CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
+  endif
+  CFLAGS  += -DHAVE_LIBUNWIND_SUPPORT
+  EXTLIBS += $(LIBUNWIND_LIBS)
+  CFLAGS  += $(LIBUNWIND_CFLAGS)
+  LDFLAGS += $(LIBUNWIND_LDFLAGS)
 endif
 
 ifndef NO_LIBAUDIT
@@ -620,6 +654,10 @@ endef
 PERF_FEATURES := $(foreach feat,$(LIB_FEATURE_TESTS),feature-$(feat)($(feature-$(feat))))
 PERF_FEATURES_FILE := $(shell touch $(OUTPUT)PERF-FEATURES; cat $(OUTPUT)PERF-FEATURES)
 
+ifeq ($(dwarf-post-unwind),1)
+  PERF_FEATURES += dwarf-post-unwind($(dwarf-post-unwind-text))
+endif
+
 # The $(display_lib) controls the default detection message
 # output. It's set if:
 # - detected features differes from stored features from
@@ -650,6 +688,10 @@ ifeq ($(display_lib),1)
   $(info )
   $(info Auto-detecting system features:)
   $(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_print_status,$(feat),))
+
+  ifeq ($(dwarf-post-unwind),1)
+    $(call feature_print_text,"DWARF post unwind library", $(dwarf-post-unwind-text))
+  endif
 endif
 
 ifeq ($(display_vf),1)
@@ -659,6 +701,8 @@ ifeq ($(display_vf),1)
   $(call feature_print_var,bindir)
   $(call feature_print_var,libdir)
   $(call feature_print_var,sysconfdir)
+  $(call feature_print_var,LIBUNWIND_DIR)
+  $(call feature_print_var,LIBDW_DIR)
 endif
 
 ifeq ($(display_lib),1)
-- 
1.8.1.4

