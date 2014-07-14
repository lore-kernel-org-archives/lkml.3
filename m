Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbaGNRzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:55:00 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35625 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaGNRyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140711082512.GC31646@krava.redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
	<1404857759-25105-4-git-send-email-eranian@google.com>
	<20140711082512.GC31646@krava.redhat.com>
Date: Mon, 14 Jul 2014 19:54:53 +0200
Message-ID: <CABPqkBSVF3S=Yy6_Lq2DtvXkLLgckuRXYeo1Xaqs1fmU3G3kkA@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: add core support for sampling intr
 machine state regs
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:25 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jul 09, 2014 at 12:15:58AM +0200, Stephane Eranian wrote:
>> Add the infrastructure to setup, collect and report the interrupt
>> machine state regs which can be captured by the kernel.
>>
>
> SNIP
>
>> index 8606175..00e45d1 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -626,6 +626,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>>       if (opts->call_graph_enabled)
>>               perf_evsel__config_callgraph(evsel, opts);
>>
>> +     if (opts->sample_intr_regs) {
>> +             attr->sample_regs_intr = PERF_REGS_MASK;
>> +             perf_evsel__set_sample_bit(evsel, REGS_INTR);
>> +     }
>> +
>>       if (target__has_cpu(&opts->target))
>>               perf_evsel__set_sample_bit(evsel, CPU);
>>
>> @@ -979,6 +984,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
>>       ret += PRINT_ATTR_X64(branch_sample_type);
>>       ret += PRINT_ATTR_X64(sample_regs_user);
>>       ret += PRINT_ATTR_U32(sample_stack_user);
>> +     ret += PRINT_ATTR_X64(sample_regs_intr);
>>
>>       ret += fprintf(fp, "%.60s\n", graph_dotted_line);
>>
>> @@ -1468,6 +1474,23 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>>               array++;
>>       }
>>
>> +     data->intr_regs.abi = PERF_SAMPLE_REGS_ABI_NONE;
>
> not necessary, data is zeroed in the top
>
Don't like that too much. You are using an enum. So why not explicitly
initialize instead of relying on ABI_NONE = 0.
