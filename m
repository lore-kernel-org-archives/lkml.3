Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbaGQQOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:52474 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030223AbaGQQOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:30 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/33] perf tools: Add feature test for __sync_val_compare_and_swap
Date: Thu, 17 Jul 2014 13:12:23 -0300
Message-Id: <1405613555-23380-22-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a feature test for __sync_val_compare_and_swap() and
__sync_bool_compare_and_swap()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-30-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                                 |  6 ++++++
 tools/perf/config/feature-checks/Makefile                  |  4 ++++
 tools/perf/config/feature-checks/test-all.c                |  5 +++++
 .../config/feature-checks/test-sync-compare-and-swap.c     | 14 ++++++++++++++
 4 files changed, 29 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b7f42d577c4e..1f67aa02d240 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -164,6 +164,7 @@ CORE_FEATURE_TESTS =			\
 	backtrace			\
 	dwarf				\
 	fortify-source			\
+	sync-compare-and-swap		\
 	glibc				\
 	gtk2				\
 	gtk2-infobar			\
@@ -199,6 +200,7 @@ LIB_FEATURE_TESTS =			\
 VF_FEATURE_TESTS =			\
 	backtrace			\
 	fortify-source			\
+	sync-compare-and-swap		\
 	gtk2-infobar			\
 	libelf-getphdrnum		\
 	libelf-mmap			\
@@ -272,6 +274,10 @@ CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
+ifeq ($(feature-sync-compare-and-swap), 1)
+  CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
+endif
+
 ifndef NO_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 64c84e5f0514..6088f8d8a434 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -5,6 +5,7 @@ FILES=					\
 	test-bionic.bin			\
 	test-dwarf.bin			\
 	test-fortify-source.bin		\
+	test-sync-compare-and-swap.bin	\
 	test-glibc.bin			\
 	test-gtk2.bin			\
 	test-gtk2-infobar.bin		\
@@ -141,6 +142,9 @@ test-timerfd.bin:
 test-libdw-dwarf-unwind.bin:
 	$(BUILD)
 
+test-sync-compare-and-swap.bin:
+	$(BUILD) -Werror
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index fe5c1e5c952f..a7d022e161c0 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -89,6 +89,10 @@
 # include "test-libdw-dwarf-unwind.c"
 #undef main
 
+#define main main_test_sync_compare_and_swap
+# include "test-sync-compare-and-swap.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -111,6 +115,7 @@ int main(int argc, char *argv[])
 	main_test_timerfd();
 	main_test_stackprotector_all();
 	main_test_libdw_dwarf_unwind();
+	main_test_sync_compare_and_swap(argc, argv);
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-sync-compare-and-swap.c b/tools/perf/config/feature-checks/test-sync-compare-and-swap.c
new file mode 100644
index 000000000000..c34d4ca4af56
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-sync-compare-and-swap.c
@@ -0,0 +1,14 @@
+#include <stdint.h>
+
+volatile uint64_t x;
+
+int main(int argc, char *argv[])
+{
+	uint64_t old, new = argc;
+
+	argv = argv;
+	do {
+		old = __sync_val_compare_and_swap(&x, 0, 0);
+	} while (!__sync_bool_compare_and_swap(&x, old, new));
+	return old == new;
+}
-- 
1.9.3

