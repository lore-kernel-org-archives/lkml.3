Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3LJLal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:30:41 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:34891 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3LJLai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:30:38 -0500
Message-ID: <52A6FB5C.7010706@linaro.org>
Date: Tue, 10 Dec 2013 12:30:36 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Alex Shi <alex.shi@linaro.org>
Subject: [question] sched: idle_avg and migration latency
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

I am trying to understand how is computed the idle_avg and how it is 
used regarding the migration latency.

1. What is the sysctl_sched_migration_cost value ? It is initialized to 
500000UL. Is it an arbitrarily chosen value ? Could it change depending 
on the hardware performances ?


2. The idle_balance function checks:

         if (this_rq->avg_idle < sysctl_sched_migration_cost)
                 return 0;

IIUC, it is not worth to migrate a task to this cpu as we expect to run 
another task before we can pull a task to the current cpu, right ?

Then if there is no task to balance we will enter idle, thus we 
initialize the idle_stamp to the current clock.

When another task is woken up with the ttwu_do_wakeup, the duration of 
the idle time is computed in there:

	if (rq->idle_stamp) {
		u64 delta = rq_clock(rq) - rq->idle_stamp;
		u64 max = 2*sysctl_sched_migration_cost;

		if (delta > max)
			rq->avg_idle = max;
		else
			update_avg(&rq->avg_idle, delta);
		rq->idle_stamp = 0;
	}

Why is the 'delta' leveraged by 'max' ?


3. And finally the function update_avg does:

	s64 diff = sample - *avg;
	*avg += diff >> 3;

Why is diff >> 3 used instead of the number of values ?

Thanks in advance for any answers

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

