Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3LLMHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:07:50 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:54561 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3LLMHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:07:46 -0500
Message-ID: <52A9A711.1040002@linaro.org>
Date: Thu, 12 Dec 2013 13:07:45 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] time: Serialize calls to 'clockevents_update_freq'
 in the timing core
References: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de> <1386635686-15686-1-git-send-email-soren.brinkmann@xilinx.com> <1386635686-15686-2-git-send-email-soren.brinkmann@xilinx.com> <52A87799.8010300@linaro.org> <ba4dce4a-1332-4fd8-80de-41347bb5b7b2@TX2EHSMHS005.ehs.local>
In-Reply-To: <ba4dce4a-1332-4fd8-80de-41347bb5b7b2@TX2EHSMHS005.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 09:09 PM, Sören Brinkmann wrote:
> Hi Daniel,
>
> On Wed, Dec 11, 2013 at 03:32:57PM +0100, Daniel Lezcano wrote:
>> On 12/10/2013 01:34 AM, Soren Brinkmann wrote:
>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>
>>> We can identify the broadcast device in the core and serialize all
>>> callers including interrupts on a different CPU against the update.
>>> Also, disabling interrupts is moved into the core allowing callers to
>>> leave interrutps enabled when calling clockevents_update_freq().
>>>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>>   kernel/time/clockevents.c    | 29 ++++++++++++++++++++++-------
>>>   kernel/time/tick-broadcast.c | 25 +++++++++++++++++++------
>>>   kernel/time/tick-internal.h  |  4 ++++
>>>   3 files changed, 45 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>>> index 086ad6043bcb..641d91003a45 100644
>>> --- a/kernel/time/clockevents.c
>>> +++ b/kernel/time/clockevents.c
>>> @@ -439,6 +439,16 @@ void clockevents_config_and_register(struct clock_event_device *dev,
>>>   }
>>>   EXPORT_SYMBOL_GPL(clockevents_config_and_register);
>>>
>>> +int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
>>> +{
>>> +	clockevents_config(dev, freq);
>>> +
>>> +	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
>>> +		return 0;
>>> +
>>> +	return clockevents_program_event(dev, dev->next_event, false);
>>> +}
>>> +
>>
>> ./arch/arm/kernel/smp_twd.c should be modified to call
>> __clockevents_update_freq instead of clockevents_update_freq, no ?
>
> IIUC, the __-version is only for timer core internal usage and not an
> exported interface. Doesn't the non-__ version work for the twd?
> I don't see issues on my Zynq platform with these patches.

I don't think there is an issue but if we can rid of the extra code 
added in clockevents_update_freq with this patch for twd, it would make 
sense. The __-version means the function is lockless and there is a 
function without '__' in the name with the lock.

> Another side note regarding the twd: Shouldn't we set the
> CLOCK_EVT_FEAT_PERCPU flag we introduced recently for that timer?

Yes.

There will be some fun with the patchset http://lwn.net/Articles/566270/ 
where the local timer could be used as a broadcast timer.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

