Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab3BMJiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:38:14 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55977 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab3BMJiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:38:10 -0500
MIME-Version: 1.0
In-Reply-To: <874nhgps85.fsf@sejong.aot.lge.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
	<1360678168-6974-2-git-send-email-eranian@google.com>
	<874nhgps85.fsf@sejong.aot.lge.com>
Date: Wed, 13 Feb 2013 10:38:09 +0100
Message-ID: <CABPqkBR=H5NOTjjEXRzC-tU3K+tbkYHYTzBvjyZyn3-Xu68UVw@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf stat: refactor aggregation code
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 8:50 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> On Tue, 12 Feb 2013 15:09:27 +0100, Stephane Eranian wrote:
>> Refactor aggregation code by introducing
>> a single aggr_mode variable and an enum
>> for aggregation.
>>
>> Also refactor cpumap code having to do
>> with cpu to socket mappings. All in preparation
>> for extended modes, such as cpu -> core.
>>
>> Also fix socket aggregation and ensure
>> that sockets are printed in increasing order.
> [snip]
>> -static void print_aggr_socket(char *prefix)
>> +static void print_aggr(char *prefix)
>>  {
>>       struct perf_evsel *counter;
>> +     int cpu, s, s2, id, nr;
>>       u64 ena, run, val;
>> -     int cpu, s, s2, sock, nr;
>>
>> -     if (!sock_map)
>> +     if (!(aggr_map || aggr_get_id))
>>               return;
>>
>> -     for (s = 0; s < sock_map->nr; s++) {
>> -             sock = cpu_map__socket(sock_map, s);
>> +     for (s = 0; s < aggr_map->nr; s++) {
>> +             id = aggr_map->map[s];
>>               list_for_each_entry(counter, &evsel_list->entries, node) {
>>                       val = ena = run = 0;
>>                       nr = 0;
> ...
>> @@ -1073,14 +1081,20 @@ static void print_stat(int argc, const char **argv)
>>               fprintf(output, ":\n\n");
>>       }
>>
>> -     if (aggr_socket)
>> -             print_aggr_socket(NULL);
>> -     else if (no_aggr) {
>> -             list_for_each_entry(counter, &evsel_list->entries, node)
>> -                     print_counter(counter, NULL);
>> -     } else {
>> +     switch (aggr_mode) {
>> +     case AGGR_SOCKET:
>> +             print_aggr(NULL);
>> +             break;
>
> This line should look like this IMHO:
>
>                 list_for_each_entry(counter, &evsel_list->entries, node)
>                         print_aggr(counter, NULL);
>
> and the equivalent loop in the print_aggr() should be removed.  This is
> for consistency with other formats if multiple events counted.
>
Sounds good. I will make the change.

> For instance, it'd sorting on events first and then sockets like:
>
>   #      time socket cpus     counts events
>            t0 S0     4        XXXXXX cycles
>            t0 S1     4        XXXXXX cycles
>            t0 S0     4          YYYY cache-misses
>            t0 S1     4          YYYY cache-misses
>            t1 S0     4        ZZZZZZ cycles
>   ...
>
> But current code looks like sorting on sockets first instead.
>
>   #      time socket cpus     counts events
>            t0 S0     4        XXXXXX cycles
>            t0 S0     4          YYYY cache-misses
>            t0 S1     4        XXXXXX cycles
>            t0 S1     4          YYYY cache-misses
>            t1 S0     4        ZZZZZZ cycles
>   ...
>
> Thanks,
> Namhyung
>
>
>> +     case AGGR_GLOBAL:
>>               list_for_each_entry(counter, &evsel_list->entries, node)
>>                       print_counter_aggr(counter, NULL);
>> +             break;
>> +     case AGGR_NONE:
>> +             list_for_each_entry(counter, &evsel_list->entries, node)
>> +                     print_counter(counter, NULL);
>> +             break;
>> +     default:
>> +             break;
>>       }
