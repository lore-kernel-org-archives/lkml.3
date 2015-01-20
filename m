Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbbATLZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:25:22 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56019 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbbATLZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:25:20 -0500
Message-ID: <54BE3B0E.2050502@linux.vnet.ibm.com>
Date: Tue, 20 Jan 2015 16:55:02 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idle/tick-broadcast: Exit cpu idle poll loop when cleared
 from tick_broadcast_force_mask
References: <20150119052754.20256.54721.stgit@preeti.in.ibm.com> <alpine.DEB.2.11.1501201216420.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501201216420.5526@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012011-0033-0000-0000-0000019AD9AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 04:51 PM, Thomas Gleixner wrote:
> On Mon, 19 Jan 2015, Preeti U Murthy wrote:
>> An idle cpu enters cpu_idle_poll() if it is set in the tick_broadcast_force_mask.
>> This is so that it does not incur the overhead of entering idle states when it is expected
>> to be woken up anytime then through a broadcast IPI. The condition that forces an exit out
>> of the idle polling is the check on setting of the TIF_NEED_RESCHED flag for the idle thread.
>>
>> When the broadcast IPI does arrive, it is not guarenteed that the handler sets the
>> TIF_NEED_RESCHED flag. Hence although the cpu is cleared in the tick_broadcast_force_mask,
>> it continues to loop in cpu_idle_poll unnecessarily wasting power. Hence exit the idle
>> poll loop if the tick_broadcast_force_mask gets cleared and enter idle states.
>>
>> Of course if the cpu has entered cpu_idle_poll() on being asked to poll explicitly,
>> it continues to poll till it is asked to reschedule.
>>
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/sched/idle.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
>> index c47fce7..aaf1c1d 100644
>> --- a/kernel/sched/idle.c
>> +++ b/kernel/sched/idle.c
>> @@ -47,7 +47,8 @@ static inline int cpu_idle_poll(void)
>>  	rcu_idle_enter();
>>  	trace_cpu_idle_rcuidle(0, smp_processor_id());
>>  	local_irq_enable();
>> -	while (!tif_need_resched())
>> +	while (!tif_need_resched() &&
>> +		(cpu_idle_force_poll || tick_check_broadcast_expired()))
> 
> You explain the tick_check_broadcast_expired() bit, but what about the
> cpu_idle_force_poll part?

The last few lines which say "Of course if the cpu has entered
cpu_idle_poll() on being asked to poll explicitly, it continues to poll
till it is asked to reschedule" explains the cpu_idle_force_poll part.
Perhaps I should s/poll explicitly/do cpu_idle_force_poll ?

Regards
Preeti U Murthy
> 
> Thanks,
> 
> 	tglx
> 

