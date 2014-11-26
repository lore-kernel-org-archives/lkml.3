Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaKZOlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:41:40 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41918 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbaKZOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:41:38 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4] clocksource: arch_timer: Allow the device tree to
 specify uninitialized timer registers
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Sonny Rao <sonnyrao@chromium.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
In-Reply-To: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org>
References: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Nov 2014 22:41:33 +0800
Message-ID: <1417012893.12707.12.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 15:33 +0800, Sonny Rao wrote:
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
> Note that it's been said that on ARMv8 systems the firmware and
> kernel really can't be architected as described above.  That means
> using the physical timer like this really only makes sense for ARMv7
> systems.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> ---
> Changes in v2:
> - Add "#ifdef CONFIG_ARM" as per Will Deacon
> 
> Changes in v3:
> - change property name to arm,cntvoff-not-fw-configured and specify
>   that the value of CNTHCTL.PL1PC(T)EN must still be the reset value
>   of 1 as per Mark Rutland
> 
> Changes in v4:
> - change property name to arm,cpu-registers-not-fw-configured and
>   specify that all cpu registers must have architected reset values
>   per Mark Rutland
> - change from "#ifdef CONFIG_ARM" to "if (IS_ENABLED(CONFIG_ARM))" per
>   Arnd Bergmann
> ---
>  Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++++++
>  drivers/clocksource/arm_arch_timer.c                 | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 37b2caf..256b4d8 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -22,6 +22,14 @@ to deliver its interrupts via SPIs.
>  - always-on : a boolean property. If present, the timer is powered through an
>    always-on power domain, therefore it never loses context.
> 
> +** Optional properties:
> +
> +- arm,cpu-registers-not-fw-configured : Firmware does not initialize
> +  any of the generic timer CPU registers, which contain their
> +  architecturally-defined reset values. Only supported for 32-bit
> +  systems which follow the ARMv7 architected reset values.
> +
> +

Hi,

Sorry for the (very) late reply.
I just realize today MT8135 need this and the other patch [1] to boot
SMP correctly. I've applied both patches and they works fine. Thanks :)

However, I'm not sure if we really need to add new property.
arm_arch_timer driver will only use virtual timer when virtual PPI
interrupt is provided, so the following patch to timer dtsi will also
works. I think if the firmware doesn't support virtual timer, it make
sense to not supply virtual interrupt.

        timer {
                compatible = "arm,armv7-timer";
                interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
-                            <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
-                            <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-                            <GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+                            <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>;
                clock-frequency = <13000000>;
        };

Joe.C

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305436.html


