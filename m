Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaHLQZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:25:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51433 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaHLQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:25:33 -0400
Message-ID: <53EA3FF5.1050709@codeaurora.org>
Date: Tue, 12 Aug 2014 21:55:25 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: provide support to use deferrable timers
 for scanner thread
References: <1406793591-26793-2-git-send-email-cpandya@codeaurora.org> <1406793591-26793-3-git-send-email-cpandya@codeaurora.org> <alpine.LSU.2.11.1408110332350.1500@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1408110332350.1500@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

>>
>> Typically, on our setup we observed, 10% less power consumption with some
>> use-cases in which CPU goes to power collapse frequently.  For example,
>> playing audio while typically CPU remains idle.
>
> I'm probably stupid, but I don't quite get your scenario from that
> description: please would you spell it out a little more clearly for me?

I think I have missed to share some important details here. Scenario 
here in general is where CPUs stay in Low Power mode and waits for 
interrupt for long time. One such situation could be what we observed in 
our testing. In our SoC based platform, Audio decode happens on a 
separate HW block but during that, use-case demands CPUs to stay in Low 
Power mode (not completely shut down) if not busy. Classic end-user 
scenario is Audio playback while user does nothing else on the 
mobile/watch. At this time, KSM wakes up the CPU at very regular 
interval and affects the power consumption. Another scenario could be 
background email sync where also for very long duration, CPU stays in 
Low Power mode, not busy, not off-line.

>
> Are you thinking of two CPUs, one of them running a process busily
> streaming audio (with no VM_MERGEABLE areas to work on), most other
> processes sleeping, and ksmd "pinned" to another, otherwise idle CPU?
>
> I'm very inexperienced in scheduler (and audio) matters, but I'd like
> to think that the scheduler would migrate ksmd to the mostly busy CPU
> in that case - or is it actually 100% busy, with no room for ksmd too?

IMHO waking up the CPU considering busyness of active CPU is probably 
not scheduler's interest (I am completely naive here so please correct 
me if I am wrong). So, here I believe that ksmd will get scheduled on 
active CPU where its timer will expire and not deferred.

>> To enable deferrable timers,
>> $ echo 1>  /sys/kernel/mm/ksm/deferrable_timer
>
> I do share Andrew's original reservations: I'd much prefer this if we
> can just go ahead and do the deferrable timer without a new tunable
> to concern the user, simple though your "deferrable_timer" knob is.
>
> In an earlier mail, you said "We have observed that KSM does maximum
> savings when system is idle", as reason why some will prefer a non-
> deferrable timer.  I am somewhat suspicious of that observation:
> because KSM waits for a page's checksum to stabilize before it saves
> it in its "unstable" tree of pages to compare against.  So when the
> rest of the system goes idle, KSM is briefly more likely to find
> matches; but that may be a short-lived "success" once the system
> becomes active again.  So, I'm wondering if your observation just
> reflects the mechanics of KSM, and is not actually a reason to
> refrain from using a deferrable timer for everyone.

Sometimes savings in idle time are not always short-lived. For example, 
in 512 MB DDR system running android saturates at somewhat around 25 MB 
of KSM savings. We have observed this saturation achieved quicker when 
phone is in idle. But I think that doesn't disprove your comment above. 
So, I would keep deferrable timer as a default. Next patch.

>
> On the other hand, I have a worry about using deferrable timer here.
> I think I understand the value of a deferrable timer, in doing a job
> which is bound to a particular cpu (mm/slab.c's cache_reap() gives
> me a good example of that).  But ksmd is potentially serving every
> process, every cpu: we would not want it to be deferred indefinitely,
> if other cpus (running processes with VM_MERGEABLE vmas) are active.

I too consider this as undesirable situation. But I think scheduler 
won't schedule ksmd on a non-busy idle CPU if we have active CPUs.

>
> Perhaps the likelihood of that scenario is too low; or perhaps it's
> a reason why we do need to offer your "deferrable_timer" knob.

I didn't thought of this reason for having the knob but I would still 
prefer to have a knob for some futuristic use-cases. Such as,

(1) When power is not constraint (charging mobile ?), we don't want KSM 
to use deferrable timers.

(2) We want maximum savings from KSM at the cost of power to get more 
free memory, even if it is short-lived.

May be above use-cases are not realistic. But providing a knob just 
enables us to implement some logic in userspace. So, what do you think 
of keeping the knob but default value is '1' i.e. use deferrable timers ?

>
> Please, I need to understand better before acking this change.
>
> By the way: perhaps KSM is the right place to start, but please take
> a look also at THP in mm/huge_memory.c, whose khugepaged was originally
> modelled on ksmd (but now seems to be using wait_event_freezable_timeout
> rather than schedule_timeout_interruptible - I've not yet researched the
> history behind that difference).  I expect it to need the same treatment.

I have no idea of THP so far. But would check it in this perspective. 
Thanks for the guide.

>> +	unsigned long enable;
>> +	int err;
>> +
>> +	err = kstrtoul(buf, 10,&enable);
>> +	if (err<  0)
>> +		return err;
>> +	if (enable>= 1)
>> +		return -EINVAL;
>
> I haven't studied the patch itself, I'm still worrying about the concept.
> But this caught my eye just before hitting Send: I don't think we need
> a tunable which only accepts the value 0 ;)

Okay. I can correct this to accept any non-zero value. Is that okay ?

>
>> +	use_deferrable_timer = enable;

-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
