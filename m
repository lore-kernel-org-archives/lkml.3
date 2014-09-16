Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaIPQfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:35:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34934 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbaIPQfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:35:10 -0400
Message-ID: <541866A2.70007@ti.com>
Date: Tue, 16 Sep 2014 11:34:42 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: <daniel.lezcano@linaro.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Keerthy <j-keerthy@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, linux-pm <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
References: <1408716154-26101-1-git-send-email-nm@ti.com> <1408716154-26101-9-git-send-email-nm@ti.com> <7hvbpdbvb1.fsf@paris.lan> <CAGo_u6o7vAf=syzDTyxh0-kOhmzAmtdG_ardgFgoPQofrGdxUQ@mail.gmail.com> <53FE3477.2020207@ti.com> <7hegw1bs30.fsf@paris.lan> <20140905211847.GB31011@kahuna>
In-Reply-To: <20140905211847.GB31011@kahuna>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Daniel,

On 09/05/2014 04:18 PM, Nishanth Menon wrote:
> Daniel,
> 
> On 13:22-20140827, Kevin Hilman wrote:
>> Santosh Shilimkar <santosh.shilimkar@ti.com> writes:
>>
>>> On Wednesday 27 August 2014 03:35 PM, Nishanth Menon wrote:
>>>> On Wed, Aug 27, 2014 at 2:13 PM, Kevin Hilman
>>>> <khilman@deeprootsystems.com> wrote:
>>>>> + Daniel (cpuidle maintainer)
>>>> [...]
>>>>>> +static int omap_enter_idle_smp(struct cpuidle_device *dev,
>>>>>> +                            struct cpuidle_driver *drv,
>>>>>> +                            int index)
>>>>>> +{
>>>>>> +     struct idle_statedata *cx = state_ptr + index;
>>>>>> +     unsigned long flag;
>>>>>> +
>>>>>> +     raw_spin_lock_irqsave(&mpu_lock, flag);
>>>>>> +     cx->mpu_state_vote++;
>>>>>> +     if (cx->mpu_state_vote == num_online_cpus()) {
>>>>>> +             pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
>>>>>> +             omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
>>>>>> +     }
>>>>>> +     raw_spin_unlock_irqrestore(&mpu_lock, flag);
>>>>>> +
>>>>>> +     omap4_enter_lowpower(dev->cpu, cx->cpu_state);
>>>>>> +
>>>>>> +     raw_spin_lock_irqsave(&mpu_lock, flag);
>>>>>> +     if (cx->mpu_state_vote == num_online_cpus())
>>>>>> +             omap_set_pwrdm_state(mpu_pd, PWRDM_POWER_ON);
>>>>>> +     cx->mpu_state_vote--;
>>>>>> +     raw_spin_unlock_irqrestore(&mpu_lock, flag);
>>>>>> +
>>>>>> +     return index;
>>>>>> +}
>>>>>
>>>>> Hmm, maybe OMAP5/DRA7 CPUidle driver should be a new one based on MCPM?
>>>>
>>>> Trying to understand benefit of MCPM here - at least without a deeper
>>>> understanding of mcpm infrastructure benefits (first look seemed a
>>>> little heavy for OMAP5/DRA7 needs).
>>>>
>>>> Neither DRA7/OMAP5 are multi-cluster, the SoCs are not targetted for
>>>> "OFF" of CPU1/0, we have mercury hardware to help with context and
>>>> sync issues.
>>>>
>>>> Being able to reuse most of existing OMAP4 infrastructure code is
>>>> useful as well to leave the existing omap4 framework as being lighter
>>>> in complexity -esp in a cpuidle like hot path?
>>>>
>>>> The spin_lock is only for the programming of MPU power domain in a
>>>> consistent manner - I suppose might have been the trigger for
>>>> proposing mcpm?
>>>>
>>> Mostly not....
>>>
>>> I think this is coming because last time Nicolas Pitre tried to convert
>>> the OMAP CPUIdle into MCPM but because of various ordering requirements,
>>> OMAP wasn't suitable and then the plan was dropped later.
>>>
>>> Just to make clear, OMAP OMAP5/DRA7 as well the ordering requirement
>>> remains the same for deeper states. Its just the mercury retention state
>>> which we are able to enter without ordering requirements and hence
>>> the voting scheme.
>>
>> Ah, OK.  This is the part that I'm missing.  So for deeper states you'll
>> need to be using omap_enter_idle_coupled()
>>
>>> Hope this clarifies to you as well as Kevin just in case he missed the
>>> part of the deeper C-states requirements.
>>
>> Yes, thanks for clarifying.
>>
>> That being said, I think MCPM can now do essentially what the coupled
>> states code is doing. Even so, that's probably not a reason to hold up
>> this patch, but Daniel gets to make that call.
> 
> 
> Gentle ping.. You can find the discussion and the patch here:
> https://patchwork.kernel.org/patch/4764661/
> 

Ping on this again.. we are pretty close to approaching v3.18 merge
window and this discussion has'nt gotten further.

-- 
Regards,
Nishanth Menon
