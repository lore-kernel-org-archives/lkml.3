Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3GVS6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:58:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40526 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab3GVS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:58:48 -0400
Message-ID: <51ED80E7.4050606@codeaurora.org>
Date: Mon, 22 Jul 2013 11:58:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 03/17] sched_clock: Use an hrtimer instead of timer
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org> <1374189690-10810-4-git-send-email-sboyd@codeaurora.org> <51ED781F.6060300@linaro.org> <51ED7DD5.8010000@codeaurora.org>
In-Reply-To: <51ED7DD5.8010000@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/13 11:45, Stephen Boyd wrote:
> On 07/22/13 11:21, John Stultz wrote:
>> On 07/18/2013 04:21 PM, Stephen Boyd wrote:
>>> In the next patch we're going to increase the number of bits that
>>> the generic sched_clock can handle to be greater than 32. With
>>> more than 32 bits the wraparound time can be larger than what can
>>> fit into the units that msecs_to_jiffies takes (unsigned int).
>>> Luckily, the wraparound is initially calculated in nanoseconds
>>> which we can easily use with hrtimers, so switch to using an
>>> hrtimer.
>>>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>> Hrmm. So in my testing (under qemu), this patch causes bootup to hang.
>>
>> qemu-system-arm -kernel zImage-arm -M vexpress-a9 -cpu cortex-a9
>> -nographic -m 1024  -append 'root=/dev/mmcblk0p2 rw mem=1024M
>> raid=noautodetect console=ttyAMA0,38400n8 rootwait vmalloc=256MB
>> devtmpfs.mount=0' -sd test-arm.img -redir tcp:4300::22
>>
>> Config file attached.
>>
>> I haven't gotten a chance to look very closely, but it seems the
>> folowing patch resolves the issue. I'm not sure if we're seeing
>> callers to setup_sched_clock happen after sched_clock_postinit or
>> what, but it probably needs another look over.
>>
>> thanks
>> -john
>>
>>
>> diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
>> index a269890b..c018ffc 100644
>> --- a/kernel/time/sched_clock.c
>> +++ b/kernel/time/sched_clock.c
>> @@ -138,12 +138,6 @@ void __init setup_sched_clock(u32 (*read)(void),
>> int bits, unsigned long rate)
>>      pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns,
>> wraps every %lluns\n",
>>          bits, r, r_unit, res, wrap);
>>  
>> -    /*
>> -     * Start the timer to keep sched_clock() properly updated and
>> -     * sets the initial epoch.
>> -     */
>> -    hrtimer_init(&sched_clock_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>> -    sched_clock_timer.function = sched_clock_poll;
>>      update_sched_clock();
>>  
>>      /*
>> @@ -175,6 +169,13 @@ void __init sched_clock_postinit(void)
>>          setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
>>  
>>      update_sched_clock();
>> +
>> +    /*
>> +     * Start the timer to keep sched_clock() properly updated and
>> +     * sets the initial epoch.
>> +     */
>> +    hrtimer_init(&sched_clock_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>> +    sched_clock_timer.function = sched_clock_poll;
>>      hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
>>  }
>>  
>>
> Hmm. Is it too early to use hrtimers? Moving the hrtimer_start() into
> sched_clock_register() also causes the same crash.

Yes that seems to be the problem. The vexpress board is setting up the
sched_clock in setup_arch() (via v2m_init_early) which runs before
hrtimers_init(). I've only tested this on boards that setup the timer in
the time_init() callback which runs after hrtimers_init(). Your patch
should be fine, although it would be nice if we didn't have callers
setting up the sched_clock so early.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

