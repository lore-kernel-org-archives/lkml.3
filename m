Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3HLKX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:23:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:53 -0400
Date: Mon, 12 Aug 2013 03:23:12 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-1afe1d148491069ef51ed69fa53b09e1cb3ec30d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375753297-69645-3-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Add live mode
Git-Commit-ID: 1afe1d148491069ef51ed69fa53b09e1cb3ec30d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:23:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1afe1d148491069ef51ed69fa53b09e1cb3ec30d
Gitweb:     http://git.kernel.org/tip/1afe1d148491069ef51ed69fa53b09e1cb3ec30d
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 5 Aug 2013 21:41:34 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:38 -0300

perf kvm: Add live mode

perf kvm stat currently requires back to back record and report commands
to see stats. e.g,.

  perf kvm stat record -p $pid -- sleep 1
  perf kvm stat report

This is inconvenvient for on box monitoring of a VM. This patch
introduces a 'live' mode that in effect combines the record plus report
into one command. e.g., to monitor a single VM:

  perf kvm stat live -p $pid

or all VMs:

  perf kvm stat live

Same stats options for the record+report path work with the live mode.
Display rate defaults to 1 second and can be changed using the -d
option.

v4:
- address comments from Xiao -- verify_vcpu check should not look at
  processors on line for the host, prune configurable options.
- set attr->{mmap,comm,task} to 0 - don't need task events so trim events
  we have to deal with
- better control of time for queue event flushing to reduce frequency of
  "Timestamp below last timeslice flush" failures.

v3:
updated to use existing tracepoint parsing code

v2:
removed ABSTIME arg from timerfd_settime as mentioned by Namhyung
only call perf_kvm__handle_stdin when poll returns activity.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375753297-69645-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 659 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 633 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7d14a3a..29bfca7 100644
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
@@ -639,24 +672,56 @@ static struct kvm_event *pop_from_result(struct rb_root *result)
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
@@ -683,6 +748,20 @@ static void print_result(struct perf_kvm_stat *kvm)
 
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
@@ -707,10 +786,20 @@ static int process_sample_event(struct perf_tool *tool,
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
@@ -718,10 +807,361 @@ static int get_cpu_isa(struct perf_session *session)
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
+	if (vcpu != -1 && vcpu < 0) {
+		pr_err("Invalid vcpu:%d.\n", vcpu);
+		return false;
+	}
+
+	return true;
+}
+
+/* keeping the max events to a modest level to keep
+ * the processing of samples per mmap smooth.
+ */
+#define PERF_KVM__MAX_EVENTS_PER_MMAP  25
+
+static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
+				   u64 *mmap_time)
+{
+	union perf_event *event;
+	struct perf_sample sample;
+	s64 n = 0;
+	int err;
+
+	*mmap_time = ULLONG_MAX;
+	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
+		err = perf_evlist__parse_sample(kvm->evlist, event, &sample);
+		if (err) {
+			pr_err("Failed to parse sample\n");
+			return -1;
+		}
+
+		err = perf_session_queue_event(kvm->session, event, &sample, 0);
+		if (err) {
+			pr_err("Failed to enqueue sample: %d\n", err);
+			return -1;
+		}
+
+		/* save time stamp of our first sample for this mmap */
+		if (n == 0)
+			*mmap_time = sample.time;
+
+		/* limit events per mmap handled all at once */
+		n++;
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
+	u64 flush_time = ULLONG_MAX, mmap_time;
+
+	for (i = 0; i < kvm->evlist->nr_mmaps; i++) {
+		n = perf_kvm__mmap_read_idx(kvm, i, &mmap_time);
+		if (n < 0)
+			return -1;
+
+		/* flush time is going to be the minimum of all the individual
+		 * mmap times. Essentially, we flush all the samples queued up
+		 * from the last pass under our minimal start time -- that leaves
+		 * a very small race for samples to come in with a lower timestamp.
+		 * The ioctl to return the perf_clock timestamp should close the
+		 * race entirely.
+		 */
+		if (mmap_time < flush_time)
+			flush_time = mmap_time;
+
+		ntotal += n;
+		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
+			throttled = 1;
+	}
+
+	/* flush queue after each round in which we processed events */
+	if (ntotal) {
+		kvm->session->ordered_samples.next_flush = flush_time;
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
+	}
+
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
+static int kvm_live_open_events(struct perf_kvm_stat *kvm)
+{
+	int err, rc = -1;
+	struct perf_evsel *pos;
+	struct perf_evlist *evlist = kvm->evlist;
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
+		/* make sure these *are* set */
+		attr->sample_type |= PERF_SAMPLE_TID;
+		attr->sample_type |= PERF_SAMPLE_TIME;
+		attr->sample_type |= PERF_SAMPLE_CPU;
+		attr->sample_type |= PERF_SAMPLE_RAW;
+		/* make sure these are *not*; want as small a sample as possible */
+		attr->sample_type &= ~PERF_SAMPLE_PERIOD;
+		attr->sample_type &= ~PERF_SAMPLE_IP;
+		attr->sample_type &= ~PERF_SAMPLE_CALLCHAIN;
+		attr->sample_type &= ~PERF_SAMPLE_ADDR;
+		attr->sample_type &= ~PERF_SAMPLE_READ;
+		attr->mmap = 0;
+		attr->comm = 0;
+		attr->task = 0;
+
+		attr->sample_period = 1;
+
+		attr->watermark = 0;
+		attr->wakeup_events = 1000;
+
+		/* will enable all once we are ready */
+		attr->disabled = 1;
+	}
+
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		printf("Couldn't create the events: %s\n", strerror(errno));
+		goto out;
 	}
 
-	return isa;
+	if (perf_evlist__mmap(evlist, kvm->opts.mmap_pages, false) < 0) {
+		ui__error("Failed to mmap the events: %s\n", strerror(errno));
+		perf_evlist__close(evlist);
+		goto out;
+	}
+
+	rc = 0;
+
+out:
+	return rc;
 }
 
 static int read_events(struct perf_kvm_stat *kvm)
@@ -749,30 +1189,13 @@ static int read_events(struct perf_kvm_stat *kvm)
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
@@ -886,6 +1309,186 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	return kvm_events_report_vcpu(kvm);
 }
 
+static struct perf_evlist *kvm_live_event_list(void)
+{
+	struct perf_evlist *evlist;
+	char *tp, *name, *sys;
+	unsigned int j;
+	int err = -1;
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL)
+		return NULL;
+
+	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+
+		tp = strdup(kvm_events_tp[j]);
+		if (tp == NULL)
+			goto out;
+
+		/* split tracepoint into subsystem and name */
+		sys = tp;
+		name = strchr(tp, ':');
+		if (name == NULL) {
+			pr_err("Error parsing %s tracepoint: subsystem delimiter not found\n",
+				kvm_events_tp[j]);
+			free(tp);
+			goto out;
+		}
+		*name = '\0';
+		name++;
+
+		if (perf_evlist__add_newtp(evlist, sys, name, NULL)) {
+			pr_err("Failed to add %s tracepoint to the list\n", kvm_events_tp[j]);
+			free(tp);
+			goto out;
+		}
+
+		free(tp);
+	}
+
+	err = 0;
+
+out:
+	if (err) {
+		perf_evlist__delete(evlist);
+		evlist = NULL;
+	}
+
+	return evlist;
+}
+
+static int kvm_events_live(struct perf_kvm_stat *kvm,
+			   int argc, const char **argv)
+{
+	char errbuf[BUFSIZ];
+	int err;
+
+	const struct option live_options[] = {
+		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
+			"record events on existing process id"),
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
+	kvm->opts.target.uses_mmap = false;
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
+	kvm->evlist = kvm_live_event_list();
+	if (kvm->evlist == NULL) {
+		err = -1;
+		goto out;
+	}
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
+	err = kvm_live_open_events(kvm);
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
+	if (kvm->evlist) {
+		perf_evlist__delete_maps(kvm->evlist);
+		perf_evlist__delete(kvm->evlist);
+	}
+
+	return err;
+}
+
 static void print_kvm_stat_usage(void)
 {
 	printf("Usage: perf kvm stat <command>\n\n");
@@ -893,6 +1496,7 @@ static void print_kvm_stat_usage(void)
 	printf("# Available commands:\n");
 	printf("\trecord: record kvm events\n");
 	printf("\treport: report statistical data of kvm events\n");
+	printf("\tlive:   live reporting of statistical data of kvm events\n");
 
 	printf("\nOtherwise, it is the alias of 'perf stat':\n");
 }
@@ -922,6 +1526,9 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 	if (!strncmp(argv[1], "rep", 3))
 		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
+	if (!strncmp(argv[1], "live", 4))
+		return kvm_events_live(&kvm, argc - 1 , argv + 1);
+
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
