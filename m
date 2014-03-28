Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaC1IsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:48:21 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60381 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaC1IsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:48:01 -0400
Message-ID: <53353723.2040000@linux.vnet.ibm.com>
Date: Fri, 28 Mar 2014 14:17:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, davem@davemloft.net
Subject: Re: [PATCH] tick, broadcast: Prevent false alarm when force mask
 contains offline cpus
References: <20140326035648.21736.85740.stgit@preeti.in.ibm.com> <5332B833.2030701@linux.vnet.ibm.com> <533394C7.1000702@linux.vnet.ibm.com> <5333C521.10901@linux.vnet.ibm.com> <5333FA02.3090402@linux.vnet.ibm.com>
In-Reply-To: <5333FA02.3090402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032808-1396-0000-0000-0000048A0A5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 03:44 PM, Preeti U Murthy wrote:
> On 03/27/2014 11:58 AM, Srivatsa S. Bhat wrote:
>>
>> Actually, my suggestion was to remove the dying CPU from the force_mask alone,
>> in the CPU_DYING notifier. The rest of the cleanup (removing it from the other
>> masks, moving the broadcast duty to someone else etc can still be done at
>> the CPU_DEAD stage). Also, note that the CPU which is set in force_mask is
>> definitely not the one doing the broadcast.
>>
>> Basically, my reasoning was this:
>>
>> If we look at how the 3 broadcast masks (oneshot, pending and force) are
>> set and cleared during idle entry/exit, we see this pattern:
>>
>> oneshot_mask: This is set at BROADCAST_ENTER and cleared at EXIT.
>> pending_mask: This is set at tick_handle_oneshot_broadcast and cleared at
>>               EXIT.
>> force_mask:   This is set at EXIT and cleared at the next call to
>>               tick_handle_oneshot_broadcast. (Also, if the CPU is set in this
>>               mask, the CPU doesn't enter deep idle states in subsequent
>>               idle durations, and keeps polling instead, until it gets the
>>               broadcast interrupt).
>>
>> What we can derive from this is that force_mask is the only mask that can
>> remain set across an idle ENTER/EXIT sequence. Both of the other 2 masks
>> can never remain set across a full idle ENTER/EXIT sequence. And a CPU going
>> offline certainly goes through EXIT if it had gone through ENTER, before
>> entering stop_machine().
>>
>> That means, force_mask is the only odd one out here, which can remain set
>> when entering stop_machine() for CPU offline. So that's the only mask that
>> needs to be cleared separately. The other 2 masks take care of themselves
>> automatically. So, we can have a CPU_DYING callback which just clears the
>> dying CPU from the force_mask (and does nothing more). That should work, no?
> 
> Yep I think this will work. Find the modified patch below:
> 
> Thanks.
> 
> Regards
> Preeti U Murthy
> 
> 
> tick,broadcast:Clear hotplugged cpu in broadcast masks during CPU_DYING notification
> 
> From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
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
> While the hotplugged cpu clears its bit in the tick_broadcast_oneshot_mask
> and tick_broadcast_pending mask during BROADCAST_EXIT, it *sets* its bit
> in the tick_broadcast_force_mask if the broadcast interrupt is found to be
> around the same time as the present time. Today we clear all the broadcast
> masks and shutdown tick devices in the CPU_DEAD stage. But as shown above
> the broadcast interrupt could occur before this stage is reached and the
> WARN_ON() gets triggered when it is found that the tick_broadcast_force_mask
> contains an offline cpu.
> 
> This WARN_ON was added to capture scenarios where the broadcast mask, be it
> oneshot/pending/force_mask contain offline cpus whose tick devices have been
> removed. But here is a case where we trigger the WARN_ON() when the tick
> device of the hotplugged cpu is still around but we are delaying the clearing
> of the broadcast masks. This has not been a problem for
> tick_broadcastoneshot_mask and tick_broadcast_pending_mask since they get
> cleared on exit from broadcast.
>    But since the force_mask gets set at the same time on certain occasions
> it is necessary to move the clearing of masks to a stage during cpu hotplug
> before the hotplugged cpu clears itself in the online_mask.
>

That last sentence is not entirely accurate. During stop-machine in the CPU
offline path, the CPU removes itself from the cpu_online_mask at the very
beginning, in the __cpu_disable() call. Only after that the CPU_DYING notifiers
are invoked. But the advantage of clearing the CPU from the force_mask at
the CPU_DYING stage is that no other CPU is "noticing" this event, since
everybody is busy spinning in stop-machine. So, by the time stop-machine
completes and the CPU is officially offline, it would have "magically" cleared
itself from the force_mask as well, making things look very consistent for
the rest of the CPUs (i.e., an offline CPU will never remain set in the
force_mask).
 
> Hence move the clearing of broadcast masks to the CPU_DYING notification stage
> so that they remain consistent with the cpu_online_mask at the time of
> broadcast delivery at all times.
>

This last paragraph sums it up perfectly.
 
> Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

You might want to alter the changelog a bit as mentioned above. Other than
that, everything looks fine to me. (But see one minor whitespace nitpick
below).

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

> ---
>  kernel/time/clockevents.c    |    1 +
>  kernel/time/tick-broadcast.c |   20 +++++++++++++++-----
>  kernel/time/tick-internal.h  |    3 +++
>  3 files changed, 19 insertions(+), 5 deletions(-)
>
[...]
> @@ -912,11 +925,8 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
>  	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
>  	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
> 
> -	broadcast_move_bc(cpu);
> -
>  	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>  }
> -

I guess you removed that newline by mistake. Please add it back, it improves
readability.

Regards,
Srivatsa S. Bhat

>  /*
>   * Check, whether the broadcast device is in one shot mode
>   */

