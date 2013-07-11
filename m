Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3GKQ1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:27:14 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56073 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3GKQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:27:10 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 08/11] perf kvm: add live mode
Date: Thu, 11 Jul 2013 10:26:39 -0600
Message-Id: <1373560002-14618-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
References: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf kvm stat currently requires back to back record and report
commands to see stats. e.g,.

  perf kvm stat record -p $pid -- sleep 1
  perf kvm stat report

This is inconvenvient for on box monitoring of a VM. This patch
introduces a 'live' mode that in effect combines the record plus
report into one command. e.g., to monitor a single VM:

  perf kvm stat live -p $pid

or all VMs:

  perf kvm stat live

Same stats options for the record+report path work with the live mode.
Display rate defaults to 1 second and can be changed using the -d option.

v2:
removed ABSTIME arg from timerfd_settime as mentioned by Namhyung
only call perf_kvm__handle_stdin when poll returns activity.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |  603 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 577 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7d14a3a..15fdf54 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -2,6 +2,7 @@
 #include "perf.h"
 
 #include "util/evsel.h"
+#include "util/evlist.h"
 #include "util/util.h"
 #include "util/cache.h"
 #include "util/symbol.h"
@@ -15,9 +16,12 @@
 #include <lk/debugfs.h>
 #include "util/tool.h"
 #include "util/stat.h"
+#include "util/top.h"
 
 #include <sys/prctl.h>
+#include <sys/timerfd.h>
 
+#include <termios.h>
 #include <semaphore.h>
 #include <pthread.h>
 #include <math.h>
@@ -82,6 +86,8 @@ struct exit_reasons_table {
 
 struct perf_kvm_stat {
 	struct perf_tool    tool;
+	struct perf_record_opts opts;
+	struct perf_evlist  *evlist;
 	struct perf_session *session;
 
 	const char *file_name;
@@ -96,10 +102,16 @@ struct perf_kvm_stat {
 	struct kvm_events_ops *events_ops;
 	key_cmp_fun compare;
 	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+
 	u64 total_time;
 	u64 total_count;
+	u64 lost_events;
 
 	struct rb_root result;
+
+	int timerfd;
+	unsigned int display_time;
+	bool live;
 };
 
 
@@ -320,6 +332,23 @@ static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
+static void clear_events_cache_stats(struct list_head *kvm_events_cache)
+{
+	struct list_head *head;
+	struct kvm_event *event;
+	unsigned int i;
+
+	for (i = 0; i < EVENTS_CACHE_SIZE; i++) {
+		head = &kvm_events_cache[i];
+		list_for_each_entry(event, head, hash_entry) {
+			/* reset stats for event */
+			memset(&event->total, 0, sizeof(event->total));
+			memset(event->vcpu, 0,
+			       event->max_vcpu * sizeof(*event->vcpu));
+		}
+	}
+}
+
 static int kvm_events_hash_fn(u64 key)
 {
 	return key & (EVENTS_CACHE_SIZE - 1);
@@ -472,7 +501,11 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
 	vcpu_record->last_event = NULL;
 	vcpu_record->start_time = 0;
 
-	BUG_ON(timestamp < time_begin);
+	/* seems to happen once in a while during live mode */
+	if (timestamp < time_begin) {
+		pr_debug("End time before begin time; skipping event.\n");
+		return true;
+	}
 
 	time_diff = timestamp - time_begin;
 	return update_kvm_event(event, vcpu, time_diff);
@@ -639,24 +672,60 @@ static struct kvm_event *pop_from_result(struct rb_root *result)
 	return container_of(node, struct kvm_event, rb);
 }
 
-static void print_vcpu_info(int vcpu)
+static void print_vcpu_info(struct perf_kvm_stat *kvm)
 {
+	int vcpu = kvm->trace_vcpu;
+
 	pr_info("Analyze events for ");
 
+	if (kvm->live) {
+		if (kvm->opts.target.system_wide)
+			pr_info("all VMs, ");
+		else if (kvm->opts.target.pid)
+			pr_info("pid(s) %s, ", kvm->opts.target.pid);
+		else if (kvm->opts.target.tid)
+			pr_info("tid(s) %s, ", kvm->opts.target.tid);
+		else if (kvm->opts.target.cpu_list)
+			pr_info("host cpu(s) %s, ", kvm->opts.target.cpu_list);
+		else
+			pr_info("dazed and confused on what is monitored, ");
+	}
+
 	if (vcpu == -1)
 		pr_info("all VCPUs:\n\n");
 	else
 		pr_info("VCPU %d:\n\n", vcpu);
 }
 
+static void show_timeofday(void)
+{
+	char date[64];
+	struct timeval tv;
+	struct tm ltime;
+
+	gettimeofday(&tv, NULL);
+	if (localtime_r(&tv.tv_sec, &ltime)) {
+		strftime(date, sizeof(date), "%H:%M:%S", &ltime);
+		pr_info("%s.%06ld", date, tv.tv_usec);
+	} else
+		pr_info("00:00:00.000000");
+
+	return;
+}
+
 static void print_result(struct perf_kvm_stat *kvm)
 {
 	char decode[20];
 	struct kvm_event *event;
 	int vcpu = kvm->trace_vcpu;
 
+	if (kvm->live) {
+		puts(CONSOLE_CLEAR);
+		show_timeofday();
+	}
+
 	pr_info("\n\n");
-	print_vcpu_info(vcpu);
+	print_vcpu_info(kvm);
 	pr_info("%20s ", kvm->events_ops->name);
 	pr_info("%10s ", "Samples");
 	pr_info("%9s ", "Samples%");
@@ -683,6 +752,20 @@ static void print_result(struct perf_kvm_stat *kvm)
 
 	pr_info("\nTotal Samples:%" PRIu64 ", Total events handled time:%.2fus.\n\n",
 		kvm->total_count, kvm->total_time / 1e3);
+
+	if (kvm->lost_events)
+		pr_info("\nLost events: %" PRIu64 "\n\n", kvm->lost_events);
+}
+
+static int process_lost_event(struct perf_tool *tool,
+			      union perf_event *event __maybe_unused,
+			      struct perf_sample *sample __maybe_unused,
+			      struct machine *machine __maybe_unused)
+{
+	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat, tool);
+
+	kvm->lost_events++;
+	return 0;
 }
 
 static int process_sample_event(struct perf_tool *tool,
@@ -707,10 +790,20 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int get_cpu_isa(struct perf_session *session)
+static int cpu_isa_config(struct perf_kvm_stat *kvm)
 {
-	char *cpuid = session->header.env.cpuid;
-	int isa;
+	char buf[64], *cpuid;
+	int err, isa;
+
+	if (kvm->live) {
+		err = get_cpuid(buf, sizeof(buf));
+		if (err != 0) {
+			pr_err("Failed to look up CPU type (Intel or AMD)\n");
+			return err;
+		}
+		cpuid = buf;
+	} else
+		cpuid = kvm->session->header.env.cpuid;
 
 	if (strstr(cpuid, "Intel"))
 		isa = 1;
@@ -718,10 +811,339 @@ static int get_cpu_isa(struct perf_session *session)
 		isa = 0;
 	else {
 		pr_err("CPU %s is not supported.\n", cpuid);
-		isa = -ENOTSUP;
+		return -ENOTSUP;
+	}
+
+	if (isa == 1) {
+		kvm->exit_reasons = vmx_exit_reasons;
+		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
+		kvm->exit_reasons_isa = "VMX";
+	}
+
+	return 0;
+}
+
+static bool verify_vcpu(int vcpu)
+{
+	int nr_cpus;
+
+	if (vcpu != -1 && vcpu < 0) {
+		pr_err("Invalid vcpu:%d.\n", vcpu);
+		return false;
+	}
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if ((nr_cpus > 0) && (vcpu > nr_cpus - 1)) {
+		pr_err("Invalid vcpu:%d.\n", vcpu);
+		return false;
+	}
+
+	return true;
+}
+
+#define PERF_KVM__MAX_EVENTS_PER_MMAP  1000
+
+static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx)
+{
+	union perf_event *event;
+	s64 n = 0;
+	int err;
+
+	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
+		err = perf_session__process_event(kvm->session, event,
+						  &kvm->tool, 0);
+		if (err) {
+			pr_err("Failed to process event\n");
+			return err;
+		}
+		n++;
+
+		/* limit events per mmap handled all at once */
+		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
+			break;
+	}
+
+	return n;
+}
+
+static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
+{
+	int i, err, throttled = 0;
+	s64 n, ntotal = 0;
+
+	for (i = 0; i < kvm->evlist->nr_mmaps; i++) {
+		n = perf_kvm__mmap_read_idx(kvm, i);
+		if (n < 0)
+			return -1;
+		ntotal += n;
+		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
+			throttled = 1;
+	}
+
+	/* flush queue after each round in which we processed events */
+	if (ntotal) {
+		err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
+		if (err) {
+			if (kvm->lost_events)
+				pr_info("\nLost events: %" PRIu64 "\n\n",
+					kvm->lost_events);
+			return err;
+		}
+	}
+
+	return throttled;
+}
+
+static volatile int done;
+
+static void sig_handler(int sig __maybe_unused)
+{
+	done = 1;
+}
+
+static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
+{
+	struct itimerspec new_value;
+	int rc = -1;
+
+	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
+	if (kvm->timerfd < 0) {
+		pr_err("timerfd_create failed\n");
+		goto out;
+	}
+
+	new_value.it_value.tv_sec = kvm->display_time;
+	new_value.it_value.tv_nsec = 0;
+	new_value.it_interval.tv_sec = kvm->display_time;
+	new_value.it_interval.tv_nsec = 0;
+
+	if (timerfd_settime(kvm->timerfd, 0, &new_value, NULL) != 0) {
+		pr_err("timerfd_settime failed: %d\n", errno);
+		close(kvm->timerfd);
+		goto out;
+	}
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int perf_kvm__handle_timerfd(struct perf_kvm_stat *kvm)
+{
+	uint64_t c;
+	int rc;
+
+	rc = read(kvm->timerfd, &c, sizeof(uint64_t));
+	if (rc < 0) {
+		if (errno == EAGAIN)
+			return 0;
+
+		pr_err("Failed to read timer fd: %d\n", errno);
+		return -1;
+	}
+
+	if (rc != sizeof(uint64_t)) {
+		pr_err("Error reading timer fd - invalid size returned\n");
+		return -1;
+	}
+
+	if (c != 1)
+		pr_debug("Missed timer beats: %" PRIu64 "\n", c-1);
+
+	/* update display */
+	sort_result(kvm);
+	print_result(kvm);
+
+	/* reset counts */
+	clear_events_cache_stats(kvm->kvm_events_cache);
+	kvm->total_count = 0;
+	kvm->total_time = 0;
+	kvm->lost_events = 0;
+
+	return 0;
+}
+
+static int fd_set_nonblock(int fd)
+{
+	long arg = 0;
+
+	arg = fcntl(fd, F_GETFL);
+	if (arg < 0) {
+		pr_err("Failed to get current flags for fd %d\n", fd);
+		return -1;
+	}
+
+	if (fcntl(fd, F_SETFL, arg | O_NONBLOCK) < 0) {
+		pr_err("Failed to set non-block option on fd %d\n", fd);
+		return -1;
+	}
+
+	return 0;
+}
+
+static
+int perf_kvm__handle_stdin(struct termios *tc_now, struct termios *tc_save)
+{
+	int c;
+
+	tcsetattr(0, TCSANOW, tc_now);
+	c = getc(stdin);
+	tcsetattr(0, TCSAFLUSH, tc_save);
+
+	if (c == 'q')
+		return 1;
+
+	return 0;
+}
+
+static int kvm_events_live_report(struct perf_kvm_stat *kvm)
+{
+	struct pollfd *pollfds = NULL;
+	int nr_fds, nr_stdin, ret, err = -EINVAL;
+	struct termios tc, save;
+
+	/* live flag must be set first */
+	kvm->live = true;
+
+	ret = cpu_isa_config(kvm);
+	if (ret < 0)
+		return ret;
+
+	if (!verify_vcpu(kvm->trace_vcpu) ||
+	    !select_key(kvm) ||
+	    !register_kvm_events_ops(kvm)) {
+		goto out;
+	}
+
+	init_kvm_event_record(kvm);
+
+	tcgetattr(0, &save);
+	tc = save;
+	tc.c_lflag &= ~(ICANON | ECHO);
+	tc.c_cc[VMIN] = 0;
+	tc.c_cc[VTIME] = 0;
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	/* copy pollfds -- need to add timerfd and stdin */
+	nr_fds = kvm->evlist->nr_fds;
+	pollfds = zalloc(sizeof(struct pollfd) * (nr_fds + 2));
+	if (!pollfds) {
+		err = -ENOMEM;
+		goto out;
+	}
+	memcpy(pollfds, kvm->evlist->pollfd,
+		sizeof(struct pollfd) * kvm->evlist->nr_fds);
+
+	/* add timer fd */
+	if (perf_kvm__timerfd_create(kvm) < 0) {
+		err = -1;
+		goto out;
+	}
+
+	pollfds[nr_fds].fd = kvm->timerfd;
+	pollfds[nr_fds].events = POLLIN;
+	nr_fds++;
+
+	pollfds[nr_fds].fd = fileno(stdin);
+	pollfds[nr_fds].events = POLLIN;
+	nr_stdin = nr_fds;
+	nr_fds++;
+	if (fd_set_nonblock(fileno(stdin)) != 0)
+		goto out;
+
+	/* everything is good - enable the events and process */
+	perf_evlist__enable(kvm->evlist);
+
+	while (!done) {
+		int rc;
+
+		rc = perf_kvm__mmap_read(kvm);
+		if (rc < 0)
+			break;
+
+		err = perf_kvm__handle_timerfd(kvm);
+		if (err)
+			goto out;
+
+		if (pollfds[nr_stdin].revents & POLLIN)
+			done = perf_kvm__handle_stdin(&tc, &save);
+
+		if (!rc && !done)
+			err = poll(pollfds, nr_fds, 100);
+	}
+
+	perf_evlist__disable(kvm->evlist);
+
+	if (err == 0) {
+		sort_result(kvm);
+		print_result(kvm);
 	}
 
-	return isa;
+out:
+	if (kvm->timerfd >= 0)
+		close(kvm->timerfd);
+
+	if (pollfds)
+		free(pollfds);
+
+	return err;
+}
+
+static int perf_kvm__open_counters(struct perf_kvm_stat *kvm)
+{
+	struct perf_evsel *pos;
+	struct perf_evlist *evlist = kvm->evlist;
+	char msg[512];
+
+	perf_evlist__config(evlist, &kvm->opts);
+
+	/*
+	 * Note: exclude_{guest,host} do not apply here.
+	 *       This command processes KVM tracepoints from host only
+	 */
+	list_for_each_entry(pos, &evlist->entries, node) {
+		struct perf_event_attr *attr = &pos->attr;
+
+		attr->sample_type |= PERF_SAMPLE_TID;
+		attr->sample_type |= PERF_SAMPLE_TIME;
+		attr->sample_type |= PERF_SAMPLE_CPU;
+		attr->sample_type |= PERF_SAMPLE_RAW;
+
+		attr->sample_period = 1;
+
+		attr->watermark = 0;
+		attr->wakeup_events = 1000;
+
+		/* will enable all once we are ready */
+		attr->disabled = 1;
+
+try_again:
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
+			if (perf_evsel__fallback(pos, errno, msg, sizeof(msg))) {
+				if (verbose)
+					ui__warning("%s\n", msg);
+				goto try_again;
+			}
+
+			perf_evsel__open_strerror(pos, &kvm->opts.target,
+						  errno, msg, sizeof(msg));
+			ui__error("%s\n", msg);
+			goto out_err;
+		}
+	}
+
+	if (perf_evlist__mmap(evlist, kvm->opts.mmap_pages, false) < 0) {
+		ui__error("Failed to mmap with %d (%s)\n",
+			  errno, strerror(errno));
+		goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	return -1;
 }
 
 static int read_events(struct perf_kvm_stat *kvm)
@@ -749,30 +1171,13 @@ static int read_events(struct perf_kvm_stat *kvm)
 	 * Do not use 'isa' recorded in kvm_exit tracepoint since it is not
 	 * traced in the old kernel.
 	 */
-	ret = get_cpu_isa(kvm->session);
-
+	ret = cpu_isa_config(kvm);
 	if (ret < 0)
 		return ret;
 
-	if (ret == 1) {
-		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
-		kvm->exit_reasons_isa = "VMX";
-	}
-
 	return perf_session__process_events(kvm->session, &kvm->tool);
 }
 
-static bool verify_vcpu(int vcpu)
-{
-	if (vcpu != -1 && vcpu < 0) {
-		pr_err("Invalid vcpu:%d.\n", vcpu);
-		return false;
-	}
-
-	return true;
-}
-
 static int kvm_events_report_vcpu(struct perf_kvm_stat *kvm)
 {
 	int ret = -EINVAL;
@@ -886,6 +1291,148 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	return kvm_events_report_vcpu(kvm);
 }
 
+static int kvm_events_live(struct perf_kvm_stat *kvm,
+			   int argc, const char **argv)
+{
+	char errbuf[BUFSIZ];
+	int err;
+	const struct option live_options[] = {
+		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
+			"record events on existing process id"),
+		OPT_STRING('t', "tid", &kvm->opts.target.tid, "tid",
+			"record events on existing thread id"),
+		OPT_STRING('C', "cpu", &kvm->opts.target.cpu_list, "cpu",
+			"list of host cpus to monitor"),
+		OPT_UINTEGER('m', "mmap-pages", &kvm->opts.mmap_pages,
+			"number of mmap data pages"),
+		OPT_INCR('v', "verbose", &verbose,
+			"be more verbose (show counter open errors, etc)"),
+		OPT_BOOLEAN('a', "all-cpus", &kvm->opts.target.system_wide,
+			"system-wide collection from all CPUs"),
+		OPT_UINTEGER('d', "display", &kvm->display_time,
+			"time in seconds between display updates"),
+		OPT_STRING(0, "event", &kvm->report_event, "report event",
+			"event for reporting: vmexit, mmio, ioport"),
+		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
+			"vcpu id to report"),
+		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
+			"key for sorting: sample(sort by samples number)"
+			" time (sort by avg time)"),
+		OPT_END()
+	};
+	const char * const live_usage[] = {
+		"perf kvm stat live [<options>]",
+		NULL
+	};
+
+
+	/* event handling */
+	kvm->tool.sample = process_sample_event;
+	kvm->tool.comm   = perf_event__process_comm;
+	kvm->tool.exit   = perf_event__process_exit;
+	kvm->tool.fork   = perf_event__process_fork;
+	kvm->tool.lost   = process_lost_event;
+	kvm->tool.ordered_samples = true;
+	perf_tool__fill_defaults(&kvm->tool);
+
+	/* set defaults */
+	kvm->display_time = 1;
+	kvm->opts.user_interval = 1;
+	kvm->opts.mmap_pages = 512;
+	kvm->opts.target.uses_mmap = true;
+	kvm->opts.target.uid_str = NULL;
+	kvm->opts.target.uid = UINT_MAX;
+
+	symbol__init();
+	disable_buildid_cache();
+
+	use_browser = 0;
+	setup_browser(false);
+
+	if (argc) {
+		argc = parse_options(argc, argv, live_options,
+				     live_usage, 0);
+		if (argc)
+			usage_with_options(live_usage, live_options);
+	}
+
+	/*
+	 * target related setups
+	 */
+	err = perf_target__validate(&kvm->opts.target);
+	if (err) {
+		perf_target__strerror(&kvm->opts.target, err, errbuf, BUFSIZ);
+		ui__warning("%s", errbuf);
+	}
+
+	if (perf_target__none(&kvm->opts.target))
+		kvm->opts.target.system_wide = true;
+
+
+	/*
+	 * generate the event list
+	 */
+	kvm->evlist = perf_evlist__new();
+	if (kvm->evlist == NULL)
+		return -ENOMEM;
+
+	err = perf_evlist__add_tracepoints(kvm->evlist,
+					   kvm_events_tp,
+					   ARRAY_SIZE(kvm_events_tp));
+	if (err != 0)
+		goto out;
+
+	symbol_conf.nr_events = kvm->evlist->nr_entries;
+
+	if (perf_evlist__create_maps(kvm->evlist, &kvm->opts.target) < 0)
+		usage_with_options(live_usage, live_options);
+
+	/*
+	 * perf session
+	 */
+	kvm->session = perf_session__new(NULL, O_WRONLY, false, false, &kvm->tool);
+	if (kvm->session == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
+	kvm->session->evlist = kvm->evlist;
+	perf_session__set_id_hdr_size(kvm->session);
+
+	/*
+	 * need to get pevent initialized
+	 */
+	err = perf_evlist__trace_init(kvm->evlist, kvm->session);
+	if (err != 0)
+		goto out;
+
+	if (perf_target__has_task(&kvm->opts.target))
+		perf_event__synthesize_thread_map(&kvm->tool,
+						  kvm->evlist->threads,
+						  perf_event__process,
+						  &kvm->session->machines.host);
+	else
+		perf_event__synthesize_threads(&kvm->tool, perf_event__process,
+					       &kvm->session->machines.host);
+
+
+	err = perf_kvm__open_counters(kvm);
+	if (err)
+		goto out;
+
+	err = kvm_events_live_report(kvm);
+
+out:
+	exit_browser(0);
+
+	if (kvm->session)
+		perf_session__delete(kvm->session);
+	kvm->session = NULL;
+	perf_evlist__delete_maps(kvm->evlist);
+	perf_evlist__delete(kvm->evlist);
+
+	return err;
+}
+
 static void print_kvm_stat_usage(void)
 {
 	printf("Usage: perf kvm stat <command>\n\n");
@@ -893,6 +1440,7 @@ static void print_kvm_stat_usage(void)
 	printf("# Available commands:\n");
 	printf("\trecord: record kvm events\n");
 	printf("\treport: report statistical data of kvm events\n");
+	printf("\tlive:   live reporting of statistical data of kvm events\n");
 
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }
@@ -922,6 +1470,9 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 	if (!strncmp(argv[1], "rep", 3))
 		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
+	if (!strncmp(argv[1], "live", 4))
+		return kvm_events_live(&kvm, argc - 1 , argv + 1);
+
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
-- 
1.7.10.1

