Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3FFBdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:33:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40381 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3FFBdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:33:10 -0400
Message-ID: <51AFE6D1.9010600@gmail.com>
Date: Wed, 05 Jun 2013 19:33:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 3/4] perf report: Add --time-filter option
References: <1370234653-31582-1-git-send-email-namhyung@kernel.org> <1370234653-31582-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1370234653-31582-3-git-send-email-namhyung@kernel.org>
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
> can be omitted.  This can be useful when analyzing a part of a huge
> data only.
>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-Tested-by: David Ahern <dsahern@gmail.com>


> ---
>   tools/perf/Documentation/perf-report.txt |  7 +++++++
>   tools/perf/builtin-report.c              | 27 +++++++++++++++++++++++++++
>   2 files changed, 34 insertions(+)
>
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 66dab7410c1d..04a96f657ca7 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -214,6 +214,13 @@ OPTIONS
>   	Do not show entries which have an overhead under that percent.
>   	(Default: 0).
>
> +-X::
> +--time-filter::
> +	Report samples within a range of time only. A time range can be given
> +	like 'time1-time2' and treated as a start time and end time
> +	respectively. The time format is like "<sec>.<usec>". Either of time1
> +	or time2 can be omitted.
> +
>   SEE ALSO
>   --------
>   linkperf:perf-stat[1], linkperf:perf-annotate[1]
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index ca98d34cd58b..e09e1bdb1401 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -53,6 +53,7 @@ struct perf_report {
>   	const char		*cpu_list;
>   	const char		*symbol_filter_str;
>   	float			min_percent;
> +	u64			time_start, time_end;
>   	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>   };
>
> @@ -318,6 +319,12 @@ static int process_sample_event(struct perf_tool *tool,
>   	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
>   		return 0;
>
> +	if (rep->time_start && rep->time_start > sample->time)
> +		return 0;
> +
> +	if (rep->time_end && rep->time_end < sample->time)
> +		return 0;
> +
>   	if (sort__mode == SORT_MODE__BRANCH) {
>   		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
>   							 evsel, machine);
> @@ -714,6 +721,24 @@ parse_percent_limit(const struct option *opt, const char *str,
>   	return 0;
>   }
>
> +static int
> +parse_time_filter(const struct option *opt, const char *str,
> +		  int unset __maybe_unused)
> +{
> +	struct perf_report *rep = opt->value;
> +	char *sep;
> +
> +	sep = strchr(str, '-');
> +	if (sep == NULL)
> +		return parse_nsec_time(str, &rep->time_start);
> +	else if (sep == str)
> +		return parse_nsec_time(++str, &rep->time_end);
> +
> +	*sep++ = '\0';
> +	return parse_nsec_time(str, &rep->time_start) ||
> +		parse_nsec_time(sep , &rep->time_end);
> +}
> +
>   int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>   {
>   	struct perf_session *session;
> @@ -825,6 +850,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>   	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
>   	OPT_CALLBACK(0, "percent-limit", &report, "percent",
>   		     "Don't show entries under that percent", parse_percent_limit),
> +	OPT_CALLBACK('X', "time-filter", &report, "time[-time]",
> +		     "Only display entries in the time range", parse_time_filter),
>   	OPT_END()
>   	};
>
>

