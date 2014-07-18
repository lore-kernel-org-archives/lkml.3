Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbaGRE05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:26:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGRE0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:26:53 -0400
Date: Thu, 17 Jul 2014 21:26:01 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f6d313699a9612a30fabe05bf2c9302c1408b5cf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-30-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-30-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add feature test for __sync_val_compare_and_swap
Git-Commit-ID: f6d313699a9612a30fabe05bf2c9302c1408b5cf
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

Commit-ID:  f6d313699a9612a30fabe05bf2c9302c1408b5cf
Gitweb:     http://git.kernel.org/tip/f6d313699a9612a30fabe05bf2c9302c1408b5cf
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:53 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:36 -0300

perf tools: Add feature test for __sync_val_compare_and_swap

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b7f42d5..1f67aa0 100644
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
