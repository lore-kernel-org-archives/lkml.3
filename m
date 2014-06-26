Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaFZQLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:11:41 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:49545 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbaFZQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:11:33 -0400
X-Yandex-Uniq: 5cede9e7-a0a1-4b16-b42d-5dba72148337
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, bp@suse.de,
        rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] perf timechart: implement IO mode
Date: Thu, 26 Jun 2014 20:11:09 +0400
Message-Id: <1403799071-1252-3-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, timechart records only scheduler and CPU events (task switches,
running times, CPU power states, etc); this commit adds IO mode which
makes it's possible to record IO (disk, network) activity. In this mode
perf timechart will generate SVG with IO charts (writes, reads, tx, rx, polls).

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt |  25 +-
 tools/perf/builtin-timechart.c              | 613 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.c                 |  98 ++++-
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 718 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 5e0f986dff38..ec6b46c7bca0 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -15,10 +15,20 @@ DESCRIPTION
 There are two variants of perf timechart:
 
   'perf timechart record <command>' to record the system level events
-  of an arbitrary workload.
+  of an arbitrary workload. By default timechart records only scheduler
+  and CPU events (task switches, running times, CPU power states, etc),
+  but it's possible to record IO (disk, network) activity using -I argument.
 
   'perf timechart' to turn a trace into a Scalable Vector Graphics file,
-  that can be viewed with popular SVG viewers such as 'Inkscape'.
+  that can be viewed with popular SVG viewers such as 'Inkscape'. Depending
+  on the events in the perf.data file, timechart will contain scheduler/cpu
+  events or IO events.
+
+  In IO mode, every bar has two charts: upper and lower.
+  Upper bar shows incoming events (disk reads, ingress network packets).
+  Lower bar shows outgoing events (disk writes, egress network packets).
+  There are also poll bars which show how much time application spent
+  in poll/epoll/select syscalls.
 
 TIMECHART OPTIONS
 -----------------
@@ -63,6 +73,9 @@ RECORD OPTIONS
 -T::
 --tasks-only::
         Record only tasks-related events
+-I::
+--io-only::
+        Record only io-related events
 -g::
 --callchain::
         Do call-graph (stack chain/backtrace) recording
@@ -87,6 +100,14 @@ $ perf timechart
 
   $ perf timechart --highlight gcc
 
+Record system-wide IO events:
+
+  $ perf timechart record -I
+
+  then generate timechart:
+
+  $ perf timechart
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 74db2568b867..8d454c55bc4e 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -60,10 +60,14 @@ struct timechart {
 				tasks_only,
 				with_backtrace,
 				topology;
+	/* IO related settings */
+	u64			io_events;
+	bool			io_only;
 };
 
 struct per_pidcomm;
 struct cpu_sample;
+struct io_sample;
 
 /*
  * Datastructure layout:
@@ -84,6 +88,7 @@ struct per_pid {
 	u64		start_time;
 	u64		end_time;
 	u64		total_time;
+	u64		total_bytes;
 	int		display;
 
 	struct per_pidcomm *all;
@@ -97,6 +102,8 @@ struct per_pidcomm {
 	u64		start_time;
 	u64		end_time;
 	u64		total_time;
+	u64		max_bytes;
+	u64		total_bytes;
 
 	int		Y;
 	int		display;
@@ -107,6 +114,7 @@ struct per_pidcomm {
 	char		*comm;
 
 	struct cpu_sample *samples;
+	struct io_sample  *io_samples;
 };
 
 struct sample_wrapper {
@@ -131,6 +139,27 @@ struct cpu_sample {
 	const char *backtrace;
 };
 
+enum {
+	IOTYPE_READ,
+	IOTYPE_WRITE,
+	IOTYPE_SYNC,
+	IOTYPE_TX,
+	IOTYPE_RX,
+	IOTYPE_POLL,
+};
+
+struct io_sample {
+	struct io_sample *next;
+
+	u64 start_time;
+	u64 end_time;
+	u64 bytes;
+	int type;
+	int fd;
+	int err;
+	int merges;
+};
+
 #define CSTATE 1
 #define PSTATE 2
 
@@ -682,6 +711,212 @@ static void end_sample_processing(struct timechart *tchart)
 	}
 }
 
+static int pid_begin_io_sample(struct timechart *tchart, int pid, int type,
+			       u64 start, int fd)
+{
+	struct per_pid *p = find_create_pid(tchart, pid);
+	struct per_pidcomm *c = p->current;
+	struct io_sample *sample;
+	struct io_sample *prev;
+
+	if (!c) {
+		c = zalloc(sizeof(*c));
+		if (!c)
+			return -ENOMEM;
+		p->current = c;
+		c->next = p->all;
+		p->all = c;
+	}
+
+	prev = c->io_samples;
+
+	if (prev && prev->start_time && !prev->end_time) {
+		pr_err("Invalid previous event (duplicate start)!\n");
+		return -1;
+	}
+
+	sample = zalloc(sizeof(*sample));
+	if (!sample)
+		return -ENOMEM;
+	sample->start_time = start;
+	sample->type = type;
+	sample->fd = fd;
+	sample->next = c->io_samples;
+	c->io_samples = sample;
+
+	if (c->start_time == 0 || c->start_time > start)
+		c->start_time = start;
+
+	return 0;
+}
+
+static int pid_end_io_sample(struct timechart *tchart, int pid, int type,
+			     u64 end, long ret)
+{
+	struct per_pid *p = find_create_pid(tchart, pid);
+	struct per_pidcomm *c = p->current;
+	struct io_sample *sample;
+
+	if (!c) {
+		pr_err("Invalid pidcomm!\n");
+		return -1;
+	}
+
+	sample = c->io_samples;
+
+	if (!sample) /* skip partially captured events */
+		return 0;
+
+	if (c->io_samples->end_time) {
+		pr_err("Invalid previous event (non-zero)!\n");
+		return -1;
+	}
+
+	if (c->io_samples->type != type) {
+		pr_err("Invalid previous event (type)!\n");
+		return -1;
+	}
+
+	sample->end_time = end;
+
+	if (ret < 0) {
+		sample->err = ret;
+	} else if (type == IOTYPE_READ || type == IOTYPE_WRITE ||
+		   type == IOTYPE_TX || type == IOTYPE_RX) {
+
+		if ((u64)ret > c->max_bytes)
+			c->max_bytes = ret;
+
+		c->total_bytes += ret;
+		p->total_bytes += ret;
+		sample->bytes = ret;
+	}
+
+	tchart->io_events++;
+
+	return 0;
+}
+
+static int
+process_enter_read(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_READ,
+				   sample->time, fd);
+}
+
+static int
+process_exit_read(struct timechart *tchart,
+		  struct perf_evsel *evsel,
+		  struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_READ,
+				 sample->time, ret);
+}
+
+static int
+process_enter_write(struct timechart *tchart,
+		    struct perf_evsel *evsel,
+		    struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_WRITE,
+				   sample->time, fd);
+}
+
+static int
+process_exit_write(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_WRITE,
+				 sample->time, ret);
+}
+
+static int
+process_enter_sync(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_SYNC,
+				   sample->time, fd);
+}
+
+static int
+process_exit_sync(struct timechart *tchart,
+		  struct perf_evsel *evsel,
+		  struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_SYNC,
+				 sample->time, ret);
+}
+
+static int
+process_enter_tx(struct timechart *tchart,
+		 struct perf_evsel *evsel,
+		 struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_TX,
+				   sample->time, fd);
+}
+
+static int
+process_exit_tx(struct timechart *tchart,
+		struct perf_evsel *evsel,
+		struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_TX,
+				 sample->time, ret);
+}
+
+static int
+process_enter_rx(struct timechart *tchart,
+		 struct perf_evsel *evsel,
+		 struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_RX,
+				   sample->time, fd);
+}
+
+static int
+process_exit_rx(struct timechart *tchart,
+		struct perf_evsel *evsel,
+		struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_RX,
+				 sample->time, ret);
+}
+
+static int
+process_enter_poll(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_POLL,
+				   sample->time, fd);
+}
+
+static int
+process_exit_poll(struct timechart *tchart,
+		  struct perf_evsel *evsel,
+		  struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_POLL,
+				 sample->time, ret);
+}
+
 /*
  * Sort the pid datastructure
  */
@@ -852,6 +1087,117 @@ static void draw_cpu_usage(struct timechart *tchart)
 	}
 }
 
+static void draw_io_bars(struct timechart *tchart)
+{
+	const char *suf;
+	double bytes;
+	char comm[256];
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct io_sample *sample;
+	int Y = 1;
+
+	p = tchart->all_data;
+	while (p) {
+		c = p->all;
+		while (c) {
+			if (!c->display) {
+				c->Y = 0;
+				c = c->next;
+				continue;
+			}
+
+			svg_box(Y, c->start_time, c->end_time, "process3");
+			sample = c->io_samples;
+			for (sample = c->io_samples; sample; sample = sample->next) {
+				double h = (double)sample->bytes / c->max_bytes;
+
+				if (sample->err)
+					h = 1;
+
+				if (sample->type == IOTYPE_SYNC)
+					svg_fbox(Y,
+						sample->start_time,
+						sample->end_time,
+						1,
+						sample->err ? "error" : "sync",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_POLL)
+					svg_fbox(Y,
+						sample->start_time,
+						sample->end_time,
+						1,
+						sample->err ? "error" : "poll",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_READ)
+					svg_ubox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "disk",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_WRITE)
+					svg_lbox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "disk",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_RX)
+					svg_ubox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "net",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_TX)
+					svg_lbox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "net",
+						sample->fd,
+						sample->err,
+						sample->merges);
+			}
+
+			suf = "";
+			bytes = c->total_bytes;
+			if (bytes > 1024) {
+				bytes = bytes / 1024;
+				suf = "K";
+			}
+			if (bytes > 1024) {
+				bytes = bytes / 1024;
+				suf = "M";
+			}
+			if (bytes > 1024) {
+				bytes = bytes / 1024;
+				suf = "G";
+			}
+
+
+			sprintf(comm, "%s:%i (%3.1f %sbytes)", c->comm ?: "", p->pid, bytes, suf);
+			svg_text(Y, c->start_time, comm);
+
+			c->Y = Y;
+			Y++;
+			c = c->next;
+		}
+		p = p->next;
+	}
+}
+
 static void draw_process_bars(struct timechart *tchart)
 {
 	struct per_pid *p;
@@ -987,9 +1333,6 @@ static int determine_display_tasks(struct timechart *tchart, u64 threshold)
 	struct per_pidcomm *c;
 	int count = 0;
 
-	if (process_filter)
-		return determine_display_tasks_filtered(tchart);
-
 	p = tchart->all_data;
 	while (p) {
 		p->display = 0;
@@ -1025,15 +1368,46 @@ static int determine_display_tasks(struct timechart *tchart, u64 threshold)
 	return count;
 }
 
+static int determine_display_io_tasks(struct timechart *timechart, u64 threshold)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	int count = 0;
+
+	p = timechart->all_data;
+	while (p) {
+		/* no exit marker, task kept running to the end */
+		if (p->end_time == 0)
+			p->end_time = timechart->last_time;
+
+		c = p->all;
+
+		while (c) {
+			c->display = 0;
 
+			if (c->total_bytes >= threshold) {
+				c->display = 1;
+				count++;
+			}
 
+			if (c->end_time == 0)
+				c->end_time = timechart->last_time;
+
+			c = c->next;
+		}
+		p = p->next;
+	}
+	return count;
+}
+
+#define BYTES_THRESH (1 * 1024 * 1024)
 #define TIME_THRESH 10000000
 
 static void write_svg_file(struct timechart *tchart, const char *filename)
 {
 	u64 i;
 	int count;
-	int thresh = TIME_THRESH;
+	int thresh = tchart->io_events ? BYTES_THRESH : TIME_THRESH;
 
 	if (tchart->power_only)
 		tchart->proc_num = 0;
@@ -1041,28 +1415,43 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 	/* We'd like to show at least proc_num tasks;
 	 * be less picky if we have fewer */
 	do {
-		count = determine_display_tasks(tchart, thresh);
+		if (process_filter)
+			count = determine_display_tasks_filtered(tchart);
+		else if (tchart->io_events)
+			count = determine_display_io_tasks(tchart, thresh);
+		else
+			count = determine_display_tasks(tchart, thresh);
 		thresh /= 10;
 	} while (!process_filter && thresh && count < tchart->proc_num);
 
 	if (!tchart->proc_num)
 		count = 0;
 
-	open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
+	if (tchart->io_events) {
+		open_svg(filename, 0, count, tchart->first_time, tchart->last_time);
 
-	svg_time_grid();
-	svg_legenda();
+		svg_time_grid(0.5);
+		svg_io_legenda();
 
-	for (i = 0; i < tchart->numcpus; i++)
-		svg_cpu_box(i, tchart->max_freq, tchart->turbo_frequency);
+		draw_io_bars(tchart);
+	} else {
+		open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
 
-	draw_cpu_usage(tchart);
-	if (tchart->proc_num)
-		draw_process_bars(tchart);
-	if (!tchart->tasks_only)
-		draw_c_p_states(tchart);
-	if (tchart->proc_num)
-		draw_wakeups(tchart);
+		svg_time_grid(0);
+
+		svg_legenda();
+
+		for (i = 0; i < tchart->numcpus; i++)
+			svg_cpu_box(i, tchart->max_freq, tchart->turbo_frequency);
+
+		draw_cpu_usage(tchart);
+		if (tchart->proc_num)
+			draw_process_bars(tchart);
+		if (!tchart->tasks_only)
+			draw_c_p_states(tchart);
+		if (tchart->proc_num)
+			draw_wakeups(tchart);
+	}
 
 	svg_close();
 }
@@ -1110,6 +1499,56 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 		{ "power:power_end",		process_sample_power_end },
 		{ "power:power_frequency",	process_sample_power_frequency },
 #endif
+
+		{ "syscalls:sys_enter_read",		process_enter_read },
+		{ "syscalls:sys_enter_pread64",		process_enter_read },
+		{ "syscalls:sys_enter_readv",		process_enter_read },
+		{ "syscalls:sys_enter_preadv",		process_enter_read },
+		{ "syscalls:sys_enter_write",		process_enter_write },
+		{ "syscalls:sys_enter_pwrite64",	process_enter_write },
+		{ "syscalls:sys_enter_writev",		process_enter_write },
+		{ "syscalls:sys_enter_pwritev",		process_enter_write },
+		{ "syscalls:sys_enter_sync",		process_enter_sync },
+		{ "syscalls:sys_enter_sync_file_range",	process_enter_sync },
+		{ "syscalls:sys_enter_fsync",		process_enter_sync },
+		{ "syscalls:sys_enter_msync",		process_enter_sync },
+		{ "syscalls:sys_enter_recvfrom",	process_enter_rx },
+		{ "syscalls:sys_enter_recvmmsg",	process_enter_rx },
+		{ "syscalls:sys_enter_recvmsg",		process_enter_rx },
+		{ "syscalls:sys_enter_sendto",		process_enter_tx },
+		{ "syscalls:sys_enter_sendmsg",		process_enter_tx },
+		{ "syscalls:sys_enter_sendmmsg",	process_enter_tx },
+		{ "syscalls:sys_enter_epoll_pwait",	process_enter_poll },
+		{ "syscalls:sys_enter_epoll_wait",	process_enter_poll },
+		{ "syscalls:sys_enter_poll",		process_enter_poll },
+		{ "syscalls:sys_enter_ppoll",		process_enter_poll },
+		{ "syscalls:sys_enter_pselect6",	process_enter_poll },
+		{ "syscalls:sys_enter_select",		process_enter_poll },
+
+		{ "syscalls:sys_exit_read",		process_exit_read },
+		{ "syscalls:sys_exit_pread64",		process_exit_read },
+		{ "syscalls:sys_exit_readv",		process_exit_read },
+		{ "syscalls:sys_exit_preadv",		process_exit_read },
+		{ "syscalls:sys_exit_write",		process_exit_write },
+		{ "syscalls:sys_exit_pwrite64",		process_exit_write },
+		{ "syscalls:sys_exit_writev",		process_exit_write },
+		{ "syscalls:sys_exit_pwritev",		process_exit_write },
+		{ "syscalls:sys_exit_sync",		process_exit_sync },
+		{ "syscalls:sys_exit_sync_file_range",	process_exit_sync },
+		{ "syscalls:sys_exit_fsync",		process_exit_sync },
+		{ "syscalls:sys_exit_msync",		process_exit_sync },
+		{ "syscalls:sys_exit_recvfrom",		process_exit_rx },
+		{ "syscalls:sys_exit_recvmmsg",		process_exit_rx },
+		{ "syscalls:sys_exit_recvmsg",		process_exit_rx },
+		{ "syscalls:sys_exit_sendto",		process_exit_tx },
+		{ "syscalls:sys_exit_sendmsg",		process_exit_tx },
+		{ "syscalls:sys_exit_sendmmsg",		process_exit_tx },
+		{ "syscalls:sys_exit_epoll_pwait",	process_exit_poll },
+		{ "syscalls:sys_exit_epoll_wait",	process_exit_poll },
+		{ "syscalls:sys_exit_poll",		process_exit_poll },
+		{ "syscalls:sys_exit_ppoll",		process_exit_poll },
+		{ "syscalls:sys_exit_pselect6",		process_exit_poll },
+		{ "syscalls:sys_exit_select",		process_exit_poll },
 	};
 	struct perf_data_file file = {
 		.path = input_name,
@@ -1154,6 +1593,139 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 	return ret;
 }
 
+static int timechart__io_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i;
+	const char **rec_argv;
+	const char **p;
+	char *filter = NULL;
+
+	const char * const common_args[] = {
+		"record", "-a", "-R", "-c", "1",
+	};
+	unsigned int common_args_nr = ARRAY_SIZE(common_args);
+
+	const char * const disk_events[] = {
+		"syscalls:sys_enter_read",
+		"syscalls:sys_enter_pread64",
+		"syscalls:sys_enter_readv",
+		"syscalls:sys_enter_preadv",
+		"syscalls:sys_enter_write",
+		"syscalls:sys_enter_pwrite64",
+		"syscalls:sys_enter_writev",
+		"syscalls:sys_enter_pwritev",
+		"syscalls:sys_enter_sync",
+		"syscalls:sys_enter_sync_file_range",
+		"syscalls:sys_enter_fsync",
+		"syscalls:sys_enter_msync",
+
+		"syscalls:sys_exit_read",
+		"syscalls:sys_exit_pread64",
+		"syscalls:sys_exit_readv",
+		"syscalls:sys_exit_preadv",
+		"syscalls:sys_exit_write",
+		"syscalls:sys_exit_pwrite64",
+		"syscalls:sys_exit_writev",
+		"syscalls:sys_exit_pwritev",
+		"syscalls:sys_exit_sync",
+		"syscalls:sys_exit_sync_file_range",
+		"syscalls:sys_exit_fsync",
+		"syscalls:sys_exit_msync",
+	};
+	unsigned int disk_events_nr = ARRAY_SIZE(disk_events);
+
+	const char * const net_events[] = {
+		"syscalls:sys_enter_recvfrom",
+		"syscalls:sys_enter_recvmmsg",
+		"syscalls:sys_enter_recvmsg",
+		"syscalls:sys_enter_sendto",
+		"syscalls:sys_enter_sendmsg",
+		"syscalls:sys_enter_sendmmsg",
+
+		"syscalls:sys_exit_recvfrom",
+		"syscalls:sys_exit_recvmmsg",
+		"syscalls:sys_exit_recvmsg",
+		"syscalls:sys_exit_sendto",
+		"syscalls:sys_exit_sendmsg",
+		"syscalls:sys_exit_sendmmsg",
+	};
+	unsigned int net_events_nr = ARRAY_SIZE(net_events);
+
+	const char * const poll_events[] = {
+		"syscalls:sys_enter_epoll_pwait",
+		"syscalls:sys_enter_epoll_wait",
+		"syscalls:sys_enter_poll",
+		"syscalls:sys_enter_ppoll",
+		"syscalls:sys_enter_pselect6",
+		"syscalls:sys_enter_select",
+
+		"syscalls:sys_exit_epoll_pwait",
+		"syscalls:sys_exit_epoll_wait",
+		"syscalls:sys_exit_poll",
+		"syscalls:sys_exit_ppoll",
+		"syscalls:sys_exit_pselect6",
+		"syscalls:sys_exit_select",
+	};
+	unsigned int poll_events_nr = ARRAY_SIZE(poll_events);
+
+	rec_argc = common_args_nr +
+		disk_events_nr * 4 +
+		net_events_nr * 4 +
+		poll_events_nr * 4 +
+		argc;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	if (asprintf(&filter, "common_pid != %d", getpid()) < 0)
+		return -ENOMEM;
+
+	p = rec_argv;
+	for (i = 0; i < common_args_nr; i++)
+		*p++ = strdup(common_args[i]);
+
+	for (i = 0; i < disk_events_nr; i++) {
+		if (!is_valid_tracepoint(disk_events[i])) {
+			rec_argc -= 4;
+			continue;
+		}
+
+		*p++ = "-e";
+		*p++ = strdup(disk_events[i]);
+		*p++ = "--filter";
+		*p++ = filter;
+	}
+	for (i = 0; i < net_events_nr; i++) {
+		if (!is_valid_tracepoint(net_events[i])) {
+			rec_argc -= 4;
+			continue;
+		}
+
+		*p++ = "-e";
+		*p++ = strdup(net_events[i]);
+		*p++ = "--filter";
+		*p++ = filter;
+	}
+	for (i = 0; i < poll_events_nr; i++) {
+		if (!is_valid_tracepoint(poll_events[i])) {
+			rec_argc -= 4;
+			continue;
+		}
+
+		*p++ = "-e";
+		*p++ = strdup(poll_events[i]);
+		*p++ = "--filter";
+		*p++ = filter;
+	}
+
+	for (i = 0; i < (unsigned int)argc; i++)
+		*p++ = argv[i];
+
+	return cmd_record(rec_argc, rec_argv, NULL);
+}
+
+
 static int timechart__record(struct timechart *tchart, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
@@ -1314,6 +1886,8 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
 	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
 		    "output processes data only"),
+	OPT_BOOLEAN('I', "io-only", &tchart.io_only,
+		    "record only IO data"),
 	OPT_BOOLEAN('g', "callchain", &tchart.with_backtrace, "record callchain"),
 	OPT_END()
 	};
@@ -1340,7 +1914,10 @@ int cmd_timechart(int argc, const char **argv,
 			return -1;
 		}
 
-		return timechart__record(&tchart, argc, argv);
+		if (tchart.io_only)
+			return timechart__io_record(argc, argv);
+		else
+			return timechart__record(&tchart, argc, argv);
 	} else if (argc)
 		usage_with_options(timechart_usage, timechart_options);
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 27caf0f45469..283d3e73e2f2 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -30,6 +30,7 @@ static u64 turbo_frequency, max_freq;
 
 #define SLOT_MULT 30.0
 #define SLOT_HEIGHT 25.0
+#define SLOT_HALF (SLOT_HEIGHT / 2)
 
 int svg_page_width = 1000;
 u64 svg_highlight;
@@ -114,8 +115,14 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "      rect          { stroke-width: 1; }\n");
 	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.process3 { fill:rgb(180,180,180); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample_hi{ fill:rgb(255,128,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.error    { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.net      { fill:rgb(  0,128,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.disk     { fill:rgb(  0,  0,255); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.sync     { fill:rgb(128,128,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.poll     { fill:rgb(  0,128,128); fill-opacity:0.2; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
@@ -132,6 +139,75 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "    ]]>\n   </style>\n</defs>\n");
 }
 
+static double normalize_height(double height)
+{
+	if (height < 0.25)
+		return 0.25;
+	else if (height < 0.50)
+		return 0.50;
+	else if (height < 0.75)
+		return 0.75;
+	else
+		return 0.100;
+}
+
+void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
+{
+	double w = time2pixels(end) - time2pixels(start);
+	height = normalize_height(height);
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
+		time2pixels(start),
+		w,
+		Yslot * SLOT_MULT,
+		SLOT_HALF * height,
+		type);
+	fprintf(svgfile, "</g>\n");
+}
+
+void svg_lbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
+{
+	double w = time2pixels(end) - time2pixels(start);
+	height = normalize_height(height);
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
+		time2pixels(start),
+		w,
+		Yslot * SLOT_MULT + SLOT_HEIGHT - SLOT_HALF * height,
+		SLOT_HALF * height,
+		type);
+	fprintf(svgfile, "</g>\n");
+}
+
+void svg_fbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
+{
+	double w = time2pixels(end) - time2pixels(start);
+	height = normalize_height(height);
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
+		time2pixels(start),
+		w,
+		Yslot * SLOT_MULT + SLOT_HEIGHT - SLOT_HEIGHT * height,
+		SLOT_HEIGHT * height,
+		type);
+	fprintf(svgfile, "</g>\n");
+}
+
 void svg_box(int Yslot, u64 start, u64 end, const char *type)
 {
 	if (!svgfile)
@@ -543,6 +619,20 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
 }
 
+void svg_io_legenda(void)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	svg_legenda_box(0,	"Disk", "disk");
+	svg_legenda_box(100,	"Network", "net");
+	svg_legenda_box(200,	"Sync", "sync");
+	svg_legenda_box(300,	"Poll", "poll");
+	svg_legenda_box(400,	"Error", "error");
+	fprintf(svgfile, "</g>\n");
+}
+
 void svg_legenda(void)
 {
 	if (!svgfile)
@@ -559,7 +649,7 @@ void svg_legenda(void)
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_time_grid(void)
+void svg_time_grid(double min_thickness)
 {
 	u64 i;
 
@@ -579,8 +669,10 @@ void svg_time_grid(void)
 			color = 128;
 		}
 
-		fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%.3f\"/>\n",
-			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
+		if (thickness >= min_thickness)
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%.3f\"/>\n",
+				time2pixels(i), SLOT_MULT/2, time2pixels(i),
+				total_height, color, color, color, thickness);
 
 		i += 10000000;
 	}
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index e3aff5332e30..9292a5291445 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -4,6 +4,9 @@
 #include <linux/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
+extern void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges);
+extern void svg_lbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges);
+extern void svg_fbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
 extern void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
 extern void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
@@ -16,7 +19,8 @@ extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
 
-extern void svg_time_grid(void);
+extern void svg_time_grid(double min_thickness);
+extern void svg_io_legenda(void);
 extern void svg_legenda(void);
 extern void svg_wakeline(u64 start, int row1, int row2, const char *backtrace);
 extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2, const char *backtrace);
-- 
1.9.1

