Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191Ab3FTIlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:41:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41722 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab3FTIlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:41:49 -0400
Message-ID: <51C2C04A.7050403@gmail.com>
Date: Thu, 20 Jun 2013 01:41:46 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/8] sched: task_sched_runtime introduce micro optimization
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com> <1369604149-13016-9-git-send-email-kosaki.motohiro@gmail.com> <20130618142744.GG17619@somewhere.redhat.com> <CAHGf_=qhooSDvZVBUqct0B9khTZ-8Ju5YZ7b0yA34=3UgY+OoA@mail.gmail.com> <20130618171819.GJ17619@somewhere.redhat.com>
In-Reply-To: <20130618171819.GJ17619@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/18/13 10:18 AM), Frederic Weisbecker wrote:
> On Tue, Jun 18, 2013 at 11:17:41AM -0400, KOSAKI Motohiro wrote:
>>>> +#ifdef CONFIG_64BIT
>>>> +     /*
>>>> +      * 64-bit doesn't need locks to atomically read a 64bit value. So we
>>>> +      * have two optimization chances, 1) when caller doesn't need
>>>> +      * delta_exec and 2) when the task's delta_exec is 0. The former is
>>>> +      * obvious. The latter is complicated. reading ->on_cpu is racy, but
>>>> +      * this is ok. If we race with it leaving cpu, we'll take a lock. So
>>>> +      * we're correct. If we race with it entering cpu, unaccounted time
>>>> +      * is 0. This is indistinguishable from the read occurring a few
>>>> +      * cycles earlier.
>>>> +      */
>>>> +     if (!add_delta || !p->on_cpu)
>>>> +             return p->se.sum_exec_runtime;
>>>
>>> I'm not sure this is correct from an smp ordering POV. p->on_cpu may appear
>>> to be 0 whereas the task is actually running for a while and p->se.sum_exec_runtime
>>> can then be past the actual value on the remote CPU.
>>
>> Quate form Paul's last e-mail
>>
>>> Stronger:
>>>
>>> +#ifdef CONFIG_64BIT
>>> +       if (!p->on_cpu)
>>> +               return p->se.sum_exec_runtime;
>>> +#endif
>>>
>>> [ Or !p->on_cpu || !add_delta ].
>>>
>>> We can take the racy read versus p->on_cpu since:
>>>   If we race with it leaving cpu: we take lock, we're correct
>>>   If we race with it entering cpu: unaccounted time ---> 0, this is
>>> indistinguishable from the read occurring a few cycles earlier.
>
> Yeah, my worry was more about both p->on_cpu and p->se.sum_exec_runtime being
> stale for too long. How much time can happen in the worst case before CPU X sees
> the updates done by a CPU Y under rq(Y)->lock considering that CPU X doesn't take rq(Y)
> to read that update? I guess it depends on the hardware, locking and ordering
> that happened before.

Right. The worst case depend on memory access cost on remote node.
If memory access cost is m, The worst scenario is:

t
-------------
0: CPU X start to fetch p->on_cpu. (now it's 0)
0: CPU Y changes p->on_cpu to 1.
m: CPU X sees p->on_cpu is 0.

Then CPU X uses p->se.sum_exec_runtime even though p has delta m. And, in worst case,
all cpus make the same scenario. So, inaccuracy should be m x nr_online_cpus.
In this case, we can ignore cpu cache because we don't hit anyway in worst case.

However, I think it's ok. m is us order and our run_posx_cpu_timer() only has 1/HZ accuracy.
Moreover,taking lock needs more time than m because it need lock prefixed op. Then, It's free lunch.

I have no seen any ordering issue in this code because each CPU have independent time and no dependency. Please tell me if I'm missing something.

> Bah it probably doesn't matter in practice.

I'm ok to drop this "!p->on_cpu" optimization if you really dislike it.
It is just a micro optimization and the benefit is not so much.



