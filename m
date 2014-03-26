Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaCZL03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:26:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47070 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCZLVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:21:49 -0400
Message-ID: <5332B833.2030701@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 16:51:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, davem@davemloft.net
Subject: Re: [PATCH] tick, broadcast: Prevent false alarm when force mask
 contains offline cpus
References: <20140326035648.21736.85740.stgit@preeti.in.ibm.com>
In-Reply-To: <20140326035648.21736.85740.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032611-5564-0000-0000-00000CAEC3CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 09:26 AM, Preeti U Murthy wrote:
> Its possible that the tick_broadcast_force_mask contains cpus which are not
> in cpu_online_mask when a broadcast tick occurs. This could happen under the
> following circumstance assuming CPU1 is among the CPUs waiting for broadcast.
> 
> CPU0					CPU1
> 
> Run CPU_DOWN_PREPARE notifiers
> 
> Start stop_machine			Gets woken up by IPI to run
> 					stop_machine, sets itself in
> 					tick_broadcast_force_mask if the
> 					time of broadcast interrupt is around
> 					the same time as this IPI.
> 
> 					Start stop_machine
> 					  set_cpu_online(cpu1, false)
> End stop_machine			End stop_machine
> 
> Broadcast interrupt
>   Finds that cpu1 in
>   tick_broadcast_force_mask is offline
>   and triggers the WARN_ON in
>   tick_handle_oneshot_broadcast()
> 
> Clears all broadcast masks
> in CPU_DEAD stage.
> 
> This WARN_ON was added to capture scenarios where the broadcast mask, be it
> oneshot/pending/force_mask contain offline cpus whose tick devices have been
> removed. But here is a case where we trigger the warn on in a valid scenario.
> 
> One could argue that the scenario is invalid and ought to be warned against
> because ideally the broadcast masks need to be cleared of the cpus about to
> go offine before clearing them in the online_mask so that we dont hit these
> scenarios.
> 
> This would mean clearing the masks in CPU_DOWN_PREPARE stage.

Not necessarily. We could clear the mask in the CPU_DYING stage. That way,
offline CPUs will automatically get cleared from the force_mask and hence
the tick-broadcast code will not need to have a special case to deal with
this scenario. What do you think?

Regards,
Srivatsa S. Bhat

> ---
> 
>  kernel/time/tick-broadcast.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 63c7b2d..30b8731 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -606,7 +606,12 @@ again:
>  	 */
>  	cpumask_clear_cpu(smp_processor_id(), tick_broadcast_pending_mask);
> 
> -	/* Take care of enforced broadcast requests */
> +	/* Take care of enforced broadcast requests. We could have offline
> +	 * cpus in the tick_broadcast_force_mask. Thats ok, we got the interrupt
> +	 * before we could clear the mask.
> +	 */
> +	cpumask_and(tick_broadcast_force_mask,
> +			tick_broadcast_force_mask, cpu_online_mask);
>  	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
>  	cpumask_clear(tick_broadcast_force_mask);
> 
> 

