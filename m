Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3J2ImA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:42:00 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57693 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3J2Ilz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:41:55 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-90-526f74d2b26f
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] perf timechart: add backtrace support
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-7-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 29 Oct 2013 17:41:54 +0900
In-Reply-To: <1382439412-23713-7-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Tue, 22 Oct 2013 14:56:52 +0400")
Message-ID: <87d2mo5uzx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 14:56:52 +0400, Stanislav Fomichev wrote:
> Add -g flag to `perf timechart record` which saves callchain info in
> the perf.data.
> When generating SVG, add backtrace information to the figure details,
> so now it's possible to see which code path woke up the task and why some
> task went to sleep.

[SNIP]

> +static const char *cat_backtrace(union perf_event *event,
> +				 struct perf_sample *sample,
> +				 struct machine *machine)
> +{
> +	struct addr_location al;
> +	unsigned int i;
> +	char *p = NULL;
> +	size_t p_len;
> +	u8 cpumode = PERF_RECORD_MISC_USER;
> +	struct addr_location tal;
> +	struct ip_callchain *chain = sample->callchain;
> +	FILE *f = open_memstream(&p, &p_len);

It is safer to check the return value.

> +
> +	if (!chain)
> +		return NULL;
> +
> +	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
> +		fprintf(stderr, "problem processing %d event, skipping it.\n",
> +			event->header.type);
> +		return NULL;
> +	}

Above two returns should close 'f'.

> +
> +	for (i = 0; i < chain->nr; i++) {
> +		u64 ip;
> +
> +		if (callchain_param.order == ORDER_CALLEE)
> +			ip = chain->ips[i];
> +		else
> +			ip = chain->ips[chain->nr - i - 1];

The ip might carry context information rather than the actual
instruction pointer.  Please see machine__resolve_callchain_sample().

> +
> +		tal.filtered = false;
> +		thread__find_addr_location(al.thread, machine, cpumode,
> +					   MAP__FUNCTION, ip, &tal);
> +
> +		if (tal.sym)
> +			fprintf(f, "..... %016" PRIx64 " %s\n", ip,
> +				tal.sym->name);
> +		else
> +			fprintf(f, "..... %016" PRIx64 "\n", ip);
> +	}
> +
> +	fclose(f);
> +
> +	return p;
> +}
> +
>  typedef int (*tracepoint_handler)(struct perf_evsel *evsel,
> -				  struct perf_sample *sample);
> +				  struct perf_sample *sample,
> +				  const char *backtrace);
>  
>  static int process_sample_event(struct perf_tool *tool __maybe_unused,
>  				union perf_event *event __maybe_unused,
> @@ -485,7 +545,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>  
>  	if (evsel->handler.func != NULL) {
>  		tracepoint_handler f = evsel->handler.func;
> -		return f(evsel, sample);
> +		return f(evsel, sample,
> +			 cat_backtrace(event, sample, machine));
>  	}
>  
>  	return 0;
> @@ -493,7 +554,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>  
>  static int
>  process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
> -			struct perf_sample *sample)
> +			struct perf_sample *sample,
> +			const char *backtrace __maybe_unused)
>  {
>  	struct power_processor_entry *ppe = sample->raw_data;
>  
> @@ -506,7 +568,8 @@ process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
>  
>  static int
>  process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
> -			     struct perf_sample *sample)
> +			     struct perf_sample *sample,
> +			     const char *backtrace __maybe_unused)
>  {
>  	struct power_processor_entry *ppe = sample->raw_data;
>  
> @@ -516,28 +579,31 @@ process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
>  
>  static int
>  process_sample_sched_wakeup(struct perf_evsel *evsel __maybe_unused,
> -			    struct perf_sample *sample)
> +			    struct perf_sample *sample,
> +			    const char *backtrace __maybe_unused)

You don't need to add __maybe_unused if it's used. :)


>  {
>  	struct trace_entry *te = sample->raw_data;
>  
> -	sched_wakeup(sample->cpu, sample->time, sample->pid, te);
> +	sched_wakeup(sample->cpu, sample->time, sample->pid, te, backtrace);
>  	return 0;
>  }
>  
[SNIP]

> @@ -1166,6 +1255,7 @@ int cmd_timechart(int argc, const char **argv,
>  		     "record power data only", parse_power),
>  	OPT_CALLBACK_NOOPT('T', "tasks-only", NULL, NULL,
>  		     "record processes data only", parse_tasks),
> +	OPT_BOOLEAN('g', "callchain", &with_backtrace, "record callchain"),

Please update the doc also.

Thanks,
Namhyung


>  	OPT_END()
>  	};
>  	const char * const record_usage[] = {
