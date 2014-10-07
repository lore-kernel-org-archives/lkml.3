Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaJGKWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:22:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52378 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256AbaJGKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:22:07 -0400
Date: Tue, 7 Oct 2014 11:21:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v3] clocksource: arch_timer: Allow the device tree to
 specify uninitialized CNTVOFF
Message-ID: <20141007102158.GA24725@leverpostej>
References: <1412663852-32681-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412663852-32681-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonny,

This looks generally fine, but there are a couple of minor changes below
that I would like to see (removing arm64/armv8 confusion, and describing
the problem more precisely).

On Tue, Oct 07, 2014 at 07:37:32AM +0100, Sonny Rao wrote:
> From: Doug Anderson <dianders@chromium.org>
> 
> Some 32-bit (ARMv7) systems are architected like this:
> 
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
> 
> * The firmware isn't involved in SMP bringup or resume.
> 
> * The ARCH timer come up with an uninitialized offset (CNTVOFF)
>   between the virtual and physical counters.  Each core gets a
>   different random offset.
> 
> * The device boots in "Secure SVC" mode.
> 
> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>   CNTHCTL.PL1PCTEN (both default to 1 at reset)
> 
> On systems like the above, it doesn't make sense to use the virtual
> counter.  There's nobody managing the offset and each time a core goes
> down and comes back up it will get reinitialized to some other random
> value.
> 
> This adds an optional property which can inform the kernel of this
> situation, and firmware is free to remove the property if it is going
> to initialize the CNTVOFF registers when each CPU comes out of reset.
> 
> Currently, the best course of action in this case is to use the
> physical timer, which is why it is important that CNTHCTL hasn't been
> changed from its reset value and it's a reasonable assumption given
> that the firmware has never entered HYP mode.
> 
> Note that it's been said that ARM64 (ARMv8) systems the firmware and
> kernel really can't be architected as described above.  That means
> using the physical timer like this really only makes sense for ARMv7
> systems.

Please drop the mention of arm64 here, and just say ARMv8 (they aren't
quite the same thing, and this confuses the matter). The differences
w.r.t. privilege boundaries and reset values are properties of ARMv8,
and would also apply to a 32-bit kernel.

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
> Changes in v2:
> - Add "#ifdef CONFIG_ARM" as per Will Deacon
> 
> Changes in v3:
> - change property name to arm,cntvoff-not-fw-configured and specify
>   that the value of CNTHCTL.PL1PC(T)EN must still be the reset value
>   of 1 as per Mark Rutland
> ---
>  Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++++++
>  drivers/clocksource/arm_arch_timer.c                 | 9 +++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 37b2caf..67837c9 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -22,6 +22,14 @@ to deliver its interrupts via SPIs.
>  - always-on : a boolean property. If present, the timer is powered through an
>    always-on power domain, therefore it never loses context.
>  
> +** Optional properties:
> +
> +- arm,cntvoff-not-fw-configured : Firmware does not initialize
> +  CNTVOFF, which may reset to arbitrary and different values on each
> +  CPU.  CNTHCTL.PL1PC(T)EN must both be 1, which is the reset value
> +  specificed by the architecture.   Only supported for ARM (not ARM64).

Could we change this to:

- arm,cpu-registers-not-fw-configured: Firmware does not initialize any
  of the generic timer CPU registers, which contain their
  architecturally-defined reset values. Only supported for 32-bit
  systems which follow the ARMv7 architected reset values.

That should match your case precisely, and we can derive the reset
values of CNTVOFF and CNTHCTL from the architecture.

> +
> +
>  Example:
>  
>  	timer {
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index bd8da15..234d7b9 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -668,6 +668,15 @@ static void __init arch_timer_init(struct device_node *np)
>  		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
>  	arch_timer_detect_rate(NULL, np);
>  
> +#ifdef CONFIG_ARM
> +	/*
> +	 * If we cannot rely on firmware initializing the CNTVOFF then
> +	 * we should use the physical timers instead.
> +	 */
> +	if (of_property_read_bool(np, "arm,cntvoff-not-fw-configured"))
> +		arch_timer_use_virtual = false;
> +#endif

This would need fixing up similarly to "arm,cpu-registers-not-fw-configured".

With that:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
