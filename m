Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3FGWWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:22:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3FGWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:22:34 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 4/4] perf: add timehist command
Date: Fri,  7 Jun 2013 16:22:14 -0600
Message-Id: <1370643734-9579-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
References: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf timehist provides an analysis of scheduling event data. Right now
it uses the context-switch softwar event; it needs to be updated to use
the scheduling tracepoints along with analysis enhancements those
tracepoints provide. For now, the context switch event provides a
well-tested start point.

This command has been extremely helpful debugging systems with heavy
CPU contention.

Use case:
1. collect context switch data for the system (or cpu) along with
   the stack trace:
       perf record -e cs -c 1 -ag -- <workload>

2. run the timehist command to show the time between schedule-in
   times (ie., how long did the task go between access to the CPU)
   as well as run times (ie., how long did the task run once scheduled)
   and the stack trace of the task when scheduled out:

       perf timehist

time          cpu  task [tid/pid]    b/n time  run time
------------- ---- ----------------- --------- ---------
227959.352628 [02] make[17133]       0.004877  0.000285  do_wait         sys_wait4 ...
227959.352762 [03] sh[17136]         0.000000  0.000135  __cond_resched  _cond_resched  ...
227959.352777 [03] migration/3[23]   0.003163  0.000014  smpboot_thread_fn kthread      ...
227959.352801 [02] <idle>            0.000285  0.000173  cpu_idle        start_secondary
227959.353552 [02] sh[17136]         0.000038  0.000750  do_exit         do_group_exit   ...
227959.353564 [04] <idle>            0.000014  0.001113  cpu_idle        start_secondary
227959.353722 [04] make[17133]       0.000936  0.000157  do_exit         do_group_exit   ...
227959.353761 [06] <idle>            0.001210  0.021919  cpu_idle        start_secondary
227959.353900 [06] make[17127]       0.001310  0.000139  wait_for_completion_killable do_fork ...
227959.353921 [03] <idle>            0.000150  0.001143  cpu_idle        start_secondary
227959.353945 [03] make[17137]       0.000000  0.000023  __cond_resched  _cond_resched   ...
227959.353962 [03] migration/3[23]   0.001167  0.000017  smpboot_thread_fn kthread         ret_from_fork
227959.353990 [02] <idle>            0.000750  0.000438  cpu_idle        start_secondary
227959.354034 [03] <idle>            0.000041  0.000071  cpu_idle        start_secondary
227959.354044 [03] rcu_sched[10]     0.002931  0.000010  rcu_gp_kthread  kthread         ret_from_fork
227959.354089 [06] <idle>            0.000139  0.000189  cpu_idle        start_secondary
227959.354096 [06] rcu_sched[10]     0.000044  0.000006  rcu_gp_kthread  kthread         ret_from_fork
227959.354110 [06] make[17127]       0.000195  0.000014  pipe_wait       pipe_read       ...
227959.354382 [00] <idle>            0.000013  0.003307  cpu_idle        rest_init       ...
227959.354452 [00] qemu-kvm[25781/25777]  0.000000  0.000069  kvm_vcpu_block  kvm_arch_vcpu_ioctl_run ...
227959.354498 [04] <idle>                 0.000157  0.000776  cpu_idle        start_secondary

Additional options:
  i. --cpu-visual - useful for multi-core. Adds a field to highlight
                    visually which cpu had an event

 ii. --summary - show a run time summary of how long each task ran over
                 the time interval analyzed

Runtime summary (times are in seconds)
                     comm  parent  number  run-time    min-run    max-run   avg-run  stddev(%)
...
          qemu-kvm[25777]     -1       8   0.000398   0.000037   0.000076   0.000049   8.99
    qemu-kvm[25781/25777]     -1      22   0.001532   0.000040   0.000193   0.000069  10.39
    qemu-kvm[25782/25777]     -1      21   0.001536   0.000038   0.000255   0.000073  14.13
              sshd[28339]     -1      12   0.001337   0.000073   0.000129   0.000111   4.69
...

Terminated tasks:
                sh[17126]  17125       2   0.000778
              make[17125]  17124       3   0.002007
                sh[17129]  17128       2   0.000945
                sh[17130]  17128       2   0.001600
              make[17128]  17127       4   0.002272
...

iii. --tree - show parent-child summary with runtimes:

Parent-child relationships
--------------------------
...
perf[17124]  0.002964
    make[17125]  0.002007
        sh[17126]  0.000778
    make[17127]  0.101272
        make[17128]  0.002272
            sh[17129]  0.000945
            sh[17130]  0.001600
        make[17131]  0.001888
        make[17132]  0.000715
        make[17133]  0.002273
            sh[17134]  0.002230
                gcc[17135]  0.002527
            sh[17136]  0.000886
        make[17137]  0.002408
            sh[17138]  0.002420
                gcc[17139]  0.010634
                gcc[17140]  0.006208

This command has been a work in progress for years and many more options
and features will be added in time.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile           |    2 +
 tools/perf/builtin-timehist.c | 1047 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h          |    1 +
 tools/perf/perf.c             |    1 +
 tools/perf/perf.h             |    3 +
 tools/perf/util/time-utils.c  |  230 +++++++++
 tools/perf/util/time-utils.h  |   12 +
 7 files changed, 1296 insertions(+)
 create mode 100644 tools/perf/builtin-timehist.c
 create mode 100644 tools/perf/util/time-utils.c
 create mode 100644 tools/perf/util/time-utils.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 203cb0e..731d1a4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -423,6 +423,8 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
+BUILTIN_OBJS += $(OUTPUT)builtin-timehist.o
+BUILTIN_OBJS += $(OUTPUT)util/time-utils.o
 
 PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 
diff --git a/tools/perf/builtin-timehist.c b/tools/perf/builtin-timehist.c
new file mode 100644
index 0000000..ce2ee38
--- /dev/null
+++ b/tools/perf/builtin-timehist.c
@@ -0,0 +1,1047 @@
+#include "builtin.h"
+
+#include "perf.h"
+#include "util/cache.h"
+#include "util/debug.h"
+#include "util/exec_cmd.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/session.h"
+#include "util/tool.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/trace-event.h"
+#include "util/util.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include "util/strlist.h"
+#include "util/time-utils.h"
+#include <linux/bitmap.h>
+#include <math.h>
+
+static char idle_comm[] = "<idle>";
+
+static bool		hide_unresolved;
+static bool		no_callchain;
+static bool		force;
+static const char		*cpu_list;
+static const char      *excl_sym_list_str;
+struct strlist         *excl_sym_list;
+static u32		max_cpus;
+static bool		show_cpu_visual;
+static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+static const char	*time_str;
+static bool		show_summary;
+static bool		show_tree;
+
+struct thread_runtime {
+	struct list_head children;
+	struct list_head node;
+
+	u64   last_time;
+	u64   total_run_time;
+	u64   count;
+	u64   min_run_time;
+	u64   max_run_time;
+	double mean, M2;
+	char commstr[32];
+};
+
+struct evsel_runtime {
+	u64 *last_time; /* time this event was last seen */
+	u32 ncpu;       /* highest cpu slot allocated */
+};
+
+/* track idle times per cpu */
+static struct thread **idle_threads;
+static int idle_max_cpu;
+
+static char default_tod_fmt[] = "%H:%M:%S";
+static char *tod_fmt = default_tod_fmt;
+
+enum perf_output_field {
+	PERF_OUTPUT_COMM            = 1U << 0,
+	PERF_OUTPUT_TID             = 1U << 1,
+	PERF_OUTPUT_PID             = 1U << 2,
+	PERF_OUTPUT_TIME            = 1U << 3,
+	PERF_OUTPUT_CPU             = 1U << 4,
+	PERF_OUTPUT_EVNAME          = 1U << 5,
+	PERF_OUTPUT_TRACE           = 1U << 6,
+	PERF_OUTPUT_IP              = 1U << 7,
+	PERF_OUTPUT_SYM             = 1U << 8,
+	PERF_OUTPUT_DSO             = 1U << 9,
+	PERF_OUTPUT_ADDR            = 1U << 10,
+	PERF_OUTPUT_TIMEOFDAY       = 1U << 11,
+	PERF_OUTPUT_DT              = 1U << 12,
+};
+
+static int perf_event_attr__check_stype(struct perf_event_attr *attr,
+				  u64 sample_type, const char *sample_msg)
+{
+	if (attr->sample_type & sample_type)
+		return 0;
+
+	pr_err("Samples do not have %s attribute set.\n", sample_msg);
+	return -1;
+}
+
+static int perf_evsel__check_attr(struct perf_evsel *evsel)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
+	if (perf_event_attr__check_stype(attr, PERF_SAMPLE_IP, "IP"))
+		return -EINVAL;
+
+	if (!no_callchain &&
+	    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
+		symbol_conf.use_callchain = false;
+
+	if (perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID"))
+		return -EINVAL;
+
+	if (perf_event_attr__check_stype(attr, PERF_SAMPLE_TIME, "TIME"))
+		return -EINVAL;
+
+	if (perf_event_attr__check_stype(attr, PERF_SAMPLE_CPU, "CPU"))
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * verify all user requested events exist and the samples
+ * have the expected data
+ */
+static int perf_session__check_output_opt(struct perf_session *session)
+{
+	struct perf_evsel *evsel;
+
+	evsel = perf_session__find_first_evtype(session, PERF_TYPE_SOFTWARE);
+	if (!evsel) {
+		pr_err("No software events exist in this file.\n");
+		return -1;
+	}
+
+	return perf_evsel__check_attr(evsel);
+}
+
+static unsigned int max_stack_depth = 5;
+
+/* based on perf_session__print_ip */
+static void my_print_ip(struct perf_sample *sample, struct addr_location *al,
+		struct machine *machine, struct perf_evsel *evsel)
+{
+	struct callchain_cursor *cursor = &callchain_cursor;
+	struct callchain_cursor_node *node;
+	const char *symname, *dsoname;
+	char ipbuf[32];
+	int i;
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+
+		if (machine__resolve_callchain(machine, evsel, al->thread,
+						sample, NULL) != 0) {
+			if (verbose)
+				error("Failed to resolve callchain. Skipping\n");
+			return;
+		}
+		callchain_cursor_commit(cursor);
+
+		i = max_stack_depth;
+		while (i) {
+			node = callchain_cursor_current(cursor);
+			if (!node)
+				break;
+
+			if (node->sym && node->sym->name)
+				symname = node->sym->name;
+			else if (!hide_unresolved) {
+				snprintf(ipbuf, sizeof(ipbuf), " %-16" PRIx64, node->ip);
+				symname = ipbuf;
+			} else
+				goto next;
+
+			if (!strlist__has_entry(excl_sym_list, symname)) {
+					printf(" %-15s", symname);
+					i--;
+			}
+next:
+			callchain_cursor_advance(cursor);
+		}
+
+	} else {
+		if (al->sym && al->sym->name)
+			printf(" %s", al->sym->name);
+		else
+			printf(" %" PRIx64, sample->ip);
+
+		if (al->map && al->map->dso && al->map->dso->name)
+			dsoname = al->map->dso->name;
+		else
+			dsoname = "";
+
+		printf(" (%s)", dsoname);
+	}
+}
+
+static inline void printf_nsecs(unsigned long long nsecs, int width_sec)
+{
+	unsigned long secs;
+	unsigned long usecs;
+
+	secs = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs = nsecs / NSECS_PER_USEC;
+	printf("%*lu.%06lu ", width_sec, secs, usecs);
+}
+
+static void perf_evsel__save_time(struct perf_evsel *evsel,
+				  u64 timestamp, u32 cpu)
+{
+	struct evsel_runtime *r = evsel->priv;
+
+	if (r == NULL) {
+		r = zalloc(sizeof(struct evsel_runtime));
+		if (r == NULL)
+			return;
+
+		evsel->priv = r;
+	}
+
+	if ((cpu > r->ncpu) || (r->last_time == NULL)) {
+		unsigned int i;
+
+		/* TO-DO: handle failure */
+		r->last_time = realloc(r->last_time, (cpu+1) * sizeof(u64));
+		if (!r->last_time)
+			return;
+
+		i = r->ncpu ? r->ncpu + 1 : 0;
+		for (; i <= cpu; ++i)
+			r->last_time[i] = (u64) 0;
+
+		r->ncpu = cpu;
+	}
+
+	r->last_time[cpu] = timestamp;
+}
+
+static u64 perf_evsel__get_time(struct perf_evsel *evsel, u32 cpu)
+{
+	struct evsel_runtime *r = evsel->priv;
+
+	if (r == NULL)
+		return 0;
+
+	if (!r->last_time)
+		return 0;
+
+	if ((cpu > r->ncpu) || (r->last_time == NULL))
+		return 0;
+
+	return r->last_time[cpu];
+}
+
+static void perf_timehist__header(void)
+{
+	u32 i, j;
+
+	printf("%-15s %-4s", "time", "cpu");
+	if (max_cpus) {
+		printf(" ");
+		for (i = 0, j = 0; i < max_cpus; ++i) {
+			printf("%x", j++);
+			if (j > 15)
+				j = 0;
+		}
+		printf(" ");
+	}
+	printf(" %-20s %9s %9s",
+		"task name[tid/pid]", "b/n time", "run time");
+
+	printf("\n");
+
+	printf("%15s %4s", "---------------", "----");
+	if (max_cpus) {
+		printf(" ");
+		for (i = 0; i < max_cpus; ++i)
+			printf("-");
+		printf(" ");
+	}
+
+	printf(" %20s %9s %9s",
+		"--------------------", "---------", "---------");
+
+	printf("\n");
+}
+
+static unsigned int comm_width = 20;
+
+static void timehist_set_commstr(struct thread *thread,
+				 pid_t pid, pid_t tid)
+{
+	unsigned int i, n;
+	struct thread_runtime *r = thread__priv(thread);
+
+	if ((r == NULL) || (*r->commstr != '\0'))
+		return;
+
+	if (thread->pid == 0) {
+		snprintf(r->commstr, sizeof(r->commstr)-1, "%s", thread->comm);
+
+	} else if (tid != pid) {
+		snprintf(r->commstr, sizeof(r->commstr)-1, "%s[%d/%d]",
+			 thread->comm, tid, pid);
+	} else {
+		snprintf(r->commstr, sizeof(r->commstr)-1, "%s[%d]",
+			 thread->comm, tid);
+	}
+
+	for (i = 0; i < strlen(r->commstr); ++i) {
+		if (r->commstr[i] == ' ')
+			r->commstr[i] = '-';
+	}
+
+	n = strlen(r->commstr);
+	if (n > comm_width)
+		comm_width = n;
+}
+
+static char *timehist_time_str(char *tstr, int len, u64 t)
+{
+	unsigned long secs, usecs;
+	unsigned long long nsecs;
+
+	if (perf_time__tod_str(tstr, len, t, tod_fmt)) {
+		nsecs = t;
+		secs = nsecs / NSECS_PER_SEC;
+		nsecs -= secs * NSECS_PER_SEC;
+		usecs = nsecs / NSECS_PER_USEC;
+		snprintf(tstr, len, "%5lu.%06lu", secs, usecs);
+	}
+
+	return tstr;
+}
+
+static void print_sample_start(struct perf_sample *sample,
+				const char *comm,
+				u64 dt_btwn, u64 dt_event)
+{
+	char tstr[64];
+
+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
+
+	printf("[%02d] ", sample->cpu);
+	/* give the user a visual */
+	if (max_cpus) {
+		u32 i;
+		char c;
+		for (i = 0; i < max_cpus; ++i) {
+			c = i == sample->cpu ? 's' : ' ';
+			printf("%c", c);
+		}
+		printf("  ");
+	}
+
+	printf("%-*s ", comm_width, comm);
+
+	printf_nsecs(dt_btwn, 2);
+	printf_nsecs(dt_event, 2);
+}
+
+static u64 nevents;
+
+static void process_event(struct perf_sample *sample,
+			  struct perf_evsel *evsel,
+			  struct machine *machine,
+			  struct thread *thread,
+			  struct addr_location *al)
+{
+	u64 dt_task = 0, dt_event = 0, tprev, dt_btwn = 0;
+	struct thread_runtime *r = thread__priv(thread);
+	double delta;
+
+	/*
+	 * if we have not already done so, set the commstr for this task
+	 */
+	timehist_set_commstr(thread, sample->pid, sample->tid);
+
+	/*
+	 * compute time between events on the cpu -- this is the
+	 * run time for the current task
+	 */
+	tprev = perf_evsel__get_time(evsel, sample->cpu);
+	if (tprev)
+		dt_event = sample->time - tprev;
+
+	/* for context switches we can compute the time between task
+	 * schedulings by taking the time between task sightings and
+	 * removing the time between last sched event
+	 */
+	if (r->last_time)
+		dt_task = sample->time - r->last_time;
+
+	if (dt_task > dt_event)
+		dt_btwn = dt_task - dt_event;
+
+	/*
+	 * update run time stats for this thread
+	 */
+	r->count++;
+	r->total_run_time += dt_event;
+
+	delta = dt_event - r->mean;
+	r->mean += delta / r->count;
+	r->M2 += delta * (dt_event - r->mean);
+
+	if (dt_event > r->max_run_time)
+		r->max_run_time = dt_event;
+
+	if (dt_event < r->min_run_time)
+		r->min_run_time = dt_event;
+
+
+	if (!quiet) {
+		print_sample_start(sample, r->commstr, dt_btwn, dt_event);
+		my_print_ip(sample, al, machine, evsel);
+		printf("\n");
+	}
+}
+
+static bool is_idle_sym(const char *symname)
+{
+	static const char * const idle_symbols[] = {
+		"cpu_idle",
+		"intel_idle",
+		"default_idle",
+		"native_safe_halt",
+		"enter_idle",
+		"exit_idle",
+		"mwait_idle",
+		"mwait_idle_with_hints",
+		"poll_idle",
+		"ppc64_runlatch_off",
+		"pseries_dedicated_idle_sleep",
+		NULL
+	};
+
+	int i;
+
+	for (i = 0; idle_symbols[i]; i++) {
+		if (!strcmp(idle_symbols[i], symname)) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool is_idle_sample(struct perf_sample *sample, struct addr_location *al,
+			   struct perf_evsel *evsel, struct machine *machine)
+{
+	struct callchain_cursor *cursor = &callchain_cursor;
+	struct callchain_cursor_node *node;
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+
+		if (machine__resolve_callchain(machine, evsel, al->thread,
+					sample, NULL) != 0) {
+			if (verbose)
+				error("Failed to resolve callchain. Skipping\n");
+
+			return false;
+		}
+		callchain_cursor_commit(cursor);
+
+		/* idle symbol should be early in the stack */
+		while (5) {
+			node = callchain_cursor_current(cursor);
+			if (!node)
+				break;
+
+			if (node->sym && node->sym->name && is_idle_sym(node->sym->name))
+				return true;
+
+			callchain_cursor_advance(cursor);
+		}
+		return false;
+	}
+
+	if (!al->sym || !al->sym->name)
+		return false;
+
+	return is_idle_sym(al->sym->name);
+}
+
+static struct thread *get_idle_thread(int cpu)
+{
+	/* expand/allocate array of pointers to local thread
+	 * structs if needed
+	 */
+	if ((cpu > idle_max_cpu) || (idle_threads == NULL)) {
+		int i, j = 15;
+		void *p;
+
+		if (cpu > j)
+			j = cpu;
+		p = realloc(idle_threads, (j+1) * sizeof(struct thread *));
+		if (!p)
+			return NULL;
+
+		idle_threads = (struct thread **) p;
+		i = idle_max_cpu ? idle_max_cpu + 1 : 0;
+		for (; i <= cpu; ++i)
+			idle_threads[i] = NULL;
+
+		idle_max_cpu = cpu;
+	}
+
+	/* allocate the actual thread struct if needed */
+	if (idle_threads[cpu] == NULL) {
+		idle_threads[cpu] = zalloc(sizeof(struct thread));
+		if (idle_threads[cpu]) {
+			idle_threads[cpu]->pid = 0;
+			idle_threads[cpu]->comm = idle_comm;
+		}
+	}
+
+	return idle_threads[cpu];
+}
+
+static struct thread_runtime *thread__init_priv(struct thread *thread)
+{
+	struct thread_runtime *r;
+
+	r = zalloc(sizeof(struct thread_runtime));
+	if (!r)
+		return NULL;
+
+	r->min_run_time = (u64) -1;
+	INIT_LIST_HEAD(&r->children);
+	INIT_LIST_HEAD(&r->node);
+	thread__set_priv(thread, r);
+
+	return r;
+}
+
+static int process_sample_event(struct perf_tool *tool __maybe_unused,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	int rc = 0;
+	const char *evname = NULL;
+	struct thread *thread;
+	struct thread_runtime *r = NULL;
+	struct addr_location al;
+
+	thread = machine__findnew_thread(machine, event->ip.tid, sample->time);
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
+		rc = -1;
+		goto out;
+	}
+
+	/* this command looks solely at scheduling events */
+	evname = perf_evsel__name(evsel);
+	if (!evname ||
+	    (strcmp(evname, "context-switches") && strcmp(evname, "cs")))
+		return 0;
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample, 0) < 0) {
+		pr_err("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	if (al.filtered)
+		goto out;
+
+	if (sample->cpu > 255) {
+		pr_err("invalid cpu id (%d) in event, skipping it.\n", sample->cpu);
+		return -1;
+	}
+
+	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
+		goto out;
+
+	if (is_idle_sample(sample, &al, evsel, machine)) {
+		thread = get_idle_thread(sample->cpu);
+		if (thread == NULL) {
+			pr_err("failed to get idle thread for cpu %d.\n", sample->cpu);
+			return -1;
+		}
+	}
+
+	/* make sure private struct exists before calling process_event */
+	r = thread__priv(thread);
+	if (r == NULL) {
+		r = thread__init_priv(thread);
+		if (r == NULL) {
+			pr_debug("failed to malloc memory for runtime data.\n");
+			rc = -1;
+			goto out;
+		}
+	}
+
+	if (perf_time__skip_sample(sample))
+		goto out;
+
+	process_event(sample, evsel, machine, thread, &al);
+
+	nevents++;
+	evsel->hists.stats.total_period += sample->period;
+
+out:
+	if (thread && r)
+		r->last_time = sample->time;
+	perf_evsel__save_time(evsel, sample->time, sample->cpu);
+
+	return rc;
+}
+
+static int process_lost(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample,
+			struct machine *machine)
+{
+	struct addr_location al;
+	char tstr[64];
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample, 0) < 0) {
+		pr_err("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
+	printf("lost %" PRIu64 " events on cpu %d\n", event->lost.lost, sample->cpu);
+
+	return 0;
+}
+
+static struct perf_tool perf_timehist = {
+	.sample		 = process_sample_event,
+	.mmap		 = perf_event__process_mmap,
+	.comm		 = perf_event__process_comm,
+	.exit        = perf_event__process_exit,
+	.fork        = perf_event__process_fork,
+	.lost		 = process_lost,
+	.attr		 = perf_event__process_attr,
+	.event_type	 = perf_event__process_event_type,
+	.tracing_data	 = perf_event__process_tracing_data,
+	.build_id	 = perf_event__process_build_id,
+	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
+};
+
+
+static void timehist_add_child(struct thread *t,
+			       struct thread *p)
+{
+	struct thread_runtime *rc, *rp;
+
+	if (p == NULL) {
+		pr_err("add_child: no parent entry for child %d ppid %d\n",
+			   t->pid, t->ppid);
+		return;
+	}
+
+	rc = thread__priv(t);
+	if (rc == NULL) {
+		rc = thread__init_priv(t);
+		timehist_set_commstr(t, t->pid, t->pid);
+	}
+
+	rp = thread__priv(p);
+	if (rp == NULL) {
+		rp = thread__init_priv(p);
+		timehist_set_commstr(p, p->pid, p->pid);
+	}
+
+	if (rc == NULL || rp == NULL) {
+		pr_err("r = %p for tid %d, r = %p for tid %d\n",
+		       rc, t->pid, rp, p->pid);
+		return;
+	}
+
+	if (list_empty(&rc->node)) {
+		list_add_tail(&rc->node, &rp->children);
+	} else
+		pr_err("thread %s already on a list\n", rc->commstr);
+}
+
+static void pstree_print_entry(const char *comm, u64 run_time)
+{
+		printf("%s ", comm);
+		printf_nsecs(run_time, 2);
+		printf("\n");
+}
+
+static void pstree_print_children(struct thread_runtime *r, int depth)
+{
+	struct thread_runtime *next;
+
+	depth++;
+
+	list_for_each_entry(next, &r->children, node) {
+
+		/* processes outside of analysis window */
+		if (next->total_run_time == 0 && time_str)
+			continue;
+
+		printf("%*s", 4*depth, " ");
+		pstree_print_entry(next->commstr, next->total_run_time);
+		pstree_print_children(next, depth);
+	}
+}
+
+static void pstree_print_thread(struct thread *t)
+{
+	struct thread_runtime *r;
+
+	r = thread__priv(t);
+	if (r) {
+		/* only print trees from top parent. skip processes with 0
+		 * runtime if a time window was given
+		 */
+		if ((t->ppid == -1) && (r->total_run_time || time_str == NULL)) {
+			pstree_print_entry(r->commstr, r->total_run_time);
+			pstree_print_children(r, 0);
+			printf("\n");
+		}
+
+	}
+}
+
+static void timehist_pstree(struct perf_session *session)
+{
+	struct machine *m = &session->machines.host;
+	struct rb_node *nd;
+	struct thread *t, *p;
+
+	/* first, link children to parent */
+	nd = rb_first(&m->threads);
+	while (nd) {
+		t = rb_entry(nd, struct thread, rb_node);
+
+		if (t->ppid > 0) {
+			p = machine__find_thread(m, t->ppid, (u64)-1);
+			timehist_add_child(t, p);
+		}
+
+		nd = rb_next(nd);
+	}
+
+	/* repeat for terminated tasks */
+	list_for_each_entry(t, &m->dead_threads, node) {
+		if (t->ppid > 0) {
+			p = machine__find_thread(m, t->ppid, (u64)-1);
+			timehist_add_child(t, p);
+		}
+	}
+
+	printf("\n\nParent-child relationships\n");
+	printf("--------------------------\n");
+
+	nd = rb_first(&m->threads);
+	while (nd) {
+		t = rb_entry(nd, struct thread, rb_node);
+		pstree_print_thread(t);
+		nd = rb_next(nd);
+	}
+
+	/* repeat for terminated tasks */
+	list_for_each_entry(t, &m->dead_threads, node) {
+		pstree_print_thread(t);
+	}
+}
+
+static void timehist_print_summary(struct perf_session *session)
+{
+	struct machine *m = &session->machines.host;
+	struct rb_node *nd;
+	struct thread *t;
+	struct thread_runtime *r;
+	u64 total_run_time = 0;
+	u64 total_count = 0;
+	int i, total_task = 0;
+
+	printf("\n\nRuntime summary (times are in seconds)\n");
+	printf("    %*s  parent  number  ", comm_width, "comm");
+	printf("run-time    min-run    max-run   avg-run  stddev(%%)\n");
+
+	nd = rb_first(&m->threads);
+	while (nd) {
+		t = rb_entry(nd, struct thread, rb_node);
+
+		r = thread__priv(t);
+		if (r && r->count) {
+			total_count += r->count;
+			total_run_time += r->total_run_time;
+
+			printf("    %*s  %5d  %6" PRIu64 "  ",
+				   comm_width, r->commstr, t->ppid, r->count);
+			printf_nsecs(r->total_run_time, 2);
+			if (r->count > 1) {
+				double variance;
+				float stddev;
+
+				variance = r->M2 / (r->count - 1);
+				stddev = 100.0 * sqrt(variance / r->count) / r->mean;
+
+				printf(" ");
+				printf_nsecs(r->min_run_time, 2);
+				printf(" ");
+				printf_nsecs(r->max_run_time, 2);
+				if (r->count > 2) {
+					printf(" ");
+					printf_nsecs((u64) r->mean, 2);
+					printf(" ");
+					printf("%5.2f", stddev);
+				}
+			}
+			printf("\n");
+
+			total_task++;
+		}
+
+		nd = rb_next(nd);
+	}
+
+	printf("\nTerminated tasks:\n");
+	list_for_each_entry(t, &m->dead_threads, node) {
+		r = thread__priv(t);
+		if (r && r->count) {
+			total_count += r->count;
+			total_run_time += r->total_run_time;
+
+			printf("    %*s  %5d  %6" PRIu64 "  ",
+				   comm_width, r->commstr, t->ppid, r->count);
+			printf_nsecs(r->total_run_time, 2);
+			printf("\n");
+
+			total_task++;
+		}
+	}
+
+	printf("\nIdle stats:\n");
+	for (i = 0; i <= idle_max_cpu; ++i) {
+		t = idle_threads[i];
+		if (t) {
+			r = thread__priv(t);
+			if (r && r->count) {
+				total_count += r->count;
+
+				printf("    CPU %2d idle for ", i);
+				printf_nsecs(r->total_run_time, 2);
+				printf("\n");
+			}
+		}
+	}
+
+
+	printf("\n"
+	       "    Total number of unique tasks: %d\n"
+	       "Total number of context switches: %" PRIu64 "\n"
+	       "            Total run time (sec): ",
+		   total_task, total_count);
+	printf_nsecs(total_run_time, 2);
+	printf("\n");
+}
+
+static int __cmd_timehist(struct perf_session *session)
+{
+	int ret;
+
+	max_cpus = session->header.env.nr_cpus_online;
+
+	if (show_cpu_visual && max_cpus == 0)
+		pr_err("Failed to lookup max cpus; cannot give CPU visual\n");
+
+	if (max_cpus > 0) {
+		idle_max_cpu = max_cpus - 1;
+		idle_threads = zalloc(max_cpus * sizeof(struct thread *));
+		if (!show_cpu_visual)
+			max_cpus = 0;
+	}
+
+	if (!quiet)
+		perf_timehist__header();
+
+	ret = perf_session__process_events(session, &perf_timehist);
+
+	if (nevents == 0) {
+		printf("No scheduling related events found.\n");
+		goto out;
+	}
+
+	if (show_summary)
+		timehist_print_summary(session);
+
+	if (show_tree)
+		timehist_pstree(session);
+
+out:
+	return ret;
+}
+
+static int parse_tod_format(const struct option *opt __maybe_unused,
+			    const char *arg, int unset __maybe_unused)
+{
+	char date[128];
+	size_t rc;
+	struct tm ltime;
+
+	if (strlen(arg) == 0) {
+		pr_debug("Time-of-day strings will be suppressed\n");
+		goto out;
+	}
+
+	/* test input string for validity and length of output */
+	localtime_r(0, &ltime);
+	rc = strftime(date, sizeof(date), arg, &ltime);
+	if (rc == 0) {
+		fprintf(stderr, "Invalid format string for time-of-day\n");
+		return -EINVAL;
+	}
+
+out:
+	if (tod_fmt != default_tod_fmt)
+		free(tod_fmt);
+
+	tod_fmt = strdup(arg);
+	if (!tod_fmt) {
+		fprintf(stderr, "Failed to copy time-of-day format string\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/* list of symbols to exclude from stack dump */
+static int setup_excl_sym(void)
+{
+	char buf[4096];
+
+	snprintf(buf, sizeof(buf),
+			"schedule,__schedule,"
+			"schedule_timeout,schedule_timeout_interruptible,"
+			"schedule_hrtimeout_range_clock,schedule_hrtimeout_range"
+			"syscall,system_call_done,ia32_syscall_done,"
+			"%s", excl_sym_list_str);
+
+	if (setup_list(&excl_sym_list, buf, "excl_sym") < 0)
+		return -1;
+
+	return 0;
+}
+
+static const char * const timehist_usage[] = {
+	"perf timehist [<options>]",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_BOOLEAN('G', "hide-call-graph", &no_callchain,
+		    "When printing symbols do not display call chain"),
+	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
+		    "Only display entries resolved to a symbol"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
+	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only display events for these comms"),
+	OPT_STRING('x', "excl", &excl_sym_list_str, "sym[,sym...]",
+		   "symbols to skip in backtrace"),
+	OPT_UINTEGER('s', "stack-depth", &max_stack_depth,
+		   "Maximum number of functions to display backtrace."),
+	OPT_CALLBACK(0, "tod", NULL, "str",
+	     "Format for time-of-day strings. Option is passed to strftime; microseconds are appended. Default is %H:%M:%S.",
+		     parse_tod_format),
+	OPT_BOOLEAN(0, "cpu-visual", &show_cpu_visual, "Show CPU visual"),
+	OPT_STRING(0, "time", &time_str, "str",
+		   "Time span for analysis (start,stop as " DEFAULT_TOD_FMT ")"),
+	OPT_BOOLEAN(0, "summary", &show_summary, "show task summary"),
+	OPT_BOOLEAN(0, "tree", &show_tree, "show parent-child tree"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "don't print events, just summary"),
+
+	OPT_END()
+};
+
+int cmd_timehist(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	struct perf_session *session;
+	int err;
+
+	argc = parse_options(argc, argv, options, timehist_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (!show_summary && !show_tree && quiet) {
+		pr_err("no output to show. remove -q or add --summary or --tree\n");
+		return -1;
+	}
+
+	if (setup_excl_sym() < 0)
+		return -1;
+
+	if (symbol__init() < 0)
+		return -1;
+
+	if (!symbol_conf.vmlinux_name && !symbol_conf.kallsyms_name) {
+		pr_err("kernel symbols not given. If this is an offline analysis idle time computations will be wrong\n");
+	}
+
+	setup_pager();
+
+	session = perf_session__new(input_name, O_RDONLY, 1, false, &perf_timehist);
+	if (session == NULL)
+		return -ENOMEM;
+
+	if (!no_callchain)
+		symbol_conf.use_callchain = true;
+	else
+		symbol_conf.use_callchain = false;
+
+	err = perf_session__check_output_opt(session);
+	if (err < 0)
+		goto out;
+
+	if (cpu_list) {
+		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
+			goto out;
+	}
+
+	/* do after reftime has been extracted from header */
+	if (perf_time__parse_str(time_str, NULL) != 0)
+		goto out;
+
+	if (!quiet)
+		perf_session__fprintf_info(session, stdout, true);
+
+	if (time_str)
+		printf("Analyzing events for %s\n", time_str);
+
+	err = __cmd_timehist(session);
+
+out:
+	perf_session__delete(session);
+
+	if (tod_fmt != default_tod_fmt)
+		free(tod_fmt);
+
+	return err;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b210d62..f593f41 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -37,6 +37,7 @@ extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
 extern int cmd_mem(int argc, const char **argv, const char *prefix);
+extern int cmd_timehist(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 85e1aed..dc8ae0d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -61,6 +61,7 @@ static struct cmd_struct commands[] = {
 #endif
 	{ "inject",	cmd_inject,	0 },
 	{ "mem",	cmd_mem,	0 },
+	{ "timehist",   cmd_timehist,   0 },
 };
 
 struct pager_config {
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index c98e9c9..07f17c4 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -128,6 +128,9 @@
 #ifndef USECS_PER_SEC
 #define USECS_PER_SEC           1000000ULL
 #endif
+#ifndef NSEC_PER_USEC
+# define NSEC_PER_USEC         1000ULL
+#endif
 
 static inline unsigned long long rdclock(void)
 {
diff --git a/tools/perf/util/time-utils.c b/tools/perf/util/time-utils.c
new file mode 100644
index 0000000..30c2ef2
--- /dev/null
+++ b/tools/perf/util/time-utils.c
@@ -0,0 +1,230 @@
+#include <string.h>
+#include <sys/time.h>
+#include <time.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include "../perf.h"
+#include "session.h"
+#include "time-utils.h"
+
+static struct timeval tv_ref;
+static u64 timestamp_ref;
+static u64 start_time, end_time;
+
+static int parse_timestr_tod(char *start_str, char *end_str, const char *fmt)
+{
+	struct tm tm, tm_ref;
+	time_t t;
+	u64 tref;
+	char *endp;
+
+	if (timestamp_ref == 0 || tv_ref.tv_usec == 0) {
+		pr_err("timestamp reference not found in header; cannot honor start/end request\n");
+		return -1;
+	}
+
+	/* adjust timestamp_ref back to tv_ref.tv_sec by taking out the
+	 * microseconds element.
+	 */
+	tref = timestamp_ref - tv_ref.tv_usec * NSEC_PER_USEC;
+
+	/* convert tv_ref seconds to tm */
+	t = tv_ref.tv_sec;
+	if (localtime_r(&t, &tm_ref) == NULL) {
+		pr_err("Error converting reference time; cannot honor start/end request\n");
+		return -1;
+	}
+
+	if (*start_str != '\0') {
+		tm = tm_ref;   /* start with our reference time */
+
+		/* update based on the user string */
+		endp = strptime(start_str, fmt, &tm);
+		if (endp == NULL || *endp != '\0') {
+			pr_err("invalid start time string\n");
+			return -1;
+		}
+
+		t = mktime(&tm);
+		if (t > tv_ref.tv_sec)
+			start_time = tref + (t - tv_ref.tv_sec) * NSEC_PER_SEC;
+	}
+
+	if (end_str && *end_str != '\0') {
+		tm = tm_ref;   /* start with our reference time */
+
+		/* update based on the user string */
+		endp = strptime(end_str, fmt, &tm);
+		if (endp == NULL || *endp != '\0') {
+			pr_err("invalid end time string\n");
+			return -1;
+		}
+
+		t = mktime(&tm);
+		if (t < tv_ref.tv_sec) {
+			end_time = 0;
+		} else {
+			end_time = tref + (t - tv_ref.tv_sec) * NSEC_PER_SEC;
+
+			/* if end time is before start time perhaps it is a
+			 * wrap over midnight. really need to add day option
+			 * to time string.
+			 */
+			if (end_time < start_time)
+				end_time += 86400;
+		}
+	}
+	pr_debug("start time %" PRIu64 ", ", start_time);
+	pr_debug("end time %" PRIu64 "\n", end_time);
+
+	return 0;
+}
+
+static int parse_nsec_time(const char *str, u64 *ptime)
+{
+	u64 time_sec, time_nsec;
+	char *end;
+
+	time_sec = strtoul(str, &end, 10);
+	if (*end != '.' && *end != '\0')
+		return -1;
+
+	if (*end == '.') {
+		int i;
+		char nsec_buf[10];
+
+		if (strlen(++end) > 9)
+			return -1;
+
+		strncpy(nsec_buf, end, 9);
+		nsec_buf[9] = '\0';
+
+		/* make it nsec precision */
+		for (i = strlen(nsec_buf); i < 9; i++)
+			nsec_buf[i] = '0';
+
+		time_nsec = strtoul(nsec_buf, &end, 10);
+		if (*end != '\0')
+			return -1;
+	} else
+		time_nsec = 0;
+
+	*ptime = time_sec * NSEC_PER_SEC + time_nsec;
+	return 0;
+}
+
+static int parse_timestr_sec_nsec(char *start_str, char *end_str)
+{
+	if ((*start_str != '\0') &&
+	   (parse_nsec_time(start_str, &start_time) != 0)) {
+		    return -1;
+	}
+
+	if ((end_str && *end_str != '\0') &&
+	   (parse_nsec_time(start_str, &end_time) != 0)) {
+		    return -1;
+	}
+
+	return 0;
+}
+
+int perf_time__parse_str(const char *ostr, const char *fmt)
+{
+	char *start_str, *end_str;
+	char *d, *str;
+	int rc = 0;
+
+	if (ostr == NULL || *ostr == '\0')
+		return 0;
+
+	if (fmt == NULL)
+		fmt = DEFAULT_TOD_FMT;
+
+	/* copy original string because we need to modify it */
+	str = strdup(ostr);
+	if (str == NULL)
+		return -ENOMEM;
+
+	/* str has the format: <start>,<stop>
+	 * variations: <start>,
+	 *             ,<stop>
+	 *             ,
+	 */
+	start_str = str;
+	d = strchr(start_str, ',');
+	if (d) {
+		*d = '\0';
+		++d;
+	}
+	end_str = d;
+
+	/*
+	 * start and end times can be either wall clock as HH:MM:DD
+	 * or perf_clock as second.microseconds
+	 */
+	if ((*start_str != '\0' && strchr(start_str, ':')) ||
+		(*end_str != '\0' && strchr(end_str, ':'))) {
+		rc = parse_timestr_tod(start_str, end_str, fmt);
+	} else {
+		rc = parse_timestr_sec_nsec(start_str, end_str);
+	}
+
+	free(str);
+
+	return rc;
+}
+
+int perf_time__tod_str(char *buf, int buflen, u64 timestamp, const char *fmt)
+{
+	struct tm ltime;
+	u64 dt;
+	struct timeval tv_dt, tv_res;
+
+	if (fmt == NULL)
+		fmt = DEFAULT_TOD_FMT;
+
+	buf[0] = '\0';
+	if (buflen < 64)
+		return -1;
+
+	if ((timestamp_ref == 0) || (timestamp == 0))
+		return -1;
+
+	if (timestamp > timestamp_ref) {
+		dt = timestamp - timestamp_ref;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timeradd(&tv_ref, &tv_dt, &tv_res);
+	} else {
+		dt = timestamp_ref - timestamp;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timersub(&tv_ref, &tv_dt, &tv_res);
+	}
+
+	if (localtime_r(&tv_res.tv_sec, &ltime) == NULL)
+		buf[0] = '\0';
+	else {
+		char date[64];
+		strftime(date, sizeof(date), fmt, &ltime);
+		snprintf(buf, buflen, "%s.%06ld", date, tv_res.tv_usec);
+	}
+
+	return 0;
+}
+
+bool perf_time__skip_sample(struct perf_sample *sample)
+{
+	/* if time is not set don't drop */
+	if (sample->time == 0)
+		return false;
+
+	if (start_time && sample->time < start_time)
+		return true;
+
+	if (end_time && sample->time > end_time)
+		return true;
+
+	return false;
+}
diff --git a/tools/perf/util/time-utils.h b/tools/perf/util/time-utils.h
new file mode 100644
index 0000000..a54110b
--- /dev/null
+++ b/tools/perf/util/time-utils.h
@@ -0,0 +1,12 @@
+#ifndef _TIME_UTIL_H_
+#define _TIME_UTIL_H_
+
+#define DEFAULT_TOD_FMT "%H:%M:%S"
+
+int perf_time__parse_str(const char *str, const char *fmt);
+
+int perf_time__tod_str(char *buf, int buflen, u64 t, const char *fmt);
+
+bool perf_time__skip_sample(struct perf_sample *sample);
+
+#endif
-- 
1.7.10.1

