Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3GBCwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:52:11 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60833 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3GBCwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31R+4ysf6xZ84G=JMhx=X9pcFuRPfUX5Q0-4CTKdVPeVA1w@mail.gmail.com>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
	<1372682002-15373-1-git-send-email-leiwen@marvell.com>
	<1372682002-15373-3-git-send-email-leiwen@marvell.com>
	<CAPM31R+4ysf6xZ84G=JMhx=X9pcFuRPfUX5Q0-4CTKdVPeVA1w@mail.gmail.com>
Date: Tue, 2 Jul 2013 10:52:07 +0800
Message-ID: <CALZhoSRECT+NtFV1WWTOKn-td=VDWCzNyLr9sXuxxU_Oo3RuuA@mail.gmail.com>
Subject: Re: [V2 2/2] sched: update cfs_rq weight earlier in enqueue_entity
From: Lei Wen <adrian.wenl@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Lei Wen <leiwen@marvell.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Mon, Jul 1, 2013 at 10:07 PM, Paul Turner <pjt@google.com> wrote:
> Could you please restate the below?
>
> On Mon, Jul 1, 2013 at 5:33 AM, Lei Wen <leiwen@marvell.com> wrote:
>> Since we are going to calculate cfs_rq's average ratio by
>> runnable_load_avg/load.weight
>
> I don't understand what you mean by this.

Previously I take runnable_load_avg/load.weight calculation as the cfs_rq's
average ratio. But as Alex point out, the runnable_avg_sum/runnable_avg_period
may better sever this need.

>
>>, if not increase the load.weight prior to
>> enqueue_entity_load_avg, it may lead to one cfs_rq's avg ratio higher
>> than 100%.
>>
>
> Or this.

In my mind, runnable_load_avg in one cfs_rq should always be less than
load.weight.
Not sure whether this assumption stand here, but runnable_load_avg/load.weight
truly could shows out the cfs_rq execution trend in some aspect.

The previous problem that enqueue_entity_load_avg called before
account_entity_enqueue,
which make runnable_load_avg be updated first, then the load.weight.
So that with the trace info log inside of enqueue_entity_load_avg, we
may get the calculation
result for runnable_load_avg/load.weight > 1.
This result is not friendly for the final data being parsed out.


>
>> Adjust the sequence, so that all ratio is kept below 100%.
>>
>> Signed-off-by: Lei Wen <leiwen@marvell.com>
>> ---
>>  kernel/sched/fair.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 07bd74c..d1eee84 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1788,8 +1788,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>>          * Update run-time statistics of the 'current'.
>>          */
>>         update_curr(cfs_rq);
>> -       enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
>>         account_entity_enqueue(cfs_rq, se);
>> +       enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
>
> account_entity_enqueue is independent of enqueue_entity_load_avg;
> their order should not matter.

Yes, agree, the order should not be matter, but for make trace info
integrated, we may
need some order here.

>
> Further, should we restore the reverted amortization commit (improves
> context switch times)


Not understand here...
What the "should we restore the reverted amortization commit (improves
context switch times)" means here...?


enqueue_entity_load_avg needs to precede
> account_entity_enqueue as it may update se->load.weight.

account_entity_enqueue needs to precede enqueue_entity_load_avg?

Thanks,
Lei


>
>>         update_cfs_shares(cfs_rq);
>>
>>         if (flags & ENQUEUE_WAKEUP) {
>> --
>> 1.7.10.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
