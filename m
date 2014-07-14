Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaGNKGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:06:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:42003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbaGNKFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434661"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/41] perf tools: Add feature test for __sync_val_compare_and_swap
Date: Mon, 14 Jul 2014 13:02:53 +0300
Message-Id: <1405332185-4050-30-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a feature test for __sync_val_compare_and_swap()
and __sync_bool_compare_and_swap()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/config/Makefile                                 |  6 ++++++
 tools/perf/config/feature-checks/Makefile                  |  4 ++++
 tools/perf/config/feature-checks/test-all.c                |  5 +++++
 .../config/feature-checks/test-sync-compare-and-swap.c     | 14 ++++++++++++++
 4 files changed, 29 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 346bdb6..a0e1329 100644
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
index 64c84e5..6088f8d 100644
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
index fe5c1e5..a7d022e 100644
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
index 0000000..c34d4ca
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
1.8.3.2

