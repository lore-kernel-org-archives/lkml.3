Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaIKQEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:04:16 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63244 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaIKQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <5411C68B.6090308@codeaurora.org>
References: <1410450727-8182-1-git-send-email-dianders@chromium.org>
	<5411C68B.6090308@codeaurora.org>
Date: Thu, 11 Sep 2014 09:04:11 -0700
X-Google-Sender-Auth: 56cta2MhH_FOYDKmeuCPSFWx57c
Message-ID: <CAD=FV=XPqma5sYbn65NLEAipZFq96t_HcX96ym_cEQrqTKddOQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Allow the device tree to specify
 the physical timer
From: Doug Anderson <dianders@chromium.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher,

On Thu, Sep 11, 2014 at 8:58 AM, Christopher Covington
<cov@codeaurora.org> wrote:
> Hi Doug,
>
> On 09/11/2014 11:52 AM, Doug Anderson wrote:
>> Some 32-bit (ARMv7) systems are architected like this:
>>
>> * The firmware doesn't know and doesn't care about hypervisor mode and
>>   we don't want to add the complexity of hypervisor there.
>>
>> * The firmware isn't involved in SMP bringup or resume.
>>
>> * The ARCH timer come up with an uninitialized offset between the
>>   virtual and physical counters.  Each core gets a different random
>>   offset.
>>
>> On systems like the above, it doesn't make sense to use the virtual
>> counter.  There's nobody managing the offset and each time a core goes
>> down and comes back up it will get reinitialized to some other random
>> value.
>>
>> Let's add a property to the device tree to say that we shouldn't use
>> the virtual timer.  Firmware could potentially remove this property
>> before passing the device tree to the kernel if it really wants the
>> kernel to use a virtual timer.
>>
>> Note that it's been said that ARM64 (ARMv8) systems the firmware and
>> kernel really can't be architected as described above.  That means
>> using the physical timer like this really only makes sense for ARMv7
>> systems.
>>
>> In order for this patch to do anything useful, we also need Sonny's
>> patch at <https://patchwork.kernel.org/patch/4790921/>
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>> ---
>>  Documentation/devicetree/bindings/arm/arch_timer.txt | 6 ++++++
>>  drivers/clocksource/arm_arch_timer.c                 | 3 +++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> index 37b2caf..876d32b 100644
>> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
>> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
>> @@ -22,6 +22,12 @@ to deliver its interrupts via SPIs.
>>  - always-on : a boolean property. If present, the timer is powered through an
>>    always-on power domain, therefore it never loses context.
>>
>> +** Optional properties:
>> +
>> +- arm,use-physical-timer : Don't ever use the virtual timer, just use the
>> +  physical one.  Not supported for ARM64.
>> +
>> +
>>  Example:
>>
>>       timer {
>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index 5163ec1..8ca07a9 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -649,6 +649,9 @@ static void __init arch_timer_init(struct device_node *np)
>>               arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
>>       arch_timer_detect_rate(NULL, np);
>>
>> +     if (of_property_read_bool(np, "arm,use-physical-timer"))
>> +             arch_timer_use_virtual = false;
>> +
>>       /*
>>        * If HYP mode is available, we know that the physical timer
>>        * has been configured to be accessible from PL1. Use it, so
>>
>
> How's the VDSO supposed to deal with this? It currently does:
>
> cycle_now = arch_counter_get_cntvct()

I don't see that line of code anywhere when I do a "git grep" on linux
or linuxnext.  Can you give me a clearer pointer?

Also, I just want to make sure you saw the part of the patch
description that says:
  In order for this patch to do anything useful, we also need Sonny's
  patch at <https://patchwork.kernel.org/patch/4790921/>

-Doug
