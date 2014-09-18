Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaIRAnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:43:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32881 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbaIRAnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:43:23 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>, "Menon, Nishanth" <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Kristo, Tero" <t-kristo@ti.com>,
        "Paul Walmsley" <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J, KEERTHY" <j-keerthy@ti.com>,
        =?iso-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
Subject: RE: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
Thread-Topic: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
Thread-Index: AQHPvhG8IMkGuPSFcU+pa0gvRTGwoZwFd+aAgAClgO7//7eeAIAAYEWl
Date: Thu, 18 Sep 2014 00:42:48 +0000
Message-ID: <448912EABC71F84BBCADFD3C67C4BE52CAC8B9@DBDE04.ent.ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
 <1408716154-26101-9-git-send-email-nm@ti.com>,<5419D7BD.30003@linaro.org>
 <448912EABC71F84BBCADFD3C67C4BE52CAC748@DBDE04.ent.ti.com>,<541A25DA.8030101@linaro.org>
In-Reply-To: <541A25DA.8030101@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Daniel Lezcano [daniel.lezcano@linaro.org]
Sent: Wednesday, September 17, 2014 8:22 PM
To: Shilimkar, Santosh; Menon, Nishanth; Tony Lindgren; Kristo, Tero; Paul Walmsley
Cc: Kevin Hilman; linux-arm-kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; J, KEERTHY; Benoît Cousson
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support

On 09/17/2014 04:20 PM, Shilimkar, Santosh wrote:
> Sorry for the format. Emailing from webmail.
> ________________________________________

[ ... ]


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

[Santosh] The coherency isn't disable by CPU. Thats actually taken care by
hardware. CPU takes it own power domain down and takes itself out of
coherency. The Coherency is always ON as long as there is a CPU ON
and SMP bit on that CPU is enabled.

The scenario, you mentioned can never happen on this hardware thanks
to the inbuilt smart hardware.

If you have more questions, lets discuss. I am around here at connect. ;-)

Regards,
Santosh