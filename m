Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3HVRtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:49:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41256 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3HVRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:49:08 -0400
Message-ID: <52164EEE.9070707@ti.com>
Date: Thu, 22 Aug 2013 13:48:30 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, <srinivas.kandagatla@st.com>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] clockevents: Prefer clockevents that don't suffer
 from FEAT_C3_STOP
References: <52138784.7050703@linaro.org> <1377191201-14696-1-git-send-email-sboyd@codeaurora.org> <1377191201-14696-2-git-send-email-sboyd@codeaurora.org> <52164B5B.5010902@ti.com> <52164CF5.20705@codeaurora.org>
In-Reply-To: <52164CF5.20705@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 August 2013 01:40 PM, Stephen Boyd wrote:
> On 08/22/13 10:33, Santosh Shilimkar wrote:
>> On Thursday 22 August 2013 01:06 PM, Stephen Boyd wrote:
>>> On some ARM systems there are two sets of per-cpu timers: the TWD
>>> timers and the global timers. The TWD timers are rated at 350 and
>>> the global timers are rated at 300 but the TWD timers suffer from
>>> FEAT_C3_STOP while the arm global timers don't. The tick device
>>> selection logic doesn't consider the FEAT_C3_STOP flag so we'll
>>> always end up with the TWD as the tick device although we don't
>>> want that.
>>>
>>> Extend the preference logic to take the FEAT_C3_STOP flag into
>>> account and always prefer tick devices that don't suffer from
>>> FEAT_C3_STOP even if their rating is lower than tick devices that
>>> do suffer from FEAT_C3_STOP. This will remove the need to do any
>>> broadcasting on such ARM systems.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>>  kernel/time/tick-common.c | 14 ++++++++++++--
>>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
>>> index 64522ec..3ae437d 100644
>>> --- a/kernel/time/tick-common.c
>>> +++ b/kernel/time/tick-common.c
>>> @@ -244,12 +244,22 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
>>>  			return false;
>>>  	}
>>>  
>>> +	if (!curdev)
>>> +		return true;
>>> +
>>> +	/* Always prefer a tick device that doesn't suffer from FEAT_C3STOP */
>>> +	if (!(newdev->features & CLOCK_EVT_FEAT_C3STOP) &&
>>> +			(curdev->features & CLOCK_EVT_FEAT_C3STOP))
>>> +		return true;
>>> +	if ((newdev->features & CLOCK_EVT_FEAT_C3STOP) &&
>>> +			!(curdev->features & CLOCK_EVT_FEAT_C3STOP))
>>> +		return false;
>>> +
>> I don't think preferring the clock-event which doesn't suffer
>> from FEAT_C3STOP is a good idea if the quality of the time source
>> is not same. Generally the global timers are slow and far away from
>> CPU(cycle cost). So as long as we don't get impacted because of low power
>> states, the tick should run out of local timers which are faster access
>> as well as high resolution.
>>
> 
> Fair enough. I have no data either way to convince anyone that this is a
> good or bad idea so this patch should have probably been an RFC. Are you
> hinting at something like switching to a per-cpu timer that doesn't
> suffer from FEAT_C3_STOP when a CPU goes into a deep idle state?
> Interesting idea but I think I'll leave that to someone else if they
> really care to do that.
> 
If the per-CPU timer don't suffer from C3_STOP, there is no need to
switch at all and the per CPU tick continue to runs on CPU local
timers. We need to switch to a broadcast device(no affected by C3_STOP)
only for the cases where the per-CPU timer wakeup don't work in CPU
low power states.

Are we talking about a hardware where one of the CPU from a cluster
has a local timer which is not affected by C3_STOP where as rest
of the CPU local timers are ? If yes, it must be crazy hardware and
we should not care too much about that.

Regards,
Santosh


