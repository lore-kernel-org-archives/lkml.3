Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3CMJms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:42:48 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:44117 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMJmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:42:46 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 8/8]Perf: Add some callback functions to process fork & exit events
Date: Wed, 13 Mar 2013 17:42:12 +0800
Message-Id: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Many applications will fork threads on-the-fly, these threads could exit before
the main thread exit. The perf top tool should perceive the new forked threads
while we profile a special application.
If the target process fork a thread or a thread exit, we will get a PERF_RECORD_FORK
 or PERF_RECORD_EXIT events. The following callback functions can process these events.
1) perf_top__process_event_fork()
   Open a new fd for the new forked, and expend the related data structures.
2) perf_top__process_event_exit()
   Close the fd of exit threadsd, and destroy the nodes in the related data structures.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-top.c |  109 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cff58e5..a591b96 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -800,7 +800,8 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	return;
 }
 
-static void perf_top__mmap_read_idx(struct perf_top *top, struct perf_mmap *md)
+static int perf_top__mmap_read_idx(struct perf_top *top, struct perf_mmap *md,
+				    int idx)
 {
 	struct perf_sample sample;
 	struct perf_evsel *evsel;
@@ -825,6 +826,20 @@ static void perf_top__mmap_read_idx(struct perf_top *top, struct perf_mmap *md)
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			++top->samples;
 
+		if (cpu_map__all(top->evlist->cpus) &&
+		    event->header.type == PERF_RECORD_FORK)
+			(&top->tool)->fork(&top->tool, event, &sample, NULL);
+
+		if (cpu_map__all(top->evlist->cpus) &&
+		    event->header.type == PERF_RECORD_EXIT) {
+			int tidx;
+
+			tidx = (&top->tool)->exit(&top->tool, event,
+						  &sample, NULL);
+			if (tidx == idx)
+				return -1;
+		}
+
 		switch (origin) {
 		case PERF_RECORD_MISC_USER:
 			++top->us_samples;
@@ -863,14 +878,18 @@ static void perf_top__mmap_read_idx(struct perf_top *top, struct perf_mmap *md)
 		} else
 			++session->stats.nr_unknown_events;
 	}
+	return 0;
 }
 
 static void perf_top__mmap_read(struct perf_top *top)
 {
 	struct perf_mmap *md;
+	int i = 0;
 
 	for_each_mmap(md, top->evlist) {
-		perf_top__mmap_read_idx(top, md);
+		if (perf_top__mmap_read_idx(top, md, i) == -1)
+			break;
+		i++;
 	}
 }
 
@@ -1025,11 +1044,97 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int perf_top__append_thread(struct perf_top *top, pid_t pid)
+{
+	char msg[512];
+	struct perf_evsel *counter, *counter_err;
+	struct perf_evlist *evlist = top->evlist;
+	struct cpu_map *cpus = evlist->cpus;
+
+	counter_err = list_entry(evlist->entries.prev, struct perf_evsel, node);
+
+	list_for_each_entry(counter, &evlist->entries, node) {
+		if (perf_evsel__open_single_thread(counter, cpus, pid) < 0) {
+			if (verbose) {
+				perf_evsel__open_strerror(counter,
+							  &top->record_opts.target,
+							  errno, msg, sizeof(msg));
+				ui__warning("%s\n", msg);
+			}
+			counter_err = counter;
+			goto close_opened_fd;
+		}
+	}
+
+	if (perf_evlist__mmap_thread(evlist, false) < 0)
+		goto close_opened_fd;
+
+	return 0;
+
+close_opened_fd:
+	list_for_each_entry(counter, &evlist->entries, node) {
+		perf_evsel__close_single_thread(counter, cpus->nr, -1);
+		if (counter == counter_err)
+			break;
+	}
+	return -1;
+}
+
+static int perf_top__process_event_fork(struct perf_tool *tool __maybe_unused,
+					union perf_event *event __maybe_unused,
+					struct perf_sample *sample __maybe_unused,
+					struct machine *machine __maybe_unused)
+{
+	pid_t tid = event->fork.tid;
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
+	struct thread_map *threads = top->evlist->threads;
+	int ret;
+
+	ret = thread_map__append(threads, tid); 
+	if (ret != 0)                   
+		return ret;             
+
+	if (perf_top__append_thread(top, tid) < 0)
+		goto free_new_thread;
+
+	return 0; 
+
+free_new_thread:
+	thread_map__remove(threads, -1);
+	return -1;
+}
+
+static int perf_top__process_event_exit(struct perf_tool *tool __maybe_unused,
+					union perf_event *event __maybe_unused,
+					struct perf_sample *sample __maybe_unused,
+					struct machine *machine __maybe_unused)
+{
+	pid_t tid = event->fork.tid;
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
+	struct perf_evsel *evsel;
+	struct thread_map *threads = top->evlist->threads;
+	int tidx = thread_map__get_idx_by_pid(threads, tid);
+
+	if (tidx < 0)
+		return -1;
+
+	perf_evlist__munmap_thread(top->evlist, tidx);
+	list_for_each_entry(evsel, &top->evlist->entries, node) {
+		perf_evsel__close_single_thread(evsel, top->evlist->cpus->nr, tidx);
+	}
+	thread_map__remove(threads, tidx);
+	return tidx;
+}
+
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int status;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
+		.tool = {
+			.fork		= perf_top__process_event_fork,
+			.exit		= perf_top__process_event_exit,
+		},
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
 		.record_opts = {
-- 
1.7.9.5

