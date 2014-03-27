Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaC0G3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 02:29:14 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37307 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaC0G3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 02:29:12 -0400
Message-ID: <5333C521.10901@linux.vnet.ibm.com>
Date: Thu, 27 Mar 2014 11:58:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, davem@davemloft.net
Subject: Re: [PATCH] tick, broadcast: Prevent false alarm when force mask
 contains offline cpus
References: <20140326035648.21736.85740.stgit@preeti.in.ibm.com> <5332B833.2030701@linux.vnet.ibm.com> <533394C7.1000702@linux.vnet.ibm.com>
In-Reply-To: <533394C7.1000702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032706-8878-0000-0000-00000B840060
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 08:32 AM, Preeti U Murthy wrote:
> On 03/26/2014 04:51 PM, Srivatsa S. Bhat wrote:
>> On 03/26/2014 09:26 AM, Preeti U Murthy wrote:
>>> Its possible that the tick_broadcast_force_mask contains cpus which are not
>>> in cpu_online_mask when a broadcast tick occurs. This could happen under the
>>> following circumstance assuming CPU1 is among the CPUs waiting for broadcast.
>>>
>>> CPU0					CPU1
>>>
>>> Run CPU_DOWN_PREPARE notifiers
>>>
>>> Start stop_machine			Gets woken up by IPI to run
>>> 					stop_machine, sets itself in
>>> 					tick_broadcast_force_mask if the
>>> 					time of broadcast interrupt is around
>>> 					the same time as this IPI.
>>>
>>> 					Start stop_machine
>>> 					  set_cpu_online(cpu1, false)
>>> End stop_machine			End stop_machine
>>>
>>> Broadcast interrupt
>>>   Finds that cpu1 in
>>>   tick_broadcast_force_mask is offline
>>>   and triggers the WARN_ON in
>>>   tick_handle_oneshot_broadcast()
>>>
>>> Clears all broadcast masks
>>> in CPU_DEAD stage.
>>>
>>> This WARN_ON was added to capture scenarios where the broadcast mask, be it
>>> oneshot/pending/force_mask contain offline cpus whose tick devices have been
>>> removed. But here is a case where we trigger the warn on in a valid scenario.
>>>
>>> One could argue that the scenario is invalid and ought to be warned against
>>> because ideally the broadcast masks need to be cleared of the cpus about to
>>> go offine before clearing them in the online_mask so that we dont hit these
>>> scenarios.
>>>
>>> This would mean clearing the masks in CPU_DOWN_PREPARE stage.
>>
>> Not necessarily. We could clear the mask in the CPU_DYING stage. That way,
>> offline CPUs will automatically get cleared from the force_mask and hence
>> the tick-broadcast code will not need to have a special case to deal with
>> this scenario. What do you think?
> 
> Ok I gave some thought to this. This will not work with the hrtimer mode
> of broadcast framework going in. This is the feature that was added for
> implementations of such archs which do not have an external clock device
> to wake them up in deep idle states when the local timers stop. They
> assign one of the CPUs as an agent to wake them up. When this designated
> CPU gets hotplugged out, we need to assign this duty to some other CPU.
> 
> The way this is being done now is in
> tick_shutdown_broadcast_oneshot_control() which is also responsible for
> clearing the broadcast masks. When the hrtimer mode of broadcast is
> active, then in addition to clearing masks in this function we make the
> CPU executing this function take on the task of waking up CPUs in deep
> idle state if the hotplugged CPU was doing this earlier.
> 
> Currently tick_shutdown_broadcast_oneshot_control() is being executed in
> the CPU_DEAD notification and this is guarenteed to run on a CPU *other
> than* the dying CPU. Hence we can safely do this.
> 
> However if we move this function underneath CPU_DYING notifier, this
> will turn out to be a disaster since IIUC the dying CPU is running this
> notifier and will end up re-assigning the duty of waking up CPUs to itself.
> 

Actually, my suggestion was to remove the dying CPU from the force_mask alone,
in the CPU_DYING notifier. The rest of the cleanup (removing it from the other
masks, moving the broadcast duty to someone else etc can still be done at
the CPU_DEAD stage). Also, note that the CPU which is set in force_mask is
definitely not the one doing the broadcast.

Basically, my reasoning was this:

If we look at how the 3 broadcast masks (oneshot, pending and force) are
set and cleared during idle entry/exit, we see this pattern:

oneshot_mask: This is set at BROADCAST_ENTER and cleared at EXIT.
pending_mask: This is set at tick_handle_oneshot_broadcast and cleared at
              EXIT.
force_mask:   This is set at EXIT and cleared at the next call to
              tick_handle_oneshot_broadcast. (Also, if the CPU is set in this
              mask, the CPU doesn't enter deep idle states in subsequent
              idle durations, and keeps polling instead, until it gets the
              broadcast interrupt).

What we can derive from this is that force_mask is the only mask that can
remain set across an idle ENTER/EXIT sequence. Both of the other 2 masks
can never remain set across a full idle ENTER/EXIT sequence. And a CPU going
offline certainly goes through EXIT if it had gone through ENTER, before
entering stop_machine().

That means, force_mask is the only odd one out here, which can remain set
when entering stop_machine() for CPU offline. So that's the only mask that
needs to be cleared separately. The other 2 masks take care of themselves
automatically. So, we can have a CPU_DYING callback which just clears the
dying CPU from the force_mask (and does nothing more). That should work, no?

Regards,
Srivatsa S. Bhat

