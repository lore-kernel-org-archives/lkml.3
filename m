Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaG3O0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:26:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaG3O0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:26:21 -0400
Message-ID: <53D9003F.3050900@redhat.com>
Date: Wed, 30 Jul 2014 10:25:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1% proc-vmstat.numa_hint_faults_local
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com> <53D72FF5.90908@intel.com> <20140729023940.37b6aebc@annuminas.surriel.com> <20140729081712.GS20603@laptop.programming.kicks-ass.net> <20140729160437.4561742f@annuminas.surriel.com> <20140730021425.GA25023@aaronlu.sh.intel.com>
In-Reply-To: <20140730021425.GA25023@aaronlu.sh.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 10:14 PM, Aaron Lu wrote:
> On Tue, Jul 29, 2014 at 04:04:37PM -0400, Rik van Riel wrote:
>> On Tue, 29 Jul 2014 10:17:12 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>>> +#define NUMA_SCALE 1000
>>>> +#define NUMA_MOVE_THRESH 50
>>>
>>> Please make that 1024, there's no reason not to use power of two here.
>>> This base 10 factor thing annoyed me no end already, its time for it to
>>> die.
>>
>> That's easy enough.  However, it would be good to know whether
>> this actually helps with the regression Aaron found :)
> 
> Sorry for the delay.
> 
> I applied the last patch and queued the hackbench job to the ivb42 test
> machine for it to run 5 times, and here is the result(regarding the
> proc-vmstat.numa_hint_faults_local field):
> 173565
> 201262
> 192317
> 198342
> 198595
> avg:
> 192816
> 
> It seems it is still very big than previous kernels.

It looks like a step in the right direction, though.

Could you try running with a larger threshold?

>> +++ b/kernel/sched/fair.c
>> @@ -924,10 +924,12 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
>>  
>>  /*
>>   * These return the fraction of accesses done by a particular task, or
>> - * task group, on a particular numa node.  The group weight is given a
>> - * larger multiplier, in order to group tasks together that are almost
>> - * evenly spread out between numa nodes.
>> + * task group, on a particular numa node.  The NUMA move threshold
>> + * prevents task moves with marginal improvement, and is set to 5%.
>>   */
>> +#define NUMA_SCALE 1024
>> +#define NUMA_MOVE_THRESH (5 * NUMA_SCALE / 100)

It would be good to see if changing NUMA_MOVE_THRESH to
(NUMA_SCALE / 8) does the trick.

I will run the same thing here with SPECjbb2005.

