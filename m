Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaB0N3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:29:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaB0N3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:29:12 -0500
Date: Thu, 27 Feb 2014 05:28:49 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-45757895c785e0a4c10afd5670cdc26cea2bbc97@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1392825179-5228-4-git-send-email-jolsa@redhat.com>
References: <1392825179-5228-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add feature check for libdw dwarf unwind
Git-Commit-ID: 45757895c785e0a4c10afd5670cdc26cea2bbc97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45757895c785e0a4c10afd5670cdc26cea2bbc97
Gitweb:     http://git.kernel.org/tip/45757895c785e0a4c10afd5670cdc26cea2bbc97
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 16:52:56 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:36 -0300

perf tools: Add feature check for libdw dwarf unwind

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9429805..074fa61 100644
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
index 12e5513..2b492f5 100644
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
