Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3GKNIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:08:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:28287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab3GKNII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="368613026"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V5 07/12] perf tools: remove references to struct ip_event
Date: Thu, 11 Jul 2013 16:12:16 +0300
Message-Id: <1373548341-24119-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ip_event assumes fixeed positions for ip, pid
and tid.  That is no longer true with the addition of
PERF_SAMPLE_IDENTIFIER.  The information is anyway in
struct sample, so use that instead.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c   |  4 ++--
 tools/perf/builtin-kmem.c     |  4 ++--
 tools/perf/builtin-mem.c      |  2 +-
 tools/perf/builtin-script.c   |  4 ++--
 tools/perf/builtin-top.c      | 10 +++++-----
 tools/perf/tests/hists_link.c |  4 ++++
 tools/perf/util/build-id.c    |  8 ++++----
 tools/perf/util/event.c       |  6 +++---
 tools/perf/util/evsel.c       |  4 ++--
 tools/perf/util/session.c     |  7 ++++---
 10 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index c467eac..da0cc13 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -204,7 +204,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, event->ip.pid, event->ip.pid);
+	thread = machine__findnew_thread(machine, sample->pid, sample->pid);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
@@ -212,7 +212,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
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
index a8ff6d2..4274680 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -96,7 +96,7 @@ dump_raw_samples(struct perf_tool *tool,
 		symbol_conf.field_sep,
 		sample->tid,
 		symbol_conf.field_sep,
-		event->ip.ip,
+		sample->ip,
 		symbol_conf.field_sep,
 		sample->addr,
 		symbol_conf.field_sep,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 338b5a4..51ba51c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -480,8 +480,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
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
index bbf4635..88daba7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -690,7 +690,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
 	struct symbol *parent = NULL;
-	u64 ip = event->ip.ip;
+	u64 ip = sample->ip;
 	struct addr_location al;
 	int err;
 
@@ -700,10 +700,10 @@ static void perf_event__process_sample(struct perf_tool *tool,
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
@@ -838,7 +838,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			break;
 		case PERF_RECORD_MISC_GUEST_KERNEL:
 			++top->guest_kernel_samples;
-			machine = perf_session__find_machine(session, event->ip.pid);
+			machine = perf_session__find_machine(session, sample.pid);
 			break;
 		case PERF_RECORD_MISC_GUEST_USER:
 			++top->guest_us_samples;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 5a178d5..7e0ca15 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -220,6 +220,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				},
 			};
 
+			sample.pid = ip_event.ip.pid;
+			sample.ip = ip_event.ip.ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample, 0) < 0)
 				goto out;
@@ -244,6 +246,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				},
 			};
 
+			sample.pid = ip_event.ip.pid;
+			sample.ip = ip_event.ip.ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample, 0) < 0)
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
index ec494a3..6861d19 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -677,8 +677,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  symbol_filter_t filter)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
-							event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, sample->pid,
+							sample->pid);
 
 	if (thread == NULL)
 		return -1;
@@ -700,7 +700,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		machine__create_kernel_maps(machine);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, al);
+			      sample->ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index febff21..dfdd6cb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1176,7 +1176,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		return -EFAULT;
 
 	if (type & PERF_SAMPLE_IP) {
-		data->ip = event->ip.ip;
+		data->ip = *array;
 		array++;
 	}
 
@@ -1349,7 +1349,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	array = event->sample.array;
 
 	if (type & PERF_SAMPLE_IP) {
-		event->ip.ip = sample->ip;
+		*array = sample->ip;
 		array++;
 	}
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a0e427b..5a8221d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -811,7 +811,8 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 static struct machine *
 	perf_session__find_machine_for_cpumode(struct perf_session *session,
-					       union perf_event *event)
+					       union perf_event *event,
+					       struct perf_sample *sample)
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
@@ -823,7 +824,7 @@ static struct machine *
 		if (event->header.type == PERF_RECORD_MMAP)
 			pid = event->mmap.pid;
 		else
-			pid = event->ip.pid;
+			pid = sample->pid;
 
 		return perf_session__findnew_machine(session, pid);
 	}
@@ -860,7 +861,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 		hists__inc_nr_events(&evsel->hists, event->header.type);
 	}
 
-	machine = perf_session__find_machine_for_cpumode(session, event);
+	machine = perf_session__find_machine_for_cpumode(session, event, sample);
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-- 
1.7.11.7

