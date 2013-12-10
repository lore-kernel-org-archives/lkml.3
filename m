Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3LJPUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:20:09 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34832 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3LJPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:20:06 -0500
Message-ID: <52A73121.30309@linaro.org>
Date: Tue, 10 Dec 2013 23:20:01 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [question] sched: idle_avg and migration latency
References: <52A6FB5C.7010706@linaro.org>
In-Reply-To: <52A6FB5C.7010706@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to MikeG, he written this part. :)
I try to explain sth I know. I am sorry if my understanding incorrect.

On 12/10/2013 07:30 PM, Daniel Lezcano wrote:
> 
> Hi All,
> 
> I am trying to understand how is computed the idle_avg and how it is
> used regarding the migration latency.
> 
> 1. What is the sysctl_sched_migration_cost value ? It is initialized to
> 500000UL. Is it an arbitrarily chosen value ? Could it change depending
> on the hardware performances ?

current sysctl_sched_mirgration_cost is 0.5ms, used to limit
overscheduling. Guess it is a kind of arbitrary. But it can be rewrite
at /proc/sys/kernel/sched_migration_cost_ns.
So if you find some new suitable value in particular scenario. guess
PeterZ like to modify it. :)

> 
> 
> 2. The idle_balance function checks:
> 
>         if (this_rq->avg_idle < sysctl_sched_migration_cost)
>                 return 0;
> 
> IIUC, it is not worth to migrate a task to this cpu as we expect to run
> another task before we can pull a task to the current cpu, right ?

No, that used to prevent every idle_balance cause a task migration if
idle balance happens too much and too quick, -- frequency more than task
migration limitation.
> 
> Then if there is no task to balance we will enter idle, thus we
> initialize the idle_stamp to the current clock.

If we pulled task, we will restart frequency calculation by set
idle_stamp = 0;
or if new task adding this rq, allow more idle_balance.
> 
> When another task is woken up with the ttwu_do_wakeup, the duration of
> the idle time is computed in there:
> 
>     if (rq->idle_stamp) {
>         u64 delta = rq_clock(rq) - rq->idle_stamp;
>         u64 max = 2*sysctl_sched_migration_cost;
> 
>         if (delta > max)
>             rq->avg_idle = max;
>         else
>             update_avg(&rq->avg_idle, delta);
>         rq->idle_stamp = 0;
>     }
> 
> Why is the 'delta' leveraged by 'max' ?
> 
> 
> 3. And finally the function update_avg does:
> 
>     s64 diff = sample - *avg;
>     *avg += diff >> 3;
> 
> Why is diff >> 3 used instead of the number of values ?

It is a kind of decay. but has no idea of why this value '3'. Guess
MikeG has some reason.
> 
> Thanks in advance for any answers
> 
>   -- Daniel
> 


-- 
Thanks
    Alex
