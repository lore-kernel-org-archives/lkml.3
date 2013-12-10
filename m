Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3LJPLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:11:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3LJPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:11:46 -0500
Message-ID: <1386688302.6304.30.camel@marge.simpson.net>
Subject: Re: [question] sched: idle_avg and migration latency
From: Mike Galbraith <bitbucket@online.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@linaro.org>
Date: Tue, 10 Dec 2013 16:11:42 +0100
In-Reply-To: <52A6FB5C.7010706@linaro.org>
References: <52A6FB5C.7010706@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:c/Zm6xMfRbPv71VIRzmZEMrU9WT7cF910zzZcF9JzNp
 KaTEjOYT1WJjgef2ZCNC8tuuL9x1UJ763oAnkDqoHqCaYUiKkr
 nvvs1o4Zm4PMjlcoo9gQ0mzoELC+rdTOqOm55A6oKrw6nhwNhN
 ZGWLJtwHzPrSwBz9DGYDZeAIGnLTwhbBO8w1CcfH3aHjUFSbHl
 aolxw3sW6W33PsLilF2HdtzxzC7Slk15zZX7WaUUz7xsALsJ7p
 FUhZz+VapyxHFZbL6PKewnIz84Au6rg97+3r+POGiTClT3hJPy
 CFUX/rM7Du5pSnSiSn3oWDAxOTmPwjOanX2hef542q88nu3YCC
 q9KZn0keBBuMw9R0e5pQ3rshjPq+yfZR6oXRi1XswSdIqYbTNW
 n25y+455Hw3xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 12:30 +0100, Daniel Lezcano wrote: 
> Hi All,
> 
> I am trying to understand how is computed the idle_avg and how it is 
> used regarding the migration latency.
> 
> 1. What is the sysctl_sched_migration_cost value ? It is initialized to 
> 500000UL. Is it an arbitrarily chosen value ? Could it change depending 
> on the hardware performances ?

Yeah, it's a magic number.  We used to use boot time measurements.

> 2. The idle_balance function checks:
> 
>          if (this_rq->avg_idle < sysctl_sched_migration_cost)
>                  return 0;
> 
> IIUC, it is not worth to migrate a task to this cpu as we expect to run 
> another task before we can pull a task to the current cpu, right ?

No, that's all about not beating living hell outta ourselves on every
micro-idle.  As with all load balancing, it's usually too much balancing
that creates a problem.  You need it, but it's really expensive, so less
is more.

> Then if there is no task to balance we will enter idle, thus we 
> initialize the idle_stamp to the current clock.
> 
> When another task is woken up with the ttwu_do_wakeup, the duration of 
> the idle time is computed in there:
> 
> 	if (rq->idle_stamp) {
> 		u64 delta = rq_clock(rq) - rq->idle_stamp;
> 		u64 max = 2*sysctl_sched_migration_cost;
> 
> 		if (delta > max)
> 			rq->avg_idle = max;
> 		else
> 			update_avg(&rq->avg_idle, delta);
> 		rq->idle_stamp = 0;
> 	}
> 
> Why is the 'delta' leveraged by 'max' ?

That has changed a little recently.  I originally slammed avg_idle
itself straight to max to ensure that a bursty load would idle balance,
and not use stale data.  If you start cross core switching at high
frequency, you'll still shut idle balancing quickly.

> 3. And finally the function update_avg does:
> 
> 	s64 diff = sample - *avg;
> 	*avg += diff >> 3;
> 
> Why is diff >> 3 used instead of the number of values ?

Ingo's quick like bunny smooth average.

-Mike

