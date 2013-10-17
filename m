Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab3JQQ25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:28:57 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:26161 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3JQQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:28:56 -0400
Message-ID: <5260103B.9070106@hp.com>
Date: Thu, 17 Oct 2013 12:28:43 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/2] perf-report: add --max-stack option to limit callchain
 stack scan
References: <1381953595-36427-1-git-send-email-Waiman.Long@hp.com> <525F52F0.2030006@gmail.com>
In-Reply-To: <525F52F0.2030006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 11:01 PM, David Ahern wrote:
> On 10/16/13 1:59 PM, Waiman Long wrote:
>> This patch adds a new --max-stack option to perf-report to limit the
>> depth of callchain stack data to look at to reduce the time it takes
>> for perf-report to finish its processing. It trades the presence of
>> trailing stack information with faster speed.
>
> I like the patch. I have a similar option in my perf-sched-timehist 
> command, and I have a patch somewhere for perf-script.
>
> It would be even better to pass this arg kernel side and limit the 
> stack depth at data collection time.
>

That will require option a similar option on the record side. However, 
the overhead of collecting more stack ip address isn't as high as that 
in the report side.

> ---8<---
>
>> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>> index 72eae74..d90d04a 100644
>> --- a/tools/perf/builtin-report.c
>> +++ b/tools/perf/builtin-report.c
>> @@ -37,6 +37,12 @@
>>
>>   #include <linux/bitmap.h>
>>
>> +/*
>> + * 2-level stringification macro to enable stringification of macro 
>> value
>> + * */
>> +#define    __to_string(x)    #x
>> +#define    STRINGIFY(x)    __to_string(x)
>
> These 2 lines should be somewhere else -- like util/util.h

I will move that to a common header file.

>
> ---8<---
>
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 2122141..2725aca 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -771,7 +771,8 @@ static void perf_event__process_sample(struct 
>> perf_tool *tool,
>>               sample->callchain) {
>>               err = machine__resolve_callchain(machine, evsel,
>>                                al.thread, sample,
>> - &parent, &al);
>> + &parent, &al,
>> +                             PERF_MAX_STACK_DEPTH);
>>               if (err)
>>                   return;
>>           }
>
> Why not add the option to perf-top as well? copy-paste.

I had thought about it, but I decided to wait for feedback before doing 
it. I will make that change in the next version.

-Longman

