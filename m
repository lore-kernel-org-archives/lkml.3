Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaELQCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:02:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaELQB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:01:58 -0400
Date: Mon, 12 May 2014 09:01:33 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-bac1e4d103f7e3d82e5dc7423c04edcb8c899c22@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, namhyung@kernel.org,
        Bernhard.Rosenkranzer@linaro.org, irina.tirdea@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, namhyung@kernel.org,
        Bernhard.Rosenkranzer@linaro.org, irina.tirdea@intel.com,
        tglx@linutronix.de
In-Reply-To: <1399855645-25815-2-git-send-email-namhyung@kernel.org>
References: <1399855645-25815-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Get rid of on_exit() feature test
Git-Commit-ID: bac1e4d103f7e3d82e5dc7423c04edcb8c899c22
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

Commit-ID:  bac1e4d103f7e3d82e5dc7423c04edcb8c899c22
Gitweb:     http://git.kernel.org/tip/bac1e4d103f7e3d82e5dc7423c04edcb8c899c22
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 12 May 2014 09:47:25 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 12 May 2014 11:09:50 +0200

perf tools: Get rid of on_exit() feature test

The on_exit() function was only used in perf record but it's gone in
previous patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Link: http://lkml.kernel.org/r/1399855645-25815-2-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-record.c                     | 31 -------------------------
 tools/perf/config/Makefile                      |  8 -------
 tools/perf/config/feature-checks/Makefile       |  4 ----
 tools/perf/config/feature-checks/test-all.c     |  5 ----
 tools/perf/config/feature-checks/test-on-exit.c | 16 -------------
 5 files changed, 64 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2e0d484..e4c85b8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,37 +30,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#ifndef HAVE_ON_EXIT_SUPPORT
-#ifndef ATEXIT_MAX
-#define ATEXIT_MAX 32
-#endif
-static int __on_exit_count = 0;
-typedef void (*on_exit_func_t) (int, void *);
-static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
-static void *__on_exit_args[ATEXIT_MAX];
-static int __exitcode = 0;
-static void __handle_on_exit_funcs(void);
-static int on_exit(on_exit_func_t function, void *arg);
-#define exit(x) (exit)(__exitcode = (x))
-
-static int on_exit(on_exit_func_t function, void *arg)
-{
-	if (__on_exit_count == ATEXIT_MAX)
-		return -ENOMEM;
-	else if (__on_exit_count == 0)
-		atexit(__handle_on_exit_funcs);
-	__on_exit_funcs[__on_exit_count] = function;
-	__on_exit_args[__on_exit_count++] = arg;
-	return 0;
-}
-
-static void __handle_on_exit_funcs(void)
-{
-	int i;
-	for (i = 0; i < __on_exit_count; i++)
-		__on_exit_funcs[i] (__exitcode, __on_exit_args[i]);
-}
-#endif
 
 struct record {
 	struct perf_tool	tool;
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 150c84c..f2edc59 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -174,7 +174,6 @@ CORE_FEATURE_TESTS =			\
 	libpython-version		\
 	libslang			\
 	libunwind			\
-	on-exit				\
 	stackprotector-all		\
 	timerfd				\
 	libdw-dwarf-unwind
@@ -200,7 +199,6 @@ VF_FEATURE_TESTS =			\
 	libelf-getphdrnum		\
 	libelf-mmap			\
 	libpython-version		\
-	on-exit				\
 	stackprotector-all		\
 	timerfd				\
 	libunwind-debug-frame		\
@@ -571,12 +569,6 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
   CFLAGS += -DHAVE_LIBBFD_SUPPORT
 endif
 
-ifndef NO_ON_EXIT
-  ifeq ($(feature-on-exit), 1)
-    CFLAGS += -DHAVE_ON_EXIT_SUPPORT
-  endif
-endif
-
 ifndef NO_BACKTRACE
   ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2da103c..64c84e5 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -24,7 +24,6 @@ FILES=					\
 	test-libslang.bin		\
 	test-libunwind.bin		\
 	test-libunwind-debug-frame.bin	\
-	test-on-exit.bin		\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin		\
 	test-libdw-dwarf-unwind.bin
@@ -133,9 +132,6 @@ test-liberty-z.bin:
 test-cplus-demangle.bin:
 	$(BUILD) -liberty
 
-test-on-exit.bin:
-	$(BUILD)
-
 test-backtrace.bin:
 	$(BUILD)
 
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index fc37eb3..fe5c1e5 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -69,10 +69,6 @@
 # include "test-libbfd.c"
 #undef main
 
-#define main main_test_on_exit
-# include "test-on-exit.c"
-#undef main
-
 #define main main_test_backtrace
 # include "test-backtrace.c"
 #undef main
@@ -110,7 +106,6 @@ int main(int argc, char *argv[])
 	main_test_gtk2(argc, argv);
 	main_test_gtk2_infobar(argc, argv);
 	main_test_libbfd();
-	main_test_on_exit();
 	main_test_backtrace();
 	main_test_libnuma();
 	main_test_timerfd();
diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
deleted file mode 100644
index 8e88b16..0000000
--- a/tools/perf/config/feature-checks/test-on-exit.c
+++ /dev/null
@@ -1,16 +0,0 @@
-#include <stdio.h>
-#include <stdlib.h>
-
-static void exit_fn(int status, void *__data)
-{
-	printf("exit status: %d, data: %d\n", status, *(int *)__data);
-}
-
-static int data = 123;
-
-int main(void)
-{
-	on_exit(exit_fn, &data);
-
-	return 321;
-}
