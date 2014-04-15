Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaDOXBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:01:30 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57095 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDOXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140415144324.GJ1863@htj.dyndns.org>
References: <1798086.IHnGGWGxmu@daeseok-laptop.cloud.net>
	<20140415144324.GJ1863@htj.dyndns.org>
Date: Wed, 16 Apr 2014 08:01:28 +0900
Message-ID: <CAHb8M2Ayn9Ek2oEuA724y810q25L4tPu3RJMjWTPSsZy32pcnQ@mail.gmail.com>
Subject: Re: [PATCH V3] workqueue: fix double unlock bug
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun.

2014-04-15 23:43 GMT+09:00 Tejun Heo <tj@kernel.org>:
> On Tue, Apr 15, 2014 at 08:17:43AM +0900, Daeseok Youn wrote:
>>
>> Use default pwq when alloc_unbound_pwq() is failed.
>>
>> And remove "if" condition for whether "pwq" is same as "wq->dfl_pwq"
>> when wq_calc_node_cpumask() returns false and just use "goto use_dfl_pwq"
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>
> This is an awfully inadequate patch description.  Can you change it to
> something like the following?
OK. I will change the patch description as your comment.

>
>   workqueue: fix bugs in wq_update_unbound_numa() failure path
>
>   wq_update_unbound_numa() failure path has the following two bugs.
>
>   * alloc_unbound_pwq() is called without holding wq->mutex; however, if
>     the allocation fails, it jumps to out_unlock which tries to unlock
>     wq->mutex.
>
>   * The function should switch to dfl_pwq on failure but didn't do so
>     after alloc_unbound_pwq() failure.
>
>   Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
>   alloc_unbound_pwq() failure.
>
>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 0ee63af..0679854 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4087,10 +4087,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>>               if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
>>                       goto out_unlock;
>>       } else {
>> -             if (pwq == wq->dfl_pwq)
>> -                     goto out_unlock;
>> -             else
>> -                     goto use_dfl_pwq;
>> +             goto use_dfl_pwq;
>
> And please put this in a separate patch.  Patches which are to be
> backported through -stable should be minimal.  Also, please update the
> comment above to reflect the change.
Yes, I will do.

Thanks for review.

Regards,
Daeseok Youn.
>
> Thanks.
>
> --
> tejun
