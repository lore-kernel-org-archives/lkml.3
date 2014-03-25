Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaCYUyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:54:40 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49178 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaCYUyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
References: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
Date: Tue, 25 Mar 2014 21:54:38 +0100
Message-ID: <CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
Subject: Re: [PATCH] tools, perf: Allow the user to disable time stamps
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 9:44 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> From: Andi Kleen <ak@linux.intel.com>
>
> [post with updated description]
>
> Time stamps are always implicitely enabled for record currently.
> The old --time/-T option is a nop.
>
> The time stamps are needed to handle library mmaps correctly.
> This mainly matters at program startup, but is not useful
> when profiling long running programs.
>
> Allow the user to disable timestamps by using --no-time
>
> This can cause some minor misaccounting, but lowers the
> size of the perf.data nicely:
>
> % perl -e 'while(1) {}' &
> [1] 5827
> % perf record -p 5827 --no-time -c 1000003 sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.089 MB perf.data (~3872 samples) ]
> % perf record -p 5827  -c 1000003  sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.114 MB perf.data (~4967 samples) ]
>
> 22% smaller data file, even though we got more samples.
> It also seems to speed up perf slightly, that is why we get more
> samples.
>
But that measure of the number of samples is bogus most of the time.
It is an estimate based on a standard sample size.

Timestamp are useful to order samples during reporting.
How do you do with it if you monitor multi-threaded (multi-cpu)
workloads. This is only good for single thread or single CPU
measurements. Or am I missing something?


>
> The defaults are unchanged.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/builtin-record.c | 1 +
>  tools/perf/util/evsel.c     | 9 ++++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 3c394bf..8e92d3c 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -800,6 +800,7 @@ static const char * const record_usage[] = {
>   */
>  static struct record record = {
>         .opts = {
> +               .sample_time         = true,
>                 .mmap_pages          = UINT_MAX,
>                 .user_freq           = UINT_MAX,
>                 .user_interval       = ULLONG_MAX,
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 22e18a2..a15efc4 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -613,9 +613,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>         if (opts->period)
>                 perf_evsel__set_sample_bit(evsel, PERIOD);
>
> -       if (!perf_missing_features.sample_id_all &&
> -           (opts->sample_time || !opts->no_inherit ||
> -            target__has_cpu(&opts->target) || per_cpu))
> +       /*
> +        * When the user explicitely disabled time don't force it here.
> +        */
> +       if (opts->sample_time &&
> +           (!perf_missing_features.sample_id_all &&
> +           (!opts->no_inherit || target__has_cpu(&opts->target) || per_cpu)))
>                 perf_evsel__set_sample_bit(evsel, TIME);
>
>         if (opts->raw_samples) {
> --
> 1.8.5.3
>
