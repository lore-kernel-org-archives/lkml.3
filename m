Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaIZKAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:00:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42284 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbaIZKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:00:28 -0400
Date: Fri, 26 Sep 2014 11:00:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
Message-ID: <20140926100025.GC4476@leverpostej>
References: <1410454801-14231-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410454801-14231-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 06:00:01PM +0100, Doug Anderson wrote:
> Some 32-bit (ARMv7) systems are architected like this:
> 
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
> 
> * The firmware isn't involved in SMP bringup or resume.
> 
> * The ARCH timer come up with an uninitialized offset between the
>   virtual and physical counters.  Each core gets a different random
>   offset.
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
> Let's add a property to the device tree to say that we shouldn't use
> the virtual timer.  Firmware could potentially remove this property
> before passing the device tree to the kernel if it really wants the
> kernel to use a virtual timer.
> 
> Note that it's been said that ARM64 (ARMv8) systems the firmware and
> kernel really can't be architected as described above.  That means
> using the physical timer like this really only makes sense for ARMv7
> systems.
> 
> In order for this patch to do anything useful, we also need Sonny's
> patch at <https://patchwork.kernel.org/patch/4790921/>
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
> Changes in v3:
> - Wording changes to bindings and patch desc as per Will Deacon
> 
> Changes in v2:
> - Add "#ifdef CONFIG_ARM" as per Will Deacon
> 
>  Documentation/devicetree/bindings/arm/arch_timer.txt | 6 ++++++
>  drivers/clocksource/arm_arch_timer.c                 | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 37b2caf..e28fced 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -22,6 +22,12 @@ to deliver its interrupts via SPIs.
>  - always-on : a boolean property. If present, the timer is powered through an
>    always-on power domain, therefore it never loses context.
>  
> +** Optional properties:
> +
> +- arm,use-physical-timer : Don't ever use the virtual timer, just use the
> +  physical one.  Only supported for ARM (not ARM64).

I'm still not keen on telling the kernel what to do rather than
describing the actual state of affairs and having the kernel decide what
to do. Perhaps what we actually need is:

- cntvoff-not-fw-configured: Firmware does not configure CNTVOFF, which
  may reset to (different) arbitrary values on each CPU.

This also doesn't describe that CNTHCTL.PL1PC(T)EN must both be 1. While
that is the reset state, it still feels dodbgy to me to rely on that.

Mark.

> +
> +
>  Example:
>  
>  	timer {
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 5163ec1..e7aa256 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -649,6 +649,11 @@ static void __init arch_timer_init(struct device_node *np)
>  		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
>  	arch_timer_detect_rate(NULL, np);
>  
> +#ifdef CONFIG_ARM
> +	if (of_property_read_bool(np, "arm,use-physical-timer"))
> +		arch_timer_use_virtual = false;
> +#endif
> +
>  	/*
>  	 * If HYP mode is available, we know that the physical timer
>  	 * has been configured to be accessible from PL1. Use it, so
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> 
