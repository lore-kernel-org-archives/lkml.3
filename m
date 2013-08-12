Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3HLQXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:23:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57932 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3HLQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:23:39 -0400
Message-ID: <52090C0A.2000105@codeaurora.org>
Date: Mon, 12 Aug 2013 09:23:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: srinivas.kandagatla@st.com, S??ren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <51F97CE3.9030306@linaro.org> <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local> <51F99747.4060901@linaro.org> <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local> <51FA9AE8.1060004@linaro.org> <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local> <51FA9F54.3060704@linaro.org> <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local> <5204C54A.9020105@st.com> <5204FA5D.3060908@linaro.org> <20130809172757.GD14845@codeaurora.org> <5208BEC4.7090700@linaro.org>
In-Reply-To: <5208BEC4.7090700@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/13 03:53, Daniel Lezcano wrote:
> On 08/09/2013 07:27 PM, Stephen Boyd wrote:
>> On 08/09, Daniel Lezcano wrote:
>>> yes, but at least the broadcast mechanism should send an IPI to cpu0 to
>>> wake it up, no ? As Stephen stated this kind of configuration should has
>>> never been tested before so the tick broadcast code is not handling this
>>> case properly IMHO.
>>>
>> If you have a per-cpu tick device that isn't suffering from
>> FEAT_C3_STOP why wouldn't you use that for the tick versus a
>> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
>> is a bug in the preference logic or you should boost the rating
>> of the arm global timer above the twd. Does this patch help? It
>> should make the arm global timer the tick device and whatever the
>> cadence timer you have into the broadcast device.
>>
>> ---8<----
>> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>> index 218bcb5..d3539e5 100644
>> --- a/kernel/time/tick-broadcast.c
>> +++ b/kernel/time/tick-broadcast.c
>> @@ -77,6 +77,9 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
>>  	    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
>>  		return false;
>>  
>> +	if (cpumask_equal(newdev->cpumask, cpumask_of(smp_processor_id())))
>> +		return false;
> Yes, that makes sense to prevent local timer devices to be a broadcast one.
>
> In the case of the arm global timer, each cpu will register their timer,
> so the test will be ok but is it possible the cpu0 registers the timers
> for the other cpus ?

As far as I know every tick device has to be registered on the CPU that
it will be used on. See tick_check_percpu().

>
>>  	return !curdev || newdev->rating > curdev->rating;
>>  }
>>  
>> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
>> index 64522ec..1628b9f 100644
>> --- a/kernel/time/tick-common.c
>> +++ b/kernel/time/tick-common.c
>> @@ -245,6 +245,15 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
>>  	}
>>  
>>  	/*
>> +	 * Prefer tick devices that don't suffer from FEAT_C3_STOP
>> +	 * regardless of their rating
>> +	 */
>> +	if (curdev && cpumask_equal(curdev->cpumask, newdev->cpumask) &&
>> +	    !(newdev->features & CLOCK_EVT_FEAT_C3STOP) &&
>> +	    (curdev->features & CLOCK_EVT_FEAT_C3STOP))
>> +		return true;
> That sounds reasonable, but what is the acceptable gap between the
> ratings ? I am wondering if there isn't too much heuristic in the tick
> code...

Yes I wonder if we should just change the ratings of the clockevents.
But it feels to me like the rating should only matter if the two are
equal in features. Otherwise we can use the features to determine what
we want.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

