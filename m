Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3K0LiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:38:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54956 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3K0LiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:38:14 -0500
X-IronPort-AV: E=Sophos;i="4.93,781,1378828800"; 
   d="scan'208";a="9138233"
Message-ID: <5296900F.8010209@cn.fujitsu.com>
Date: Wed, 27 Nov 2013 19:36:31 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: linux-kernel@vger.kernel.org, dsahern@gmail.com, jolsa@redhat.com,
        namhyung@kernel.org, acme@ghostprotocols.net, mingo@redhat.com
Subject: Re: [PATCH] perf util: Join four conditions in two in perf_evlist__create_maps().
References: <1385590984-30244-1-git-send-email-yangds.fnst@cn.fujitsu.com> <5295BEDA.5070002@intel.com> <529677A2.6040304@cn.fujitsu.com> <5295CE48.4090501@intel.com>
In-Reply-To: <5295CE48.4090501@intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/27 19:38:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/27 19:38:15,
	Serialize complete at 2013/11/27 19:38:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 05:49 AM, Adrian Hunter wrote:
> On 28/11/13 00:52, Dongsheng Yang wrote:
>> On 11/27/2013 04:43 AM, Adrian Hunter wrote:
>>> On 28/11/13 00:23, Dongsheng Yang wrote:
>>>> There are four condition branchs in perf_evlist__create_maps, but they
>>>> only do two kinds of thing. 1st and 4th call cpu_map__new(), and the others
>>>> call cpu_map__dummy_new(). This patch joins them in two branchs, decreasing
>>>> the number of branch and removing some duplicated code.
>>> That code has changed again.  See:
>>>
>>>      http://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/core
>>>
>>>
>> Hi Adrian!
>>      Thanx for your reminding. Yes, a more checking is added into the 1st
>> branch.
>> And I think we still can join them in two conditions.
>>
>> Do you think this idea is ok to you? If so, I will update my patch base on
>> the latest code.
> Personally I like code that is easy to read, and I don't think
> combining the conditions does that.  But you could set a bool
> and use that to decide what to call.
>

How about add a function in target.c named 
perf_target__uses_dummy_map(), and this
function take over the all checking to decide which to call. Then we can 
use it here like:

if (perf_target__uses_dummy_map(target)):
     evlist->cpus = cpu_map__dummy_new();
else:
     evlist->cpus = cpu_map__new(target->cpu_list);
>> Yang
>>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>>> ---
>>>>    tools/perf/util/evlist.c | 8 +++-----
>>>>    1 file changed, 3 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>>>> index bbc746a..2258eb4 100644
>>>> --- a/tools/perf/util/evlist.c
>>>> +++ b/tools/perf/util/evlist.c
>>>> @@ -819,11 +819,9 @@ int perf_evlist__create_maps(struct perf_evlist
>>>> *evlist, struct target *target)
>>>>        if (evlist->threads == NULL)
>>>>            return -1;
>>>>    -    if (target->force_per_cpu)
>>>> -        evlist->cpus = cpu_map__new(target->cpu_list);
>>>> -    else if (target__has_task(target))
>>>> -        evlist->cpus = cpu_map__dummy_new();
>>>> -    else if (!target__has_cpu(target) && !target->uses_mmap)
>>>> +    if (!target->force_per_cpu &&
>>>> +        (target__has_task(target) ||
>>>> +         (!target__has_cpu(target) && !target->uses_mmap)))
>>>>            evlist->cpus = cpu_map__dummy_new();
>>>>        else
>>>>            evlist->cpus = cpu_map__new(target->cpu_list);
>>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

