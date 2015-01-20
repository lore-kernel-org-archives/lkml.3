Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbbATG6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:58:55 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:54739 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbATG6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:58:53 -0500
Message-ID: <54BDFC9C.3020308@linux.vnet.ibm.com>
Date: Tue, 20 Jan 2015 12:28:36 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, tglx@linutronix.de
CC: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        anton@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: tick/broadcast: Make movement of broadcast hrtimer robust against
 hotplug
References: <20150120060913.A5EF31402DE@ozlabs.org>
In-Reply-To: <20150120060913.A5EF31402DE@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-6
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012006-0033-0000-0000-00000362D8C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 11:39 AM, Michael Ellerman wrote:
> On Mon, 2015-19-01 at 10:26:48 UTC, Preeti U Murthy wrote:
>> Today if a cpu handling broadcasting of wakeups goes offline, it hands over
> 
> It's *the* cpu handling broadcasting of wakeups right? ie. there's only ever
> one at a time.

Right, thanks for pointing this.

> 
>> the job of broadcasting to another cpu in the CPU_DEAD phase. 
> 
> I think that would be clearer as "to another cpu, when the cpu going offline
> reaches the CPU_DEAD state."
> 
> Otherwise it can read as "another cpu (which is) in the CPU_DEAD phase", which
> is not what you mean - I think.

Yes I will word this better.
> 
>> The CPU_DEAD notifiers are run only after the offline cpu sets its state as
>> CPU_DEAD. Meanwhile, the kthread doing the offline is scheduled out while
> 
> The kthread which is running on a different cpu from either of the first two
> cpus you've mentioned.

It could be running on any cpu other than the offline one. The next line
clarifies this - "This is fatal if the cpu on which this kthread was
running". I also say "Meanwhile, the kthread doing the offline" above so
as to clarify that the offline cpu has nothing to do with this kthread.

> 
>> waiting for this transition by queuing a timer. This is fatal because if the
>> cpu on which this kthread was running has no other work queued on it, it can
>> re-enter deep idle state, since it sees that a broadcast cpu still exists.
>> However the broadcast wakeup will never come since the cpu which was handling
>> it is offline, and this cpu never wakes up to see this because its in deep
>> idle state.
> 
> Which cpu is "this cpu"? I think you mean the one running the kthread which is
> doing the offline, but it's not 100% clear.

Right, I will make this correction as well, its ambiguous.

> 
>> Fix this by setting the broadcast timer to a max value so as to force the cpus
>> entering deep idle states henceforth to freshly nominate the broadcast cpu. More
>> importantly this has to be done in the CPU_DYING phase so that it is visible to
>> all cpus right after exiting stop_machine, which is when they can re-enter idle.
>> This ensures that handover of the broadcast duty falls in place on offline, without
>> having to do it explicitly.
> 
> OK, I don't know the code well enough to say if that's the right fix.
> 
> You say:
> 
> +	/* This allows fresh nomination of broadcast cpu */
> +	bc->next_event.tv64 = KTIME_MAX;
> 
> Is that all it does? I see that check in several places in the code.

This change does not affect those parts of the tick broadcast code,
which do not depend on the hrtimer broadcast framework. And for those
parts that do depend on this framework, this plays a critical role in
handing over the broadcast duty.

> 
> 
> I assume we're expecting Thomas to merge this?

Yes, Thomas can you please take this into the next 3.19 rc release ? I
will send out a new patch with the modified changelog. If you find this
acceptable I will port it to the relevant stable kernels.
> 
> If so it's probably worth mentioning that it fixes a bug we are seeing on

I will mention this in the changelog by pointing to the bug report.

Regards
Preeti U Murthy
> machines in the wild. So it'd be nice if it went into 3.19 and/or gets sent to
> stable.
> 
> cheers
> 

