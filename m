Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3K3MyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:54:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3K3Mxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:55 -0500
Date: Sat, 30 Nov 2013 04:53:36 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-3ed0d21e1103787e21ca38bed2ff50c9f087bedb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, rostedt@goodmis.org,
        stfomichev@yandex-team.ru, tglx@linutronix.de, olvaffe@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, rostedt@goodmis.org, stfomichev@yandex-team.ru,
        tglx@linutronix.de, olvaffe@gmail.com
In-Reply-To: <20131127104459.GB3309@stfomichev-desktop>
References: <20131127104459.GB3309@stfomichev-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  dynamically determine event fields offset
Git-Commit-ID: 3ed0d21e1103787e21ca38bed2ff50c9f087bedb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:53:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ed0d21e1103787e21ca38bed2ff50c9f087bedb
Gitweb:     http://git.kernel.org/tip/3ed0d21e1103787e21ca38bed2ff50c9f087bedb
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Wed, 27 Nov 2013 14:45:00 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 15:10:11 -0300

perf timechart: dynamically determine event fields offset

Since b000c8065a92 "tracing: Remove the extra 4 bytes of padding in
events" removed padding bytes, perf timechart got out of sync with the
kernel's trace_entry structure.

Convert perf timechart to use dynamic fields offsets (via
perf_evsel__intval) not relying on a hardcoded copy of fields layout
from the kernel.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Chia-I Wu <olvaffe@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20131127104459.GB3309@stfomichev-desktop
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 119 +++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 77 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 491662b..436cb5f 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -306,50 +306,10 @@ static int process_exit_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-struct trace_entry {
-	unsigned short		type;
-	unsigned char		flags;
-	unsigned char		preempt_count;
-	int			pid;
-	int			lock_depth;
-};
-
 #ifdef SUPPORT_OLD_POWER_EVENTS
 static int use_old_power_events;
-struct power_entry_old {
-	struct trace_entry te;
-	u64	type;
-	u64	value;
-	u64	cpu_id;
-};
 #endif
 
-struct power_processor_entry {
-	struct trace_entry te;
-	u32	state;
-	u32	cpu_id;
-};
-
-#define TASK_COMM_LEN 16
-struct wakeup_entry {
-	struct trace_entry te;
-	char comm[TASK_COMM_LEN];
-	int   pid;
-	int   prio;
-	int   success;
-};
-
-struct sched_switch {
-	struct trace_entry te;
-	char prev_comm[TASK_COMM_LEN];
-	int  prev_pid;
-	int  prev_prio;
-	long prev_state; /* Arjan weeps. */
-	char next_comm[TASK_COMM_LEN];
-	int  next_pid;
-	int  next_prio;
-};
-
 static void c_state_start(int cpu, u64 timestamp, int state)
 {
 	cpus_cstate_start_times[cpu] = timestamp;
@@ -409,25 +369,23 @@ static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
 			turbo_frequency = max_freq;
 }
 
-static void
-sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te,
-	     const char *backtrace)
+static void sched_wakeup(int cpu, u64 timestamp, int waker, int wakee,
+			 u8 flags, const char *backtrace)
 {
 	struct per_pid *p;
-	struct wakeup_entry *wake = (void *)te;
 	struct wake_event *we = zalloc(sizeof(*we));
 
 	if (!we)
 		return;
 
 	we->time = timestamp;
-	we->waker = pid;
+	we->waker = waker;
 	we->backtrace = backtrace;
 
-	if ((te->flags & TRACE_FLAG_HARDIRQ) || (te->flags & TRACE_FLAG_SOFTIRQ))
+	if ((flags & TRACE_FLAG_HARDIRQ) || (flags & TRACE_FLAG_SOFTIRQ))
 		we->waker = -1;
 
-	we->wakee = wake->pid;
+	we->wakee = wakee;
 	we->next = wake_events;
 	wake_events = we;
 	p = find_create_pid(we->wakee);
@@ -444,24 +402,22 @@ sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te,
 	}
 }
 
-static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te,
-			 const char *backtrace)
+static void sched_switch(int cpu, u64 timestamp, int prev_pid, int next_pid,
+			 u64 prev_state, const char *backtrace)
 {
 	struct per_pid *p = NULL, *prev_p;
-	struct sched_switch *sw = (void *)te;
-
 
-	prev_p = find_create_pid(sw->prev_pid);
+	prev_p = find_create_pid(prev_pid);
 
-	p = find_create_pid(sw->next_pid);
+	p = find_create_pid(next_pid);
 
 	if (prev_p->current && prev_p->current->state != TYPE_NONE)
-		pid_put_sample(sw->prev_pid, TYPE_RUNNING, cpu,
+		pid_put_sample(prev_pid, TYPE_RUNNING, cpu,
 			       prev_p->current->state_since, timestamp,
 			       backtrace);
 	if (p && p->current) {
 		if (p->current->state != TYPE_NONE)
-			pid_put_sample(sw->next_pid, p->current->state, cpu,
+			pid_put_sample(next_pid, p->current->state, cpu,
 				       p->current->state_since, timestamp,
 				       backtrace);
 
@@ -472,9 +428,9 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te,
 	if (prev_p->current) {
 		prev_p->current->state = TYPE_NONE;
 		prev_p->current->state_since = timestamp;
-		if (sw->prev_state & 2)
+		if (prev_state & 2)
 			prev_p->current->state = TYPE_BLOCKED;
-		if (sw->prev_state == 0)
+		if (prev_state == 0)
 			prev_p->current->state = TYPE_WAITING;
 	}
 }
@@ -586,61 +542,69 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 }
 
 static int
-process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
+process_sample_cpu_idle(struct perf_evsel *evsel,
 			struct perf_sample *sample,
 			const char *backtrace __maybe_unused)
 {
-	struct power_processor_entry *ppe = sample->raw_data;
+	u32 state = perf_evsel__intval(evsel, sample, "state");
+	u32 cpu_id = perf_evsel__intval(evsel, sample, "cpu_id");
 
-	if (ppe->state == (u32) PWR_EVENT_EXIT)
-		c_state_end(ppe->cpu_id, sample->time);
+	if (state == (u32)PWR_EVENT_EXIT)
+		c_state_end(cpu_id, sample->time);
 	else
-		c_state_start(ppe->cpu_id, sample->time, ppe->state);
+		c_state_start(cpu_id, sample->time, state);
 	return 0;
 }
 
 static int
-process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
+process_sample_cpu_frequency(struct perf_evsel *evsel,
 			     struct perf_sample *sample,
 			     const char *backtrace __maybe_unused)
 {
-	struct power_processor_entry *ppe = sample->raw_data;
+	u32 state = perf_evsel__intval(evsel, sample, "state");
+	u32 cpu_id = perf_evsel__intval(evsel, sample, "cpu_id");
 
-	p_state_change(ppe->cpu_id, sample->time, ppe->state);
+	p_state_change(cpu_id, sample->time, state);
 	return 0;
 }
 
 static int
-process_sample_sched_wakeup(struct perf_evsel *evsel __maybe_unused,
+process_sample_sched_wakeup(struct perf_evsel *evsel,
 			    struct perf_sample *sample,
 			    const char *backtrace)
 {
-	struct trace_entry *te = sample->raw_data;
+	u8 flags = perf_evsel__intval(evsel, sample, "common_flags");
+	int waker = perf_evsel__intval(evsel, sample, "common_pid");
+	int wakee = perf_evsel__intval(evsel, sample, "pid");
 
-	sched_wakeup(sample->cpu, sample->time, sample->pid, te, backtrace);
+	sched_wakeup(sample->cpu, sample->time, waker, wakee, flags, backtrace);
 	return 0;
 }
 
 static int
-process_sample_sched_switch(struct perf_evsel *evsel __maybe_unused,
+process_sample_sched_switch(struct perf_evsel *evsel,
 			    struct perf_sample *sample,
 			    const char *backtrace)
 {
-	struct trace_entry *te = sample->raw_data;
+	int prev_pid = perf_evsel__intval(evsel, sample, "prev_pid");
+	int next_pid = perf_evsel__intval(evsel, sample, "next_pid");
+	u64 prev_state = perf_evsel__intval(evsel, sample, "prev_state");
 
-	sched_switch(sample->cpu, sample->time, te, backtrace);
+	sched_switch(sample->cpu, sample->time, prev_pid, next_pid, prev_state,
+		     backtrace);
 	return 0;
 }
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
 static int
-process_sample_power_start(struct perf_evsel *evsel __maybe_unused,
+process_sample_power_start(struct perf_evsel *evsel,
 			   struct perf_sample *sample,
 			   const char *backtrace __maybe_unused)
 {
-	struct power_entry_old *peo = sample->raw_data;
+	u64 cpu_id = perf_evsel__intval(evsel, sample, "cpu_id");
+	u64 value = perf_evsel__intval(evsel, sample, "value");
 
-	c_state_start(peo->cpu_id, sample->time, peo->value);
+	c_state_start(cpu_id, sample->time, value);
 	return 0;
 }
 
@@ -654,13 +618,14 @@ process_sample_power_end(struct perf_evsel *evsel __maybe_unused,
 }
 
 static int
-process_sample_power_frequency(struct perf_evsel *evsel __maybe_unused,
+process_sample_power_frequency(struct perf_evsel *evsel,
 			       struct perf_sample *sample,
 			       const char *backtrace __maybe_unused)
 {
-	struct power_entry_old *peo = sample->raw_data;
+	u64 cpu_id = perf_evsel__intval(evsel, sample, "cpu_id");
+	u64 value = perf_evsel__intval(evsel, sample, "value");
 
-	p_state_change(peo->cpu_id, sample->time, peo->value);
+	p_state_change(cpu_id, sample->time, value);
 	return 0;
 }
 #endif /* SUPPORT_OLD_POWER_EVENTS */
