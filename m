Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbbATLVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:21:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:48037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbbATLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:21:51 -0500
Date: Tue, 20 Jan 2015 12:21:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idle/tick-broadcast: Exit cpu idle poll loop when cleared
 from tick_broadcast_force_mask
In-Reply-To: <20150119052754.20256.54721.stgit@preeti.in.ibm.com>
Message-ID: <alpine.DEB.2.11.1501201216420.5526@nanos>
References: <20150119052754.20256.54721.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Preeti U Murthy wrote:
> An idle cpu enters cpu_idle_poll() if it is set in the tick_broadcast_force_mask.
> This is so that it does not incur the overhead of entering idle states when it is expected
> to be woken up anytime then through a broadcast IPI. The condition that forces an exit out
> of the idle polling is the check on setting of the TIF_NEED_RESCHED flag for the idle thread.
> 
> When the broadcast IPI does arrive, it is not guarenteed that the handler sets the
> TIF_NEED_RESCHED flag. Hence although the cpu is cleared in the tick_broadcast_force_mask,
> it continues to loop in cpu_idle_poll unnecessarily wasting power. Hence exit the idle
> poll loop if the tick_broadcast_force_mask gets cleared and enter idle states.
> 
> Of course if the cpu has entered cpu_idle_poll() on being asked to poll explicitly,
> it continues to poll till it is asked to reschedule.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched/idle.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index c47fce7..aaf1c1d 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -47,7 +47,8 @@ static inline int cpu_idle_poll(void)
>  	rcu_idle_enter();
>  	trace_cpu_idle_rcuidle(0, smp_processor_id());
>  	local_irq_enable();
> -	while (!tif_need_resched())
> +	while (!tif_need_resched() &&
> +		(cpu_idle_force_poll || tick_check_broadcast_expired()))

You explain the tick_check_broadcast_expired() bit, but what about the
cpu_idle_force_poll part?

Thanks,

	tglx
