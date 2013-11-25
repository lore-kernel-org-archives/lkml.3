Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3KYSVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:21:48 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43984 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3KYSVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:21:47 -0500
Date: Mon, 25 Nov 2013 15:21:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: remove lock_depth from trace_entry
Message-ID: <20131125182139.GD20168@ghostprotocols.net>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
 <20131022103223.GA29489@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <20131022103223.GA29489@stfomichev-desktop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Tue, Oct 22, 2013 at 02:32:23PM +0400, Stanislav Fomichev escreveu:
> On Mon, Oct 07, 2013 at 02:48:34PM +0800, Chia-I Wu wrote:
> > struct trace_entry went out-of-sync with the kernel since
> > 
> >  commit b000c8065 "tracing: Remove the extra 4 bytes of padding in events"
> > 
> > causing "perf timechart" to be broken.
> > 
> > Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Reviewed-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> 
> For some reason nobody noticed this patch on lkml, so resending to the
> maintainers...
> This also makes sense to merge it into the stable line.

This makes the new tool stop processing old files, can you try the patch
attached instead?

Its only compile tested tho.

- Arnaldo
 
> > ---
> >  tools/perf/builtin-timechart.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> > index c2e0231..f9cbc18 100644
> > --- a/tools/perf/builtin-timechart.c
> > +++ b/tools/perf/builtin-timechart.c
> > @@ -303,7 +303,6 @@ struct trace_entry {
> >  	unsigned char		flags;
> >  	unsigned char		preempt_count;
> >  	int			pid;
> > -	int			lock_depth;
> >  };
> >  
> >  #ifdef SUPPORT_OLD_POWER_EVENTS
> > -- 
> > 1.8.3.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lock_depth_removal.patch"

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 41c9bde2fb67..e24834d35eec 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -41,6 +41,27 @@
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
 
+static unsigned int payload_offset;
+
+static int timechart__set_payload_offset(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+	struct format_field *field = perf_evsel__field(evsel, "lock_depth");
+	
+	if (field == NULL) {
+		field = perf_evsel__field(evsel, "common_pid");
+		if (field == NULL)
+			return -1;
+	}
+
+	payload_offset = field->next->offset;
+	return 0;
+}
+
+static void *timechart__payload(struct perf_sample *sample)
+{
+	return sample->raw_data + payload_offset;
+}
 
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
@@ -304,13 +325,11 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			lock_depth;
 };
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
 static int use_old_power_events;
 struct power_entry_old {
-	struct trace_entry te;
 	u64	type;
 	u64	value;
 	u64	cpu_id;
@@ -318,14 +337,12 @@ struct power_entry_old {
 #endif
 
 struct power_processor_entry {
-	struct trace_entry te;
 	u32	state;
 	u32	cpu_id;
 };
 
 #define TASK_COMM_LEN 16
 struct wakeup_entry {
-	struct trace_entry te;
 	char comm[TASK_COMM_LEN];
 	int   pid;
 	int   prio;
@@ -333,7 +350,6 @@ struct wakeup_entry {
 };
 
 struct sched_switch {
-	struct trace_entry te;
 	char prev_comm[TASK_COMM_LEN];
 	int  prev_pid;
 	int  prev_prio;
@@ -402,11 +418,13 @@ static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
 			turbo_frequency = max_freq;
 }
 
-static void
-sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
+static void sched_wakeup(struct perf_sample *sample)
 {
+	struct trace_entry *te = sample->raw_data;
+	struct wakeup_entry *wake = timechart__payload(sample);
+	u64 timestamp = sample->time;
+	int pid = sample->pid, cpu = sample->cpu;
 	struct per_pid *p;
-	struct wakeup_entry *wake = (void *)te;
 	struct wake_event *we = zalloc(sizeof(*we));
 
 	if (!we)
@@ -434,11 +452,9 @@ sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
 	}
 }
 
-static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
+static void sched_switch(int cpu, u64 timestamp, struct sched_switch *sw)
 {
 	struct per_pid *p = NULL, *prev_p;
-	struct sched_switch *sw = (void *)te;
-
 
 	prev_p = find_create_pid(sw->prev_pid);
 
@@ -495,7 +511,7 @@ static int
 process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
 			struct perf_sample *sample)
 {
-	struct power_processor_entry *ppe = sample->raw_data;
+	struct power_processor_entry *ppe = timechart__payload(sample);
 
 	if (ppe->state == (u32) PWR_EVENT_EXIT)
 		c_state_end(ppe->cpu_id, sample->time);
@@ -508,7 +524,7 @@ static int
 process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
 			     struct perf_sample *sample)
 {
-	struct power_processor_entry *ppe = sample->raw_data;
+	struct power_processor_entry *ppe = timechart__payload(sample);
 
 	p_state_change(ppe->cpu_id, sample->time, ppe->state);
 	return 0;
@@ -518,9 +534,7 @@ static int
 process_sample_sched_wakeup(struct perf_evsel *evsel __maybe_unused,
 			    struct perf_sample *sample)
 {
-	struct trace_entry *te = sample->raw_data;
-
-	sched_wakeup(sample->cpu, sample->time, sample->pid, te);
+	sched_wakeup(sample);
 	return 0;
 }
 
@@ -528,9 +542,9 @@ static int
 process_sample_sched_switch(struct perf_evsel *evsel __maybe_unused,
 			    struct perf_sample *sample)
 {
-	struct trace_entry *te = sample->raw_data;
+	struct sched_switch *sw = timechart__payload(sample);
 
-	sched_switch(sample->cpu, sample->time, te);
+	sched_switch(sample->cpu, sample->time, sw);
 	return 0;
 }
 
@@ -539,7 +553,7 @@ static int
 process_sample_power_start(struct perf_evsel *evsel __maybe_unused,
 			   struct perf_sample *sample)
 {
-	struct power_entry_old *peo = sample->raw_data;
+	struct power_entry_old *peo = timechart__payload(sample);
 
 	c_state_start(peo->cpu_id, sample->time, peo->value);
 	return 0;
@@ -557,7 +571,7 @@ static int
 process_sample_power_frequency(struct perf_evsel *evsel __maybe_unused,
 			       struct perf_sample *sample)
 {
-	struct power_entry_old *peo = sample->raw_data;
+	struct power_entry_old *peo = timechart__payload(sample);
 
 	p_state_change(peo->cpu_id, sample->time, peo->value);
 	return 0;
@@ -1012,6 +1026,11 @@ static int __cmd_timechart(const char *output_name)
 		goto out_delete;
 	}
 
+	if (timechart__set_payload_offset(session->evlist)) {
+		pr_err("\"common_pid\" field not found, please try updating this tool\n");
+		goto out_delete;
+	}
+
 	ret = perf_session__process_events(session, &perf_timechart);
 	if (ret)
 		goto out_delete;

--TakKZr9L6Hm6aLOc--
