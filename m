Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3BALBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:01:42 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:48851 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab3BALBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:01:36 -0500
MIME-Version: 1.0
In-Reply-To: <87d2wktq8c.fsf@sejong.aot.lge.com>
References: <CABPqkBSK_+v+16EPphRkWb+nqmxHwiV6gVo_5yfmqCV8-f062g@mail.gmail.com>
	<87d2wktq8c.fsf@sejong.aot.lge.com>
Date: Fri, 1 Feb 2013 12:01:35 +0100
Message-ID: <CABPqkBSLjOBaiUSjoFbsv_2rnCeDnY8y6fM+KTB4n-mJnS9+MQ@mail.gmail.com>
Subject: Re: [BUG] perf annotate: broken in pipe mode
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 9:04 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> On Fri, 1 Feb 2013 00:51:51 +0100, Stephane Eranian wrote:
>> Hi,
>>
>> Looks like perf annotate in pipe mode is totally broken nowadays.
>> I tried this from tip.git:
>>
>> $ perf record -o - noploop 5 >perf.data
>> $ perf annotate -i i < perf.data
>> Core dump
>>
>> Callstack looks as follows:
>> 0x000000000049f9e4 in add_hist_entry (hists=0x809708,
>> entry=0x7fffffffde60, al=0x7fffffffdff0, period=1) at util/hist.c:297
>> 297 while (*p != NULL) {
>> :t
>> [Current thread is 1 (Thread 0x7ffff7fc9980 (LWP 13292))]
>> (gdb) bt
>> #0  0x000000000049f9e4 in add_hist_entry (hists=0x809708,
>> entry=0x7fffffffde60, al=0x7fffffffdff0, period=1) at util/hist.c:297
>> #1  0x000000000049fcca in __hists__add_entry (self=0x809708,
>> al=0x7fffffffdff0, sym_parent=0x0, period=1) at util/hist.c:395
>> #2  0x00000000004171b0 in perf_evsel__add_sample (evsel=0x809660,
>> sample=0x7fffffffe0e0, al=0x7fffffffdff0, ann=0x7fffffffe750) at
>> builtin-annotate.c:65
>> #3  0x0000000000417394 in process_sample_event (tool=0x7fffffffe750,
>> event=0x80af70, sample=0x7fffffffe0e0, evsel=0x809660,
>> machine=0x8093c8) at builtin-annotate.c:102
>> #4  0x000000000048c56d in perf_session_deliver_event
>> (session=0x8092e0, event=0x80af70, sample=0x7fffffffe0e0,
>> tool=0x7fffffffe750, file_offset=11688)
>>     at util/session.c:870
>> #5  0x000000000048cb20 in perf_session__process_event
>> (session=0x8092e0, event=0x80af70, tool=0x7fffffffe750,
>> file_offset=11688) at util/session.c:986
>> #6  0x000000000048cf75 in __perf_session__process_pipe_events
>> (self=0x8092e0, tool=0x7fffffffe750) at util/session.c:1120
>>
>> Looks like the session->evlist is not properly initialized in pipe
>> mode or that evsel->hists
>> is bogus because it crashes due to evsel->hists->entries_in == NULL.
>> Don't know how
>> you can get there.
>>
>> Anybody has a clue?
>
> After some study I think I managed to figure out the root cause.  The
> patch follows..
>
>
> ---------8<---------------8<------------
> From a550d15f788397552b3fc04dbe4a089498288a05 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung.kim@lge.com>
> Date: Fri, 1 Feb 2013 16:51:45 +0900
> Subject: [PATCH] perf annotate: Process synthetic events for pipe mode
>
> Stephane reported that perf annotate in pipe mode is broken with NULL
> evlist.  It's because we didn't process ATTR and EVENT_TYPE events in
> annoate.  Since in pipe mode we cannot get the event info from the
> header, it should be handled prior to processing sample events so that
> the event and/or evlist are added to the session properly.
>
> I'm not sure TRACING_DATA and BUILD_ID events should also be processed
> but adding them will cause no harm I guess. :)
>
> After adding needed callbacks, I realized symbol_conf.nr_events value
> should be increased when processing new events/attrs otherwise it'd
> get a zero division exception when calling symbol__alloc_hist().
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Works for me now both in per-process and system-wide mode.
Thanks for fixing this quickly.

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  tools/perf/builtin-annotate.c | 4 ++++
>  tools/perf/util/header.c      | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index dc870cf31b79..5509cc37a829 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -254,6 +254,10 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>                         .comm   = perf_event__process_comm,
>                         .exit   = perf_event__process_exit,
>                         .fork   = perf_event__process_fork,
> +                       .attr            = perf_event__process_attr,
> +                       .event_type      = perf_event__process_event_type,
> +                       .tracing_data    = perf_event__process_tracing_data,
> +                       .build_id        = perf_event__process_build_id,
>                         .ordered_samples = true,
>                         .ordering_requires_timestamps = true,
>                 },
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 8022b5254f75..274ecd401d41 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2950,6 +2950,7 @@ int perf_event__process_attr(union perf_event *event,
>                 return -ENOMEM;
>
>         perf_evlist__add(evlist, evsel);
> +       symbol_conf.nr_events++;
>
>         ids = event->header.size;
>         ids -= (void *)&event->attr.id - (void *)event;
> --
> 1.7.11.7
>
