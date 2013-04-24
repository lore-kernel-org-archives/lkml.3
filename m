Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3DXOvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:51:53 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46371 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab3DXOvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:51:51 -0400
Message-ID: <5177F182.8050200@imgtec.com>
Date: Wed, 24 Apr 2013 15:51:46 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/8] metag: minimal TZ1090 (Comet) SoC infrastructure
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-3-git-send-email-james.hogan@imgtec.com> <201304231725.34826.arnd@arndb.de> <5176B173.40107@imgtec.com> <CAHkRjk4A5bM=Xsf=DA+OMt0M_e4Y-3XkLPyJirxV4MQOWf25gQ@mail.gmail.com>
In-Reply-To: <CAHkRjk4A5bM=Xsf=DA+OMt0M_e4Y-3XkLPyJirxV4MQOWf25gQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_24_15_51_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 14:26, Catalin Marinas wrote:
> On 23 April 2013 17:06, James Hogan <james.hogan@imgtec.com> wrote:
>> On 23/04/13 16:25, Arnd Bergmann wrote:
>>> On Tuesday 23 April 2013, James Hogan wrote:
>>>
>>>> @@ -46,6 +46,12 @@ core-y                                    += arch/metag/boot/dts/
>>>>  core-y                                      += arch/metag/kernel/
>>>>  core-y                                      += arch/metag/mm/
>>>>
>>>> +# SoCs
>>>> +socdir-$(CONFIG_SOC_TZ1090)         += tz1090
>>>> +
>>>> +socdirs             := $(filter-out ., $(patsubst %,%/,$(socdir-y)))
>>>> +core-y              += $(addprefix arch/metag/soc/, $(socdirs))
>>>> +
>>>
>>> Does it actually make sense to have subdirectories per soc? I would
>>> suggest you copy from arm64 rather from arm for the platform support and
>>> do it as minimal as possible. Any code you need can go into a shared directory
>>> as a start, and if you end up needing more of a hierarchical structure,
>>> you can add that later. Hopefully we've come to the point now where almost
>>> everything can live in drivers/* though.
>>
>> Where is the shared directory for arm64 platforms? (arch/arm64 is
>> looking pretty bare).
> 
> There is no platform-specific code under arch/arm64/. SoC code is
> split into various subsystems under drivers/ and it lives there
> (including timers and irqchip). We have the SMP booting protocol but
> there is no reason why SoCs can't use a common one (or two) specified
> via DT (as it is the case of other SoC specific definitions).

Ah okay, thanks. That's what I've been aiming for as much as possible too.

>> It's certainly heading in that direction a lot. For this patchset I
>> could get away with dropping arch/metag/soc/*, and deal with anything
>> that really requires something like it later.
>>
>> The machine callbacks I was planning on using in future patches are:
>> * init_time() for calling into the appropriate common clock driver from
>> time_init(), prior to setting up the timer so that the right frequency
>> can be reported based on the clock hierarchy specified in DT. I guess
>> this could be made more general, allowing any enabled clock component to
>> be initialised at this time.
> 
> This is driven by DT on arm64, no need for platform callback (see
> drivers/clocksource/arch_arm_timer.c).

Right. The problem is that the frequency of the core clock in TZ1090
(and hence the arch timer that is derived from it) isn't discoverable in
an arch generic way. I can do something similar to tegra (see
tegra_clocks_init()) to init the common clk stuff early and then do:

node = of_find_compatible_node(NULL, NULL, "img,meta");
clk_core = of_clk_get_by_name(node, "core");
rate = clk_get_rate(clk_core);

>From time_init prior to setting up the arch timer, but I need a platform
callback for that.

> 
>> * init_irq(), for dynamically detecting evaluation silicon and if so
>> telling the interrupt controller that there are no mask registers (easy
>> to drop tbh since nobody uses TZ1090 evaluation silicon any longer).
> 
> Similarly, DT-driven (e.g. drivers/irqchip/irq-gic.c) with
> irqchip_init() called from the arm64 init_IRQ().

I could put that info in the DT for the irqchip, but it would mean
another variation (I thought the whole point of DT was to handle the
cases that can't be detected automatically).

> 
>> * probably something for setting up power management (suspend to ram /
>> standby and associated asm code), which would also be used by some
>> TZ1090 based boards requiring their own power management variations.
> 
> If you can separate the CPU-specific power management (like cache
> flushing, MMU off) from the SoC part, you can place the SoC under
> drivers/power/reset/. We currently moved the vexpress there, though it
> is not a complete example for power management. We'll see when we get
> more platforms.

Cool, that looks like a good place for the power stuff.

Thanks
James

