Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3BROjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:39:03 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41347 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3BROjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:39:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzu-7uAXLqP+J48DaqLUYQWTESMNwPMYiiwrU2ZoOsgqw@mail.gmail.com>
References: <1359455940-1710-1-git-send-email-vincent.guittot@linaro.org>
	<1359455940-1710-2-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hzboD8Mv_-pRDHc+39QwXGWiT3MGtL8gJ=_ajnHdDCBcA@mail.gmail.com>
	<CAKfTPtD2jRke2CUXiJdmaYYki_Voi4eTqJKgsyTnRpna7p8mJg@mail.gmail.com>
	<CAFTL4hzriJm1mK1A_9U5kX9Z0RCMGpxy8M3gKuzFtt9Bky5htQ@mail.gmail.com>
	<CAKfTPtCWudftS2XSM1OC2sR050mYvcAU6Fkt0vjV=C2V+w84Ew@mail.gmail.com>
	<CAFTL4hzu-7uAXLqP+J48DaqLUYQWTESMNwPMYiiwrU2ZoOsgqw@mail.gmail.com>
Date: Mon, 18 Feb 2013 15:38:58 +0100
Message-ID: <CAFTL4hyR=_ftCxycyvCBR0xwj6aOix9op40ps7htogpkkqVz+A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, Mike Galbraith <efault@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 Frederic Weisbecker <fweisbec@gmail.com>:
> 2013/2/8 Vincent Guittot <vincent.guittot@linaro.org>:
>> On 8 February 2013 16:35, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> What if the following happen (inventing function names but you get the idea):
>>>
>>> CPU 0                                           CPU 1
>>>
>>> dom = new_domain(...) {
>>>            nr_cpus_busy = 0;
>>>            set_idle(CPU 1);                  old_dom =get_dom()
>>>                                                      clear_idle(CPU 1)
>>> }
>>> rcu_assign_pointer(cpu1_dom, dom);
>>>
>>>
>>> Can this scenario happen?
>>
>> This scenario will be:
>>
>>  CPU 0                                           CPU 1
>>
>>  detach_and_destroy_domain {
>>             rcu_assign_pointer(cpu1_dom, NULL);
>>  }
>>
>>  dom = new_domain(...) {
>>             nr_cpus_busy = 0;
>>             set_idle(CPU 1);                  old_dom =get_dom()
>>                                                       old_dom is null
>>                                                       //clear_idle(CPU
>> 1) can't happen because a null domain is attached so we will never
>> call nohz_kick_needed which is the only place where we can clear_idle
>>  }
>>  rcu_assign_pointer(cpu1_dom, dom);
>
> So is the following possible?
>
> = CPU 0 =                                                       = CPU 1=
>
> detach_and_destroy_domain {
>             rcu_assign_pointer(cpu1_dom, NULL);
> }
>
> dom = new_domain(...) {
>              nr_cpus_busy = 0;
>              set_idle(CPU 1);
> }
>
> clear_idle(CPU 1)
>
> dom = rcu_dereference(cpu1_dom)
>
> //dom == NULL, return
>
> rcu_assign_pointer(cpu1_dom, NULL);
>
>
> set_idle(CPU 1)
>
> dom = rcu_dereference(cpu1_dom)
>
> //dec nr_cpus_busy, making it negative

Sorry, gmail messed up as usual.

I pasted the original at: http://pastebin.com/DMm5U8J8
