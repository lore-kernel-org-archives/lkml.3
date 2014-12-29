Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaL2NAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:00:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:61115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaL2NAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:00:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="644079625"
Message-ID: <54A14FE4.9070601@intel.com>
Date: Mon, 29 Dec 2014 14:58:12 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/37] perf record: Use a software dummy event to track
 task/mmap events
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-3-git-send-email-namhyung@kernel.org> <549D8C59.1000700@gmail.com> <CAM9d7chzE5ffPO=AwmjBEpbHb38xLJt4nhg-=Cjgj7tz+jCLZA@mail.gmail.com>
In-Reply-To: <CAM9d7chzE5ffPO=AwmjBEpbHb38xLJt4nhg-=Cjgj7tz+jCLZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/12/14 07:28, Namhyung Kim wrote:
> Hi David,
> 
> On Sat, Dec 27, 2014 at 1:27 AM, David Ahern <dsahern@gmail.com> wrote:
>> On 12/24/14 12:14 AM, Namhyung Kim wrote:
>>>
>>> Prepend a software dummy event into evlist to track task/comm/mmap
>>> events separately.  This is a preparation of multi-file/thread support
>>> which will come later.
>>
>>
>> Are you are making this the first event because of how perf internals are
>> coded -- that the first event tracks tasks events? With the tracking bit in
>> evsel you should not need to do that. Is there another reason?
> 
> Yeah, I know the tracking bit can be set to any evsel in the evlist.
> But I'd like to keep it at a fixed index so that it can be easily
> identified at later stages (like perf report) too.  Ideally, it'd be
> great if we have a way to distinguish this auto-added dummy tracking
> event from other (user-added) (dummy?) tracking events if any.
> 
>>
>> ---8<---
>>
>>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>>> index cfbe2b99b9aa..72dff295237e 100644
>>> --- a/tools/perf/util/evlist.c
>>> +++ b/tools/perf/util/evlist.c
>>> @@ -193,6 +193,44 @@ int perf_evlist__add_default(struct perf_evlist
>>> *evlist)
>>>         return -ENOMEM;
>>>   }
>>>
>>> +int perf_evlist__prepend_dummy(struct perf_evlist *evlist)
>>> +{
>>> +       struct perf_event_attr attr = {
>>> +               .type = PERF_TYPE_SOFTWARE,
>>> +               .config = PERF_COUNT_SW_DUMMY,

Probably need .exclude_kernel = 1, here

>>> +       };
>>> +       struct perf_evsel *evsel, *pos;
>>> +
>>> +       event_attr_init(&attr);
>>> +
>>> +       evsel = perf_evsel__new(&attr);
>>> +       if (evsel == NULL)
>>> +               goto error;
>>> +
>>> +       /* use strdup() because free(evsel) assumes name is allocated */
>>> +       evsel->name = strdup("dummy");
>>> +       if (!evsel->name)
>>> +               goto error_free;
>>> +
>>> +       list_for_each_entry(pos, &evlist->entries, node) {
>>> +               pos->idx += 1;
>>> +               pos->tracking = false;
>>> +       }
>>> +
>>> +       list_add(&evsel->node, &evlist->entries);
>>> +       evsel->idx = 0;
>>> +       evsel->tracking = true;
>>
>>
>> perf_evlist__set_tracking_event()?
> 
> I found that after I wrote this, so yes, it can use the function
> instead of the oped-code.  But the loop traversal is needed anyway to
> fixup the evsel->idx.

perf_evlist__set_tracking_event() also ensures there is only one tracking
event so it is easy to identify. It is the only event with attr->mmap etc
set to 1. Then you can use perf_evlist__add().

