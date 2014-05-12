Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaELJ1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaELJ1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:27:31 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6/6] perf tools: Use tid for finding thread
Date: Mon, 12 May 2014 11:27:13 +0200
Message-Id: <1399886833-15472-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
References: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

I believe that passing pid (instead of tid) as the 3rd arg of the
machine__find*_thread() was to find a main thread so that it can
search proper map group for symbols.  However with the map sharing
patch applied, it now can do it in any thread.

It fixes a bug when each thread has different name, it only reports a
main thread for samples in other threads.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1399856202-26221-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-inject.c     | 2 +-
 tools/perf/builtin-kmem.c       | 2 +-
 tools/perf/tests/code-reading.c | 2 +-
 tools/perf/tests/hists_filter.c | 1 +
 tools/perf/tests/hists_link.c   | 2 ++
 tools/perf/util/build-id.c      | 2 +-
 tools/perf/util/event.c         | 2 +-
 7 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3a73875..6a3af00 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -209,7 +209,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, sample->pid, sample->pid);
+	thread = machine__findnew_thread(machine, sample->pid, sample->tid);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index f91fa437..bef3376 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -235,7 +235,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->pid);
+							sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index adf3de3..67f2d63 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -256,7 +256,7 @@ static int process_sample_event(struct machine *machine,
 		return -1;
 	}
 
-	thread = machine__findnew_thread(machine, sample.pid, sample.pid);
+	thread = machine__findnew_thread(machine, sample.pid, sample.tid);
 	if (!thread) {
 		pr_debug("machine__findnew_thread failed\n");
 		return -1;
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 23dc2f4..4617a8b 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -69,6 +69,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			evsel->hists.symbol_filter_str = NULL;
 
 			sample.pid = fake_samples[i].pid;
+			sample.tid = fake_samples[i].pid;
 			sample.ip = fake_samples[i].ip;
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index e42d679..b009bbf 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -81,6 +81,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			sample.pid = fake_common_samples[k].pid;
+			sample.tid = fake_common_samples[k].pid;
 			sample.ip = fake_common_samples[k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
@@ -104,6 +105,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			sample.pid = fake_samples[i][k].pid;
+			sample.tid = fake_samples[i][k].pid;
 			sample.ip = fake_samples[i][k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 6baabe6..a904a4c 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -25,7 +25,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->pid);
+							sample->tid);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dbcaea1..65795b8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -788,7 +788,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->pid);
+							sample->tid);
 
 	if (thread == NULL)
 		return -1;
-- 
1.8.3.1

