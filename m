Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbaDXSgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbaDXSgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:36:42 -0400
Message-ID: <53595993.2080905@redhat.com>
Date: Thu, 24 Apr 2014 20:36:03 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] nohz: Synchronize sleep time stats with memory barriers
References: <1398279636-21503-1-git-send-email-dvlasenk@redhat.com> <1398279636-21503-2-git-send-email-dvlasenk@redhat.com> <20140424001640.GA27571@localhost.localdomain>
In-Reply-To: <20140424001640.GA27571@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 02:16 AM, Frederic Weisbecker wrote:
>> + again:
>> +	active = ACCESS_ONCE(ts->idle_active);
>> +	smp_rmb();
>> +	count = ACCESS_ONCE(ts->idle_sleeptime);
>> +	if (active == 1) {
>> +		ktime_t delta, start;
>> +
>> +		smp_rmb();
>> +		start = ACCESS_ONCE(ts->idle_entrytime);
>> +		if (start.tv64 == 0) {
>> +			/*
>> +			 * Other CPU is updating the count.
>> +			 * We don't know whether fetched count is valid.
>> +			 */
>> +			goto again;
>> +		}
>> +		delta = ktime_sub(now, start);
>> +		count = ktime_add(count, delta);
> 
> There is still a possibility that you race with an updater here.
> Lets take these initial values, all of which belong to ts(CPU 1):
> 
>       // idle_sleeptime == 0
>       // idle_entrytime == 0
>       // ktime_get() == 100
>       // idle_active = 1
> 
>            CPU 0                                       CPU 1
> 
>       count = idle_sleeptime // = 0               
>                                                      tick_nohz_stop_idle();
>                                                      tick_nohz_start_idle();
>                                                      /* now idle_sleeptime == 100
>                                                         and idle_entrytime == 100
>                                                         ktime_get() is still 100
>                                                         and idle_active is still 1
>                                                         as it has toggled two times */
>       delta = now - idle_entrytime; // 100 - 100
>       count += delta // == 0
> 
> Then you get the spurious 0 result.
> 
> So memory barriers probably aren't enough here. seqcount would solve the issue as it maintains
> update seq tokens.

I think you are right. I'll use your approach (seqcount) in the next version.
