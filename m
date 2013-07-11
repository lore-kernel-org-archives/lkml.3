Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3GKNUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:20:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:63427 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab3GKNUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:20:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="363701703"
Message-ID: <51DEB290.20109@intel.com>
Date: Thu, 11 Jul 2013 16:26:40 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V4 20/21] perf: make events stream always parsable
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com> <1372944040-32690-21-git-send-email-adrian.hunter@intel.com> <CAM9d7cgXKMUcSdFFs2fbe=eeb6pJMe5pTrRjkmt4eVvr6fWqcg@mail.gmail.com>
In-Reply-To: <CAM9d7cgXKMUcSdFFs2fbe=eeb6pJMe5pTrRjkmt4eVvr6fWqcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/13 16:24, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Thu, Jul 4, 2013 at 10:20 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>> The event stream is not always parsable because the format of a sample
>> is dependent on the sample_type of the selected event.  When there
>> is more than one selected event and the sample_types are not the
>> same then parsing becomes problematic.  A sample can be matched to its
>> selected event using the ID that is allocated when the event is opened.
>> Unfortunately, to get the ID from the sample means first parsing it.
>>
>> This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
>> the ID at a fixed position so that the ID can be retrieved without
>> parsing the sample.  For sample events, that is the first position
>> immediately after the header.  For non-sample events, that is the last
>> position.
> 
> Why do we have to keep another ID again?

It is a different place for the ID not another ID.

> If all we need is the sample_type, why not just saving it directly?

We really want to associate the event with the attribute so the ID is
needed, not just the sample type.

> 
> And for the implementation, I guess it'll break old perf tools
> by parsing invalid position of data. IOW if it's recorded on a newer
> kernel/tool and then reported on an older perf tool (maybe on a
> different machine).  In this case the old tool cannot recognize the
> PERF_SAMPLE_IDENTIFIER and try to parse it as a different
> type of data, right?

I have changed the code so that PERF_SAMPLE_IDENTIFIER is only used for
non-matching sample types.  Since in those cases the data was anyway not
parsable, the scenario you outline cannot happen.

> 
> So I suggest put the data at the end of sample data like other new
> sample types added.  Older tools would simply ignore that part, and
> newer tools can access it directly by checking event.header.size
> and/or evsel->sample_size.

The ID will be on the end of non-sample (e.g. mmap, comm, task) events, so
if tools are parsing those events backwards (as perf tools does) then they
will anyway fail if they are not expecting PERF_SAMPLE_IDENTIFIER.  However
that scenario only happens when the data is anyway not parsable as I
mentioned above.

> 
> Thanks,
> Namhyung
> 
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  include/uapi/linux/perf_event.h |  3 ++-
>>  kernel/events/core.c            | 11 ++++++++++-
>>  2 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index 0b1df41..6bb217e 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -134,8 +134,9 @@ enum perf_event_sample_format {
>>         PERF_SAMPLE_STACK_USER                  = 1U << 13,
>>         PERF_SAMPLE_WEIGHT                      = 1U << 14,
>>         PERF_SAMPLE_DATA_SRC                    = 1U << 15,
>> +       PERF_SAMPLE_IDENTIFIER                  = 1U << 16,
>>
>> -       PERF_SAMPLE_MAX = 1U << 16,             /* non-ABI */
>> +       PERF_SAMPLE_MAX = 1U << 17,             /* non-ABI */
>>  };
>>
>>  /*
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 1db3af9..ca532f2 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -1203,6 +1203,9 @@ static void perf_event__id_header_size(struct perf_event *event)
>>         if (sample_type & PERF_SAMPLE_TIME)
>>                 size += sizeof(data->time);
>>
>> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
>> +               size += sizeof(data->id);
>> +
>>         if (sample_type & PERF_SAMPLE_ID)
>>                 size += sizeof(data->id);
>>
>> @@ -4229,7 +4232,7 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
>>         if (sample_type & PERF_SAMPLE_TIME)
>>                 data->time = perf_clock();
>>
>> -       if (sample_type & PERF_SAMPLE_ID)
>> +       if (sample_type & (PERF_SAMPLE_ID | PERF_SAMPLE_IDENTIFIER))
>>                 data->id = primary_event_id(event);
>>
>>         if (sample_type & PERF_SAMPLE_STREAM_ID)
>> @@ -4268,6 +4271,9 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
>>
>>         if (sample_type & PERF_SAMPLE_CPU)
>>                 perf_output_put(handle, data->cpu_entry);
>> +
>> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
>> +               perf_output_put(handle, data->id);
>>  }
>>
>>  void perf_event__output_id_sample(struct perf_event *event,
>> @@ -4380,6 +4386,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>>
>>         perf_output_put(handle, *header);
>>
>> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
>> +               perf_output_put(handle, data->id);
>> +
>>         if (sample_type & PERF_SAMPLE_IP)
>>                 perf_output_put(handle, data->ip);
>>
>> --
>> 1.7.11.7
>>
> 
> 

