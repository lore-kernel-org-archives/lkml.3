Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3FFBcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:32:32 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40008 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab3FFBcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:32:31 -0400
Message-ID: <51AFE6AA.1050708@gmail.com>
Date: Wed, 05 Jun 2013 19:32:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 2/4] perf script: Add --time-filter option
References: <1370234653-31582-1-git-send-email-namhyung@kernel.org> <1370234653-31582-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1370234653-31582-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/13 10:44 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The --time-filter option is for limiting samples within a range of
> time.  A time range looks like <time1>-<time2> and at most one of them
> can be omitted.  For instance:
>
>    $ perf script --time-filter -2178446.12
>    ...
>           xchat  1772 [002] 2178446.070330: sched:sched_switch: prev_comm=xchat prev_pid=177
>         swapper     0 [002] 2178446.070338: power:cpu_idle: state=4 cpu_id=2
>         swapper     0 [001] 2178446.091952: sched:sched_wakeup: comm=synergys pid=1488 prio=
>         swapper     0 [001] 2178446.091958: power:cpu_idle: state=4294967295 cpu_id=1
>         swapper     0 [001] 2178446.091970: sched:sched_switch: prev_comm=swapper/1 prev_pid
>        synergys  1488 [001] 2178446.091995: sched:sched_switch: prev_comm=synergys prev_pid=
>         swapper     0 [001] 2178446.092003: power:cpu_idle: state=4 cpu_id=1
>         swapper     0 [001] 2178446.116997: sched:sched_wakeup: comm=synergys pid=1488 prio=
>         swapper     0 [001] 2178446.117004: power:cpu_idle: state=4294967295 cpu_id=1
>         swapper     0 [001] 2178446.117016: sched:sched_switch: prev_comm=swapper/1 prev_pid
>        synergys  1488 [001] 2178446.117040: sched:sched_switch: prev_comm=synergys prev_pid=
>         swapper     0 [001] 2178446.117048: power:cpu_idle: state=4 cpu_id=1
>
> Above example only displays samples which have a timestamp before
> 2178446.120000.
>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-Tested-by: David Ahern <dsahern@gmail.com>


> ---
>   tools/perf/Documentation/perf-script.txt |  7 +++++++
>   tools/perf/builtin-script.c              | 32 ++++++++++++++++++++++++++++++++
>   2 files changed, 39 insertions(+)
>
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index e9cbfcddfa3f..c4994c5f27ff 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -203,6 +203,13 @@ OPTIONS
>   --show-kernel-path::
>   	Try to resolve the path of [kernel.kallsyms]
>
> +-X::
> +--time-filter::
> +	Display samples within a range of time only. A time range can be given
> +	like 'time1-time2' and treated as a start time and end time
> +        respectively. The time format is like "<sec>.<usec>". Either of time1
> +	or time2 can be omitted.
> +
>   SEE ALSO
>   --------
>   linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 92d4658f56fb..d598765e59cb 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -28,6 +28,13 @@ static bool			system_wide;
>   static const char		*cpu_list;
>   static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>
> +struct time_range {
> +	u64 start;
> +	u64 end;
> +};
> +
> +static struct time_range trange;
> +
>   enum perf_output_field {
>   	PERF_OUTPUT_COMM            = 1U << 0,
>   	PERF_OUTPUT_TID             = 1U << 1,
> @@ -510,6 +517,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>   	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
>   		return 0;
>
> +	if (trange.start && trange.start > sample->time)
> +		return 0;
> +
> +	if (trange.end && trange.end < sample->time)
> +		return 0;
> +
>   	scripting_ops->process_event(event, sample, evsel, machine, &al);
>
>   	evsel->hists.stats.total_period += sample->period;
> @@ -1236,6 +1249,23 @@ static int have_cmd(int argc, const char **argv)
>   	return 0;
>   }
>
> +static int
> +parse_time_filter(const struct option *opt, const char *str,
> +		  int unset __maybe_unused)
> +{
> +	struct time_range *time_range = opt->value;
> +	char *sep = strchr(str, '-');
> +
> +	if (sep == NULL)
> +		return parse_nsec_time(str, &time_range->start);
> +	else if (sep == str)
> +		return parse_nsec_time(++str, &time_range->end);
> +
> +	*sep++ = '\0';
> +	return parse_nsec_time(str, &time_range->start) ||
> +		parse_nsec_time(sep, &time_range->end);
> +}
> +
>   int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   {
>   	bool show_full_info = false;
> @@ -1286,6 +1316,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   		    "display extended information from perf.data file"),
>   	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
>   		    "Show the path of [kernel.kallsyms]"),
> +	OPT_CALLBACK('X', "time-filter", &trange, "time[-time]",
> +		     "Only display entries in the time range", parse_time_filter),
>   	OPT_END()
>   	};
>   	const char * const script_usage[] = {
>

