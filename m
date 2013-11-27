Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3K0KmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:42:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:25030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3K0KmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:42:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,781,1378882800"; 
   d="scan'208";a="442953380"
Message-ID: <5295CE48.4090501@intel.com>
Date: Wed, 27 Nov 2013 12:49:44 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, dsahern@gmail.com, jolsa@redhat.com,
        namhyung@kernel.org, acme@ghostprotocols.net, mingo@redhat.com
Subject: Re: [PATCH] perf util: Join four conditions in two in perf_evlist__create_maps().
References: <1385590984-30244-1-git-send-email-yangds.fnst@cn.fujitsu.com> <5295BEDA.5070002@intel.com> <529677A2.6040304@cn.fujitsu.com>
In-Reply-To: <529677A2.6040304@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/13 00:52, Dongsheng Yang wrote:
> On 11/27/2013 04:43 AM, Adrian Hunter wrote:
>> On 28/11/13 00:23, Dongsheng Yang wrote:
>>> There are four condition branchs in perf_evlist__create_maps, but they
>>> only do two kinds of thing. 1st and 4th call cpu_map__new(), and the others
>>> call cpu_map__dummy_new(). This patch joins them in two branchs, decreasing
>>> the number of branch and removing some duplicated code.
>> That code has changed again.  See:
>>
>>     http://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/core
>>
>>
> 
> Hi Adrian!
>     Thanx for your reminding. Yes, a more checking is added into the 1st
> branch.
> And I think we still can join them in two conditions.
> 
> Do you think this idea is ok to you? If so, I will update my patch base on
> the latest code.

Personally I like code that is easy to read, and I don't think
combining the conditions does that.  But you could set a bool
and use that to decide what to call.

> 
> Yang
>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>> ---
>>>   tools/perf/util/evlist.c | 8 +++-----
>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>>> index bbc746a..2258eb4 100644
>>> --- a/tools/perf/util/evlist.c
>>> +++ b/tools/perf/util/evlist.c
>>> @@ -819,11 +819,9 @@ int perf_evlist__create_maps(struct perf_evlist
>>> *evlist, struct target *target)
>>>       if (evlist->threads == NULL)
>>>           return -1;
>>>   -    if (target->force_per_cpu)
>>> -        evlist->cpus = cpu_map__new(target->cpu_list);
>>> -    else if (target__has_task(target))
>>> -        evlist->cpus = cpu_map__dummy_new();
>>> -    else if (!target__has_cpu(target) && !target->uses_mmap)
>>> +    if (!target->force_per_cpu &&
>>> +        (target__has_task(target) ||
>>> +         (!target__has_cpu(target) && !target->uses_mmap)))
>>>           evlist->cpus = cpu_map__dummy_new();
>>>       else
>>>           evlist->cpus = cpu_map__new(target->cpu_list);
>>>
>>
> 
> 
> 

