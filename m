Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3EPB5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:57:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51752 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3EPB46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:56:58 -0400
X-AuditID: 9c93016f-b7b9bae000002df2-00-51943ce8b138
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
	<5193A6E7.9040501@gmail.com>
Date: Thu, 16 May 2013 10:56:56 +0900
In-Reply-To: <5193A6E7.9040501@gmail.com> (David Ahern's message of "Wed, 15
	May 2013 09:16:55 -0600")
Message-ID: <87sj1n4rh3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 15 May 2013 09:16:55 -0600, David Ahern wrote:
> On 5/15/13 3:23 AM, Namhyung Kim wrote:
[SNIP]
>> +--time-filter::
>> +	Display samples within a range of time only. A time range can be given
>> +	like 'time1-time2' and treated as a start time and end time
>> +        respectively. The time format is like "<sec>.<usec>". Either of time1
>> +	or time2 can be omitted.
>
> I have this option internally on all analysis commands for while now -- 
> on report, script and my timehist command. Very useful feature.
>
> How about just --time? less typing.

Thanks, I'm fine with '--time' too but '--time-filter' looks more
obvious.  What does the timehist command do, btw? ;)

>
>> +
>>   SEE ALSO
>>   --------
>>   linkperf:perf-record[1], linkperf:perf-script-perl[1],
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 92d4658f56fb..fec624b9f8e3 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -28,6 +28,17 @@ static bool			system_wide;
>>   static const char		*cpu_list;
>>   static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>>
>> +#define TIME_FILTER_START 1
>> +#define TIME_FILTER_END   2
>> +
>> +struct time_range {
>> +	int filter;
>> +	u64 start;
>> +	u64 end;
>> +};
>
> The FILTER parts should not be needed.

Right.  I'll remove it.

>
>> +
>> +static struct time_range trange;
>> +
>>   enum perf_output_field {
>>   	PERF_OUTPUT_COMM            = 1U << 0,
>>   	PERF_OUTPUT_TID             = 1U << 1,
>> @@ -510,6 +521,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>>   	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
>>   		return 0;
>>
>> +	if ((trange.filter & TIME_FILTER_START) && trange.start > sample->time)
>> +		return 0;
>
> How about just:
> if (trange.start && trange.start < sample->time)
>     return 0;
>
>> +
>> +	if ((trange.filter & TIME_FILTER_END) && trange.end < sample->time)
>> +		return 0;
>
> and similarly:
> if (trange.end && trange.end > sample->time)
>     return 0;

Okay.

>
>> +
>>   	scripting_ops->process_event(event, sample, evsel, machine, &al);
>>
>>   	evsel->hists.stats.total_period += sample->period;
>> @@ -1236,6 +1253,33 @@ static int have_cmd(int argc, const char **argv)
>>   	return 0;
>>   }
>>
>> +static int
>> +parse_time_filter(const struct option *opt, const char *str,
>> +		  int unset __maybe_unused)
>> +{
>> +	struct time_range *time_range = opt->value;
>> +	char *sep;
>> +
>> +	sep = strchr(str, '-');
>> +	if (sep == NULL || sep[1] == '\0') {
>> +		time_range->filter = TIME_FILTER_START;
>> +		time_range->start = parse_nsec_time(str);
>> +		return 0;
>> +	} else if (sep == str) {
>> +		time_range->filter = TIME_FILTER_END;
>> +		time_range->end = parse_nsec_time(++str);
>> +		return 0;
>> +	}
>> +
>> +	*sep++ = '\0';
>> +
>> +	time_range->filter = TIME_FILTER_START | TIME_FILTER_END;
>> +	time_range->start = parse_nsec_time(str);
>> +	time_range->end = parse_nsec_time(sep);
>
> I would expect parse_nsec_time to fail. e.g., a time string like 123455.a

It looks like current strtol() returns 0 when failed to parse like
above.  Hmm.. do I have to check whether the return value is 0 or just
ignore invalid inputs?

Thanks,
Namhyung
