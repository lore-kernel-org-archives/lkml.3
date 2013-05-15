Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab3EOPRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:17:14 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:40015 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3EOPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:17:13 -0400
Message-ID: <5193A6E7.9040501@gmail.com>
Date: Wed, 15 May 2013 09:16:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/13 3:23 AM, Namhyung Kim wrote:
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
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/Documentation/perf-script.txt |  6 +++++
>   tools/perf/builtin-script.c              | 46 ++++++++++++++++++++++++++++++++
>   tools/perf/util/util.c                   | 25 +++++++++++++++++
>   tools/perf/util/util.h                   |  2 ++
>   4 files changed, 79 insertions(+)
>
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index e9cbfcddfa3f..e6d591c5c60c 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -203,6 +203,12 @@ OPTIONS
>   --show-kernel-path::
>   	Try to resolve the path of [kernel.kallsyms]
>
> +--time-filter::
> +	Display samples within a range of time only. A time range can be given
> +	like 'time1-time2' and treated as a start time and end time
> +        respectively. The time format is like "<sec>.<usec>". Either of time1
> +	or time2 can be omitted.

I have this option internally on all analysis commands for while now -- 
on report, script and my timehist command. Very useful feature.

How about just --time? less typing.

> +
>   SEE ALSO
>   --------
>   linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 92d4658f56fb..fec624b9f8e3 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -28,6 +28,17 @@ static bool			system_wide;
>   static const char		*cpu_list;
>   static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>
> +#define TIME_FILTER_START 1
> +#define TIME_FILTER_END   2
> +
> +struct time_range {
> +	int filter;
> +	u64 start;
> +	u64 end;
> +};

The FILTER parts should not be needed.

> +
> +static struct time_range trange;
> +
>   enum perf_output_field {
>   	PERF_OUTPUT_COMM            = 1U << 0,
>   	PERF_OUTPUT_TID             = 1U << 1,
> @@ -510,6 +521,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>   	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
>   		return 0;
>
> +	if ((trange.filter & TIME_FILTER_START) && trange.start > sample->time)
> +		return 0;

How about just:
if (trange.start && trange.start < sample->time)
     return 0;

> +
> +	if ((trange.filter & TIME_FILTER_END) && trange.end < sample->time)
> +		return 0;

and similarly:
if (trange.end && trange.end > sample->time)
     return 0;

> +
>   	scripting_ops->process_event(event, sample, evsel, machine, &al);
>
>   	evsel->hists.stats.total_period += sample->period;
> @@ -1236,6 +1253,33 @@ static int have_cmd(int argc, const char **argv)
>   	return 0;
>   }
>
> +static int
> +parse_time_filter(const struct option *opt, const char *str,
> +		  int unset __maybe_unused)
> +{
> +	struct time_range *time_range = opt->value;
> +	char *sep;
> +
> +	sep = strchr(str, '-');
> +	if (sep == NULL || sep[1] == '\0') {
> +		time_range->filter = TIME_FILTER_START;
> +		time_range->start = parse_nsec_time(str);
> +		return 0;
> +	} else if (sep == str) {
> +		time_range->filter = TIME_FILTER_END;
> +		time_range->end = parse_nsec_time(++str);
> +		return 0;
> +	}
> +
> +	*sep++ = '\0';
> +
> +	time_range->filter = TIME_FILTER_START | TIME_FILTER_END;
> +	time_range->start = parse_nsec_time(str);
> +	time_range->end = parse_nsec_time(sep);

I would expect parse_nsec_time to fail. e.g., a time string like 123455.a

David


> +
> +	return 0;
> +}
> +
>   int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   {
>   	bool show_full_info = false;
> @@ -1286,6 +1330,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   		    "display extended information from perf.data file"),
>   	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
>   		    "Show the path of [kernel.kallsyms]"),
> +	OPT_CALLBACK(0, "time-filter", &trange, "time[-time]",
> +		    "Only display entries in the time range", parse_time_filter),
>   	OPT_END()
>   	};
>   	const char * const script_usage[] = {
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 59d868add275..4f68bae5f8b1 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -269,3 +269,28 @@ void perf_debugfs_set_path(const char *mntpt)
>   	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
>   	set_tracing_events_path(mntpt);
>   }
> +
> +/* XXX.YYYYYY -> nsec */
> +u64 parse_nsec_time(const char *str)
> +{
> +	u64 time_sec, time_nsec;
> +	char *end;
> +
> +	time_sec = strtol(str, &end, 10);
> +	if (end && *end == '.') {
> +		int i;
> +		char nsec_buf[10];
> +
> +		strncpy(nsec_buf, end+1, 9);
> +
> +		/* make it nsec precision */
> +		for (i = strlen(nsec_buf); i < 9; i++)
> +			nsec_buf[i] = '0';
> +		nsec_buf[9] = '\0';
> +
> +		time_nsec = strtol(nsec_buf, &end, 10);
> +	} else
> +		time_nsec = 0;
> +
> +	return time_sec * NSEC_PER_SEC + time_nsec;
> +}
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 7a484c97e500..85b24cef96d4 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -204,6 +204,8 @@ static inline int has_extension(const char *filename, const char *ext)
>   #define NSEC_PER_MSEC	1000000L
>   #endif
>
> +u64 parse_nsec_time(const char *str);
> +
>   extern unsigned char sane_ctype[256];
>   #define GIT_SPACE		0x01
>   #define GIT_DIGIT		0x02
>

