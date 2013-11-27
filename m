Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3K0ItI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:49:08 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63095 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3K0ItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:49:05 -0500
X-AuditID: 9c930197-b7caaae000001cef-2a-5295b1fe0d24
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: dynamically determine event data offset
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
	<20131022103223.GA29489@stfomichev-desktop>
	<20131125182139.GD20168@ghostprotocols.net>
	<20131126110536.GC3388@stfomichev-desktop>
	<20131126121026.GD27323@ghostprotocols.net>
	<20131126134755.GD3388@stfomichev-desktop>
	<20131126135709.GB14838@ghostprotocols.net>
	<20131126145437.GE3388@stfomichev-desktop>
Date: Wed, 27 Nov 2013 17:49:02 +0900
In-Reply-To: <20131126145437.GE3388@stfomichev-desktop> (Stanislav Fomichev's
	message of "Tue, 26 Nov 2013 18:54:37 +0400")
Message-ID: <87mwkqqlfl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Tue, 26 Nov 2013 18:54:37 +0400, Stanislav Fomichev wrote:
> Since b000c8065a92 "tracing: Remove the extra 4 bytes of padding in events"
> removed padding bytes, perf timechart got out of sync with the kernel's
> trace_entry structure.
> We can't just align perf's trace_entry definition with the kernel because we
> want timechart to continue working with old perf.data. Instead, we now
> calculate event data offset dynamically using offset of first non-common
> event field in the perf.data.

[SNIP]
> @@ -304,13 +322,11 @@ struct trace_entry {
>  	unsigned char		flags;
>  	unsigned char		preempt_count;
>  	int			pid;
> -	int			lock_depth;
>  };

I had no chance to look into the timechart code in detail, but this is
not good.  The format of each trace event (so the struct trace_entry)
was described in the format file under the event directory on debugfs.
For cpu_frequency event, I get the following:

  $ cat /sys/kernel/debug/tracing/events/power/cpu_frequency/format 
  name: cpu_frequency
  ID: 315
  format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:u32 state;	offset:8;	size:4;	signed:0;
	field:u32 cpu_id;	offset:12;	size:4;	signed:0;

  print fmt: "state=%lu cpu_id=%lu", (unsigned long)REC->state, (unsigned long)REC->cpu_id

So it's not same as above struct trace_entry even with your change.

And the thing is we should not access it as a binary format.  IOW we
need to access those (common) fields by libtraceevent or something that
honors the event format description.  This way we can access the data
reliably even after the format change like this.

This is why other perf commands wasn't affected by those change IMHO.
The timechart command should be changed to follow the same rule.  I
think perf_evsel__intval() and perf_evsel__strval() will do most of the
job you want here.  So,

Nacked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

>  
>  #ifdef SUPPORT_OLD_POWER_EVENTS
>  static int use_old_power_events;
>  struct power_entry_old {
> -	struct trace_entry te;
>  	u64	type;
>  	u64	value;
>  	u64	cpu_id;
> @@ -318,14 +334,12 @@ struct power_entry_old {
>  #endif
>  
>  struct power_processor_entry {
> -	struct trace_entry te;
>  	u32	state;
>  	u32	cpu_id;
>  };
>  
>  #define TASK_COMM_LEN 16
>  struct wakeup_entry {
> -	struct trace_entry te;
>  	char comm[TASK_COMM_LEN];
>  	int   pid;
>  	int   prio;
> @@ -333,7 +347,6 @@ struct wakeup_entry {
>  };
>  
>  struct sched_switch {
> -	struct trace_entry te;
>  	char prev_comm[TASK_COMM_LEN];
>  	int  prev_pid;
>  	int  prev_prio;
> @@ -402,11 +415,13 @@ static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
>  			turbo_frequency = max_freq;
>  }
>  
> -static void
> -sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
> +static void sched_wakeup(struct perf_sample *sample)
>  {
> +	struct trace_entry *te = sample->raw_data;
> +	struct wakeup_entry *wake = timechart__payload(sample);
> +	u64 timestamp = sample->time;
> +	int pid = sample->pid, cpu = sample->cpu;
>  	struct per_pid *p;
> -	struct wakeup_entry *wake = (void *)te;
>  	struct wake_event *we = zalloc(sizeof(*we));
>  
>  	if (!we)
> @@ -434,11 +449,9 @@ sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
>  	}
>  }
>  
> -static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
> +static void sched_switch(int cpu, u64 timestamp, struct sched_switch *sw)
>  {
>  	struct per_pid *p = NULL, *prev_p;
> -	struct sched_switch *sw = (void *)te;
> -
>  
>  	prev_p = find_create_pid(sw->prev_pid);
>  
> @@ -495,7 +508,7 @@ static int
>  process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
>  			struct perf_sample *sample)
>  {
> -	struct power_processor_entry *ppe = sample->raw_data;
> +	struct power_processor_entry *ppe = timechart__payload(sample);
>  
>  	if (ppe->state == (u32) PWR_EVENT_EXIT)
>  		c_state_end(ppe->cpu_id, sample->time);
> @@ -508,7 +521,7 @@ static int
>  process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
>  			     struct perf_sample *sample)
>  {
> -	struct power_processor_entry *ppe = sample->raw_data;
> +	struct power_processor_entry *ppe = timechart__payload(sample);
>  
>  	p_state_change(ppe->cpu_id, sample->time, ppe->state);
>  	return 0;
> @@ -518,9 +531,7 @@ static int
>  process_sample_sched_wakeup(struct perf_evsel *evsel __maybe_unused,
>  			    struct perf_sample *sample)
>  {
> -	struct trace_entry *te = sample->raw_data;
> -
> -	sched_wakeup(sample->cpu, sample->time, sample->pid, te);
> +	sched_wakeup(sample);
>  	return 0;
>  }
>  
> @@ -528,9 +539,9 @@ static int
>  process_sample_sched_switch(struct perf_evsel *evsel __maybe_unused,
>  			    struct perf_sample *sample)
>  {
> -	struct trace_entry *te = sample->raw_data;
> +	struct sched_switch *sw = timechart__payload(sample);
>  
> -	sched_switch(sample->cpu, sample->time, te);
> +	sched_switch(sample->cpu, sample->time, sw);
>  	return 0;
>  }
>  
> @@ -539,7 +550,7 @@ static int
>  process_sample_power_start(struct perf_evsel *evsel __maybe_unused,
>  			   struct perf_sample *sample)
>  {
> -	struct power_entry_old *peo = sample->raw_data;
> +	struct power_entry_old *peo = timechart__payload(sample);
>  
>  	c_state_start(peo->cpu_id, sample->time, peo->value);
>  	return 0;
> @@ -557,7 +568,7 @@ static int
>  process_sample_power_frequency(struct perf_evsel *evsel __maybe_unused,
>  			       struct perf_sample *sample)
>  {
> -	struct power_entry_old *peo = sample->raw_data;
> +	struct power_entry_old *peo = timechart__payload(sample);
>  
>  	p_state_change(peo->cpu_id, sample->time, peo->value);
>  	return 0;
> @@ -1012,6 +1023,11 @@ static int __cmd_timechart(const char *output_name)
>  		goto out_delete;
>  	}
>  
> +	if (timechart__set_payload_offset(session->evlist)) {
> +		pr_err("Field format not found, please try updating this tool\n");
> +		goto out_delete;
> +	}
> +
>  	ret = perf_session__process_events(session, &perf_timechart);
>  	if (ret)
>  		goto out_delete;
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 46dd4c2a41ce..4847d373fe2a 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1767,6 +1767,11 @@ struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *nam
>  	return pevent_find_field(evsel->tp_format, name);
>  }
>  
> +struct format_field *perf_evsel__fields(struct perf_evsel *evsel)
> +{
> +	return evsel->tp_format->format.fields;
> +}
> +
>  void *perf_evsel__rawptr(struct perf_evsel *evsel, struct perf_sample *sample,
>  			 const char *name)
>  {
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 1ea7c92e6e33..3d50dc01bb1d 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -193,6 +193,7 @@ static inline char *perf_evsel__strval(struct perf_evsel *evsel,
>  struct format_field;
>  
>  struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name);
> +struct format_field *perf_evsel__fields(struct perf_evsel *evsel);
>  
>  #define perf_evsel__match(evsel, t, c)		\
>  	(evsel->attr.type == PERF_TYPE_##t &&	\
