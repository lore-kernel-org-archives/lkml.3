Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3LQJxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:53:17 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:45094 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3LQJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:53:11 -0500
Message-ID: <52B01F07.1070001@linaro.org>
Date: Tue, 17 Dec 2013 10:53:11 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alex Shi <alex.shi@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Amit Kucheria <amit.kucheria@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: power aware scheduler: remove the idle task ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

yes, another thread about the power aware scheduler :)

There have been a lot of discussions about the integrating the power 
management into the scheduler but it seems we are still turning around 
without agreeing on a consensus.

I would like to have some clarifications on one point.

Peter said in an email [1] :

"[...]

I think the scheduler simply wants to say: we expect to go idle for X 
ns, we want a guaranteed wakeup latency of Y ns -- go do your thing.

[...]"

I share 100% this opinion but that may imply the following:

1. the scheduler should get some information from the cpuidle framework 
in order to get the idle state it is supposed to go with its wakeup 
latency. Some of the heuristics of the cpuidle governors should be 
shared with the scheduler also in order to get how long it should stay idle.

2. the idle task should get some informations from the scheduler in 
order to get the idle time but it could be woken up several times, 
without preemption, thus it will need to recompute the expected idle 
time on its own and depending on the idle state, it will need to update 
the wakeup latency for the scheduler.

3. the pm qos is part of the constraint but also the idle balance 
constraints should be added for more integration.

4. ... certainly a lot of more things related to sched fair class with 
the scheduler.

So at the end, the resulting sub systems design is:

  -----------       -----------       ---------
| scheduler |<--->| idle task |<--->| cpuidle |
  -----------       -----------       ---------
      ^                                   ^
      |                                   |
       -----------------------------------

IMHO, this creates cyclical dependencies between scheduler, cpuidle
and idle task instead of integrating idle policy into the scheduler.

So, I am wondering if the idle task removal is something the maintainers 
had in mind when they talked about the power aware scheduler ?

The scheduler would gather all the idle informations and can modulate 
them regarding the behavior of the tasks (no details for now) and just 
tells the cpuidle framework to go the state fulfilling the constraints 
passed as parameter.

If the power aware scheduler implies the removal of the idle task, we 
could start by creating two paths in the scheduler, one with the old 
scheduler code with the idle task and the other one experimental without 
the idle task. Wouldn't make sense to investigate this first before 
moving code around to make the scheduler power aware ?

It would be nice if the maintainers and the other people deeply involved 
in the scheduler changes can share their opinion about that.

Thanks !

   -- Daniel

[1] https://lkml.org/lkml/2013/11/11/353

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

