Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3H0IR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:17:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:48905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab3H0IRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="352104934"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V13 04/12] perf tools: remove references to struct ip_event
Date: Tue, 27 Aug 2013 11:23:06 +0300
Message-Id: <1377591794-30553-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ip_event assumes fixed positions for ip, pid
and tid.  That is no longer true with the addition of
PERF_SAMPLE_IDENTIFIER.  The information is anyway in
struct sample, so use that instead.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-inject.c   |  4 ++--
 tools/perf/builtin-kmem.c     |  4 ++--
 tools/perf/builtin-mem.c      |  2 +-
 tools/perf/builtin-script.c   |  4 ++--
 tools/perf/builtin-top.c      | 11 ++++++-----
 tools/perf/tests/hists_link.c | 20 ++++++++------------
 tools/perf/util/build-id.c    |  8 ++++----
 tools/perf/util/event.c       |  6 +++---
 tools/perf/util/event.h       | 11 -----------
 tools/perf/util/evsel.c       |  4 ++--
 tools/perf/util/session.c     |  8 +++++---
 11 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 0d4ae1d..ffacd46 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -198,7 +198,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, event->ip.pid, event->ip.pid);
+	thread = machine__findnew_thread(machine, sample->pid, sample->pid);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
@@ -206,7 +206,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 	}
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al);
+			      sample->ip, &al);
 
 	if (al.map != NULL) {
 		if (!al.map->dso->hit) {
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c324778..c2dff9c 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -305,8 +305,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
-							event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->pid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 706a1fa..791b432 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -94,7 +94,7 @@ dump_raw_samples(struct perf_tool *tool,
 		symbol_conf.field_sep,
 		sample->tid,
 		symbol_conf.field_sep,
-		event->ip.ip,
+		sample->ip,
 		symbol_conf.field_sep,
 		sample->addr,
 		symbol_conf.field_sep,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index d82712f..93a34ce 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -501,8 +501,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
-							event->ip.tid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e37521f..2122141 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -689,7 +689,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
 	struct symbol *parent = NULL;
-	u64 ip = event->ip.ip;
+	u64 ip = sample->ip;
 	struct addr_location al;
 	int err;
 
@@ -699,10 +699,10 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		if (!seen)
 			seen = intlist__new(NULL);
 
-		if (!intlist__has_entry(seen, event->ip.pid)) {
+		if (!intlist__has_entry(seen, sample->pid)) {
 			pr_err("Can't find guest [%d]'s kernel information\n",
-				event->ip.pid);
-			intlist__add(seen, event->ip.pid);
+				sample->pid);
+			intlist__add(seen, sample->pid);
 		}
 		return;
 	}
@@ -836,7 +836,8 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			break;
 		case PERF_RECORD_MISC_GUEST_KERNEL:
 			++top->guest_kernel_samples;
-			machine = perf_session__find_machine(session, event->ip.pid);
+			machine = perf_session__find_machine(session,
+							     sample.pid);
 			break;
 		case PERF_RECORD_MISC_GUEST_USER:
 			++top->guest_us_samples;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 87f9f72..4228ffc 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -211,15 +211,13 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		for (k = 0; k < ARRAY_SIZE(fake_common_samples); k++) {
 			const union perf_event event = {
-				.ip = {
-					.header = {
-						.misc = PERF_RECORD_MISC_USER,
-					},
-					.pid = fake_common_samples[k].pid,
-					.ip  = fake_common_samples[k].ip,
+				.header = {
+					.misc = PERF_RECORD_MISC_USER,
 				},
 			};
 
+			sample.pid = fake_common_samples[k].pid;
+			sample.ip = fake_common_samples[k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
 				goto out;
@@ -235,15 +233,13 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 
 		for (k = 0; k < ARRAY_SIZE(fake_samples[i]); k++) {
 			const union perf_event event = {
-				.ip = {
-					.header = {
-						.misc = PERF_RECORD_MISC_USER,
-					},
-					.pid = fake_samples[i][k].pid,
-					.ip  = fake_samples[i][k].ip,
+				.header = {
+					.misc = PERF_RECORD_MISC_USER,
 				},
 			};
 
+			sample.pid = fake_samples[i][k].pid;
+			sample.ip = fake_samples[i][k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
 				goto out;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 0f9d27a..fb58409 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -18,14 +18,14 @@
 
 int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 			   union perf_event *event,
-			   struct perf_sample *sample __maybe_unused,
+			   struct perf_sample *sample,
 			   struct perf_evsel *evsel __maybe_unused,
 			   struct machine *machine)
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
-							event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->pid);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
@@ -34,7 +34,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 	}
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al);
+			      sample->ip, &al);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 61cecf9..8d51f21 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -686,8 +686,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  struct perf_sample *sample)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
-							event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->pid);
 
 	if (thread == NULL)
 		return -1;
@@ -709,7 +709,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		machine__create_kernel_maps(machine);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, al);
+			      sample->ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 15db071..19d911c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -8,16 +8,6 @@
 #include "map.h"
 #include "build-id.h"
 
-/*
- * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
- */
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-	unsigned char __more_data[];
-};
-
 struct mmap_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -166,7 +156,6 @@ struct tracing_data_event {
 
 union perf_event {
 	struct perf_event_header	header;
-	struct ip_event			ip;
 	struct mmap_event		mmap;
 	struct comm_event		comm;
 	struct fork_event		fork;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9a5fb23..7e328c4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1185,7 +1185,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		return -EFAULT;
 
 	if (type & PERF_SAMPLE_IP) {
-		data->ip = event->ip.ip;
+		data->ip = *array;
 		array++;
 	}
 
@@ -1397,7 +1397,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	array = event->sample.array;
 
 	if (type & PERF_SAMPLE_IP) {
-		event->ip.ip = sample->ip;
+		*array = sample->ip;
 		array++;
 	}
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 07590c3..c3ac483 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -840,7 +840,8 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 static struct machine *
 	perf_session__find_machine_for_cpumode(struct perf_session *session,
-					       union perf_event *event)
+					       union perf_event *event,
+					       struct perf_sample *sample)
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
@@ -852,7 +853,7 @@ static struct machine *
 		if (event->header.type == PERF_RECORD_MMAP)
 			pid = event->mmap.pid;
 		else
-			pid = event->ip.pid;
+			pid = sample->pid;
 
 		return perf_session__findnew_machine(session, pid);
 	}
@@ -958,7 +959,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 		hists__inc_nr_events(&evsel->hists, event->header.type);
 	}
 
-	machine = perf_session__find_machine_for_cpumode(session, event);
+	machine = perf_session__find_machine_for_cpumode(session, event,
+							 sample);
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-- 
1.7.11.7

