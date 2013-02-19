Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738Ab3BSWUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:20:35 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:39939 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3BSWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:20:33 -0500
Message-ID: <5123FAAE.3030706@linaro.org>
Date: Tue, 19 Feb 2013 14:20:30 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org> <alpine.LFD.2.02.1302182132230.22263@ionos> <5123C3AF.8060100@linaro.org> <alpine.LFD.2.02.1302192021370.22263@ionos> <alpine.LFD.2.02.1302192056330.22263@ionos> <5123E20E.60307@linaro.org> <alpine.LFD.2.02.1302192152240.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302192152240.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 01:50 PM, Thomas Gleixner wrote:
> On Tue, 19 Feb 2013, John Stultz wrote:
>> On 02/19/2013 12:15 PM, Thomas Gleixner wrote:
>>> Depending on the length of the delay which kept VCPU0 away from
>>> executing and depending on the direction of the ntp update of the
>>> timekeeping variables __vdso_clock_gettime()#2 can observe time going
>>> backwards.
>>>
>>> You can reproduce that by pinning VCPU0 to physical core 0 and VCPU1
>>> to physical core 1. Now remove all load from physical core 1 except
>>> VCPU1 and put massive load on physical core 0 and make sure that the
>>> NTP adjustment lowers the mult factor.
>>>
>>> Fun, isn't it ?
>> Yea, this has always worried me. I had a patch for this way way back, blocking
>> vdso readers for the entire timekeeping update.
>> But it was ugly, hurt performance and no one seemed to be hitting the window
>> you hit above.  None the less, you're probably right, we should find a way to
>> do it right. I'll try to revive those patches.
> Let me summarize the IRC discussion we just had about that:
>
> 1) We really want to reduce the seq write hold time of the timekeeper
>     to the bare minimum.
>
>     That's doable and I have working patches for this by splitting the
>     timekeeper seqlock into a spin_lock and a seqcount and doing the
>     update calculations on a shadow timekeeper structure. The seq write
>     hold time then gets reduced to switching a pointer and updating the
>     gtod data.
>
>     So the sequence would look like:
>
>     raw_spin_lock(&timekeeper_lock);
>     copy_shadow_data(current_timekeeper, shadow_timekeeper);
>     do_timekeeping_and_ntp_update(shadow_timekeeper);
>     write_seqcount_begin(&timekeeper_seq);
>     switch_pointers(current_timekeeper, shadow_timekeeper);
>     update_vsyscall();
>     write_seqcount_end(&timekeeper_seq);
>     raw_spin_unlock(&timekeeper_lock);
>
>     It's really worth the trouble. On one of my optimized RT systems I
>     get the maximum latency of the non timekeeping cores (timekeeping
>     duty is pinned to core 0) down from 8us to 4 us. That's a whopping
>     factor of 2.
>
> 2) Doing #1 will allow to observe the described time going backwards
>     scenario in kernel as well.
>
>     The reason why we did not get complaints about that scenario at all
>     (yet) is that the window and the probability to hit it are small
>     enough. Nevertheless it's a real issue for virtualized systems.
>
>     Now you came up with the great idea, that the timekeeping core is
>     able to calculate what the approximate safe value is for the
>     clocksource readout to be in a state where wreckage relative to the
>     last update of the clocksource is not observable, not matter how
>     long the scheduled out delay is and in which direction the NTP
>     update is going.

So the other bit of caution here, is I realize my idea of "valid cycle 
ranges" has the potential for deadlock.

While it should be fine for use with vdso, we have to be careful if we 
use this in-kernel, because if we're in the update path, the valid 
interval check could trigger the ktime_get() in hrtimer_interrupt() to 
spin forever. So we need to be sure we don't use this method anywhere in 
the code paths that trigger the update_wall_time() code.

So some additional thinking may be necessary here. Though it may be as 
simple as making sure we don't loop on the cpu that does the timekeeping 
update.

thanks
-john

