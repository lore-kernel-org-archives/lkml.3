Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3BDN5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:57:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3BDN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:57:47 -0500
Date: Mon, 4 Feb 2013 05:57:29 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-b2e7c77a379071318b2a9c9e500e3b8b47084391@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-7-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-7-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] perf: Integrate liblockdep support into perf
Git-Commit-ID: b2e7c77a379071318b2a9c9e500e3b8b47084391
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:57:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2e7c77a379071318b2a9c9e500e3b8b47084391
Gitweb:     http://git.kernel.org/tip/b2e7c77a379071318b2a9c9e500e3b8b47084391
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:44 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:07 +0100

perf: Integrate liblockdep support into perf

liblockdep is a user-space version of lockdep, originally
written for the tools/kvm virtualization tool.

We can use it to analyze and verify locking correctness in
perf as well.

Usage is simple, to compile perf with liblockdep all that's
needed it:

	make LOCKDEP=1

Once liblockdep support is compiled in, perf will yell if
locking goes wrong for any reason:

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
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-7-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8ab05e5..785cd51 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -572,6 +572,21 @@ ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
 endif # Libunwind support
 endif # NO_LIBUNWIND
 
+ifndef NO_LIBLOCKDEP
+# for linking with liblockdep library, run like:
+# make LIBLOCKDEP=1
+ifeq ($(LOCKDEP),1)
+	LIBLOCKDEP_CFLAGS  := -I../lib/lockdep/include -D__USE_LIBLOCKDEP
+	LIBLOCKDEP_LDFLAGS := -L../lib/lockdep/ -llockdep
+endif
+
+FLAGS_LIBLOCKDEP=$(LIBLOCKDEP_CFLAGS) $(ALL_CFLAGS) $(LIBLOCKDEP_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBLOCKDEP),$(FLAGS_LIBLOCKDEP),liblockdep),y)
+	msg := $(warning No liblockdep support.);
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
index 0000000..628a2f5
--- /dev/null
+++ b/tools/perf/util/liblockdep.h
@@ -0,0 +1,11 @@
+#ifdef __USE_LIBLOCKDEP
+
+#include <liblockdep/mutex.h>
+
+#else
+
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
