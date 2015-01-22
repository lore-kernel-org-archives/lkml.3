Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbbAVVB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:01:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:33486 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbbAVVB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:01:26 -0500
Date: Thu, 22 Jan 2015 22:00:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] cpuidle: Add missing checks to the exit condition of
 cpu_idle_poll()
In-Reply-To: <20150121105655.15279.59626.stgit@preeti.in.ibm.com>
Message-ID: <alpine.DEB.2.11.1501222200460.5526@nanos>
References: <20150121105655.15279.59626.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Preeti U Murthy wrote:

> cpu_idle_poll() is entered into when either the cpu_idle_force_poll is set or
> tick_check_broadcast_expired() returns true. The exit condition from
> cpu_idle_poll() is tif_need_resched().
> 
> However this does not take into account scenarios where cpu_idle_force_poll
> changes or tick_check_broadcast_expired() returns false, without setting
> the resched flag. So a cpu will be caught in cpu_idle_poll() needlessly,
> thereby wasting power. Add an explicit check on cpu_idle_force_poll and
> tick_check_broadcast_expired() to the exit condition of cpu_idle_poll()
> to avoid this.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> Changes from V1: Modified the Changelog
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
>  		cpu_relax();
>  	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>  	rcu_idle_exit();
> 
> 
