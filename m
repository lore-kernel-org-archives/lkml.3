Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaEDMlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 08:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaEDMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 08:41:46 -0400
Message-ID: <53663565.9080306@redhat.com>
Date: Sun, 04 May 2014 08:41:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>, umgwanakikbuti@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        george.mccollister@gmail.com, ktkhai@parallels.com,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com>	<1399011219.5233.55.camel@marge.simpson.net>	<53633B81.1080403@redhat.com> <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
In-Reply-To: <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 07:44 AM, Preeti Murthy wrote:
> Hi Rik, Mike
> 
> On Fri, May 2, 2014 at 12:00 PM, Rik van Riel <riel@redhat.com> wrote:
>> On 05/02/2014 02:13 AM, Mike Galbraith wrote:
>>> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote:
>>>
>>>> Whether or not this is the right thing to do remains to be seen,
>>>> but it does allow us to verify whether or not the wake_affine
>>>> strategy of always doing affine wakeups and only disabling them
>>>> in a specific circumstance is sound, or needs rethinking...
>>>
>>> Yes, it needs rethinking.
>>>
>>> I know why you want to try this, yes, select_idle_sibling() is very much
>>> a two faced little bitch.
>>
>> My biggest problem with select_idle_sibling and wake_affine in
>> general is that it will override NUMA placement, even when
>> processes only wake each other up infrequently...
> 
> As far as my understanding goes, the logic in select_task_rq_fair()
> does wake_affine() or calls select_idle_sibling() only at those
> levels of sched domains where the flag SD_WAKE_AFFINE is set.
> This flag is not set at the numa domain and hence they will not be
> balancing across numa nodes. So I don't understand how
> *these functions* are affecting NUMA placements.

Even on 8-node DL980 systems, the NUMA distance in the
SLIT table is less than RECLAIM_DISTANCE, and we will
do wake_affine across the entire system.

> The wake_affine() and select_idle_sibling() will shuttle tasks
> within a NUMA node as far as I can see.i.e. if the cpu that the task
> previously ran on and the waker cpu belong to the same node.
> Else they are not called.

That is what I first hoped, too. I was wrong.

> If the prev_cpu and the waker cpu are on different NUMA nodes
> then naturally the tasks will get shuttled across NUMA nodes but
> the culprits are the find_idlest* functions.
>    They do a top-down search for the idlest group and cpu, starting
> at the NUMA domain *attached to the waker and not the prev_cpu*.
> This means that the task will end up on a different NUMA node.
> Looks to me that the problem lies here and not in the wake_affine()
> and select_idle_siblings().

I have a patch for find_idlest_group that takes the NUMA
distance between each group and the task's preferred node
into account.

However, as long as the wake_affine stuff still gets to
override it, that does not make much difference :)

-- 
All rights reversed
