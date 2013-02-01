Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3BAQsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:48:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47415 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab3BAQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:48:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 7/7] perf: integrate liblockdep support into perf
Date: Fri,  1 Feb 2013 11:47:11 -0500
Message-Id: <1359737231-26127-7-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
References: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liblockdep is simply userspace lockdep. We can use that to analyze and
verify the locking in perf.

Usage is simple, to compile perf with liblockdep all that's needed it:

	make LIBLOCK=[path to liblockdep]

Once liblockdep support is compiled in, perf will yell if locking goes
wrong for any reason:

=============================================
[ INFO: possible recursive locking detected ]
liblockdep 0.0.1
---------------------------------------------
perf/23237 is trying to acquire lock:
 (sched.start_work_mutex){......}, at: ./perf() [0x419793]

but task is already holding lock:
 (sched.start_work_mutex){......}, at: ./perf() [0x419793]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sched.start_work_mutex);
  lock(sched.start_work_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by perf/23237:
 #0:  (sched.start_work_mutex){......}, at: ./perf() [0x419793]
 #1:  (sched.work_done_wait_mutex){......}, at: ./perf() [0x419793]

stack backtrace:
/usr/lib64/liblockdep.so(+0x1ba0)[0x7fa067f99ba0]
/usr/lib64/liblockdep.so(+0x37bf)[0x7fa067f9b7bf]
/usr/lib64/liblockdep.so(+0x3899)[0x7fa067f9b899]
/usr/lib64/liblockdep.so(+0x429a)[0x7fa067f9c29a]
/usr/lib64/liblockdep.so(+0x4db1)[0x7fa067f9cdb1]
/usr/lib64/liblockdep.so(lock_acquire+0x97)[0x7fa067f9d8b4]
./perf(cmd_sched+0xb166)[0x42d976]
./perf[0x419793]
./perf(main+0x529)[0x418f59]
/lib64/libc.so.6(__libc_start_main+0xed)[0x7fa063ae591d]
./perf[0x4190d9]

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/Makefile                 | 22 ++++++++++++++++++++++
 tools/perf/builtin-sched.c          |  6 ++++--
 tools/perf/builtin-top.c            |  4 ++++
 tools/perf/config/feature-tests.mak | 12 ++++++++++++
 tools/perf/perf.c                   |  3 +++
 tools/perf/ui/setup.c               |  5 ++++-
 tools/perf/util/hist.h              |  1 +
 tools/perf/util/liblockdep.h        | 11 +++++++++++
 tools/perf/util/util.h              |  1 +
 9 files changed, 62 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/util/liblockdep.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8ab05e5..994329d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -572,6 +572,21 @@ ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
 endif # Libunwind support
 endif # NO_LIBUNWIND
 
+ifndef NO_LIBLOCKDEP
+# for linking with liblockdep library, run like:
+# make DEBUG=1 LIBLOCK_DIR=/path/to/linux.git/tools/lib/lockdep/
+ifdef LIBLOCKDEP_DIR
+	LIBLOCKDEP_CFLAGS  := -I$(LIBLOCKDEP_DIR)/include -D__USE_LIBLOCKDEP
+	LIBLOCKDEP_LDFLAGS := -L$(LIBLOCKDEP_DIR)/ -llockdep
+endif
+
+FLAGS_LIBLOCKDEP=$(LIBLOCKDEP_CFLAGS) $(ALL_CFLAGS) $(LIBLOCKDEP_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBLOCKDEP),$(FLAGS_LIBLOCKDEP),liblockdep),y)
+	msg := $(warning No liblockdep found.);
+	NO_LIBLOCKDEP := 1
+endif # liblockdep support
+endif # NO_LIBLOCKDEP
+
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -621,6 +636,13 @@ ifndef NO_LIBUNWIND
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
+ifndef NO_LIBLOCKDEP
+	BASIC_CFLAGS += -D__USE_LIBLOCKDEP
+	EXTLIBS += $(LIBLOCKDEP_LIBS)
+	BASIC_CFLAGS := $(LIBLOCKDEP_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBLOCKDEP_LDFLAGS) $(BASIC_LDFLAGS)
+endif
+
 ifndef NO_LIBAUDIT
 	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
 	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index cc28b85..53d9225 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -468,6 +468,8 @@ static void *thread_func(void *ctx)
 	char comm2[22];
 	int fd;
 
+	liblockdep_set_thread();
+
 	free(parms);
 
 	sprintf(comm2, ":%s", this_task->comm);
@@ -1677,8 +1679,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
 		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
-		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
-		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
+		.start_work_mutex     = LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(sched.start_work_mutex),
+		.work_done_wait_mutex = LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(sched.work_done_wait_mutex),
 		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
 		.sort_order	      = default_sort_order,
 		.replay_repeat	      = 10,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..c9b99ef 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -588,6 +588,8 @@ static void *display_thread_tui(void *arg)
 		.refresh	= top->delay_secs,
 	};
 
+	liblockdep_set_thread();
+
 	perf_top__sort_new_samples(top);
 
 	/*
@@ -613,6 +615,8 @@ static void *display_thread(void *arg)
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
+	liblockdep_set_thread();
+
 	tcgetattr(0, &save);
 	tc = save;
 	tc.c_lflag &= ~(ICANON | ECHO);
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index f5ac774..1f5a37e 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -217,6 +217,18 @@ int main(void)
 endef
 endif
 
+ifndef NO_LIBLOCKDEP
+define SOURCE_LIBLOCKDEP
+#include <liblockdep/mutex.h>
+
+int main(void)
+{
+	liblockdep_init();
+	return 0;
+}
+endef
+endif
+
 define SOURCE_ON_EXIT
 #include <stdio.h>
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 0f661fb..ddbd315 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -446,6 +446,9 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
+	liblockdep_init();
+	liblockdep_set_thread();
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ebb4cc1..5c0cdeb 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -3,14 +3,17 @@
 #include "../util/cache.h"
 #include "../util/debug.h"
 #include "../util/hist.h"
+#include "../util/liblockdep.h"
 
-pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
+pthread_mutex_t ui__lock;
 
 void setup_browser(bool fallback_to_pager)
 {
 	if (!isatty(1) || dump_trace)
 		use_browser = 0;
 
+	pthread_mutex_init(&ui__lock, NULL);
+
 	/* default to TUI */
 	if (use_browser < 0)
 		use_browser = 1;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a5..328afe0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "liblockdep.h"
 
 extern struct callchain_param callchain_param;
 
diff --git a/tools/perf/util/liblockdep.h b/tools/perf/util/liblockdep.h
new file mode 100644
index 0000000..a996259
--- /dev/null
+++ b/tools/perf/util/liblockdep.h
@@ -0,0 +1,11 @@
+#ifdef __USE_LIBLOCKDEP
+
+#include <liblockdep/mutex.h>
+
+#else
+#error WHAT?!
+#define LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(mtx) PTHREAD_MUTEX_INITIALIZER
+#define liblockdep_init()
+#define liblockdep_set_thread()
+
+#endif
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c233091..06e6244 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -73,6 +73,7 @@
 #include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
+#include "liblockdep.h"
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
-- 
1.8.1.2

