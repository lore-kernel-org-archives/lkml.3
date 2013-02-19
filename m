Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3BSCUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:20:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17012 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3BSCUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:20:00 -0500
Message-ID: <5122E12E.6000109@oracle.com>
Date: Mon, 18 Feb 2013 21:19:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched: BUG in load_balance
References: <5122CD9C.9070702@oracle.com> <1361237185.23152.174.camel@gandalf.local.home>
In-Reply-To: <1361237185.23152.174.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 08:26 PM, Steven Rostedt wrote:
> On Mon, 2013-02-18 at 19:55 -0500, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest, running today's -next,
>> I've stumbled on the following spew.
>>
>> I've cc'ed Steven Rostedt since the culprit looks like "sched: Enable
>> interrupts in idle_balance()".
> 
> You're correct. Interrupts are ok but softirqs must still be disabled.
> 
> The following patch should work.
> 
> -- Steve
> 
> Only compiled tested:
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0fcdbff..a31174c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5222,9 +5222,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	update_rq_runnable_avg(this_rq, 1);
>  
>  	/*
> -	 * Drop the rq->lock, but keep preempt disabled.
> +	 * Drop the rq->lock, but keep softirqs disabled.
>  	 */
> -	preempt_disable();
> +	local_bh_disable();
>  	raw_spin_unlock_irq(&this_rq->lock);
>  
>  	update_blocked_averages(this_cpu);
> @@ -5253,7 +5253,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	rcu_read_unlock();
>  
>  	raw_spin_lock_irq(&this_rq->lock);
> -	preempt_enable();
> +	local_bh_enable();

I have to admit, I'm slightly confused with the patch: there's a raw_spin_lock_irq()
followed by local_bh_enable(). afaik it's illegal to call local_bh_enable() with
interrupts disabled.


Thanks,
Sasha

