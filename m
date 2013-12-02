Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3LBUuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:50:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54093 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3LBUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:49:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/12] perf timechart: Move power_events list to 'struct timechart'
Date: Mon,  2 Dec 2013 17:49:05 -0300
Message-Id: <1386017349-24486-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing another global variable.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2akef3p9caau56itf5mugd2b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 0c955acc08a2..8ee0ff1777a8 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -42,10 +42,12 @@
 #define PWR_EVENT_EXIT -1
 
 struct per_pid;
+struct power_event;
 
 struct timechart {
 	struct perf_tool	tool;
 	struct per_pid		*all_data;
+	struct power_event	*power_events;
 	int			proc_num;
 	unsigned int		numcpus;
 	u64			min_freq,	/* Lowest CPU frequency seen */
@@ -146,7 +148,6 @@ struct wake_event {
 	const char *backtrace;
 };
 
-static struct power_event    *power_events;
 static struct wake_event     *wake_events;
 
 struct process_filter {
@@ -312,7 +313,7 @@ static void c_state_start(int cpu, u64 timestamp, int state)
 	cpus_cstate_state[cpu] = state;
 }
 
-static void c_state_end(int cpu, u64 timestamp)
+static void c_state_end(struct timechart *tchart, int cpu, u64 timestamp)
 {
 	struct power_event *pwr = zalloc(sizeof(*pwr));
 
@@ -324,9 +325,9 @@ static void c_state_end(int cpu, u64 timestamp)
 	pwr->end_time = timestamp;
 	pwr->cpu = cpu;
 	pwr->type = CSTATE;
-	pwr->next = power_events;
+	pwr->next = tchart->power_events;
 
-	power_events = pwr;
+	tchart->power_events = pwr;
 }
 
 static void p_state_change(struct timechart *tchart, int cpu, u64 timestamp, u64 new_freq)
@@ -345,12 +346,12 @@ static void p_state_change(struct timechart *tchart, int cpu, u64 timestamp, u64
 	pwr->end_time = timestamp;
 	pwr->cpu = cpu;
 	pwr->type = PSTATE;
-	pwr->next = power_events;
+	pwr->next = tchart->power_events;
 
 	if (!pwr->start_time)
 		pwr->start_time = tchart->first_time;
 
-	power_events = pwr;
+	tchart->power_events = pwr;
 
 	cpus_pstate_state[cpu] = new_freq;
 	cpus_pstate_start_times[cpu] = timestamp;
@@ -551,7 +552,7 @@ process_sample_cpu_idle(struct timechart *tchart __maybe_unused,
 	u32 cpu_id = perf_evsel__intval(evsel, sample, "cpu_id");
 
 	if (state == (u32)PWR_EVENT_EXIT)
-		c_state_end(cpu_id, sample->time);
+		c_state_end(tchart, cpu_id, sample->time);
 	else
 		c_state_start(cpu_id, sample->time, state);
 	return 0;
@@ -614,12 +615,12 @@ process_sample_power_start(struct timechart *tchart __maybe_unused,
 }
 
 static int
-process_sample_power_end(struct timechart *tchart __maybe_unused,
+process_sample_power_end(struct timechart *tchart,
 			 struct perf_evsel *evsel __maybe_unused,
 			 struct perf_sample *sample,
 			 const char *backtrace __maybe_unused)
 {
-	c_state_end(sample->cpu, sample->time);
+	c_state_end(tchart, sample->cpu, sample->time);
 	return 0;
 }
 
@@ -658,9 +659,9 @@ static void end_sample_processing(struct timechart *tchart)
 		pwr->end_time = tchart->last_time;
 		pwr->cpu = cpu;
 		pwr->type = CSTATE;
-		pwr->next = power_events;
+		pwr->next = tchart->power_events;
 
-		power_events = pwr;
+		tchart->power_events = pwr;
 #endif
 		/* P state */
 
@@ -673,13 +674,13 @@ static void end_sample_processing(struct timechart *tchart)
 		pwr->end_time = tchart->last_time;
 		pwr->cpu = cpu;
 		pwr->type = PSTATE;
-		pwr->next = power_events;
+		pwr->next = tchart->power_events;
 
 		if (!pwr->start_time)
 			pwr->start_time = tchart->first_time;
 		if (!pwr->state)
 			pwr->state = tchart->min_freq;
-		power_events = pwr;
+		tchart->power_events = pwr;
 	}
 }
 
@@ -735,7 +736,7 @@ static void sort_pids(struct timechart *tchart)
 static void draw_c_p_states(struct timechart *tchart)
 {
 	struct power_event *pwr;
-	pwr = power_events;
+	pwr = tchart->power_events;
 
 	/*
 	 * two pass drawing so that the P state bars are on top of the C state blocks
@@ -746,7 +747,7 @@ static void draw_c_p_states(struct timechart *tchart)
 		pwr = pwr->next;
 	}
 
-	pwr = power_events;
+	pwr = tchart->power_events;
 	while (pwr) {
 		if (pwr->type == PSTATE) {
 			if (!pwr->state)
-- 
1.8.1.4

