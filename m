Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaLCQYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:24:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLCQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:24:51 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/8] perf tools: Add feature check for libbabeltrace
Date: Wed,  3 Dec 2014 17:23:55 +0100
Message-Id: <1417623842-14331-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding feature check for babeltrace library [1], which will be
used for perf data file CTF [2] conversion in following patches.

The babeltrace library is now automatically detected as standard
feature. It's possible to specify LIBBABELTRACE_DIR make variable
to specify location of installed libbabeltrace, like:

  $ make LIBBABELTRACE_DIR=/opt/libbabeltrace/
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
  ...                 libbabeltrace: [ on  ]
  ...            libdw-dwarf-unwind: [ on  ]
  ...                          zlib: [ on  ]
  ...     DWARF post unwind library: libunwind

[1] babeltrace - http://www.efficios.com/babeltrace
[2] Common Trace Format - http://www.efficios.com/ctf

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf                           |  4 +++-
 tools/perf/config/Makefile                         | 24 ++++++++++++++++++++++
 tools/perf/config/feature-checks/Makefile          |  8 ++++++--
 tools/perf/config/feature-checks/test-all.c        |  5 +++++
 .../config/feature-checks/test-libbabeltrace.c     |  8 ++++++++
 5 files changed, 46 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libbabeltrace.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 478efa9b2364..3421c65130f1 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -68,7 +68,9 @@ include config/utilities.mak
 # for reading the x32 mode 32-bit compatibility VDSO in 64-bit mode
 #
 # Define NO_ZLIB if you do not want to support compressed kernel modules
-
+#
+# Define NO_LIBBABELTRACE if you do not want libbabeltrace support
+# for CTF data format.
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039fe1ed..e743aae5a1f3 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -84,6 +84,17 @@ ifndef NO_LIBELF
   FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
 endif
 
+ifndef NO_LIBBABELTRACE
+  # for linking with debug library, run like:
+  # make DEBUG=1 LIBBABELTRACE_DIR=/opt/libdw/
+  ifdef LIBBABELTRACE_DIR
+    LIBBABELTRACE_CFLAGS  := -I$(LIBBABELTRACE_DIR)/include
+    LIBBABELTRACE_LDFLAGS := -L$(LIBBABELTRACE_DIR)/lib
+  endif
+  FEATURE_CHECK_CFLAGS-libbabeltrace := $(LIBBABELTRACE_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-libbabeltrace := $(LIBBABELTRACE_LDFLAGS) -lbabeltrace-ctf
+endif
+
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -201,6 +212,7 @@ CORE_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd				\
 	libdw-dwarf-unwind		\
+	libbabeltrace			\
 	zlib
 
 LIB_FEATURE_TESTS =			\
@@ -216,6 +228,7 @@ LIB_FEATURE_TESTS =			\
 	libslang			\
 	libunwind			\
 	libdw-dwarf-unwind		\
+	libbabeltrace			\
 	zlib
 
 VF_FEATURE_TESTS =			\
@@ -661,6 +674,17 @@ else
   NO_PERF_READ_VDSOX32 := 1
 endif
 
+ifndef NO_LIBBABELTRACE
+  ifeq ($(feature-libbabeltrace), 0)
+    msg := $(warning No libbabeltrace found, disables 'perf data' CTF format support, please install libbabeltrace-devel/libbabeltrace-dev);
+    NO_LIBBABELTRACE := 1
+  else
+    CFLAGS += -DHAVE_LIBBABELTRACE_SUPPORT $(LIBBABELTRACE_CFLAGS)
+    LDFLAGS += $(LIBBABELTRACE_LDFLAGS)
+    EXTLIBS += -lbabeltrace-ctf
+  endif
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 53f19b5dbc37..9d7536e39efd 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -28,6 +28,7 @@ FILES=					\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin		\
 	test-libdw-dwarf-unwind.bin	\
+	test-libbabeltrace.bin		\
 	test-compile-32.bin		\
 	test-compile-x32.bin		\
 	test-zlib.bin
@@ -42,7 +43,7 @@ BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
 ###############################
 
 test-all.bin:
-	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz
+	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz -lbabeltrace
 
 test-hello.bin:
 	$(BUILD)
@@ -129,7 +130,10 @@ test-timerfd.bin:
 	$(BUILD)
 
 test-libdw-dwarf-unwind.bin:
-	$(BUILD)
+	$(BUILD) # -ldw provided by $(FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind)
+
+test-libbabeltrace.bin:
+	$(BUILD) # -lbabeltrace provided by $(FEATURE_CHECK_LDFLAGS-libbabeltrace)
 
 test-sync-compare-and-swap.bin:
 	$(BUILD) -Werror
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 652e0098eba6..d63f5f2be9e3 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -97,6 +97,10 @@
 # include "test-zlib.c"
 #undef main
 
+#define main main_test_libbabeltrace
+# include "test-libbabeltrace.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -121,6 +125,7 @@ int main(int argc, char *argv[])
 	main_test_libdw_dwarf_unwind();
 	main_test_sync_compare_and_swap(argc, argv);
 	main_test_zlib();
+	main_test_libbabeltrace();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-libbabeltrace.c b/tools/perf/config/feature-checks/test-libbabeltrace.c
new file mode 100644
index 000000000000..3b7dd68a4d52
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libbabeltrace.c
@@ -0,0 +1,8 @@
+
+#include <babeltrace/ctf-writer/writer.h>
+
+int main(void)
+{
+	bt_ctf_stream_class_get_packet_context_type((void *) 0);
+	return 0;
+}
-- 
1.9.3

