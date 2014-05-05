Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaEEEyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:54:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41233 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaEEEyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:54:45 -0400
Message-ID: <5367188C.1060702@linux.vnet.ibm.com>
Date: Mon, 05 May 2014 10:20:20 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, umgwanakikbuti@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net>	<53633B81.1080403@redhat.com> <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com> <53663565.9080306@redhat.com>
In-Reply-To: <53663565.9080306@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050504-1344-0000-0000-000001572F81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 06:11 PM, Rik van Riel wrote:
> On 05/04/2014 07:44 AM, Preeti Murthy wrote:
>> Hi Rik, Mike
>>
>> On Fri, May 2, 2014 at 12:00 PM, Rik van Riel <riel@redhat.com> wrote:
>>> On 05/02/2014 02:13 AM, Mike Galbraith wrote:
>>>> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote:
>>>>
>>>>> Whether or not this is the right thing to do remains to be seen,
>>>>> but it does allow us to verify whether or not the wake_affine
>>>>> strategy of always doing affine wakeups and only disabling them
>>>>> in a specific circumstance is sound, or needs rethinking...
>>>>
>>>> Yes, it needs rethinking.
>>>>
>>>> I know why you want to try this, yes, select_idle_sibling() is very much
>>>> a two faced little bitch.
>>>
>>> My biggest problem with select_idle_sibling and wake_affine in
>>> general is that it will override NUMA placement, even when
>>> processes only wake each other up infrequently...
>>
>> As far as my understanding goes, the logic in select_task_rq_fair()
>> does wake_affine() or calls select_idle_sibling() only at those
>> levels of sched domains where the flag SD_WAKE_AFFINE is set.
>> This flag is not set at the numa domain and hence they will not be
>> balancing across numa nodes. So I don't understand how
>> *these functions* are affecting NUMA placements.
> 
> Even on 8-node DL980 systems, the NUMA distance in the
> SLIT table is less than RECLAIM_DISTANCE, and we will
> do wake_affine across the entire system.
> 
>> The wake_affine() and select_idle_sibling() will shuttle tasks
>> within a NUMA node as far as I can see.i.e. if the cpu that the task
>> previously ran on and the waker cpu belong to the same node.
>> Else they are not called.
> 
> That is what I first hoped, too. I was wrong.
> 
>> If the prev_cpu and the waker cpu are on different NUMA nodes
>> then naturally the tasks will get shuttled across NUMA nodes but
>> the culprits are the find_idlest* functions.
>>    They do a top-down search for the idlest group and cpu, starting
>> at the NUMA domain *attached to the waker and not the prev_cpu*.
>> This means that the task will end up on a different NUMA node.
>> Looks to me that the problem lies here and not in the wake_affine()
>> and select_idle_siblings().
> 
> I have a patch for find_idlest_group that takes the NUMA
> distance between each group and the task's preferred node
> into account.
> 
> However, as long as the wake_affine stuff still gets to
> override it, that does not make much difference :)
> 

Yeah now I see it. But I still feel wake_affine() and
select_idle_sibling() are not at fault primarily because when they were
introduced, I don't think it was foreseen that the cpu topology would
grow to the extent it is now.

select_idle_sibling() for instance scans the cpus within the purview of
the last level cache of a cpu and this was a small set. Hence there was
no overhead. Now with many cpus sharing the L3 cache, we see an
overhead. wake_affine() probably did not expect the NUMA nodes to come
under its governance as well and hence it sees no harm in waking up
tasks close to the waker because it still believes that it will be
within a node.

What has changed is the code around these two functions I feel. Take
this problem for instance. We ourselves are saying in sd_local_flags()
that this specific domain is fit for wake affine balance. So naturally
the logic in wake_affine and select_idle_sibling() will follow.
  My point is the peripheral code is seeing the negative affect of these
two functions because they pushed themselves under its ambit.

Don't you think we should go conservative on the value of
RECLAIM_DISTANCE in arch specific code at-least? On powerpc we set it to
10. Besides, the git log does not tell us the basis on which this value
was set to a default of 30. Maybe this needs re-thought?

Regards
Preeti U Murthy

