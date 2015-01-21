Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbbAUU67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:58:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55868 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbbAUU6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:58:53 -0500
Message-ID: <54C0130B.8040606@codeaurora.org>
Date: Wed, 21 Jan 2015 12:58:51 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Patch Tracking <patches@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] sched_clock: Avoid tearing during read from NMI
References: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org> <CALAqxLUmf_TNvTG2-=uavXjXk3040-MQ73V5z7S1UiGa+7c29Q@mail.gmail.com>
In-Reply-To: <CALAqxLUmf_TNvTG2-=uavXjXk3040-MQ73V5z7S1UiGa+7c29Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 09:29 AM, John Stultz wrote:
> On Wed, Jan 21, 2015 at 8:53 AM, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
>> Currently it is possible for an NMI (or FIQ on ARM) to come in and
>> read sched_clock() whilst update_sched_clock() has half updated the
>> state. This results in a bad time value being observed.
>>
>> This patch fixes that problem in a similar manner to Thomas Gleixner's
>> 4396e058c52e("timekeeping: Provide fast and NMI safe access to
>> CLOCK_MONOTONIC").
>>
>> Note that ripping out the seqcount lock from sched_clock_register() and
>> replacing it with a large comment is not nearly as bad as it looks! The
>> locking here is actually pretty useless since most of the variables
>> modified within the write lock are not covered by the read lock. As a
>> result a big comment and the sequence bump implicit in the call
>> to update_epoch() should work pretty much the same.
> It still looks pretty bad, even with the current explanation.
>
>
>> -       raw_write_seqcount_begin(&cd.seq);
>> +       /*
>> +        * sched_clock will report a bad value if it executes
>> +        * concurrently with the following code. No locking exists to
>> +        * prevent this; we rely mostly on this function being called
>> +        * early during kernel boot up before we have lots of other
>> +        * stuff going on.
>> +        */
>>         read_sched_clock = read;
>>         sched_clock_mask = new_mask;
>>         cd.rate = rate;
>>         cd.wrap_kt = new_wrap_kt;
>>         cd.mult = new_mult;
>>         cd.shift = new_shift;
>> -       cd.epoch_cyc = new_epoch;
>> -       cd.epoch_ns = ns;
>> -       raw_write_seqcount_end(&cd.seq);
>> +       update_epoch(new_epoch, ns);
>
> So looking at this, the sched_clock_register() function may not be
> called super early, so I was looking to see what prevented bad reads
> prior to registration. And from quick inspection, its nothing. I
> suspect the undocumented trick that makes this work is that the mult
> value is initialzied to zero, so sched_clock returns 0 until things
> have been registered.

mult is never zero. It's NSEC_PER_SEC / HZ by default. The thing that's
zero is the sched_clock_mask, so that's making us return 0 until
sched_clock_postinit() gets called or a non-jiffy clock is registered.

Where does the bad read happen? By default we're using
jiffy_sched_clock_read() and that doesn't move until interrupts are
enabled. We also rely on any clocks being registered before
sched_clock_postinit() is called (which is called before interrupts are
enabled on the boot CPU).

>
> So it does seem like it would be worth while to do the initialization
> under the lock, or possibly use the suspend flag to make the first
> initialization safe.

Looking back at the code now I'm not sure why we did all that under the
write lock but we don't protect it with the read lock in sched_clock()
itself. I guess we didn't really care because the registration phase is
entirely single-threaded. I don't see any problem making this more
robust so that clocks can be registered at any time. If we did that I
would hope that sched_clock_postinit() becomes largely unnecessary.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

