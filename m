Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3BAEsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:48:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40327 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3BAEsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:48:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 7/7] perf: integrate liblock support into perf
Date: Thu, 31 Jan 2013 23:47:38 -0500
Message-Id: <1359694058-24452-8-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liblock is simply userspace lockdep. We can use that to analyze and
verify the locking in perf.

Usage is simple, to compile perf with liblock all that's needed it:

	make LIBLOCK=[path to liblock]

Once liblock support is compiled in, perf will yell if locking goes
wrong for any reason:

=============================================
[ INFO: possible recursive locking detected ]
liblock 0.0.1
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
/usr/lib64/liblock.so(+0x1ba0)[0x7fa067f99ba0]
/usr/lib64/liblock.so(+0x37bf)[0x7fa067f9b7bf]
/usr/lib64/liblock.so(+0x3899)[0x7fa067f9b899]
/usr/lib64/liblock.so(+0x429a)[0x7fa067f9c29a]
/usr/lib64/liblock.so(+0x4db1)[0x7fa067f9cdb1]
/usr/lib64/liblock.so(lock_acquire+0x97)[0x7fa067f9d8b4]
./perf(cmd_sched+0xb166)[0x42d976]
./perf[0x419793]
./perf(main+0x529)[0x418f59]
/lib64/libc.so.6(__libc_start_main+0xed)[0x7fa063ae591d]
./perf[0x4190d9]

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/Makefile                 | 22 ++++++++++++++++++++++
 tools/perf/builtin-sched.c          | 31 +++++++++++++++++--------------
 tools/perf/builtin-top.c            | 19 ++++++++++---------
 tools/perf/config/feature-tests.mak | 12 ++++++++++++
 tools/perf/perf.c                   |  4 ++++
 tools/perf/ui/browser.c             | 21 +++++++++++----------
 tools/perf/ui/browsers/annotate.c   | 10 +++++-----
 tools/perf/ui/setup.c               |  4 +++-
 tools/perf/ui/tui/helpline.c        |  4 ++--
 tools/perf/ui/tui/progress.c        |  4 ++--
 tools/perf/ui/tui/setup.c           |  4 ++--
 tools/perf/ui/tui/util.c            |  4 ++--
 tools/perf/ui/ui.h                  |  3 ++-
 tools/perf/util/annotate.c          |  6 +++---
 tools/perf/util/annotate.h          |  3 ++-
 tools/perf/util/evsel.c             |  2 +-
 tools/perf/util/hist.c              |  8 ++++----
 tools/perf/util/hist.h              |  3 ++-
 tools/perf/util/liblock.h           | 17 +++++++++++++++++
 19 files changed, 123 insertions(+), 58 deletions(-)
 create mode 100644 tools/perf/util/liblock.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8ab05e5..13e8795 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -572,6 +572,21 @@ ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
 endif # Libunwind support
 endif # NO_LIBUNWIND
 
+ifndef NO_LIBLOCK
+# for linking with liblock library, run like:
+# make DEBUG=1 LIBLOCK_DIR=/path/to/linux.git/tools/lib/liblock/
+ifdef LIBLOCK_DIR
+	LIBLOCK_CFLAGS  := -I$(LIBLOCK_DIR)/include
+	LIBLOCK_LDFLAGS := -L$(LIBLOCK_DIR)/ -llock
+endif
+
+FLAGS_LIBLOCK=$(LIBLOCK_CFLAGS) $(ALL_CFLAGS) $(LIBLOCK_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBLOCK),$(FLAGS_LIBLOCK),liblock),y)
+	msg := $(warning No liblock found.);
+	NO_LIBLOCK := 1
+endif # liblock support
+endif # NO_LIBLOCK
+
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -621,6 +636,13 @@ ifndef NO_LIBUNWIND
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
+ifndef NO_LIBLOCK
+	BASIC_CFLAGS += -DLIBLOCK_SUPPORT
+	EXTLIBS += $(LIBLOCK_LIBS)
+	BASIC_CFLAGS := $(LIBLOCK_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBLOCK_LDFLAGS) $(BASIC_LDFLAGS)
+endif
+
 ifndef NO_LIBAUDIT
 	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
 	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index cc28b85..5e67c156 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -10,6 +10,7 @@
 #include "util/header.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/liblock.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -125,8 +126,8 @@ struct perf_sched {
 	struct task_desc *pid_to_task[MAX_PID];
 	struct task_desc **tasks;
 	const struct trace_sched_handler *tp_handler;
-	pthread_mutex_t	 start_work_mutex;
-	pthread_mutex_t	 work_done_wait_mutex;
+	liblock_pthread_mutex_t	 start_work_mutex;
+	liblock_pthread_mutex_t	 work_done_wait_mutex;
 	int		 profile_cpu;
 /*
  * Track the current task - that way we can know whether there's any
@@ -468,6 +469,8 @@ static void *thread_func(void *ctx)
 	char comm2[22];
 	int fd;
 
+	liblock_set_thread();
+
 	free(parms);
 
 	sprintf(comm2, ":%s", this_task->comm);
@@ -478,9 +481,9 @@ static void *thread_func(void *ctx)
 again:
 	ret = sem_post(&this_task->ready_for_work);
 	BUG_ON(ret);
-	ret = pthread_mutex_lock(&sched->start_work_mutex);
+	ret = liblock_pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(ret);
-	ret = pthread_mutex_unlock(&sched->start_work_mutex);
+	ret = liblock_pthread_mutex_unlock(&sched->start_work_mutex);
 	BUG_ON(ret);
 
 	cpu_usage_0 = get_cpu_usage_nsec_self(fd);
@@ -495,9 +498,9 @@ again:
 	ret = sem_post(&this_task->work_done_sem);
 	BUG_ON(ret);
 
-	ret = pthread_mutex_lock(&sched->work_done_wait_mutex);
+	ret = liblock_pthread_mutex_lock(&sched->work_done_wait_mutex);
 	BUG_ON(ret);
-	ret = pthread_mutex_unlock(&sched->work_done_wait_mutex);
+	ret = liblock_pthread_mutex_unlock(&sched->work_done_wait_mutex);
 	BUG_ON(ret);
 
 	goto again;
@@ -515,9 +518,9 @@ static void create_tasks(struct perf_sched *sched)
 	err = pthread_attr_setstacksize(&attr,
 			(size_t) max(16 * 1024, PTHREAD_STACK_MIN));
 	BUG_ON(err);
-	err = pthread_mutex_lock(&sched->start_work_mutex);
+	err = liblock_pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(err);
-	err = pthread_mutex_lock(&sched->work_done_wait_mutex);
+	err = liblock_pthread_mutex_lock(&sched->work_done_wait_mutex);
 	BUG_ON(err);
 	for (i = 0; i < sched->nr_tasks; i++) {
 		struct sched_thread_parms *parms = malloc(sizeof(*parms));
@@ -541,7 +544,7 @@ static void wait_for_tasks(struct perf_sched *sched)
 
 	sched->start_time = get_nsecs();
 	sched->cpu_usage = 0;
-	pthread_mutex_unlock(&sched->work_done_wait_mutex);
+	liblock_pthread_mutex_unlock(&sched->work_done_wait_mutex);
 
 	for (i = 0; i < sched->nr_tasks; i++) {
 		task = sched->tasks[i];
@@ -549,12 +552,12 @@ static void wait_for_tasks(struct perf_sched *sched)
 		BUG_ON(ret);
 		sem_init(&task->ready_for_work, 0, 0);
 	}
-	ret = pthread_mutex_lock(&sched->work_done_wait_mutex);
+	ret = liblock_pthread_mutex_lock(&sched->work_done_wait_mutex);
 	BUG_ON(ret);
 
 	cpu_usage_0 = get_cpu_usage_nsec_parent();
 
-	pthread_mutex_unlock(&sched->start_work_mutex);
+	liblock_pthread_mutex_unlock(&sched->start_work_mutex);
 
 	for (i = 0; i < sched->nr_tasks; i++) {
 		task = sched->tasks[i];
@@ -576,7 +579,7 @@ static void wait_for_tasks(struct perf_sched *sched)
 	sched->runavg_parent_cpu_usage = (sched->runavg_parent_cpu_usage * 9 +
 					 sched->parent_cpu_usage)/10;
 
-	ret = pthread_mutex_lock(&sched->start_work_mutex);
+	ret = liblock_pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(ret);
 
 	for (i = 0; i < sched->nr_tasks; i++) {
@@ -1677,8 +1680,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
 		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
-		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
-		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
+		.start_work_mutex     = LIBLOCK_PTHREAD_MUTEX_INITIALIZER(sched.start_work_mutex),
+		.work_done_wait_mutex = LIBLOCK_PTHREAD_MUTEX_INITIALIZER(sched.work_done_wait_mutex),
 		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
 		.sort_order	      = default_sort_order,
 		.replay_repeat	      = 10,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..f8e944c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -40,6 +40,7 @@
 #include "util/xyarray.h"
 #include "util/sort.h"
 #include "util/intlist.h"
+#include "util/liblock.h"
 
 #include "util/debug.h"
 
@@ -137,14 +138,14 @@ static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 
 	notes = symbol__annotation(sym);
 	if (notes->src != NULL) {
-		pthread_mutex_lock(&notes->lock);
+		liblock_pthread_mutex_lock(&notes->lock);
 		goto out_assign;
 	}
 
-	pthread_mutex_lock(&notes->lock);
+	liblock_pthread_mutex_lock(&notes->lock);
 
 	if (symbol__alloc_hist(sym) < 0) {
-		pthread_mutex_unlock(&notes->lock);
+		liblock_pthread_mutex_unlock(&notes->lock);
 		pr_err("Not enough memory for annotating '%s' symbol!\n",
 		       sym->name);
 		sleep(1);
@@ -157,7 +158,7 @@ out_assign:
 		top->sym_filter_entry = he;
 	}
 
-	pthread_mutex_unlock(&notes->lock);
+	liblock_pthread_mutex_unlock(&notes->lock);
 	return err;
 }
 
@@ -210,11 +211,11 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 	sym = he->ms.sym;
 	notes = symbol__annotation(sym);
 
-	if (pthread_mutex_trylock(&notes->lock))
+	if (liblock_pthread_mutex_trylock(&notes->lock))
 		return;
 
 	if (notes->src == NULL && symbol__alloc_hist(sym) < 0) {
-		pthread_mutex_unlock(&notes->lock);
+		liblock_pthread_mutex_unlock(&notes->lock);
 		pr_err("Not enough memory for annotating '%s' symbol!\n",
 		       sym->name);
 		sleep(1);
@@ -224,7 +225,7 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 	ip = he->ms.map->map_ip(he->ms.map, ip);
 	err = symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
 
-	pthread_mutex_unlock(&notes->lock);
+	liblock_pthread_mutex_unlock(&notes->lock);
 
 	if (err == -ERANGE && !he->ms.map->erange_warned)
 		ui__warn_map_erange(he->ms.map, sym, ip);
@@ -243,7 +244,7 @@ static void perf_top__show_details(struct perf_top *top)
 	symbol = he->ms.sym;
 	notes = symbol__annotation(symbol);
 
-	pthread_mutex_lock(&notes->lock);
+	liblock_pthread_mutex_lock(&notes->lock);
 
 	if (notes->src == NULL)
 		goto out_unlock;
@@ -260,7 +261,7 @@ static void perf_top__show_details(struct perf_top *top)
 	if (more != 0)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 out_unlock:
-	pthread_mutex_unlock(&notes->lock);
+	liblock_pthread_mutex_unlock(&notes->lock);
 }
 
 static const char		CONSOLE_CLEAR[] = "[H[2J";
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index f5ac774..2744dda 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -217,6 +217,18 @@ int main(void)
 endef
 endif
 
+ifndef NO_LIBLOCK
+define SOURCE_LIBLOCK
+#include <liblock/mutex.h>
+
+int main(void)
+{
+	liblock_init();
+	return 0;
+}
+endef
+endif
+
 define SOURCE_ON_EXIT
 #include <stdio.h>
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 0f661fb..b4eb842 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/debugfs.h"
+#include "util/liblock.h"
 #include <pthread.h>
 
 const char perf_usage_string[] =
@@ -446,6 +447,9 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
+	liblock_init();
+	liblock_set_thread();
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 4aeb7d5..6bb5375 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -14,6 +14,7 @@
 #include "helpline.h"
 #include "keysyms.h"
 #include "../color.h"
+#include "../util/liblock.h"
 
 static int ui_browser__percent_color(struct ui_browser *browser,
 				     double percent, bool current)
@@ -240,9 +241,9 @@ void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 
 void ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
-	pthread_mutex_lock(&ui__lock);
+	liblock_pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(browser, title);
-	pthread_mutex_unlock(&ui__lock);
+	liblock_pthread_mutex_unlock(&ui__lock);
 }
 
 int ui_browser__show(struct ui_browser *browser, const char *title,
@@ -253,7 +254,7 @@ int ui_browser__show(struct ui_browser *browser, const char *title,
 
 	ui_browser__refresh_dimensions(browser);
 
-	pthread_mutex_lock(&ui__lock);
+	liblock_pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(browser, title);
 
 	browser->title = title;
@@ -265,15 +266,15 @@ int ui_browser__show(struct ui_browser *browser, const char *title,
 	va_end(ap);
 	if (err > 0)
 		ui_helpline__push(browser->helpline);
-	pthread_mutex_unlock(&ui__lock);
+	liblock_pthread_mutex_unlock(&ui__lock);
 	return err ? 0 : -1;
 }
 
 void ui_browser__hide(struct ui_browser *browser __maybe_unused)
 {
-	pthread_mutex_lock(&ui__lock);
+	liblock_pthread_mutex_lock(&ui__lock);
 	ui_helpline__pop();
-	pthread_mutex_unlock(&ui__lock);
+	liblock_pthread_mutex_unlock(&ui__lock);
 }
 
 static void ui_browser__scrollbar_set(struct ui_browser *browser)
@@ -319,9 +320,9 @@ static int __ui_browser__refresh(struct ui_browser *browser)
 
 int ui_browser__refresh(struct ui_browser *browser)
 {
-	pthread_mutex_lock(&ui__lock);
+	liblock_pthread_mutex_lock(&ui__lock);
 	__ui_browser__refresh(browser);
-	pthread_mutex_unlock(&ui__lock);
+	liblock_pthread_mutex_unlock(&ui__lock);
 
 	return 0;
 }
@@ -357,10 +358,10 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 	while (1) {
 		off_t offset;
 
-		pthread_mutex_lock(&ui__lock);
+		liblock_pthread_mutex_lock(&ui__lock);
 		err = __ui_browser__refresh(browser);
 		SLsmg_refresh();
-		pthread_mutex_unlock(&ui__lock);
+		liblock_pthread_mutex_unlock(&ui__lock);
 		if (err < 0)
 			break;
 
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 5dab3ca..d639a9b 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -331,7 +331,7 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	browser->entries = RB_ROOT;
 
-	pthread_mutex_lock(&notes->lock);
+	liblock_pthread_mutex_lock(&notes->lock);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
@@ -342,7 +342,7 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 		}
 		disasm_rb_tree__insert(&browser->entries, bpos);
 	}
-	pthread_mutex_unlock(&notes->lock);
+	liblock_pthread_mutex_unlock(&notes->lock);
 
 	browser->curr_hot = rb_last(&browser->entries);
 }
@@ -413,16 +413,16 @@ static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
 	}
 
 	notes = symbol__annotation(target);
-	pthread_mutex_lock(&notes->lock);
+	liblock_pthread_mutex_lock(&notes->lock);
 
 	if (notes->src == NULL && symbol__alloc_hist(target) < 0) {
-		pthread_mutex_unlock(&notes->lock);
+		liblock_pthread_mutex_unlock(&notes->lock);
 		ui__warning("Not enough memory for annotating '%s' symbol!\n",
 			    target->name);
 		return true;
 	}
 
-	pthread_mutex_unlock(&notes->lock);
+	liblock_pthread_mutex_unlock(&notes->lock);
 	symbol__tui_annotate(target, ms->map, evidx, hbt);
 	ui_browser__show_title(&browser->b, sym->name);
 	return true;
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index ebb4cc1..105c5ba 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -4,10 +4,12 @@
 #include "../util/debug.h"
 #include "../util/hist.h"
 
-pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
+liblock_pthread_mutex_t ui__lock;
 
 void setup_browser(bool fallback_to_pager)
 {
+	liblock_pthread_mutex_init(&ui__lock, NULL);
+
 	if (!isatty(1) || dump_trace)
 		use_browser = 0;
 
diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
index 2884d2f..a0cfc1e 100644
--- a/tools/perf/ui/tui/helpline.c
+++ b/tools/perf/ui/tui/helpline.c
@@ -41,7 +41,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 	int ret;
 	static int backlog;
 
-	pthread_mutex_lock(&ui__lock);
+	liblock_pthread_mutex_lock(&ui__lock);
 	ret = vscnprintf(ui_helpline__last_msg + backlog,
 			sizeof(ui_helpline__last_msg) - backlog, format, ap);
 	backlog += ret;
@@ -51,7 +51,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 		SLsmg_refresh();
 		backlog = 0;
 	}
-	pthread_mutex_unlock(&ui__lock);
+	liblock_pthread_mutex_unlock(&ui__lock);
 
 	return ret;
 }
diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index 6c2184d..dc86655 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -18,7 +18,7 @@ static void tui_progress__update(u64 curr, u64 total, const char *title)
 		return;
 
 	ui__refresh_dimensions(true);
-	pthread_mutex_lock(&ui__lock);
+	liblock_pthread_mutex_lock(&ui__lock);
 	y = SLtt_Screen_Rows / 2 - 2;
 	SLsmg_set_color(0);
 	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
@@ -28,7 +28,7 @@ static void tui_progress__update(u64 curr, u64 total, const char *title)
 	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
 	SLsmg_fill_region(y, 1, 1, bar, ' ');
 	SLsmg_refresh();
-	pthread_mutex_unlock(&ui__lock);
+	liblock_pthread_mutex_unlock(&ui__lock);
 }
 
 static struct ui_progress tui_progress_fns =
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 81efa19..04aeeea 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -21,10 +21,10 @@ void ui__refresh_dimensions(bool force)
 {
 	if (force || ui__need_resize) {
 		ui__need_resize = 0;
-		pthread_mutex_lock(&ui__lock);
+		liblock_pthread_mutex_lock(&ui__lock);
 		SLtt_get_screen_size();
 		SLsmg_reinit_smg();
-		pthread_mutex_unlock(&ui__lock);
+		liblock_pthread_mutex_unlock(&ui__lock);
 	}
 }
 
diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
index 092902e..19ac265 100644
--- a/tools/perf/ui/tui/util.c
+++ b/tools/perf/ui/tui/util.c
@@ -215,9 +215,9 @@ static int __ui__warning(const char *title, const char *format, va_list args)
 	if (vasprintf(&s, format, args) > 0) {
 		int key;
 
-		pthread_mutex_lock(&ui__lock);
+		liblock_pthread_mutex_lock(&ui__lock);
 		key = ui__question_window(title, s, "Press any key...", 0);
-		pthread_mutex_unlock(&ui__lock);
+		liblock_pthread_mutex_unlock(&ui__lock);
 		free(s);
 		return key;
 	}
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index d86359c..d0faaee 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -4,8 +4,9 @@
 #include <pthread.h>
 #include <stdbool.h>
 #include <linux/compiler.h>
+#include "../util/liblock.h"
 
-extern pthread_mutex_t ui__lock;
+extern liblock_pthread_mutex_t ui__lock;
 
 extern int use_browser;
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 07aaeea..31ac327 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -422,7 +422,7 @@ static struct ins *ins__find(const char *name)
 int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	pthread_mutex_init(&notes->lock, NULL);
+	liblock_pthread_mutex_init(&notes->lock, NULL);
 	return 0;
 }
 
@@ -456,11 +456,11 @@ void symbol__annotate_zero_histograms(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
 
-	pthread_mutex_lock(&notes->lock);
+	liblock_pthread_mutex_lock(&notes->lock);
 	if (notes->src != NULL)
 		memset(notes->src->histograms, 0,
 		       notes->src->nr_histograms * notes->src->sizeof_sym_hist);
-	pthread_mutex_unlock(&notes->lock);
+	liblock_pthread_mutex_unlock(&notes->lock);
 }
 
 int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 8eec943..1323cff 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -9,6 +9,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <pthread.h>
+#include "liblock.h"
 
 struct ins;
 
@@ -101,7 +102,7 @@ struct annotated_source {
 };
 
 struct annotation {
-	pthread_mutex_t		lock;
+	liblock_pthread_mutex_t	lock;
 	struct annotated_source *src;
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..5bb7281 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -47,7 +47,7 @@ void hists__init(struct hists *hists)
 	hists->entries_in = &hists->entries_in_array[0];
 	hists->entries_collapsed = RB_ROOT;
 	hists->entries = RB_ROOT;
-	pthread_mutex_init(&hists->lock, NULL);
+	liblock_pthread_mutex_init(&hists->lock, NULL);
 }
 
 void perf_evsel__init(struct perf_evsel *evsel,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cb17e2a..f0a847e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -277,7 +277,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	struct hist_entry *he;
 	int cmp;
 
-	pthread_mutex_lock(&hists->lock);
+	liblock_pthread_mutex_lock(&hists->lock);
 
 	p = &hists->entries_in->rb_node;
 
@@ -319,7 +319,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
 out_unlock:
-	pthread_mutex_unlock(&hists->lock);
+	liblock_pthread_mutex_unlock(&hists->lock);
 	return he;
 }
 
@@ -463,13 +463,13 @@ static struct rb_root *hists__get_rotate_entries_in(struct hists *hists)
 {
 	struct rb_root *root;
 
-	pthread_mutex_lock(&hists->lock);
+	liblock_pthread_mutex_lock(&hists->lock);
 
 	root = hists->entries_in;
 	if (++hists->entries_in > &hists->entries_in_array[1])
 		hists->entries_in = &hists->entries_in_array[0];
 
-	pthread_mutex_unlock(&hists->lock);
+	liblock_pthread_mutex_unlock(&hists->lock);
 
 	return root;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a5..f0eabd8 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "liblock.h"
 
 extern struct callchain_param callchain_param;
 
@@ -65,7 +66,7 @@ struct hists {
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
 	const char		*symbol_filter_str;
-	pthread_mutex_t		lock;
+	liblock_pthread_mutex_t	lock;
 	struct events_stats	stats;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
diff --git a/tools/perf/util/liblock.h b/tools/perf/util/liblock.h
new file mode 100644
index 0000000..55d7cc9
--- /dev/null
+++ b/tools/perf/util/liblock.h
@@ -0,0 +1,17 @@
+#ifdef LIBLOCK_SUPPORT
+
+#include <liblock/mutex.h>
+
+#else
+
+#define LIBLOCK_PTHREAD_MUTEX_INITIALIZER(mtx) PTHREAD_MUTEX_INITIALIZER
+#define liblock_init()
+#define liblock_set_thread()
+#define liblock_pthread_mutex_t         pthread_mutex_t
+#define liblock_pthread_mutex_init      pthread_mutex_init
+#define liblock_pthread_mutex_lock      pthread_mutex_lock
+#define liblock_pthread_mutex_unlock    pthread_mutex_unlock
+#define liblock_pthread_mutex_trylock   pthread_mutex_trylock
+#define liblock_pthread_mutex_destroy   pthread_mutex_destroy
+
+#endif
-- 
1.8.1.1

