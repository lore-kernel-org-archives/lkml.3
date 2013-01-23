Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3AWRAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:00:46 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62172 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab3AWRAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:00:45 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
	<1358455012-12287-17-git-send-email-andi@firstfloor.org>
	<CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com>
	<CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com>
Date: Wed, 23 Jan 2013 18:00:43 +0100
Message-ID: <CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com>
Subject: Re: [PATCH 16/29] perf, tools: Add support for weight v7
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:54 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Jan 23, 2013 at 12:38 PM, Stephane Eranian <eranian@google.com> wrote:
>> On Thu, Jan 17, 2013 at 9:36 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> From: Andi Kleen <ak@linux.intel.com>
>>>
>>> perf record has a new option -W that enables weightened sampling.
>>>
>>> Add sorting support in top/report for the average weight per sample and the
>>> total weight sum. This allows to both compare relative cost per event
>>> and the total cost over the measurement period.
>>>
>>> Add the necessary glue to perf report, record and the library.
>>>
>>> v2: Merge with new hist refactoring.
>>> v3: Fix manpage. Remove value check.
>>> Rename global_weight to weight and weight to local_weight.
>>> v4: Readd sort keys to manpage
>>> v5: Move weight to end
>>> v6: Move weight to template
>>> v7: Rename weight key.
>>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>> ---
>>>  tools/perf/Documentation/perf-record.txt |    6 +++
>>>  tools/perf/Documentation/perf-report.txt |    2 +-
>>>  tools/perf/Documentation/perf-top.txt    |    2 +-
>>>  tools/perf/builtin-annotate.c            |    2 +-
>>>  tools/perf/builtin-diff.c                |    7 ++--
>>>  tools/perf/builtin-record.c              |    2 +
>>>  tools/perf/builtin-report.c              |    7 ++--
>>>  tools/perf/builtin-top.c                 |    5 ++-
>>>  tools/perf/perf.h                        |    1 +
>>>  tools/perf/util/event.h                  |    1 +
>>>  tools/perf/util/evsel.c                  |   10 ++++++
>>>  tools/perf/util/hist.c                   |   23 +++++++++----
>>>  tools/perf/util/hist.h                   |    8 +++-
>>>  tools/perf/util/session.c                |    3 ++
>>>  tools/perf/util/sort.c                   |   51 +++++++++++++++++++++++++++++-
>>>  tools/perf/util/sort.h                   |    3 ++
>>>  16 files changed, 112 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
>>> index f7d74b2..6f3405e 100644
>>> --- a/tools/perf/Documentation/perf-record.txt
>>> +++ b/tools/perf/Documentation/perf-record.txt
>>> @@ -185,6 +185,12 @@ is enabled for all the sampling events. The sampled branch type is the same for
>>>  The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
>>>  Note that this feature may not be available on all processors.
>>>
>>> +-W::
>>> +--weight::
>>> +Enable weightened sampling. An additional weight is recorded per sample and can be
>>> +displayed with the weight and local_weight sort keys.  This currently works for TSX
>>> +abort events and some memory events in precise mode on modern Intel CPUs.
>>> +
>>>  SEE ALSO
>>>  --------
>>>  linkperf:perf-stat[1], linkperf:perf-list[1]
>>> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
>>> index cb4216d..5dabd4d 100644
>>> --- a/tools/perf/Documentation/perf-report.txt
>>> +++ b/tools/perf/Documentation/perf-report.txt
>>> @@ -59,7 +59,7 @@ OPTIONS
>>>  --sort=::
>>>         Sort by key(s): pid, comm, dso, symbol, parent, srcline,
>>>          dso_from, dso_to, symbol_to, symbol_from, mispredict,
>>> -        abort, intx
>>> +        abort, intx, local_weight, weight
>>>
>>>  -p::
>>>  --parent=<regex>::
>>> diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
>>> index 1398b73..3533e0a 100644
>>> --- a/tools/perf/Documentation/perf-top.txt
>>> +++ b/tools/perf/Documentation/perf-top.txt
>>> @@ -114,7 +114,7 @@ Default is to monitor all CPUS.
>>>  --sort::
>>>         Sort by key(s): pid, comm, dso, symbol, parent, srcline,
>>>          dso_from, dso_to, symbol_to, symbol_from, mispredict,
>>> -        abort, intx
>>> +        abort, intx,  local_weight, weight
>>>
>>>  -n::
>>>  --show-nr-samples::
>>> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
>>> index dc870cf..1bacb7d 100644
>>> --- a/tools/perf/builtin-annotate.c
>>> +++ b/tools/perf/builtin-annotate.c
>>> @@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
>>>                 return 0;
>>>         }
>>>
>>> -       he = __hists__add_entry(&evsel->hists, al, NULL, 1);
>>> +       he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
>>>         if (he == NULL)
>>>                 return -ENOMEM;
>>>
>>> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
>>> index 93b852f..03a322f 100644
>>> --- a/tools/perf/builtin-diff.c
>>> +++ b/tools/perf/builtin-diff.c
>>> @@ -248,9 +248,10 @@ int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
>>>  }
>>>
>>>  static int hists__add_entry(struct hists *self,
>>> -                           struct addr_location *al, u64 period)
>>> +                           struct addr_location *al, u64 period,
>>> +                           u64 weight)
>>>  {
>>> -       if (__hists__add_entry(self, al, NULL, period) != NULL)
>>> +       if (__hists__add_entry(self, al, NULL, period, weight) != NULL)
>>>                 return 0;
>>>         return -ENOMEM;
>>>  }
>>> @@ -272,7 +273,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
>>>         if (al.filtered)
>>>                 return 0;
>>>
>>> -       if (hists__add_entry(&evsel->hists, &al, sample->period)) {
>>> +       if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
>>>                 pr_warning("problem incrementing symbol period, skipping event\n");
>>>                 return -1;
>>>         }
>>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>>> index e7da893..4e568aa 100644
>>> --- a/tools/perf/builtin-record.c
>>> +++ b/tools/perf/builtin-record.c
>>> @@ -1062,6 +1062,8 @@ const struct option record_options[] = {
>>>         OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
>>>                      "branch filter mask", "branch stack filter modes",
>>>                      parse_branch_stack),
>>> +       OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
>>> +                   "sample by weight (on special events only)"),
>>>         OPT_END()
>>>  };
>>>
>>> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>>> index 072c388..5dc0edd 100644
>>> --- a/tools/perf/builtin-report.c
>>> +++ b/tools/perf/builtin-report.c
>>> @@ -88,7 +88,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
>>>                  * and not events sampled. Thus we use a pseudo period of 1.
>>>                  */
>>>                 he = __hists__add_branch_entry(&evsel->hists, al, parent,
>>> -                               &bi[i], 1);
>>> +                               &bi[i], 1, 1);
>>>                 if (he) {
>>>                         struct annotation *notes;
>>>                         err = -ENOMEM;
>>> @@ -146,7 +146,8 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>>>                         return err;
>>>         }
>>>
>>> -       he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
>>> +       he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
>>> +                                       sample->weight);
>>>         if (he == NULL)
>>>                 return -ENOMEM;
>>>
>>> @@ -597,7 +598,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>>>         OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
>>>                    "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
>>>                    " dso_from, symbol_to, symbol_from, mispredict, srcline,"
>>> -                  " abort, intx"),
>>> +                  " abort, intx,  weight, local_weight"),
>>>         OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
>>>                     "Show sample percentage for different cpu modes"),
>>>         OPT_STRING('p', "parent", &parent_pattern, "regex",
>>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>>> index 6cfb678..9f87db7 100644
>>> --- a/tools/perf/builtin-top.c
>>> +++ b/tools/perf/builtin-top.c
>>> @@ -271,7 +271,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>>>  {
>>>         struct hist_entry *he;
>>>
>>> -       he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
>>> +       he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
>>> +                               sample->weight);
>>>         if (he == NULL)
>>>                 return NULL;
>>>
>>> @@ -1232,7 +1233,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
>>>         OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
>>>                    "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
>>>                    " dso_from, symbol_to, symbol_from, mispredict, srcline,"
>>> -                  " abort, intx"),
>>> +                  " abort, intx, weight, local_weight"),
>>>         OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
>>>                     "Show a column with the number of samples"),
>>>         OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
>>> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
>>> index c6d315b..7058155 100644
>>> --- a/tools/perf/perf.h
>>> +++ b/tools/perf/perf.h
>>> @@ -238,6 +238,7 @@ struct perf_record_opts {
>>>         bool         pipe_output;
>>>         bool         raw_samples;
>>>         bool         sample_address;
>>> +       bool         sample_weight;
>>>         bool         sample_time;
>>>         bool         sample_id_all_missing;
>>>         bool         exclude_guest_missing;
>>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>>> index 0d573ff..a97fbbe 100644
>>> --- a/tools/perf/util/event.h
>>> +++ b/tools/perf/util/event.h
>>> @@ -88,6 +88,7 @@ struct perf_sample {
>>>         u64 id;
>>>         u64 stream_id;
>>>         u64 period;
>>> +       u64 weight;
>>>         u32 cpu;
>>>         u32 raw_size;
>>>         void *raw_data;
>>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>>> index 1b16dd1..805d33e 100644
>>> --- a/tools/perf/util/evsel.c
>>> +++ b/tools/perf/util/evsel.c
>>> @@ -510,6 +510,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
>>>                 attr->branch_sample_type = opts->branch_stack;
>>>         }
>>>
>>> +       if (opts->sample_weight)
>>> +               attr->sample_type       |= PERF_SAMPLE_WEIGHT;
>>> +
>>>         attr->mmap = track;
>>>         attr->comm = track;
>>>
>>> @@ -908,6 +911,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>>>         data->cpu = data->pid = data->tid = -1;
>>>         data->stream_id = data->id = data->time = -1ULL;
>>>         data->period = 1;
>>> +       data->weight = 0;
>>>
>>>         if (event->header.type != PERF_RECORD_SAMPLE) {
>>>                 if (!evsel->attr.sample_id_all)
>>> @@ -1058,6 +1062,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>>>                 }
>>>         }
>>>
>>> +       data->weight = 0;
>>> +       if (type & PERF_SAMPLE_WEIGHT) {
>>> +               data->weight = *array;
>>> +               array++;
>>> +       }
>>> +
>>>         return 0;
>>>  }
>>>
>>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>>> index cb17e2a..a8d7647 100644
>>> --- a/tools/perf/util/hist.c
>>> +++ b/tools/perf/util/hist.c
>>> @@ -151,9 +151,11 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
>>>         }
>>>  }
>>>
>>> -static void he_stat__add_period(struct he_stat *he_stat, u64 period)
>>> +static void he_stat__add_period(struct he_stat *he_stat, u64 period,
>>> +                               u64 weight)
>>>  {
>>>         he_stat->period         += period;
>>> +       he_stat->weight         += weight;
>>>         he_stat->nr_events      += 1;
>>>  }
>>>
>>> @@ -165,12 +167,14 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
>>>         dest->period_guest_sys  += src->period_guest_sys;
>>>         dest->period_guest_us   += src->period_guest_us;
>>>         dest->nr_events         += src->nr_events;
>>> +       dest->weight            += src->weight;
>>>  }
>>>
>>>  static void hist_entry__decay(struct hist_entry *he)
>>>  {
>>>         he->stat.period = (he->stat.period * 7) / 8;
>>>         he->stat.nr_events = (he->stat.nr_events * 7) / 8;
>>> +       /* XXX need decay for weight too? */
>>>  }
>>>
>>>  static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
>>> @@ -270,7 +274,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
>>>  static struct hist_entry *add_hist_entry(struct hists *hists,
>>>                                       struct hist_entry *entry,
>>>                                       struct addr_location *al,
>>> -                                     u64 period)
>>> +                                     u64 period,
>>> +                                     u64 weight)
>>>  {
>>>         struct rb_node **p;
>>>         struct rb_node *parent = NULL;
>>> @@ -288,7 +293,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
>>>                 cmp = hist_entry__cmp(entry, he);
>>>
>>>                 if (!cmp) {
>>> -                       he_stat__add_period(&he->stat, period);
>>> +                       he_stat__add_period(&he->stat, period, weight);
>>>
>> With this approach, you will not aggregate samples with similar
>> weights for more than 2 samples.
>> Example:
>> Sample 1 W=250 -> no match, add Sample 1
>> Sample 2 W=250 -> match Sample1, Sample1 new weight=500
>> Sample 3 W=250 -> no match, add Sample 3
>>
>> Here you do not aggregate Sample 3 with Sample 1 and 2 , because you've updated
>> the weight which you also use in the sort__weight_cmp() routine.
>>
>> That does not work for me with PEBS-LL. I want aggregation when
>> samples are identical.
>>
>> I don't know why you want to aggregate weights.
>
> Ok, figured this out. I needed to use local_weight and not weight for
> the PEBS-LL case.
> Works fine now. So I can use your patch unaltered.

For PEBS-LL and possibly other special cases, it is important to remember
that perf report always end up sorting by period (hist_collapse_resort). But
for PEBS-LL we want to sort on nr_events * weight. Thus, with your patch,
the only way, I found, to achieve this is by passing:

       add_hist_entry(self, &entry, al, weight, weight);

Or period=weight, then pass period.
That way you ensure that if you have:

20 samples at cost 50
100 samples at cost 1

Then you see with perf report:

Samples Local Weight
        20  50
      100    1

I did update my patch to operate that way and I get the correct answer now.
