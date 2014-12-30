Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaL3JGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:06:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:13180 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbaL3JGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:06:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,664,1413270000"; 
   d="scan'208";a="630700765"
Message-ID: <54A26A96.4080505@intel.com>
Date: Tue, 30 Dec 2014 11:04:22 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/37] perf record: Use a software dummy event to track
 task/mmap events
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-3-git-send-email-namhyung@kernel.org> <549D8C59.1000700@gmail.com> <CAM9d7chzE5ffPO=AwmjBEpbHb38xLJt4nhg-=Cjgj7tz+jCLZA@mail.gmail.com> <54A14FE4.9070601@intel.com> <20141230055111.GE6081@sejong>
In-Reply-To: <20141230055111.GE6081@sejong>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/12/14 07:51, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Mon, Dec 29, 2014 at 02:58:12PM +0200, Adrian Hunter wrote:
>> On 27/12/14 07:28, Namhyung Kim wrote:
>>> Hi David,
>>>
>>> On Sat, Dec 27, 2014 at 1:27 AM, David Ahern <dsahern@gmail.com> wrote:
>>>> On 12/24/14 12:14 AM, Namhyung Kim wrote:
>>>>>
>>>>> Prepend a software dummy event into evlist to track task/comm/mmap
>>>>> events separately.  This is a preparation of multi-file/thread support
>>>>> which will come later.
>>>>
>>>>
>>>> Are you are making this the first event because of how perf internals are
>>>> coded -- that the first event tracks tasks events? With the tracking bit in
>>>> evsel you should not need to do that. Is there another reason?
>>>
>>> Yeah, I know the tracking bit can be set to any evsel in the evlist.
>>> But I'd like to keep it at a fixed index so that it can be easily
>>> identified at later stages (like perf report) too.  Ideally, it'd be
>>> great if we have a way to distinguish this auto-added dummy tracking
>>> event from other (user-added) (dummy?) tracking events if any.
>>>
>>>>
>>>> ---8<---
>>>>
>>>>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>>>>> index cfbe2b99b9aa..72dff295237e 100644
>>>>> --- a/tools/perf/util/evlist.c
>>>>> +++ b/tools/perf/util/evlist.c
>>>>> @@ -193,6 +193,44 @@ int perf_evlist__add_default(struct perf_evlist
>>>>> *evlist)
>>>>>         return -ENOMEM;
>>>>>   }
>>>>>
>>>>> +int perf_evlist__prepend_dummy(struct perf_evlist *evlist)
>>>>> +{
>>>>> +       struct perf_event_attr attr = {
>>>>> +               .type = PERF_TYPE_SOFTWARE,
>>>>> +               .config = PERF_COUNT_SW_DUMMY,
>>
>> Probably need .exclude_kernel = 1, here
> 
> Ah, right.
> 
>>
>>>>> +       };
>>>>> +       struct perf_evsel *evsel, *pos;
>>>>> +
>>>>> +       event_attr_init(&attr);
>>>>> +
>>>>> +       evsel = perf_evsel__new(&attr);
>>>>> +       if (evsel == NULL)
>>>>> +               goto error;
>>>>> +
>>>>> +       /* use strdup() because free(evsel) assumes name is allocated */
>>>>> +       evsel->name = strdup("dummy");
>>>>> +       if (!evsel->name)
>>>>> +               goto error_free;
>>>>> +
>>>>> +       list_for_each_entry(pos, &evlist->entries, node) {
>>>>> +               pos->idx += 1;
>>>>> +               pos->tracking = false;
>>>>> +       }
>>>>> +
>>>>> +       list_add(&evsel->node, &evlist->entries);
>>>>> +       evsel->idx = 0;
>>>>> +       evsel->tracking = true;
>>>>
>>>>
>>>> perf_evlist__set_tracking_event()?
>>>
>>> I found that after I wrote this, so yes, it can use the function
>>> instead of the oped-code.  But the loop traversal is needed anyway to
>>> fixup the evsel->idx.
>>
>> perf_evlist__set_tracking_event() also ensures there is only one tracking
>> event so it is easy to identify. It is the only event with attr->mmap etc
>> set to 1. Then you can use perf_evlist__add().
> 
> Well, yes, I think we can put the dummy tracking event anywhere in the
> evlist with this, but I still slightly prefer put it at a fixed
> location for a possible code simplification..

Probably you should not be checking for the "tracking event" at all on the
processing side and instead just have perf report ignore all dummy events.
That generalizes things even more.

What is the code simplification?

