Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3CULDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:03:33 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55574 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3CULDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130320181010.GA30484@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
	<1363721306-2030-16-git-send-email-laijs@cn.fujitsu.com>
	<20130320181010.GA30484@htj.dyndns.org>
Date: Thu, 21 Mar 2013 19:03:30 +0800
Message-ID: <CACvQF512Ufz-Y2HjLKOGNW8A+9epcv6yvB8szyR4S9d4Uy41Sw@mail.gmail.com>
Subject: Re: [PATCH 15/21] workqueue: remove worker_maybe_bind_and_lock()
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 2:10 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 20, 2013 at 03:28:15AM +0800, Lai Jiangshan wrote:
>>  static struct worker *alloc_worker(void)
>>  {
>>       struct worker *worker;
>> @@ -2326,7 +2262,8 @@ repeat:
>>               spin_unlock_irq(&wq_mayday_lock);
>>
>>               /* migrate to the target cpu if possible */
>> -             worker_maybe_bind_and_lock(pool);
>> +             set_cpus_allowed_ptr(current, pool->attrs->cpumask);
>> +             spin_lock_irq(&pool->lock);
>>               rescuer->pool = pool;
>
> You can't do this.  The CPU might go up between set_cpus_allowed_ptr()
> and spin_lock_irq() and the rescuer can end up executing a work item
> which was issued while the target CPU is up on the wrong CPU.


Why it is wrong?
It can be allowed if the wq has rescuer. (wq of work_on_cpu() don't has rescuer,
it does not hurt to work_on_cpu() of something else.

Actually it was allowed by recent patches.
If a cpu is up while a rescuer do process_scheduled_workers(),
all the later work item will be running the wrong CPU while
 the target CPU is up.(due to for_cpu_pool_workers() don't include
active rescuer).

I don't want to go back to make cpuhotplug nor rescuer_theread become
complicated.
so I prefer to allow work item can run on wrong cpu if the wq has rescuer.
All just needs a comments.

I guess you will agaist me...... let me rewrite it .....

Thanks,
Lai

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
