Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaHMQlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:41:11 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:2858 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHMQlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:41:09 -0400
Message-ID: <53EB9522.2070804@hp.com>
Date: Wed, 13 Aug 2014 12:41:06 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com> <1407119782-41119-3-git-send-email-Waiman.Long@hp.com> <1407125450.4710.38.camel@j-VirtualBox> <53DFAA53.4010003@hp.com> <20140813055153.GD20518@dastard>
In-Reply-To: <20140813055153.GD20518@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 01:51 AM, Dave Chinner wrote:
> On Mon, Aug 04, 2014 at 11:44:19AM -0400, Waiman Long wrote:
>> On 08/04/2014 12:10 AM, Jason Low wrote:
>>> On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
>>>> The rwsem_can_spin_on_owner() function currently allows optimistic
>>>> spinning only if the owner field is defined and is running. That is
>>>> too conservative as it will cause some tasks to miss the opportunity
>>>> of doing spinning in case the owner hasn't been able to set the owner
>>>> field in time or the lock has just become available.
>>>>
>>>> This patch enables more aggressive use of optimistic spinning by
>>>> assuming that the lock is spinnable unless proved otherwise.
>>>>
>>>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>>>> ---
>>>>   kernel/locking/rwsem-xadd.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
>>>> index d058946..dce22b8 100644
>>>> --- a/kernel/locking/rwsem-xadd.c
>>>> +++ b/kernel/locking/rwsem-xadd.c
>>>> @@ -285,7 +285,7 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
>>>>   static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>>>>   {
>>>>   	struct task_struct *owner;
>>>> -	bool on_cpu = false;
>>>> +	bool on_cpu = true;	/* Assume spinnable unless proved not to be */
>>> Hi,
>>>
>>> So "on_cpu = true" was recently converted to "on_cpu = false" in order
>>> to address issues such as a 5x performance regression in the xfs_repair
>>> workload that was caused by the original rwsem optimistic spinning code.
>>>
>>> However, patch 4 in this patchset does address some of the problems with
>>> spinning when there are readers. CC'ing Dave Chinner, who did the
>>> testing with the xfs_repair workload.
>>>
>> This patch set enables proper reader spinning and so the problem
>> that we see with xfs_repair workload should go away. I should have
>> this patch after patch 4 to make it less confusing. BTW, patch 3 can
>> significantly reduce spinlock contention in rwsem. So I believe the
>> xfs_repair workload should run faster with this patch than both 3.15
>> and 3.16.
> I see lots of handwaving. I documented the test I ran when I
> reported the problem so anyone with a 16p system and an SSD can
> reproduce it. I don't have the bandwidth to keep track of the lunacy
> of making locks scale these days - that's what you guys are doing.
>
> I gave you a simple, reliable workload that is extremely sensitive
> to rwsem perturbations, so you should be adding it to your
> regression tests rather than leaving it for others to notice you
> screwed up....
>
> Cheers,
>
> Dave.

If you can send me a rwsem workload that I can use for testing purpose, 
it will be highly appreciated.

-Longman
