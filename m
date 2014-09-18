Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaIRAWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:22:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65142 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaIRAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:22:53 -0400
Message-ID: <541A25DA.8030101@linaro.org>
Date: Wed, 17 Sep 2014 17:22:50 -0700
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Menon, Nishanth" <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Kristo, Tero" <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J, KEERTHY" <j-keerthy@ti.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
References: <1408716154-26101-1-git-send-email-nm@ti.com> <1408716154-26101-9-git-send-email-nm@ti.com>,<5419D7BD.30003@linaro.org> <448912EABC71F84BBCADFD3C67C4BE52CAC748@DBDE04.ent.ti.com>
In-Reply-To: <448912EABC71F84BBCADFD3C67C4BE52CAC748@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 04:20 PM, Shilimkar, Santosh wrote:
> Sorry for the format. Emailing from webmail.
> ________________________________________

[ ... ]

>> +static int omap_enter_idle_smp(struct cpuidle_device *dev,
>> +                            struct cpuidle_driver *drv,
>> +                            int index)
>> +{
>> +     struct idle_statedata *cx = state_ptr + index;
>> +     unsigned long flag;
>> +
>> +     raw_spin_lock_irqsave(&mpu_lock, flag);
>
> Why do you need this spin_lock_irqsave ? Aren't the local irqs already
> disabled ?
>
> [Santosh] Actually at one point of time before the idle consolidation the local
> irq disable was inside the idle drivers. Now with that moved to core layer,
> I think plain spin_lock/unlock() should work.

ok.

>> +     cx->mpu_state_vote++;
>> +     if (cx->mpu_state_vote == num_online_cpus()) {
>> +             pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
>> +             omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
>> +     }
>> +     raw_spin_unlock_irqrestore(&mpu_lock, flag);
>> +
>> +     omap4_enter_lowpower(dev->cpu, cx->cpu_state);
>> +
>> +     raw_spin_lock_irqsave(&mpu_lock, flag);
>> +     if (cx->mpu_state_vote == num_online_cpus())
>> +             omap_set_pwrdm_state(mpu_pd, PWRDM_POWER_ON);
>> +     cx->mpu_state_vote--;
>> +     raw_spin_unlock_irqrestore(&mpu_lock, flag);
>
> I am not sure that will work. What happens if a cpu exits idle and then
> re-enter idle immediately ?
>
> [Santosh] It works and that case is already taken care. CPU exist the idle and then votes
> out for cluster state and if it reenters with the right targeted state, the cluster state would
> be picked.

It isn't possible to have one cpu disabling the coherency, while the 
other one is looking for a lock ? Or eg. cpu0 is on WFI then cpu1 is the 
last entering idle. While cpu1 is entering 'lowpower', cpu0 exits the 
wfi check the state vote and set the power domain on. In the meantime 
cpu1 disables the coherency and cpu0 decrease the vote and release the 
lock. Could be possible there is a very small racy window here ?

> Could you try a long run of this little program:
>
> https://git.linaro.org/power/pm-qa.git/blob/HEAD:/cpuidle/cpuidle_killer.c
>
> [Santosh] I am sure there will not be any issue with the long run test case here.
> Lets see if Nishant sees anything otherwise

Ok. Make sure the cpu is effectively entering your C2 state with the 
sleep duration in the test program.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

