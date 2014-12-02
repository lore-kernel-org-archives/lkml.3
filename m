Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbaLBMNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:13:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38176 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932837AbaLBMNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:13:14 -0500
Date: Tue, 2 Dec 2014 12:13:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "olof@lixom.net" <olof@lixom.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 14/19] arm64: dts: exynos: Add dts files for 64-bit
 Exynos5433 SoC
Message-ID: <20141202121310.GH23671@leverpostej>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
 <1417510196-6714-15-git-send-email-cw00.choi@samsung.com>
 <20141202110909.GB23671@leverpostej>
 <547DA818.2050908@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547DA818.2050908@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >> +       psci {
> >> +               compatible = "arm,psci";
> >> +               method = "smc";
> >> +               cpu_off = <0x84000002>;
> >> +               cpu_on = <0xC4000003>;
> >> +       };
> >
> > Given your comments on the latest posting, has CPU_OFF been tested, and
> > does it work for _all_ CPUs (including CPU0)?
> 
> At current version,
> CPU_OFF of Exynos5433 is not working. I'm now working to find the cause of CPU_OFF fail.
> (I got CPU_ON of Exynos5433 all cores.)

CPU_OFF should not be described in the DT unless it works.

[...]

> >> +       soc: soc {
> >> +               compatible = "simple-bus";
> >> +               #address-cells = <1>;
> >> +               #size-cells = <1>;
> >> +               ranges;
> >
> > Is that valid when changing the number of cells? The address spaces
> > aren't strictly identical in that case, and I'd expect a translation
> > something like:
> >
> >         ranges = <0x0 0x0 0x0 0xff000000>;
> 
> I'll fix it after checking correct spec.

Thanks.

[...]

> >> +               gic:interrupt-controller@11001000 {
> >> +                       compatible = "arm,gic-400";
> >> +                       #interrupt-cells = <3>;
> >> +                       interrupt-controller;
> >> +                       reg =   <0x11001000 0x1000>,
> >> +                               <0x11002000 0x1000>,
> >> +                               <0x11004000 0x2000>,
> >> +                               <0x11006000 0x2000>;
> >> +                       interrupts = <1 9 0xf04>;
> >> +               };
> >
> > The GICC needs to be 0x2000 long to map the GICC_DIR, which is at
> > 0x1000-0x1003.
> 
> Do you mean that following dt node is right for gic-400?
> 
>                 reg =   <0x11001000 0x1000>,
>                         <0x11002000 0x2000>,    <- I changed the the range of GICC.
>                         <0x11004000 0x2000>,
>                         <0x11006000 0x2000>;

Yes.

[...]

> >> +               pinctrl_alive: pinctrl@10580000 {
> >> +                       compatible = "samsung,exynos5433-pinctrl";
> >> +                       reg = <0x10580000 0x1000>;
> >> +
> >> +                       wakeup-interrupt-controller {
> >> +                               compatible = "samsung,exynos7-wakeup-eint";
> >> +                               interrupts = <0 16 0>;
> >> +                       };
> >> +               };
> >
> > How exactly does the wakeup interrupt controller interact with the GIC?
> > Surely the relationship between the two should be described?
> 
> The pinctrl_alive contains the alive part of GPIO PAD (gpa0~gpa3).
> 
> The each GPA0/GPA1 of pinctrl_alive pad did map to unique SPI number of GIC
> amd GPA2/GPA3 use only one interrupt (SPI[16])  as following:
> 
>         +&pinctrl_alive {
>         +       gpa0: gpa0 {
>         +               gpio-controller;
>         +               #gpio-cells = <2>;
>         +
>         +               interrupt-controller;
>         +               interrupt-parent = <&gic>;
>         +               interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
>         +                            <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>;
>         +               #interrupt-cells = <2>;
>         +       };
>         +
>         +       gpa1: gpa1 {
>         +               gpio-controller;
>         +               #gpio-cells = <2>;
>         +
>         +               interrupt-controller;
>         +               interrupt-parent = <&gic>;
>         +               interrupts = <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
>         +                            <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>;
>         +               #interrupt-cells = <2>;
>         +       };
> 
>         gpa0-0 - SPI[0]
>         gpa0-1 - SPI[1]
>         gpa0-2 - SPI[2]
>         gpa0-3 - SPI[3]
>         gpa0-4 - SPI[4]
>         gpa0-5 - SPI[5]
>         gpa0-6 - SPI[6]
>         gpa0-7 - SPI[7]
> 
>         gpa1-0 - SPI[8]
>         gpa1-1 - SPI[9]
>         gpa1-2 - SPI[10]
>         gpa1-3 - SPI[11]
>         gpa1-4 - SPI[12]
>         gpa1-5 - SPI[13]
>         gpa1-6 - SPI[14]
>         gpa1-7 - SPI[15]
> 
>         GPA2/GPA3 use only one interrupt (SPI[16]).
> 
> The pinctrl-exynos.c driver initialized external wakeup interrupt
> (e.g., GPA0/GPA1/GPA2/GPA3 of Exynos5433) in exynos_eint_wkup_init() function.
> 
> Following patch[1] adds the control for Exynos5433 wakeup irq.The exynos5433_pin_ctrl structure
> includes '.eint_wkup_init = exynos_eint_wkup_init;' fields to handle wakeup interrupt of Exynos SoC.
> 
> [PATCHv2] pinctrl: exynos: Add support for Exynos543
> - https://lkml.org/lkml/2014/12/2/207
> 
>         +struct samsung_pin_ctrl exynos5433_pin_ctrl[] = {
>         +       {
>         +               /* pin-controller instance 0 data */
>         +               .pin_banks      = exynos5433_pin_banks0,
>         +               .nr_banks       = ARRAY_SIZE(exynos5433_pin_banks0),
>         +               .eint_wkup_init = exynos_eint_wkup_init,
>         +               .suspend        = exynos_pinctrl_suspend,
>         +               .resume         = exynos_pinctrl_resume,
>         +               .label          = "exynos5433-gpio-ctrl0",
>         +       }, {
> 
> And,
> 'struct exynos_irq_chip exynos7_wkup_irq_chip' handles the external interrupt of Exynos5433 SoC
> because Exynos5433 is the same with Exynos7 EINT (External Interrupt) register offset.
> 
> We can check it following patch[1] to control wakeup interrupt for Exynos7/Exynos5433.
> - [1] [patch] pinctrl: exynos: Add irq_chip instance for Exynos7 wakeup interrupts
>   https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-pinctrl.git/commit/?h=for-next&id=14c255d35b25126149fb2fd199b030404229af65
> 
> 
>         +static struct exynos_irq_chip exynos7_wkup_irq_chip __initdata = {
>         + .chip = {
>         + .name = "exynos7_wkup_irq_chip",
>         + .irq_unmask = exynos_irq_unmask,
>         + .irq_mask = exynos_irq_mask,
>         + .irq_ack = exynos_irq_ack,
>         + .irq_set_type = exynos_irq_set_type,
>         + .irq_set_wake = exynos_wkup_irq_set_wake,
>         + .irq_request_resources = exynos_irq_request_resources,
>         + .irq_release_resources = exynos_irq_release_resources,
>         + },
>         + .eint_con = EXYNOS7_WKUP_ECON_OFFSET,
>         + .eint_mask = EXYNOS7_WKUP_EMASK_OFFSET,
>         + .eint_pend = EXYNOS7_WKUP_EPEND_OFFSET,
>         +};
> 
> If happen external interrupt by pressing power button, the ops of 'struct exynos_irq_chip exynos7_wkup_irq_chip'
> would handle the interrupt.
> 
> For exampl, If I use following GPAx as interrupt, I can check it on the result of /proc/interrupts.
>         gpa2-7 - power key
>         gpa2-0 - volume-up key
>         gpa2-1 - volume-up key
>         gpa0-7 - s2mps13 pmic irq
> 
> 'exynos7_wkup_irq_chip' would handle the external interrupt(gpa).
> 
> #cat /proc/interrupts
>   1:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   0  volume-up key
>   2:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   1  volume-down key
>   7:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   7  s2mps13
>   8:          0          0          0          0          0          0          0  exynos7_wkup_irq_chip   7  power key
> 
> 
> IMHO,
> Happen SPI -> GIC -> Cortex-A57/Cortex-A53 -> pinctrl-exynos.c -> exynos7_wkup_irq_chip -> irq handling

So physically interrupts are fed into the wakeup IRQ chip, which routes
them to the GIC? And we describe such in DT, as opposed to pretending
interrupts are fed straight into the GIC, and bolting the wakeup
controller on the side?

If so, that sounds fine to me.

Thanks,
Mark.
