Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3JVLDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:03:53 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:39502 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076Ab3JVLD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:03:27 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] perf timechart: add backtrace support
Date: Tue, 22 Oct 2013 14:56:52 +0400
Message-Id: <1382439412-23713-7-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -g flag to `perf timechart record` which saves callchain info in
the perf.data.
When generating SVG, add backtrace information to the figure details,
so now it's possible to see which code path woke up the task and why some
task went to sleep.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 138 ++++++++++++++++++++++++++++++++++-------
 tools/perf/util/svghelper.c    |  27 ++++++--
 tools/perf/util/svghelper.h    |  12 ++--
 3 files changed, 141 insertions(+), 36 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 54bdebea4c6b..9a275db0f8cb 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -42,6 +42,7 @@
 
 static int proc_num = 15;
 static bool no_power;
+static bool with_backtrace;
 
 
 static unsigned int	numcpus;
@@ -124,6 +125,7 @@ struct cpu_sample {
 	u64 end_time;
 	int type;
 	int cpu;
+	const char *backtrace;
 };
 
 static struct per_pid *all_data;
@@ -145,6 +147,7 @@ struct wake_event {
 	int waker;
 	int wakee;
 	u64 time;
+	const char *backtrace;
 };
 
 static struct power_event    *power_events;
@@ -229,7 +232,8 @@ static void pid_exit(int pid, u64 timestamp)
 }
 
 static void
-pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
+pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end,
+	       const char *backtrace)
 {
 	struct per_pid *p;
 	struct per_pidcomm *c;
@@ -252,6 +256,7 @@ pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
 	sample->type = type;
 	sample->next = c->samples;
 	sample->cpu = cpu;
+	sample->backtrace = backtrace;
 	c->samples = sample;
 
 	if (sample->type == TYPE_RUNNING && end > start && start > 0) {
@@ -403,7 +408,8 @@ static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
 }
 
 static void
-sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
+sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te,
+	     const char *backtrace)
 {
 	struct per_pid *p;
 	struct wakeup_entry *wake = (void *)te;
@@ -414,6 +420,7 @@ sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
 
 	we->time = timestamp;
 	we->waker = pid;
+	we->backtrace = backtrace;
 
 	if ((te->flags & TRACE_FLAG_HARDIRQ) || (te->flags & TRACE_FLAG_SOFTIRQ))
 		we->waker = -1;
@@ -428,13 +435,15 @@ sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
 		p->current->state = TYPE_WAITING;
 	}
 	if (p && p->current && p->current->state == TYPE_BLOCKED) {
-		pid_put_sample(p->pid, p->current->state, cpu, p->current->state_since, timestamp);
+		pid_put_sample(p->pid, p->current->state, cpu,
+			       p->current->state_since, timestamp, NULL);
 		p->current->state_since = timestamp;
 		p->current->state = TYPE_WAITING;
 	}
 }
 
-static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
+static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te,
+			 const char *backtrace)
 {
 	struct per_pid *p = NULL, *prev_p;
 	struct sched_switch *sw = (void *)te;
@@ -445,10 +454,14 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 	p = find_create_pid(sw->next_pid);
 
 	if (prev_p->current && prev_p->current->state != TYPE_NONE)
-		pid_put_sample(sw->prev_pid, TYPE_RUNNING, cpu, prev_p->current->state_since, timestamp);
+		pid_put_sample(sw->prev_pid, TYPE_RUNNING, cpu,
+			       prev_p->current->state_since, timestamp,
+			       backtrace);
 	if (p && p->current) {
 		if (p->current->state != TYPE_NONE)
-			pid_put_sample(sw->next_pid, p->current->state, cpu, p->current->state_since, timestamp);
+			pid_put_sample(sw->next_pid, p->current->state, cpu,
+				       p->current->state_since, timestamp,
+				       backtrace);
 
 		p->current->state_since = timestamp;
 		p->current->state = TYPE_RUNNING;
@@ -464,8 +477,55 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 	}
 }
 
+static const char *cat_backtrace(union perf_event *event,
+				 struct perf_sample *sample,
+				 struct machine *machine)
+{
+	struct addr_location al;
+	unsigned int i;
+	char *p = NULL;
+	size_t p_len;
+	u8 cpumode = PERF_RECORD_MISC_USER;
+	struct addr_location tal;
+	struct ip_callchain *chain = sample->callchain;
+	FILE *f = open_memstream(&p, &p_len);
+
+	if (!chain)
+		return NULL;
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+		fprintf(stderr, "problem processing %d event, skipping it.\n",
+			event->header.type);
+		return NULL;
+	}
+
+	for (i = 0; i < chain->nr; i++) {
+		u64 ip;
+
+		if (callchain_param.order == ORDER_CALLEE)
+			ip = chain->ips[i];
+		else
+			ip = chain->ips[chain->nr - i - 1];
+
+		tal.filtered = false;
+		thread__find_addr_location(al.thread, machine, cpumode,
+					   MAP__FUNCTION, ip, &tal);
+
+		if (tal.sym)
+			fprintf(f, "..... %016" PRIx64 " %s\n", ip,
+				tal.sym->name);
+		else
+			fprintf(f, "..... %016" PRIx64 "\n", ip);
+	}
+
+	fclose(f);
+
+	return p;
+}
+
 typedef int (*tracepoint_handler)(struct perf_evsel *evsel,
-				  struct perf_sample *sample);
+				  struct perf_sample *sample,
+				  const char *backtrace);
 
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event __maybe_unused,
@@ -485,7 +545,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 	if (evsel->handler.func != NULL) {
 		tracepoint_handler f = evsel->handler.func;
-		return f(evsel, sample);
+		return f(evsel, sample,
+			 cat_backtrace(event, sample, machine));
 	}
 
 	return 0;
@@ -493,7 +554,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 static int
 process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
-			struct perf_sample *sample)
+			struct perf_sample *sample,
+			const char *backtrace __maybe_unused)
 {
 	struct power_processor_entry *ppe = sample->raw_data;
 
@@ -506,7 +568,8 @@ process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
 
 static int
 process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
-			     struct perf_sample *sample)
+			     struct perf_sample *sample,
+			     const char *backtrace __maybe_unused)
 {
 	struct power_processor_entry *ppe = sample->raw_data;
 
@@ -516,28 +579,31 @@ process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
 
 static int
 process_sample_sched_wakeup(struct perf_evsel *evsel __maybe_unused,
-			    struct perf_sample *sample)
+			    struct perf_sample *sample,
+			    const char *backtrace __maybe_unused)
 {
 	struct trace_entry *te = sample->raw_data;
 
-	sched_wakeup(sample->cpu, sample->time, sample->pid, te);
+	sched_wakeup(sample->cpu, sample->time, sample->pid, te, backtrace);
 	return 0;
 }
 
 static int
 process_sample_sched_switch(struct perf_evsel *evsel __maybe_unused,
-			    struct perf_sample *sample)
+			    struct perf_sample *sample,
+			    const char *backtrace __maybe_unused)
 {
 	struct trace_entry *te = sample->raw_data;
 
-	sched_switch(sample->cpu, sample->time, te);
+	sched_switch(sample->cpu, sample->time, te, backtrace);
 	return 0;
 }
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
 static int
 process_sample_power_start(struct perf_evsel *evsel __maybe_unused,
-			   struct perf_sample *sample)
+			   struct perf_sample *sample,
+			   const char *backtrace __maybe_unused)
 {
 	struct power_entry_old *peo = sample->raw_data;
 
@@ -547,7 +613,8 @@ process_sample_power_start(struct perf_evsel *evsel __maybe_unused,
 
 static int
 process_sample_power_end(struct perf_evsel *evsel __maybe_unused,
-			 struct perf_sample *sample)
+			 struct perf_sample *sample,
+			 const char *backtrace __maybe_unused)
 {
 	c_state_end(sample->cpu, sample->time);
 	return 0;
@@ -555,7 +622,8 @@ process_sample_power_end(struct perf_evsel *evsel __maybe_unused,
 
 static int
 process_sample_power_frequency(struct perf_evsel *evsel __maybe_unused,
-			       struct perf_sample *sample)
+			       struct perf_sample *sample,
+			       const char *backtrace __maybe_unused)
 {
 	struct power_entry_old *peo = sample->raw_data;
 
@@ -739,11 +807,12 @@ static void draw_wakeups(void)
 		}
 
 		if (we->waker == -1)
-			svg_interrupt(we->time, to);
+			svg_interrupt(we->time, to, we->backtrace);
 		else if (from && to && abs(from - to) == 1)
-			svg_wakeline(we->time, from, to);
+			svg_wakeline(we->time, from, to, we->backtrace);
 		else
-			svg_partial_wakeline(we->time, from, task_from, to, task_to);
+			svg_partial_wakeline(we->time, from, task_from, to,
+					     task_to, we->backtrace);
 		we = we->next;
 
 		free(task_from);
@@ -796,11 +865,20 @@ static void draw_process_bars(void)
 			sample = c->samples;
 			while (sample) {
 				if (sample->type == TYPE_RUNNING)
-					svg_sample(Y, sample->cpu, sample->start_time, sample->end_time);
+					svg_sample(Y, sample->cpu,
+						   sample->start_time,
+						   sample->end_time,
+						   sample->backtrace);
 				if (sample->type == TYPE_BLOCKED)
-					svg_blocked(Y, sample->cpu, sample->start_time, sample->end_time);
+					svg_blocked(Y, sample->cpu,
+						    sample->start_time,
+						    sample->end_time,
+						    sample->backtrace);
 				if (sample->type == TYPE_WAITING)
-					svg_waiting(Y, sample->cpu, sample->start_time, sample->end_time);
+					svg_waiting(Y, sample->cpu,
+						    sample->start_time,
+						    sample->end_time,
+						    sample->backtrace);
 				sample = sample->next;
 			}
 
@@ -1041,6 +1119,11 @@ static int __cmd_record(int argc, const char **argv)
 	};
 	unsigned int common_args_no = ARRAY_SIZE(common_args);
 
+	const char * const backtrace_args[] = {
+		"-g",
+	};
+	unsigned int backtrace_args_no = ARRAY_SIZE(backtrace_args);
+
 	const char * const power_args[] = {
 		"-e", "power:cpu_frequency",
 		"-e", "power:cpu_idle",
@@ -1080,8 +1163,11 @@ static int __cmd_record(int argc, const char **argv)
 		old_power_args_no = 0;
 	}
 
+	if (!with_backtrace)
+		backtrace_args_no = 0;
+
 	record_elems = common_args_no + tasks_args_no +
-		power_args_no + old_power_args_no;
+		power_args_no + old_power_args_no + backtrace_args_no;
 
 	rec_argc = record_elems + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
@@ -1093,6 +1179,9 @@ static int __cmd_record(int argc, const char **argv)
 	for (i = 0; i < common_args_no; i++)
 		*p++ = strdup(common_args[i]);
 
+	for (i = 0; i < backtrace_args_no; i++)
+		*p++ = strdup(backtrace_args[i]);
+
 	for (i = 0; i < tasks_args_no; i++)
 		*p++ = strdup(tasks_args[i]);
 
@@ -1166,6 +1255,7 @@ int cmd_timechart(int argc, const char **argv,
 		     "record power data only", parse_power),
 	OPT_CALLBACK_NOOPT('T', "tasks-only", NULL, NULL,
 		     "record processes data only", parse_tasks),
+	OPT_BOOLEAN('g', "callchain", &with_backtrace, "record callchain"),
 	OPT_END()
 	};
 	const char * const record_usage[] = {
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index c41be3c5722b..702d41e34576 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -130,7 +130,7 @@ void svg_box(int Yslot, u64 start, u64 end, const char *type)
 }
 
 static char *time_to_string(u64 duration);
-void svg_blocked(int Yslot, int cpu, u64 start, u64 end)
+void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 {
 	if (!svgfile)
 		return;
@@ -138,11 +138,13 @@ void svg_blocked(int Yslot, int cpu, u64 start, u64 end)
 	fprintf(svgfile, "<g>\n");
 	fprintf(svgfile, "<title>#%d blocked %s</title>\n", cpu,
 		time_to_string(end - start));
+	if (backtrace)
+		fprintf(svgfile, "<desc>Blocked on:\n%s</desc>\n", backtrace);
 	svg_box(Yslot, start, end, "blocked");
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_sample(int Yslot, int cpu, u64 start, u64 end)
+void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 {
 	double text_size;
 	if (!svgfile)
@@ -152,6 +154,8 @@ void svg_sample(int Yslot, int cpu, u64 start, u64 end)
 
 	fprintf(svgfile, "<title>#%d running %s</title>\n",
 		cpu, time_to_string(end - start));
+	if (backtrace)
+		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
 	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"sample\"/>\n",
 		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT);
 
@@ -187,7 +191,7 @@ static char *time_to_string(u64 duration)
 	return text;
 }
 
-void svg_waiting(int Yslot, int cpu, u64 start, u64 end)
+void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 {
 	char *text;
 	const char *style;
@@ -212,6 +216,8 @@ void svg_waiting(int Yslot, int cpu, u64 start, u64 end)
 
 	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
 	fprintf(svgfile, "<title>#%d waiting %s</title>\n", cpu, time_to_string(end - start));
+	if (backtrace)
+		fprintf(svgfile, "<desc>Waiting on:\n%s</desc>\n", backtrace);
 	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
 		time2pixels(end)-time2pixels(start), SLOT_HEIGHT, style);
 	if (font_size > MIN_TEXT_SIZE)
@@ -382,7 +388,7 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 }
 
 
-void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2)
+void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2, const char *backtrace)
 {
 	double height;
 
@@ -396,6 +402,9 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 		desc1 ? desc1 : "?",
 		desc2 ? desc2 : "?");
 
+	if (backtrace)
+		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
+
 	if (row1 < row2) {
 		if (row1) {
 			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
@@ -437,7 +446,7 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_wakeline(u64 start, int row1, int row2)
+void svg_wakeline(u64 start, int row1, int row2, const char *backtrace)
 {
 	double height;
 
@@ -447,6 +456,9 @@ void svg_wakeline(u64 start, int row1, int row2)
 
 	fprintf(svgfile, "<g>\n");
 
+	if (backtrace)
+		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
+
 	if (row1 < row2)
 		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 			time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT);
@@ -463,7 +475,7 @@ void svg_wakeline(u64 start, int row1, int row2)
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_interrupt(u64 start, int row)
+void svg_interrupt(u64 start, int row, const char *backtrace)
 {
 	if (!svgfile)
 		return;
@@ -472,6 +484,9 @@ void svg_interrupt(u64 start, int row)
 
 	fprintf(svgfile, "<title>Wakeup from interrupt</title>\n");
 
+	if (backtrace)
+		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
+
 	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
 			time2pixels(start), row * SLOT_MULT);
 	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index 630114b847d0..045fa087cf04 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -5,9 +5,9 @@
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
-extern void svg_blocked(int Yslot, int cpu, u64 start, u64 end);
-extern void svg_sample(int Yslot, int cpu, u64 start, u64 end);
-extern void svg_waiting(int Yslot, int cpu, u64 start, u64 end);
+extern void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
+extern void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
+extern void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
 extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
 
 
@@ -18,9 +18,9 @@ extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
 extern void svg_time_grid(void);
 extern void svg_legenda(void);
-extern void svg_wakeline(u64 start, int row1, int row2);
-extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2);
-extern void svg_interrupt(u64 start, int row);
+extern void svg_wakeline(u64 start, int row1, int row2, const char *backtrace);
+extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2, const char *backtrace);
+extern void svg_interrupt(u64 start, int row, const char *backtrace);
 extern void svg_text(int Yslot, u64 start, const char *text);
 extern void svg_close(void);
 
-- 
1.8.1.2

