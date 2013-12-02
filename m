Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3LBAXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 19:23:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LBAXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 19:23:36 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: namhyung@kernel.org, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 1/2] perf sched: Introduce timehist command - v2
Date: Sun,  1 Dec 2013 17:23:14 -0700
Message-Id: <1385943795-11761-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'perf sched timehist' provides an analysis of scheduling events.

Example usage:
    perf sched record -- sleep 1
    perf sched timehist

By default it shows the individual schedule events, including the time between
sched-in events for the task, the task scheduling delay (time between wakeup
and actually running) and run time for the task:

           time cpu  task name[tid/pid]    b/n time sch delay  run time
  ------------- ---- -------------------- --------- --------- ---------
   79371.874569 [11] gcc[31949]               0.014     0.000     1.148
   79371.874591 [10] gcc[31951]               0.000     0.000     0.024
   79371.874603 [10] migration/10[59]         3.350     0.004     0.011
   79371.874604 [11] <idle>                   1.148     0.000     0.035
   79371.874723 [05] <idle>                   0.016     0.000     1.383
   79371.874746 [05] gcc[31949]               0.153     0.078     0.022
...

Times are in msec.usec.

If callchains were recorded they are appended to the line with a default stack depth of 5:

   79371.874569 [11] gcc[31949]                  0.000014  0.000000  0.001148  wait_for_completion_killable do_fork sys_vfork stub_vfork __vfork
   79371.874591 [10] gcc[31951]                  0.000000  0.000000  0.000024  __cond_resched _cond_resched wait_for_completion stop_one_cpu sched_exec
   79371.874603 [10] migration/10[59]            0.003350  0.000004  0.000011  smpboot_thread_fn kthread ret_from_fork
   79371.874604 [11] <idle>                      0.001148  0.000000  0.000035  cpu_startup_entry start_secondary
   79371.874723 [05] <idle>                      0.000016  0.000000  0.001383  cpu_startup_entry start_secondary
   79371.874746 [05] gcc[31949]                  0.000153  0.000078  0.000022  do_wait sys_wait4 system_call_fastpath __GI___waitpid

--no-call-graph can be used to not show the callchains. --max-stack is used
to control the number of frames shown (default of 5). -x/--excl options can
be used to collapse redundant callchains to get more relevant data on screen.

Similar to perf-trace -s and -S can be used to dump a statistical summary
without or with events (respectively). Statistics include min run time,
average run time and max run time. Stats are also shown for run time by
cpu.

The cpu-visual option provides a visual aid for sched switches by cpu:
...
   79371.874569 [11]            s      gcc[31949]                  0.000014  0.000000  0.001148
   79371.874591 [10]           s       gcc[31951]                  0.000000  0.000000  0.000024
   79371.874603 [10]           s       migration/10[59]            0.003350  0.000004  0.000011
   79371.874604 [11]            i      <idle>                      0.001148  0.000000  0.000035
   79371.874723 [05]      i            <idle>                      0.000016  0.000000  0.001383
   79371.874746 [05]      s            gcc[31949]                  0.000153  0.000078  0.000022
...

Additional options:
- -w option can be used to include a dump of wakeup events
- -c comm to only display events and stats for the given comm (csv list)
- -p/-t to only display events and stats for given pid/tid (csv list)

v2:
- Addressed Namhyung's comments
- changed times to be in msec.usec versus sec.usec to be consistent with
  other perf commands

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-sched.c | 932 ++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/perf.h          |   3 +
 2 files changed, 934 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0f3c65518a2c..abcb40a44151 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -16,6 +16,9 @@
 
 #include "util/debug.h"
 
+#include "util/strlist.h"
+#include "util/intlist.h"
+#include "asm/bug.h"
 #include <sys/prctl.h>
 #include <sys/resource.h>
 
@@ -169,8 +172,49 @@ struct perf_sched {
 	u64		 cpu_last_switched[MAX_CPUS];
 	struct rb_root	 atom_root, sorted_atom_root;
 	struct list_head sort_list, cmp_pid;
+
+	/* options for timehist command */
+	bool		summary;
+	bool		summary_only;
+	bool		show_callchain;
+	unsigned int	max_stack;
+	bool		show_cpu_visual;
+	bool		show_wakeups;
+	/* process and task id's of interest */
+	struct target target;
+	struct intlist  *pid, *tid;
+};
+
+/* used in symbol filter */
+static const char	*excl_sym_list_str;
+static struct strlist	*excl_sym_list;
+
+/* per thread run time data */
+struct thread_runtime {
+	u64 last_time;      /* time of previous sched in/out event */
+	u64 dt_run;         /* run time */
+	u64 dt_between;     /* time between CPU access (off cpu) */
+	u64 dt_delay;       /* time between wakeup and sched-in */
+	u64 ready_to_run;   /* time of wakeup */
+
+	u64 count;
+	u64 total_run_time;
+	u64 min_run_time;
+	u64 max_run_time;
+	double mean, M2;
 };
 
+/* per event run time data */
+struct evsel_runtime {
+	u64 *last_time; /* time this event was last seen per cpu */
+	u32 ncpu;       /* highest cpu slot allocated */
+};
+
+/* track idle times per cpu */
+static struct thread **idle_threads;
+static int idle_max_cpu;
+static char idle_comm[] = "<idle>";
+
 static u64 get_nsecs(void)
 {
 	struct timespec ts;
@@ -1484,6 +1528,839 @@ out_delete:
 	return -1;
 }
 
+static inline void printf_nsecs(unsigned long long nsecs, int width_sec)
+{
+	unsigned long msecs;
+	unsigned long usecs;
+
+	msecs = nsecs / NSEC_PER_MSEC;
+	nsecs -= msecs * NSEC_PER_MSEC;
+	usecs = nsecs / NSEC_PER_USEC;
+	printf("%*lu.%03lu ", width_sec, msecs, usecs);
+}
+
+static struct evsel_runtime *perf_evsel__get_runtime(struct perf_evsel *evsel)
+{
+	struct evsel_runtime *r = evsel->priv;
+
+	if (r == NULL) {
+		r = zalloc(sizeof(struct evsel_runtime));
+		evsel->priv = r;
+	}
+
+	return r;
+}
+
+static void perf_evsel__save_time(struct perf_evsel *evsel,
+				  u64 timestamp, u32 cpu)
+{
+	struct evsel_runtime *r = perf_evsel__get_runtime(evsel);
+
+	if (r == NULL)
+		return;
+
+	if ((cpu > r->ncpu) || (r->last_time == NULL)) {
+		unsigned int i;
+		void *p = r->last_time;
+
+		r->last_time = realloc(r->last_time, (cpu+1) * sizeof(u64));
+		if (!r->last_time) {
+			free(p);
+			return;
+		}
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
+	struct evsel_runtime *r = perf_evsel__get_runtime(evsel);
+
+	if ((r == NULL) || (r->last_time == NULL) || (cpu > r->ncpu))
+		return 0;
+
+	return r->last_time[cpu];
+}
+
+static int comm_width = 20;
+
+static char *timehist_get_commstr(struct thread *thread)
+{
+	static char str[32];
+	const char *comm = thread__comm_str(thread);
+	pid_t tid = thread->tid;
+	pid_t pid = thread->pid_;
+	int n;
+
+	if (pid == 0)
+		n = scnprintf(str, sizeof(str), "%s", comm);
+
+	else if (tid != pid)
+		n = scnprintf(str, sizeof(str), "%s[%d/%d]", comm, tid, pid);
+
+	else
+		n = scnprintf(str, sizeof(str), "%s[%d]", comm, tid);
+
+	if (n > comm_width)
+		comm_width = n;
+
+	return str;
+}
+
+static void timehist_header(struct perf_sched *sched)
+{
+	u32 max_cpus = sched->max_cpu;
+	u32 i, j;
+
+	printf("%15s %-4s", "time", "cpu");
+
+	if (sched->show_cpu_visual && max_cpus) {
+		printf(" ");
+		for (i = 0, j = 0; i < max_cpus; ++i) {
+			printf("%x", j++);
+			if (j > 15)
+				j = 0;
+		}
+		printf(" ");
+	}
+
+	printf(" %-20s %9s %9s %9s",
+		"task name[tid/pid]", "b/n time", "sch delay", "run time");
+
+	if (sched->show_wakeups)
+		printf("  %-20s", "wakeup");
+
+	printf("\n");
+
+	printf("%.15s %.4s", graph_dotted_line, graph_dotted_line);
+
+	if (sched->show_cpu_visual && max_cpus) {
+		printf(" ");
+		for (i = 0; i < max_cpus; ++i)
+			printf("-");
+		printf(" ");
+	}
+
+	printf(" %.20s %.9s %.9s %.9s",
+		graph_dotted_line, graph_dotted_line, graph_dotted_line,
+		graph_dotted_line);
+
+	if (sched->show_wakeups)
+		printf("  %.20s", graph_dotted_line);
+
+	printf("\n");
+}
+
+static char *timehist_time_str(char *tstr, int len, u64 t)
+{
+	unsigned long secs, usecs;
+	unsigned long long nsecs;
+
+	nsecs = t;
+	secs = nsecs / NSEC_PER_SEC;
+	nsecs -= secs * NSEC_PER_SEC;
+	usecs = nsecs / NSEC_PER_USEC;
+	snprintf(tstr, len, "%5lu.%06lu", secs, usecs);
+
+	return tstr;
+}
+
+static void timehist_print_sample(struct perf_sched *sched,
+				  union perf_event *event,
+				  struct perf_evsel *evsel,
+				  struct perf_sample *sample,
+				  struct thread *thread,
+				  struct machine *machine)
+{
+	struct thread_runtime *tr = thread__priv(thread);
+	char tstr[64];
+	u32 max_cpus = sched->max_cpu;
+
+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
+
+	printf("[%02d] ", sample->cpu);
+
+	if (sched->show_cpu_visual && max_cpus) {
+		u32 i;
+		char c;
+		for (i = 0; i < max_cpus; ++i) {
+			/* flag idle times with 'i'; others are sched events */
+			if (i == sample->cpu)
+				c = (thread->tid == 0) ? 'i' : 's';
+			else
+				c = ' ';
+			printf("%c", c);
+		}
+		printf("  ");
+	}
+
+	printf("%-*s ", comm_width, timehist_get_commstr(thread));
+
+	printf_nsecs(tr->dt_between, 5);
+	printf_nsecs(tr->dt_delay, 5);
+	printf_nsecs(tr->dt_run, 5);
+
+	if (sched->show_wakeups)
+		printf(" %-*s ", comm_width, "");
+
+	perf_evsel__print_ip(evsel, event, sample, machine,
+			     PRINT_IP_OPT_SYM | PRINT_IP_OPT_ONELINE,
+			     sched->max_stack);
+
+	printf("\n");
+}
+
+/*
+ * Explanation of delta-time stats:
+ *
+ *            t = time of current schedule out event
+ *        tprev = time of previous sched out event
+ *                also time of schedule-in event for current task
+ *    last_time = time of last sched change event for current task
+ *                (i.e, time process was last scheduled out)
+ * ready_to_run = time of wakeup for current task
+ *
+ * -----|------------|------------|------------|------
+ *    last         ready        tprev          t
+ *    time         to run
+ *
+ *      |------- dt_between ------|
+ *                   |- dt_delay -|-- dt_run --|
+ *
+ *     dt_run = run time of current task
+ * dt_between = time between last schedule out event for task and tprev
+ *              represents time spent off the cpu
+ *   dt_delay = time between wakeup and schedule-in of task
+ */
+
+static void timehist_update_runtime_stats(struct thread_runtime *r,
+					 u64 t, u64 tprev)
+{
+	double delta;
+
+	r->count++;
+
+	r->dt_delay = 0;
+	r->dt_between = 0;
+	if (tprev) {
+		r->dt_run = t - tprev;
+		if (r->ready_to_run)
+			r->dt_delay = tprev - r->ready_to_run;
+
+		if (r->last_time > tprev)
+			pr_debug("time travel: last sched out time for task > previous sched_switch event\n");
+		else if (r->last_time)
+			r->dt_between = tprev - r->last_time;
+	}
+
+	delta    = r->dt_run - r->mean;
+	r->mean += delta / r->count;
+	r->M2   += delta * (r->dt_run - r->mean);
+
+	if (r->dt_run > r->max_run_time)
+		r->max_run_time = r->dt_run;
+
+	if (r->dt_run < r->min_run_time)
+		r->min_run_time = r->dt_run;
+
+	r->total_run_time += r->dt_run;
+
+	/* sched out event for task so reset ready to run time */
+	r->ready_to_run = 0;
+}
+
+static bool is_idle_sample(struct perf_sample *sample)
+{
+	/* pid 0 == swapper == idle task */
+	if (sample->pid == 0)
+		return true;
+
+	return false;
+}
+
+static int init_idle_threads(int ncpu)
+{
+	int i;
+
+	if (ncpu == 0)
+		ncpu = 1;
+
+	idle_threads = zalloc(ncpu * sizeof(struct thread *));
+	if (!idle_threads)
+		return -ENOMEM;
+
+	idle_max_cpu = ncpu - 1;
+
+	/* allocate the actual thread struct if needed */
+	for (i = 0; i < ncpu; ++i) {
+		idle_threads[i] = thread__new(0, 0);
+		if (idle_threads[i] == NULL)
+			return -ENOMEM;
+
+		thread__set_comm(idle_threads[i], idle_comm, 0);
+	}
+
+	return 0;
+}
+
+static void free_idle_threads(void)
+{
+	int i;
+
+	if (idle_threads == NULL)
+		return;
+
+	for (i = 0; i <= idle_max_cpu; ++i)
+		thread__delete(idle_threads[i]);
+
+	free(idle_threads);
+}
+
+static struct thread *get_idle_thread(int cpu)
+{
+	/*
+	 * expand/allocate array of pointers to local thread
+	 * structs if needed
+	 */
+	if ((cpu > idle_max_cpu) || (idle_threads == NULL)) {
+		int i, j = 15;
+		void *p;
+
+		if (cpu > j)
+			j = cpu;
+
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
+	/* allocate a new thread struct if needed */
+	if (idle_threads[cpu] == NULL) {
+		idle_threads[cpu] = thread__new(0, 0);
+		if (idle_threads[cpu]) {
+			idle_threads[cpu]->tid = 0;
+			thread__set_comm(idle_threads[cpu], idle_comm, 0);
+		}
+	}
+
+	return idle_threads[cpu];
+}
+
+static struct thread_runtime *thread__init_runtime(struct thread *thread)
+{
+	struct thread_runtime *r;
+
+	r = zalloc(sizeof(struct thread_runtime));
+	if (!r)
+		return NULL;
+
+	r->min_run_time = (u64) -1;
+	thread__set_priv(thread, r);
+
+	return r;
+}
+
+static struct thread_runtime *thread__get_runtime(struct thread *thread)
+{
+	struct thread_runtime *tr;
+
+	tr = thread__priv(thread);
+	if (tr == NULL) {
+		tr = thread__init_runtime(thread);
+		if (tr == NULL)
+			pr_debug("Failed to malloc memory for runtime data.\n");
+	}
+
+	return tr;
+}
+
+static struct thread *timehist_get_thread(struct perf_sample *sample,
+					  struct machine *machine)
+{
+	struct thread *thread;
+
+	if (is_idle_sample(sample)) {
+		thread = get_idle_thread(sample->cpu);
+		if (thread == NULL)
+			pr_err("Failed to get idle thread for cpu %d.\n", sample->cpu);
+
+	} else {
+		thread = machine__findnew_thread(machine, sample->pid, sample->tid);
+		if (thread == NULL) {
+			pr_debug("Failed to get thread for tid %d. skipping sample.\n",
+				 sample->tid);
+		}
+	}
+
+	return thread;
+}
+
+static bool timehist_skip_sample(struct perf_sched *sched,
+				 struct thread *thread)
+{
+	/*
+	 * if user gave a comm list, only show event if waker or wakee
+	 * is on the list
+	 */
+	if (thread__is_filtered(thread))
+		return true;
+
+	if (sched->pid && intlist__find(sched->pid, thread->pid_) == NULL)
+		return true;
+
+	if (sched->tid && intlist__find(sched->tid, thread->tid) == NULL)
+		return true;
+
+	return false;
+}
+
+static void timehist_print_wakeup_event(struct perf_sched *sched,
+					struct perf_sample *sample,
+					struct machine *machine,
+					struct thread *awakened)
+{
+	struct thread *thread;
+	char tstr[64];
+
+	thread = machine__findnew_thread(machine, sample->pid, sample->tid);
+	if (thread == NULL)
+		return;
+
+	/* show wakeup unless both awakee and awaker are filtered */
+	if (timehist_skip_sample(sched, thread) &&
+	    timehist_skip_sample(sched, awakened)) {
+		return;
+	}
+
+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
+	printf("[%02d] ", sample->cpu);
+	if (sched->show_cpu_visual && sched->max_cpu)
+		printf("%*s  ", sched->max_cpu, "");
+
+	printf("%-*s ", comm_width, timehist_get_commstr(thread));
+
+	/* dt spacer */
+	printf(" %9s %9s %9s ", "", "", "");
+
+	printf("%-*s ", comm_width, timehist_get_commstr(awakened));
+
+	printf("\n");
+
+	return;
+}
+
+static int timehist_sched_wakeup_event(struct perf_tool *tool,
+				       union perf_event *event __maybe_unused,
+				       struct perf_evsel *evsel,
+				       struct perf_sample *sample,
+				       struct machine *machine)
+{
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
+	struct thread *thread;
+	struct thread_runtime *tr = NULL;
+	/* want pid of awakened task not pid in sample */
+	const u32 pid = perf_evsel__intval(evsel, sample, "pid");
+
+	thread = machine__findnew_thread(machine, 0, pid);
+	if (thread == NULL)
+		return -1;
+
+	tr = thread__get_runtime(thread);
+	if (tr == NULL)
+		return -1;
+
+	if (tr->ready_to_run == 0)
+		tr->ready_to_run = sample->time;
+
+	/* show wakeups if requested */
+	if (sched->show_wakeups)
+		timehist_print_wakeup_event(sched, sample, machine, thread);
+
+	return 0;
+}
+
+static int timehist_sched_switch_event(struct perf_tool *tool,
+				       union perf_event *event,
+				       struct perf_evsel *evsel,
+				       struct perf_sample *sample,
+				       struct machine *machine)
+{
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
+	struct thread *thread;
+	struct thread_runtime *tr = NULL;
+	u64 tprev;
+	int rc = 0;
+
+	thread = timehist_get_thread(sample, machine);
+	if (thread == NULL) {
+		rc = -1;
+		goto out;
+	}
+
+	if (timehist_skip_sample(sched, thread))
+		goto out;
+
+	tr = thread__get_runtime(thread);
+	if (tr == NULL) {
+		rc = -1;
+		goto out;
+	}
+
+	tprev = perf_evsel__get_time(evsel, sample->cpu);
+
+	timehist_update_runtime_stats(tr, sample->time, tprev);
+	if (!sched->summary_only)
+		timehist_print_sample(sched, event, evsel, sample, thread, machine);
+
+out:
+	/* time of this sched_switch event becomes last time task seen */
+	if (tr)
+		tr->last_time = sample->time;
+
+	perf_evsel__save_time(evsel, sample->time, sample->cpu);
+
+	return rc;
+}
+
+static int process_lost(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample,
+			struct machine *machine __maybe_unused)
+{
+	char tstr[64];
+
+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
+	printf("lost %" PRIu64 " events on cpu %d\n", event->lost.lost, sample->cpu);
+
+	return 0;
+}
+
+
+static void print_thread_runtime(struct thread *t, struct thread_runtime *r)
+{
+	double variance;
+	float stddev;
+
+	printf("    %*s  %5d  %6" PRIu64 "  ",
+	       comm_width, timehist_get_commstr(t), t->ppid, r->count);
+
+	printf_nsecs(r->total_run_time, 5);
+	if (r->count > 1) {
+		variance = r->M2 / (r->count - 1);
+		stddev = 100.0 * sqrt(variance / r->count) / r->mean;
+
+		printf(" ");
+		printf_nsecs(r->min_run_time, 5);
+		printf(" ");
+		printf_nsecs((u64) r->mean, 5);
+		printf(" ");
+		printf_nsecs(r->max_run_time, 5);
+		printf("  ");
+		printf("%5.2f", stddev);
+	}
+	printf("\n");
+}
+
+#define UPDATE_TOTALS(r) { \
+		total_count += (r)->count; \
+		total_run_time += (r)->total_run_time; \
+		total_task++; \
+	}
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
+	printf("\nRuntime summary (times are in milliseconds)\n");
+	printf("    %*s  parent  number  ", comm_width, "comm");
+	printf("run-time    min-run    avg-run    max-run  stddev(%%)\n");
+
+	nd = rb_first(&m->threads);
+	while (nd) {
+		t = rb_entry(nd, struct thread, rb_node);
+		if (t->dead)
+			goto next1;
+
+		if (thread__is_filtered(t))
+			goto next1;
+
+		r = thread__priv(t);
+		if (r && r->count) {
+			UPDATE_TOTALS(r);
+			print_thread_runtime(t, r);
+		}
+next1:
+		nd = rb_next(nd);
+	}
+
+	printf("\nTerminated tasks:\n");
+	nd = rb_first(&m->threads);
+	while (nd) {
+		t = rb_entry(nd, struct thread, rb_node);
+		if (!t->dead)
+			goto next2;
+
+		if (thread__is_filtered(t))
+			goto next2;
+
+		r = thread__priv(t);
+		if (r && r->count) {
+			UPDATE_TOTALS(r);
+			print_thread_runtime(t, r);
+		}
+next2:
+		nd = rb_next(nd);
+	}
+
+	list_for_each_entry(t, &m->dead_threads, node) {
+		r = thread__priv(t);
+		if (r && r->count) {
+			UPDATE_TOTALS(r);
+			print_thread_runtime(t, r);
+		}
+	}
+
+	printf("\nIdle stats:\n");
+	for (i = 0; i <= idle_max_cpu; ++i) {
+		t = idle_threads[i];
+		if (!t)
+			continue;
+
+		r = thread__priv(t);
+		if (r && r->count) {
+			total_count += r->count;
+			printf("    CPU %d idle for ", i);
+			printf_nsecs(r->total_run_time, 5);
+			printf("\n");
+		}
+	}
+
+	printf("\n"
+	       "    Total number of unique tasks: %d\n"
+	       "Total number of context switches: %" PRIu64 "\n"
+	       "            Total run time (sec): ",
+	       total_task, total_count);
+
+	printf_nsecs(total_run_time, 5);
+	printf("\n");
+}
+
+typedef int (*sched_handler)(struct perf_tool *tool,
+			  union perf_event *event,
+			  struct perf_evsel *evsel,
+			  struct perf_sample *sample,
+			  struct machine *machine);
+
+static int perf_timehist__process_sample(struct perf_tool *tool,
+					 union perf_event *event,
+					 struct perf_sample *sample,
+					 struct perf_evsel *evsel,
+					 struct machine *machine)
+{
+	int err = 0;
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+	if (evsel->handler != NULL) {
+		sched_handler f = evsel->handler;
+
+		err = f(tool, event, evsel, sample, machine);
+	}
+
+	return err;
+}
+
+static int setup_excl_sym(void)
+{
+	if (excl_sym_list_str &&
+	    setup_list(&excl_sym_list, excl_sym_list_str, "excl_sym") < 0)
+		return -1;
+
+	return 0;
+}
+
+static int timehist_symbol_filter(struct map *map, struct symbol *sym)
+{
+	/* filter out schedule and syscall related symbols from stack trace */
+	if (map->dso->kernel == DSO_TYPE_KERNEL) {
+		if ((strncmp(sym->name, "schedule", 8) == 0) ||
+		    (strcmp(sym->name, "__schedule") == 0)) {
+			sym->ignore = true;
+			return 0;
+		}
+		if ((strcmp(sym->name, "syscall") == 0) ||
+		    (strcmp(sym->name, "system_call_done") == 0) ||
+		    (strcmp(sym->name, "ia32_syscall_done") == 0)) {
+			sym->ignore = true;
+			return 0;
+		}
+	}
+
+	if ((excl_sym_list && strlist__has_entry(excl_sym_list, sym->name)) ||
+	    symbol__is_idle(sym))
+		sym->ignore = true;
+
+	return 0;
+}
+
+static int parse_target_str(struct perf_sched *sched)
+{
+	if (sched->target.pid) {
+		sched->pid = intlist__new(sched->target.pid);
+		if (sched->pid == NULL) {
+			pr_err("Error parsing process id string\n");
+			return -EINVAL;
+		}
+	}
+
+	if (sched->target.tid) {
+		sched->tid = intlist__new(sched->target.tid);
+		if (sched->tid == NULL) {
+			intlist__delete(sched->pid);
+			pr_err("Error parsing thread id string\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int timehist_check_attr(struct perf_sched *sched,
+			       struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	struct evsel_runtime *er;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		er = perf_evsel__get_runtime(evsel);
+		if (er == NULL) {
+			pr_err("Failed to allocate memory for evsel runtime data\n");
+			return -1;
+		}
+
+		if (sched->show_callchain &&
+		    !(evsel->attr.sample_type & PERF_SAMPLE_CALLCHAIN)) {
+			pr_info("Samples do not have callchains.\n");
+			sched->show_callchain = 0;
+			symbol_conf.use_callchain = 0;
+		}
+	}
+
+	return 0;
+}
+
+static int perf_sched__timehist(struct perf_sched *sched)
+{
+	const struct perf_evsel_str_handler handlers[] = {
+		{ "sched:sched_switch",       timehist_sched_switch_event, },
+		{ "sched:sched_wakeup",	      timehist_sched_wakeup_event, },
+		{ "sched:sched_wakeup_new",   timehist_sched_wakeup_event, },
+	};
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
+
+	struct perf_session *session;
+	int err = -1;
+
+	/*
+	 * event handlers for timehist option
+	 */
+	sched->tool.sample	 = perf_timehist__process_sample;
+	sched->tool.mmap	 = perf_event__process_mmap;
+	sched->tool.comm	 = perf_event__process_comm;
+	sched->tool.exit	 = perf_event__process_exit;
+	sched->tool.fork	 = perf_event__process_fork;
+	sched->tool.lost	 = process_lost;
+	sched->tool.attr	 = perf_event__process_attr;
+	sched->tool.tracing_data = perf_event__process_tracing_data;
+	sched->tool.build_id	 = perf_event__process_build_id;
+
+	sched->tool.ordered_samples = true;
+	sched->tool.ordering_requires_timestamps = true;
+
+	if (setup_excl_sym() < 0)
+		return -1;
+
+	symbol_conf.use_callchain = sched->show_callchain;
+	if (symbol__init() < 0)
+		return -1;
+
+	session = perf_session__new(&file, false, &sched->tool);
+	if (session == NULL)
+		return -ENOMEM;
+
+	machines__set_symbol_filter(&session->machines, timehist_symbol_filter);
+
+	if (timehist_check_attr(sched, session->evlist) != 0)
+		goto out;
+
+	if (parse_target_str(sched) != 0)
+		goto out;
+
+	setup_pager();
+
+	/* setup per-evsel handlers */
+	if (perf_session__set_tracepoints_handlers(session, handlers))
+		goto out;
+
+	if (!perf_session__has_traces(session, "record -R"))
+		goto out;
+
+	/* pre-allocate struct for per-CPU idle stats */
+	sched->max_cpu = session->header.env.nr_cpus_online;
+	if (init_idle_threads(sched->max_cpu))
+		goto out;
+
+	/* summary_only implies summary option, but don't overwrite summary if set */
+	if (sched->summary_only)
+		sched->summary = sched->summary_only;
+
+	if (!sched->summary_only)
+		timehist_header(sched);
+
+	err = perf_session__process_events(session, &sched->tool);
+	if (err) {
+		pr_err("Failed to process events, error %d", err);
+		goto out;
+	}
+
+	sched->nr_events      = session->stats.nr_events[0];
+	sched->nr_lost_events = session->stats.total_lost;
+	sched->nr_lost_chunks = session->stats.nr_events[PERF_RECORD_LOST];
+
+	if (sched->summary)
+		timehist_print_summary(session);
+
+out:
+	free_idle_threads();
+	perf_session__delete(session);
+
+	return err;
+}
+
 static void print_bad_events(struct perf_sched *sched)
 {
 	if (sched->nr_unordered_timestamps && sched->nr_timestamps) {
@@ -1675,6 +2552,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		.profile_cpu	      = -1,
 		.next_shortname1      = 'A',
 		.next_shortname2      = '0',
+		.show_callchain	      = 1,
+		.max_stack            = 5,
 	};
 	const struct option latency_options[] = {
 	OPT_STRING('s', "sort", &sched.sort_order, "key[,key2...]",
@@ -1705,6 +2584,42 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "dump raw trace in ASCII"),
 	OPT_END()
 	};
+	const struct option timehist_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only display events for these comms"),
+	OPT_STRING('p', "pid", &sched.target.pid, "pid",
+		   "analyze events only for given process id(s)"),
+	OPT_STRING('t', "tid", &sched.target.tid, "tid",
+		    "analyze events only for given thread id(s)"),
+	OPT_BOOLEAN('g', "call-graph", &sched.show_callchain,
+		    "Display call chains if present (default on)"),
+	OPT_UINTEGER(0, "max-stack", &sched.max_stack,
+		   "Maximum number of functions to display backtrace."),
+	OPT_STRING('x', "exclude-sym", &excl_sym_list_str, "sym[,sym...]",
+		   "symbols to skip in backtrace"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
+	OPT_BOOLEAN('s', "summary", &sched.summary_only,
+		    "Show only syscall summary with statistics"),
+	OPT_BOOLEAN('S', "with-summary", &sched.summary,
+		    "Show all syscalls and summary with statistics"),
+	OPT_BOOLEAN('w', "wakeups", &sched.show_wakeups, "Show wakeup events"),
+	OPT_BOOLEAN('V', "cpu-visual", &sched.show_cpu_visual, "Add CPU visual"),
+	OPT_END()
+	};
+	const char * const timehist_usage[] = {
+		"perf sched timehist [<options>]",
+		NULL
+	};
+
 	const char * const latency_usage[] = {
 		"perf sched latency [<options>]",
 		NULL
@@ -1747,7 +2662,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
 
-	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
@@ -1758,10 +2672,12 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 				usage_with_options(latency_usage, latency_options);
 		}
 		setup_sorting(&sched, latency_options, latency_usage);
+		symbol__init();
 		return perf_sched__lat(&sched);
 	} else if (!strcmp(argv[0], "map")) {
 		sched.tp_handler = &map_ops;
 		setup_sorting(&sched, latency_options, latency_usage);
+		symbol__init();
 		return perf_sched__map(&sched);
 	} else if (!strncmp(argv[0], "rep", 3)) {
 		sched.tp_handler = &replay_ops;
@@ -1770,7 +2686,21 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 			if (argc)
 				usage_with_options(replay_usage, replay_options);
 		}
+		symbol__init();
 		return perf_sched__replay(&sched);
+	} else if (!strcmp(argv[0], "timehist")) {
+		if (argc) {
+			argc = parse_options(argc, argv, timehist_options,
+					     timehist_usage, 0);
+			if (argc)
+				usage_with_options(timehist_usage, timehist_options);
+		}
+		if (sched.show_wakeups && sched.summary_only) {
+			pr_err("-w and -s are mutually exclusive.\n");
+			return -EINVAL;
+		}
+
+		return perf_sched__timehist(&sched);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b23fed527514..6300f7843b9c 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -160,6 +160,9 @@
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
+#ifndef NSEC_PER_MSEC
+# define NSEC_PER_MSEC			1000000ULL
+#endif
 #ifndef NSEC_PER_USEC
 # define NSEC_PER_USEC			1000ULL
 #endif
-- 
1.8.3.4 (Apple Git-47)

