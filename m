Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaBXUAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:00:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49142 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaBXT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:51 -0500
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
Subject: [PATCH 07/12] perf tools: Add feature check for libdw dwarf unwind
Date: Mon, 24 Feb 2014 16:56:35 -0300
Message-Id: <1393271800-17505-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding feature check test code for libdw dwarf unwind.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392825179-5228-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                            | 19 ++++++++++++-------
 tools/perf/config/feature-checks/Makefile             |  6 +++++-
 tools/perf/config/feature-checks/test-all.c           |  5 +++++
 .../config/feature-checks/test-libdw-dwarf-unwind.c   | 13 +++++++++++++
 4 files changed, 35 insertions(+), 8 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9429805f395c..074fa618cc7b 100644
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
 
@@ -267,13 +279,6 @@ else
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
index 12e551346fa6..2b492f5480e2 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -26,7 +26,8 @@ FILES=					\
 	test-libunwind-debug-frame.bin	\
 	test-on-exit.bin		\
 	test-stackprotector-all.bin	\
-	test-timerfd.bin
+	test-timerfd.bin		\
+	test-libdw-dwarf-unwind.bin
 
 CC := $(CROSS_COMPILE)gcc -MD
 PKG_CONFIG := $(CROSS_COMPILE)pkg-config
@@ -141,6 +142,9 @@ test-backtrace.bin:
 test-timerfd.bin:
 	$(BUILD)
 
+test-libdw-dwarf-unwind.bin:
+	$(BUILD)
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 9b8a544155bb..fc37eb3ca17b 100644
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
index 000000000000..f676a3ff442a
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
1.8.1.4

