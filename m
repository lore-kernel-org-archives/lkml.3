Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbaH0TfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:35:05 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34771 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935458AbaH0TfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:35:02 -0400
MIME-Version: 1.0
In-Reply-To: <7hvbpdbvb1.fsf@paris.lan>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
	<1408716154-26101-9-git-send-email-nm@ti.com>
	<7hvbpdbvb1.fsf@paris.lan>
Date: Wed, 27 Aug 2014 14:35:01 -0500
X-Google-Sender-Auth: gkEhf4mO_2DUyp4d6Op5hiw2Kh4
Message-ID: <CAGo_u6o7vAf=syzDTyxh0-kOhmzAmtdG_ardgFgoPQofrGdxUQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Keerthy <j-keerthy@ti.com>, daniel.lezcano@linaro.org,
        lkml <linux-kernel@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 2:13 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> + Daniel (cpuidle maintainer)
[...]
>> +static int omap_enter_idle_smp(struct cpuidle_device *dev,
>> +                            struct cpuidle_driver *drv,
>> +                            int index)
>> +{
>> +     struct idle_statedata *cx = state_ptr + index;
>> +     unsigned long flag;
>> +
>> +     raw_spin_lock_irqsave(&mpu_lock, flag);
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
>> +
>> +     return index;
>> +}
>
> Hmm, maybe OMAP5/DRA7 CPUidle driver should be a new one based on MCPM?

Trying to understand benefit of MCPM here - at least without a deeper
understanding of mcpm infrastructure benefits (first look seemed a
little heavy for OMAP5/DRA7 needs).

Neither DRA7/OMAP5 are multi-cluster, the SoCs are not targetted for
"OFF" of CPU1/0, we have mercury hardware to help with context and
sync issues.

Being able to reuse most of existing OMAP4 infrastructure code is
useful as well to leave the existing omap4 framework as being lighter
in complexity -esp in a cpuidle like hot path?

The spin_lock is only for the programming of MPU power domain in a
consistent manner - I suppose might have been the trigger for
proposing mcpm?

---
Regards,
Nishanth Menon
