Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaAGMu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaAGMs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:28 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 13/16] perf tools: Add feature check for libdw dwarf unwind
Date: Tue,  7 Jan 2014 13:47:30 +0100
Message-Id: <1389098853-14466-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding feature check for libdw dwarf unwind.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/config/Makefile                         | 22 ++++++++++++++--------
 tools/perf/config/feature-checks/Makefile          |  6 +++++-
 tools/perf/config/feature-checks/test-all.c        |  5 +++++
 .../feature-checks/test-libdw-dwarf-unwind.c       | 13 +++++++++++++
 4 files changed, 37 insertions(+), 9 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1bc78d2..67de6f7 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -59,6 +59,18 @@ ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
 
+ifndef NO_LIBELF
+  # for linking with debug library, run like:
+  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
+  ifdef LIBDW_DIR
+    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+
+    FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
+    FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
+  endif
+endif
+
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -147,7 +159,8 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	on-exit				\
 	stackprotector-all		\
-	timerfd
+	timerfd				\
+	libdw-dwarf-unwind
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -281,13 +294,6 @@ else
       msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
     endif
   else
-    # for linking with debug library, run like:
-    # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-    ifdef LIBDW_DIR
-      LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-      LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-    endif
-
     ifneq ($(feature-dwarf), 1)
       msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
       NO_DWARF := 1
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 7cf6fcd..100a8bb 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -26,7 +26,8 @@ FILES=					\
 	test-libunwind-debug-frame.bin	\
 	test-on-exit.bin		\
 	test-stackprotector-all.bin	\
-	test-timerfd.bin
+	test-timerfd.bin		\
+	test-libdw-dwarf-unwind.bin
 
 CC := $(CC) -MD
 
@@ -140,6 +141,9 @@ test-backtrace.bin:
 test-timerfd.bin:
 	$(BUILD)
 
+test-libdw-dwarf-unwind.bin:
+	$(BUILD)
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 9b8a544..fc37eb3 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -89,6 +89,10 @@
 # include "test-stackprotector-all.c"
 #undef main
 
+#define main main_test_libdw_dwarf_unwind
+# include "test-libdw-dwarf-unwind.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -111,6 +115,7 @@ int main(int argc, char *argv[])
 	main_test_libnuma();
 	main_test_timerfd();
 	main_test_stackprotector_all();
+	main_test_libdw_dwarf_unwind();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c b/tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
new file mode 100644
index 0000000..f676a3f
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
@@ -0,0 +1,13 @@
+
+#include <elfutils/libdwfl.h>
+
+int main(void)
+{
+	/*
+	 * This function is guarded via: __nonnull_attribute__ (1, 2).
+	 * Passing '1' as arguments value. This code is never executed,
+	 * only compiled.
+	 */
+	dwfl_thread_getframes((void *) 1, (void *) 1, NULL);
+	return 0;
+}
-- 
1.8.3.1

