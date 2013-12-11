Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3LKMjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:60200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab3LKMj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448280201"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 21/71] perf tools: Add feature test for __sync_val_compare_and_swap
Date: Wed, 11 Dec 2013 14:36:33 +0200
Message-Id: <1386765443-26966-22-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a feature test for __sync_val_compare_and_swap()
and __sync_bool_compare_and_swap()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/config/Makefile                                 |  5 +++++
 tools/perf/config/feature-checks/Makefile                  |  4 ++++
 tools/perf/config/feature-checks/test-all.c                |  5 +++++
 .../config/feature-checks/test-sync-compare-and-swap.c     | 14 ++++++++++++++
 4 files changed, 28 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index bae1072..43a2879 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -126,6 +126,7 @@ CORE_FEATURE_TESTS =			\
 	backtrace			\
 	dwarf				\
 	fortify-source			\
+	sync-compare-and-swap		\
 	glibc				\
 	gtk2				\
 	gtk2-infobar			\
@@ -234,6 +235,10 @@ CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
+ifeq ($(feature-sync-compare-and-swap), 1)
+  CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
+endif
+
 ifndef NO_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index b8bb749..b4b7bb2 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -5,6 +5,7 @@ FILES=					\
 	test-bionic			\
 	test-dwarf			\
 	test-fortify-source		\
+	test-sync-compare-and-swap	\
 	test-glibc			\
 	test-gtk2			\
 	test-gtk2-infobar		\
@@ -140,6 +141,9 @@ test-backtrace:
 test-timerfd:
 	$(BUILD)
 
+test-sync-compare-and-swap:
+	$(BUILD)
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 9b8a544..5cfec18 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -89,6 +89,10 @@
 # include "test-stackprotector-all.c"
 #undef main
 
+#define main main_test_sync_compare_and_swap
+# include "test-sync-compare-and-swap.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -111,6 +115,7 @@ int main(int argc, char *argv[])
 	main_test_libnuma();
 	main_test_timerfd();
 	main_test_stackprotector_all();
+	main_test_sync_compare_and_swap();
 
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
1.8.5.1

