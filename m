Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab3HHCvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:53 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40688 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946Ab3HHCvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:49 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/19] perf sched: Add timehist command
Date: Wed,  7 Aug 2013 22:50:57 -0400
Message-Id: <1375930261-77273-16-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default 'perf sched timehist' dumps a run-time summary for each task. The
summary includes the number of times the process was scheduled and the min, max
and average run times when scheduled (ie., a measure of how CPU time the task
wanted). Summary of idle times per cpu is also shown.

Example output (abbreviated):

Runtime summary (times are in seconds)
                  comm  parent  number  run-time    min-run    max-run   avg-run  stddev(%)
...
           make[12858]  12823       2   0.000826   0.000063   0.000763   0.000413  84.74
           make[12859]  12823       4   0.002706   0.000026   0.001368   0.000676  40.83
           make[12860]  12823       3   0.002703   0.000026   0.001941   0.000901  62.01
           make[12861]  12823       2   0.000863   0.000061   0.000801   0.000431  85.64
       qemu-kvm[14716]     -1     207   0.009341   0.000021   0.000187   0.000045   3.19
 qemu-kvm[14720/14716]     -1     146   0.005790   0.000011   0.000105   0.000039   3.84
 qemu-kvm[14721/14716]     -1     102   0.002717   0.000014   0.000068   0.000026   2.44
 qemu-kvm[29548/29541]     -1      10   0.089883   0.000000   0.009992   0.008988  11.11
...

Idle stats:
    CPU 0 idle for  0.096720
    CPU 2 idle for  0.096138
    CPU 4 idle for  0.084509
    CPU 6 idle for  0.092162
    CPU 8 idle for  0.069825
    CPU 10 idle for  0.057123
    CPU 12 idle for  0.087755
    CPU 14 idle for  0.075491

    Total number of unique tasks: 66
Total number of context switches: 1631
            Total run time (sec):  0.204370

Individual sched_switch events can be dumped using the --events option. Output
includes N elements of the stack trace on one line with options to control
stack depth as well as exclude elements of stack dump to get more relevant
information onto each line:

  447399.732590 [14] make[12858]       0.000000  0.000063  __cond_resched _cond_resched wait_for_completion stop_one_cpu sched_exec
  447399.732608 [08] <idle>            0.002126  0.001472  schedule_preempt_disabled cpu_startup_entry start_secondary
  447399.732610 [14] migration/14[79]  0.003583  0.000019  smpboot_thread_fn kthread ret_from_fork
  447399.732611 [06] qemu-kvm[14716]   0.000592  0.000073  poll_schedule_timeout do_select core_sys_select SyS_select system_call
  447399.732623 [02] <idle>            0.000059  0.000965  schedule_preempt_disabled cpu_startup_entry start_secondary
  447399.732627 [00] <idle>            0.000048  0.000054  schedule_preempt_disabled cpu_startup_entry rest_init start_kernel x86_64_start_reservations
  447399.732658 [00] qemu-kvm[14721/14716] 0.000975  0.000030  kvm_vcpu_block kvm_arch_vcpu_ioctl_run kvm_vcpu_ioctl do_vfs_ioctl sys_ioctl
  447399.732671 [02] qemu-kvm[14720/14716] 0.000965  0.000047  kvm_vcpu_block kvm_arch_vcpu_ioctl_run kvm_vcpu_ioctl do_vfs_ioctl sys_ioctl
  447399.732686 [04] <idle>                0.000133  0.000172  schedule_preempt_disabled cpu_startup_entry start_secondary
  447399.732700 [04] perf[12823]           0.000172  0.000013  do_wait SyS_wait4 system_call __libc_wait

Options include the usual report controls for kernel symbols, symfs, limiting
output to command names of interest.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |  722 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 721 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1ec1ff4..a45a40f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -16,6 +16,8 @@
 
 #include "util/debug.h"
 
+#include "util/strlist.h"
+#include "asm/bug.h"
 #include <sys/prctl.h>
 #include <sys/resource.h>
 
@@ -169,8 +171,39 @@ struct perf_sched {
 	u64		 cpu_last_switched[MAX_CPUS];
 	struct rb_root	 atom_root, sorted_atom_root;
 	struct list_head sort_list, cmp_pid;
+
+	/* options for timehist command */
+	bool		show_events;
+	bool		no_callchain;
+	unsigned int	max_stack_depth;
+	bool		show_cpu_visual;
+};
+
+/* per thread run time data */
+struct thread_runtime {
+	u64 dt_run;
+	u64 dt_between;
+	u64 last_time;
+
+	u64 count;
+	u64 total_run_time;
+	u64 min_run_time;
+	u64 max_run_time;
+	double mean, M2;
+	char commstr[32];
+};
+
+/* per event run time data */
+struct evsel_runtime {
+	u64 *last_time; /* time this event was last seen per cpu */
+	u32 ncpu;       /* highest cpu slot allocated */
 };
 
+/* track idle times per cpu */
+static struct thread **idle_threads;
+static int idle_max_cpu;
+static char idle_comm[] = "<idle>";
+
 static u64 get_nsecs(void)
 {
 	struct timespec ts;
@@ -1479,6 +1512,652 @@ out_delete:
 	return -1;
 }
 
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
+static void timehist_header(struct perf_sched *sched)
+{
+	u32 max_cpus = sched->max_cpu;
+	u32 i, j;
+
+	printf("%-15s %-4s", "time", "cpu");
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
+	printf(" %-20s %9s %9s",
+		"task name[tid/pid]", "b/n time", "run time");
+
+	printf("\n");
+
+	printf("%15s %4s", "---------------", "----");
+
+	if (sched->show_cpu_visual && max_cpus) {
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
+static char *timehist_time_str(char *tstr, int len, u64 t)
+{
+	unsigned long secs, usecs;
+	unsigned long long nsecs;
+
+	nsecs = t;
+	secs = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs = nsecs / NSECS_PER_USEC;
+	snprintf(tstr, len, "%5lu.%06lu", secs, usecs);
+
+	return tstr;
+}
+
+static unsigned int comm_width = 20;
+
+static void timehist_print_sample(struct perf_sched *sched,
+				  struct perf_evsel *evsel,
+				  struct perf_sample *sample,
+				  struct thread *thread,
+				  struct machine *machine)
+{
+	struct thread_runtime *tr = thread__priv(thread);
+	union perf_event *event = evsel->handler.data;
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
+			c = i == sample->cpu ? 's' : ' ';
+			printf("%c", c);
+		}
+		printf("  ");
+	}
+
+	printf("%-*s ", comm_width, tr->commstr);
+
+	printf_nsecs(tr->dt_between, 2);
+	printf_nsecs(tr->dt_run, 2);
+
+	perf_evsel__print_ip(evsel, event, sample, machine,
+			     PRINT_IP_OPT_SYM | PRINT_IP_OPT_ONELINE,
+			     sched->max_stack_depth);
+
+	printf("\n");
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
+		if (!sched->no_callchain &&
+		    !(evsel->attr.sample_type & PERF_SAMPLE_CALLCHAIN)) {
+			sched->no_callchain = 1;
+			symbol_conf.use_callchain = 0;
+		}
+	}
+
+	return 0;
+}
+
+static bool is_idle_sample(struct perf_sample *sample,
+			   struct perf_evsel *evsel,
+			   struct machine *machine)
+{
+	struct thread *thread;
+	struct callchain_cursor *cursor = &callchain_cursor;
+	struct callchain_cursor_node *node;
+	struct addr_location al;
+	int iter = 5;
+
+	/* pid 0 == swapper == idle task */
+	if (sample->pid == 0)
+		return true;
+
+	/* want main thread for process - has maps */
+	thread = machine__findnew_thread(machine, sample->pid);
+	if (thread == NULL) {
+		pr_debug("Failed to get thread for pid %d.\n", sample->pid);
+		return false;
+	}
+
+	if (!symbol_conf.use_callchain || sample->callchain == NULL)
+		return false;
+
+	if (machine__resolve_callchain(machine, evsel, thread,
+					sample, NULL, &al) != 0) {
+		if (verbose)
+			error("Failed to resolve callchain. Skipping\n");
+
+		return false;
+	}
+	callchain_cursor_commit(cursor);
+
+	/* idle symbol should be early in the stack */
+	while (iter) {
+		node = callchain_cursor_current(cursor);
+		if (!node)
+			break;
+
+		if (symbol__is_idle(node->sym))
+			return true;
+
+		callchain_cursor_advance(cursor);
+
+		iter--;
+	}
+
+	return false;
+}
+
+static void timehist_update_thread_stats(struct thread_runtime *r,
+					 u64 t, u64 dt_run)
+{
+	u64 dt_task = 0;
+	double delta;
+
+	r->count++;
+
+	/* current run time and total run time */
+	r->dt_run = dt_run;
+	r->total_run_time += dt_run;
+
+	/* time b/n sched events for task */
+	if (r->last_time)
+		dt_task = t - r->last_time;
+
+	/* subtract run time for this event to get time between
+	 * sched in events - i.e., how long between accesses to CPU
+	 */
+	if (dt_task > dt_run)
+		r->dt_between = dt_task - dt_run;
+
+	/*
+	 * update average and stddev stats
+	 */
+	delta    = dt_run - r->mean;
+	r->mean += delta / r->count;
+	r->M2   += delta * (dt_run - r->mean);
+
+	if (dt_run > r->max_run_time)
+		r->max_run_time = dt_run;
+
+	if (dt_run < r->min_run_time)
+		r->min_run_time = dt_run;
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
+			idle_threads[cpu]->tid = 0;
+			idle_threads[cpu]->comm = idle_comm;
+		}
+	}
+
+	return idle_threads[cpu];
+}
+
+static void timehist_set_commstr(struct thread_runtime *r,
+				 const char *comm,
+				 pid_t pid, pid_t tid)
+{
+	unsigned int i, n;
+
+	if ((r == NULL) || (*r->commstr != '\0'))
+		return;
+
+	if (pid == 0) {
+		snprintf(r->commstr, sizeof(r->commstr)-1, "%s", comm);
+
+	} else if (tid != pid) {
+		snprintf(r->commstr, sizeof(r->commstr)-1, "%s[%d/%d]",
+			 comm, tid, pid);
+	} else {
+		snprintf(r->commstr, sizeof(r->commstr)-1, "%s[%d]",
+			 comm, tid);
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
+static struct thread_runtime *thread__init_runtime(struct thread *thread, pid_t pid)
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
+	/* optimization - saving comm string used in stack dump */
+	timehist_set_commstr(r, thread->comm, pid, thread->tid);
+
+	return r;
+}
+
+static struct thread *timehist_get_thread(struct perf_evsel *evsel,
+					  struct perf_sample *sample,
+					  struct machine *machine)
+{
+	struct thread *thread;
+
+	if (is_idle_sample(sample, evsel, machine)) {
+		thread = get_idle_thread(sample->cpu);
+		if (thread == NULL)
+			pr_err("failed to get idle thread for cpu %d.\n", sample->cpu);
+
+	} else {
+		thread = machine__findnew_thread(machine, sample->tid);
+		if (thread == NULL) {
+			pr_debug("Failed to get thread for tid %d. skipping sample.\n",
+				 sample->tid);
+		}
+	}
+
+	return thread;
+}
+
+static int timehist_sched_change_event(struct perf_tool *tool,
+				       struct perf_evsel *evsel,
+				       struct perf_sample *sample,
+				       struct machine *machine)
+{
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
+	struct thread *thread;
+	struct thread_runtime *tr = NULL;
+	u64 dt_run = 0, tprev;
+	int rc = 0;
+
+	thread = timehist_get_thread(evsel, sample, machine);
+	if (thread == NULL) {
+		rc = -1;
+		goto out;
+	}
+
+	tr = thread__priv(thread);
+	if (tr == NULL) {
+		/* pid argument is not needed once Adrian's patch is picked up */
+		tr = thread__init_runtime(thread, sample->pid);
+		if (tr == NULL) {
+			pr_debug("failed to malloc memory for runtime data.\n");
+			rc = -1;
+			goto out;
+		}
+	}
+
+	tprev = perf_evsel__get_time(evsel, sample->cpu);
+	if (tprev)
+		dt_run = sample->time - tprev;
+
+	timehist_update_thread_stats(tr, sample->time, dt_run);
+	if (sched->show_events)
+		timehist_print_sample(sched, evsel, sample, thread, machine);
+
+out:
+	if (tr)
+		tr->last_time = sample->time;
+	perf_evsel__save_time(evsel, sample->time, sample->cpu);
+
+	return rc;
+}
+
+static int timehist_sched_switch_event(struct perf_tool *tool,
+			       struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct machine *machine)
+{
+	return timehist_sched_change_event(tool, evsel, sample, machine);
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
+	       comm_width, r->commstr, t->ppid, r->count);
+
+	printf_nsecs(r->total_run_time, 2);
+	if (r->count > 1) {
+		variance = r->M2 / (r->count - 1);
+		stddev = 100.0 * sqrt(variance / r->count) / r->mean;
+
+		printf(" ");
+		printf_nsecs(r->min_run_time, 2);
+		printf(" ");
+		printf_nsecs(r->max_run_time, 2);
+		printf(" ");
+		printf_nsecs((u64) r->mean, 2);
+		printf(" ");
+		printf("%5.2f", stddev);
+	}
+	printf("\n");
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
+	printf("\nRuntime summary (times are in seconds)\n");
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
+			total_task++;
+			print_thread_runtime(t, r);
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
+			total_task++;
+
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
+			printf_nsecs(r->total_run_time, 2);
+			printf("\n");
+		}
+	}
+
+	WARN_ONCE(!symbol_conf.vmlinux_name && !symbol_conf.kallsyms_name,
+		  "kernel symbols not given. If this is an offline analysis idle time computations will be wrong\n");
+
+	printf("\n"
+	       "    Total number of unique tasks: %d\n"
+	       "Total number of context switches: %" PRIu64 "\n"
+	       "            Total run time (sec): ",
+	       total_task, total_count);
+	printf_nsecs(total_run_time, 2);
+	printf("\n");
+}
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
+	if (evsel->handler.func != NULL || verbose) {
+		tracepoint_handler f = evsel->handler.func;
+		evsel->handler.data = event;
+
+		if (f)
+			err = f(tool, evsel, sample, machine);
+	}
+
+	return err;
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
+			"schedule_hrtimeout_range_clock,schedule_hrtimeout_range,"
+			"syscall,system_call_done,ia32_syscall_done,%s",
+			symbol_conf.excl_sym_list_str ? symbol_conf.excl_sym_list_str : "");
+
+	symbol_conf.excl_sym_list_str = strdup(buf);
+
+	return 0;
+}
+
+static int perf_sched__timehist(struct perf_sched *sched)
+{
+	const struct perf_evsel_str_handler handlers[] = {
+		{ "sched:sched_switch",       timehist_sched_switch_event, },
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
+	/* if not given default to stack depth of 5 */
+	if (sched->max_stack_depth == 0)
+		sched->max_stack_depth = 5;
+
+	symbol_conf.use_callchain = !sched->no_callchain;
+	setup_excl_sym();
+	if (symbol__init() < 0)
+		return -1;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &sched->tool);
+	if (session == NULL)
+		return -ENOMEM;
+
+	setup_pager();
+
+	if (timehist_check_attr(sched, session->evlist) != 0)
+		return -ENOMEM;
+
+	perf_session__fprintf_info(session, stdout, true);
+
+	/* pre-allocate struct for per-CPU idle stats */
+	sched->max_cpu = session->header.env.nr_cpus_online;
+	if (sched->max_cpu > 0) {
+		idle_max_cpu = sched->max_cpu - 1;
+		idle_threads = zalloc(sched->max_cpu * sizeof(struct thread *));
+	}
+
+	/* setup per-evsel handlers */
+	if (perf_session__set_tracepoints_handlers(session, handlers))
+		goto out;
+
+	if (perf_session__has_traces(session, "record -R")) {
+		if (sched->show_events)
+			timehist_header(sched);
+
+		err = perf_session__process_events(session, &sched->tool);
+		if (err) {
+			pr_err("Failed to process events, error %d", err);
+			goto out;
+		}
+
+		sched->nr_events      = session->stats.nr_events[0];
+		sched->nr_lost_events = session->stats.total_lost;
+		sched->nr_lost_chunks = session->stats.nr_events[PERF_RECORD_LOST];
+	}
+
+	timehist_print_summary(session);
+
+out:
+	perf_session__delete(session);
+
+	return err;
+}
+
 static void print_bad_events(struct perf_sched *sched)
 {
 	if (sched->nr_unordered_timestamps && sched->nr_timestamps) {
@@ -1702,6 +2381,36 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "dump raw trace in ASCII"),
 	OPT_END()
 	};
+	const struct option timehist_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_INCR('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only display events for these comms"),
+	OPT_UINTEGER('s', "stack-depth", &sched.max_stack_depth,
+		   "Maximum number of functions to display backtrace."),
+	OPT_STRING('x', "excl", &symbol_conf.excl_sym_list_str, "sym[,sym...]",
+		   "symbols to skip in backtrace"),
+	OPT_BOOLEAN('G', "hide-call-graph", &sched.no_callchain,
+		    "When printing symbols do not display call chain"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
+	OPT_BOOLEAN(0, "cpu-visual", &sched.show_cpu_visual, "Show CPU visual"),
+	OPT_BOOLEAN(0, "events", &sched.show_events, "show all events"),
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
@@ -1740,7 +2449,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv, prefix);
 
-	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
@@ -1751,10 +2459,12 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -1763,7 +2473,17 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
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
+
+		return perf_sched__timehist(&sched);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
-- 
1.7.10.1

