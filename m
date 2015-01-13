Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbbAMNob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:44:31 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:52363 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:44:27 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <namhyung@kernel.org>, <jolsa@kernel.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 5/5] perf tools: [uclibc] provide stub for pthread_attr_setaffinity_np
Date: Tue, 13 Jan 2015 19:13:24 +0530
Message-ID: <1421156604-30603-6-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uClibc Linuxthreads.old doesnt support pthread_attr_setaffinity_np()
call

   ----------------->8-----------------------
  CC       bench/futex-hash.o
  CC       bench/futex-wake.o
bench/futex-hash.c: In function 'bench_futex_hash':
bench/futex-hash.c:161:3: error: implicit declaration of function
'pthread_attr_setaffinity_np' [-Werror=implicit-function-declaration]
   ret = pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t),
&cpu);
   ^
bench/futex-hash.c:161:3: error: nested extern declaration of
'pthread_attr_setaffinity_np' [-Werror=nested-externs]
   ----------------->8-----------------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 tools/perf/bench/futex.h                                   | 13 +++++++++++++
 tools/perf/config/Makefile                                 |  6 ++++++
 tools/perf/config/feature-checks/Makefile                  |  4 ++++
 tools/perf/config/feature-checks/test-all.c                |  5 +++++
 .../feature-checks/test-pthread-attr-setaffinity-np.c      | 14 ++++++++++++++
 5 files changed, 42 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/test-pthread-attr-setaffinity-np.c

diff --git a/tools/perf/bench/futex.h b/tools/perf/bench/futex.h
index 71f2844cf97f..7ed22ff1e1ac 100644
--- a/tools/perf/bench/futex.h
+++ b/tools/perf/bench/futex.h
@@ -68,4 +68,17 @@ futex_cmp_requeue(u_int32_t *uaddr, u_int32_t val, u_int32_t *uaddr2, int nr_wak
 		 val, opflags);
 }
 
+#ifndef HAVE_PTHREAD_ATTR_SETAFFINITY_NP
+#include <pthread.h>
+static inline int pthread_attr_setaffinity_np(pthread_attr_t *attr,
+					      size_t cpusetsize,
+					      cpu_set_t *cpuset)
+{
+	attr = attr;
+	cpusetsize = cpusetsize;
+	cpuset = cpuset;
+	return 0;
+}
+#endif
+
 #endif /* _FUTEX_H */
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039fe1ed..6b59662136fa 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -198,6 +198,7 @@ CORE_FEATURE_TESTS =			\
 	libpython-version		\
 	libslang			\
 	libunwind			\
+	pthread-attr-setaffinity-np	\
 	stackprotector-all		\
 	timerfd				\
 	libdw-dwarf-unwind		\
@@ -226,6 +227,7 @@ VF_FEATURE_TESTS =			\
 	libelf-getphdrnum		\
 	libelf-mmap			\
 	libpython-version		\
+	pthread-attr-setaffinity-np	\
 	stackprotector-all		\
 	timerfd				\
 	libunwind-debug-frame		\
@@ -301,6 +303,10 @@ ifeq ($(feature-sync-compare-and-swap), 1)
   CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
 endif
 
+ifeq ($(feature-pthread-attr-setaffinity-np), 1)
+  CFLAGS += -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP
+endif
+
 ifndef NO_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 53f19b5dbc37..42ac05aaf8ac 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -25,6 +25,7 @@ FILES=					\
 	test-libslang.bin		\
 	test-libunwind.bin		\
 	test-libunwind-debug-frame.bin	\
+	test-pthread-attr-setaffinity-np.bin	\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin		\
 	test-libdw-dwarf-unwind.bin	\
@@ -47,6 +48,9 @@ test-all.bin:
 test-hello.bin:
 	$(BUILD)
 
+test-pthread-attr-setaffinity-np.bin:
+	$(BUILD) -Werror -lpthread
+
 test-stackprotector-all.bin:
 	$(BUILD) -Werror -fstack-protector-all
 
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 652e0098eba6..6d4d09323922 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -97,6 +97,10 @@
 # include "test-zlib.c"
 #undef main
 
+#define main main_test_pthread_attr_setaffinity_np
+# include "test-pthread_attr_setaffinity_np.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -121,6 +125,7 @@ int main(int argc, char *argv[])
 	main_test_libdw_dwarf_unwind();
 	main_test_sync_compare_and_swap(argc, argv);
 	main_test_zlib();
+	main_test_pthread_attr_setaffinity_np();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-pthread-attr-setaffinity-np.c b/tools/perf/config/feature-checks/test-pthread-attr-setaffinity-np.c
new file mode 100644
index 000000000000..0a0d3ecb4e8a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-pthread-attr-setaffinity-np.c
@@ -0,0 +1,14 @@
+#include <stdint.h>
+#include <pthread.h>
+
+int main(void)
+{
+	int ret = 0;
+	pthread_attr_t thread_attr;
+
+	pthread_attr_init(&thread_attr);
+	/* don't care abt exact args, just the API itself in libpthread */
+	ret = pthread_attr_setaffinity_np(&thread_attr, 0, NULL);
+
+	return ret;
+}
-- 
1.9.1

