Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab3DIQt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:49:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31629 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab3DIQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:49:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="36927681"
Message-ID: <51644697.2010707@codeaurora.org>
Date: Tue, 09 Apr 2013 09:49:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 01/11] clockevents: Prefer CPU local devices over global
 devices
References: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org> <1365456453-16297-2-git-send-email-sboyd@codeaurora.org> <20130409103303.GV23725@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130409103303.GV23725@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/13 03:33, Mark Rutland wrote:
> On Mon, Apr 08, 2013 at 10:27:23PM +0100, Stephen Boyd wrote:
>> On an SMP system with only one global clockevent and a dummy
>> clockevent per CPU we run into problems. We want the dummy
>> clockevents to be registered as the per CPU tick devices, but
>> we can only achieve that if we register the dummy clockevents
>> before the global clockevent or if we artificially inflate the
>> rating of the dummy clockevents to be higher than the rating
>> of the global clockevent. Failure to do so leads to boot
>> hangs when the dummy timers are registered on all other CPUs
>> besides the CPU that accepted the global clockevent as its tick
>> device and there is no broadcast timer to poke the dummy
>> devices.
>>
>> If we're registering multiple clockevents and one clockevent is
>> global and the other is local to a particular CPU we should
>> choose to use the local clockevent regardless of the rating of
>> the device. This way, if the clockevent is a dummy it will take
>> the tick device duty as long as there isn't a higher rated tick
>> device and any global clockevent will be bumped out into
>> broadcast mode, fixing the problem described above.
> It might be worth pointing out that if dummy timers are only registered
> when there's more than one CPU, UP behaviour won't degrade from the
> current state of affairs.

Sure, I'll try to come up with something if I have to repost (looks like
I might have to rework the mct change).

>
>> Reported-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  kernel/time/tick-common.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
>> index b1600a6..9ea59b9 100644
>> --- a/kernel/time/tick-common.c
>> +++ b/kernel/time/tick-common.c
>> @@ -251,9 +251,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
>>  		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
>>  			goto out_bc;
>>  		/*
>> -		 * Check the rating
>> +		 * Check the rating, but prefer CPU local devices
>>  		 */
>> -		if (curdev->rating >= newdev->rating)
>> +		if (curdev->rating >= newdev->rating &&
>> +		    cpumask_equal(curdev->cpumask, newdev->cpumask))
>>  			goto out_bc;
>>  	}
> This looks good to me. I tested this on a TC2 with a v3.9-rc6 kernel
> without architected timer support. The patch restores the ability to use
> the sp804 as a broadcast source.
>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
>
> If possible I think this should sit in -next for a bit to make sure it
> doesn't have any unexpected side effects.

Thanks for testing.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

