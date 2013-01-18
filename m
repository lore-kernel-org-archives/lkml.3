Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3AROAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:00:04 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55441 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3AROAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:00:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130118135018.GB1579@krava>
References: <1358514388-4344-1-git-send-email-eranian@google.com>
	<1358514388-4344-3-git-send-email-eranian@google.com>
	<20130118135018.GB1579@krava>
Date: Fri, 18 Jan 2013 14:59:58 +0100
Message-ID: <CABPqkBS5uOSqM323XjRFwLXen29R=9Lejmp3EuSt3JhJa6fjHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] perf stat: add interval printing
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 2:50 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Jan 18, 2013 at 02:06:28PM +0100, Stephane Eranian wrote:
>> This patch adds a new printing mode for perf stat.
>> It allows internval printing. That means perf stat
>
> SNIP
>
>>       const char * const stat_usage[] = {
>> @@ -1245,12 +1356,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>>               usage_with_options(stat_usage, options);
>>               return -1;
>>       }
>> +     if (interval < 0 || (interval > 0 && interval < 100)) {
>> +             pr_err("print interval must be >= 100ms\n");
>> +             usage_with_options(stat_usage, options);
>> +             return -1;
>> +     }
>>
>>       list_for_each_entry(pos, &evsel_list->entries, node) {
>>               if (perf_evsel__alloc_stat_priv(pos) < 0 ||
>>                   perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
>>                       goto out_free_fd;
>>       }
>> +     if (interval) {
>> +             list_for_each_entry(pos, &evsel_list->entries, node) {
>> +                     if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
>> +                             goto out_free_fd;
>> +             }
>> +     }
>
> this could be squeezed up into the previous loop,
>
The raw_counts are lazily allocated. So you'd have to have

if (interval)
     perf_evsel__alloc_prev_raw_counts(pos);

in the body of the loop.

> the perf_evsel__alloc_counts function does the same
> job for 'counts', maybe it could be unified
>
>
>>
>>       /*
>>        * We dont want to block the signals - that would cause
>> @@ -1260,6 +1382,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>>        */
>>       atexit(sig_atexit);
>>       signal(SIGINT,  skip_signal);
>> +     signal(SIGCHLD, skip_signal);
>>       signal(SIGALRM, skip_signal);
>>       signal(SIGABRT, skip_signal);
>>
>> @@ -1272,11 +1395,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>>               status = run_perf_stat(argc, argv);
>>       }
>>
>> -     if (status != -1)
>> +     if (status != -1 && !interval)
>>               print_stat(argc, argv);
>
> The way this is done prevents final stats to be printed,
> which seems unfortunate.
>
This is on purpose. All we care about here is the spaced deltas.
Note that I also removed the shadow stats. Tried to make them
work for a while but it did not make sense especially for -a -A.
I don't think it even works right now.

> Actually I don't mind that much, because I haven't even thought about
> this feature, but looks like it could be done separately with no affect
> to final counts.
>
Initially I had it as raw_counts, prev_raw_counts. But then it would
cause problems with the stats. So I simplified everything, it uses
less memory and gives me the output I care about.

If you want total count, then don't use this new option. The results
are to be fed to a plotter, so the final counts are useless and complicate
the post-processing.

> But since you probably use it mostly for feeding some graph ploting
> program, it's probably fine.. just feels wrong ;-)
>
> jirka
