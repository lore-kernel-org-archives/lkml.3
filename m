Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaCQEs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:48:28 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36311 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaCQEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:48:23 -0400
Date: Sun, 16 Mar 2014 21:48:30 -0700
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: zynq: Add OCM driver
Message-ID: <20140317044830.GA18269@quad.lixom.net>
References: <299e37ab245da9132808c6d4265a17b9a417bf62.1389022555.git.michal.simek@xilinx.com>
 <CAOesGMiroyjPbcjfG24_sUqCicCD4M7NF2aD=Xi8NVgagZThuA@mail.gmail.com>
 <53204C73.5070807@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53204C73.5070807@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:00:51PM +0100, Michal Simek wrote:
> Hi Olof,
> 
> >> diff --git a/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt
> >> new file mode 100644
> >> index 0000000..64cb5e8
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocm.txt
> >> @@ -0,0 +1,17 @@
> >> +Device tree bindings for Zynq's OCM
> >> +
> >> +The OCM is divided to 4 64kB segments which can be separately configured
> >> +to low or high location. Location is controlled via SLCR.
> >> +
> >> +Required properties:
> >> + compatible: Compatibility string. Must be "xlnx,zynq-ocm-1.0".
> >> + reg: Specify the base and size of the OCM registers in the memory map.
> >> +      E.g.: reg = <0xf800c000 0x1000>;
> >> +
> >> +Example:
> >> +ocmc: ocmc@f800c000 {
> >> +       compatible =  "xlnx,zynq-ocm-1.0";
> >> +       interrupt-parent = <&intc>;
> >> +       interrupts = <0 3 4>;
> >> +       reg = <0xf800c000 0x1000>;
> >> +} ;
> >> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> >> index 1d942e2..4929be5 100644
> >> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> >> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> >> @@ -66,6 +66,13 @@
> >>                         cache-level = <2>;
> >>                 };
> >>
> >> +               ocmc: ocmc@f800c000 {
> >> +                       compatible = "xlnx,zynq-ocm-1.0";
> >> +                       interrupt-parent = <&intc>;
> >> +                       interrupts = <0 3 4>;
> >> +                       reg = <0xf800c000 0x1000>;
> >> +               } ;
> >> +
> >>                 uart0: uart@e0000000 {
> >>                         compatible = "xlnx,xuartps";
> >>                         status = "disabled";
> >> diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
> >> index 323e505..f3e6ce4 100644
> >> --- a/arch/arm/mach-zynq/Kconfig
> >> +++ b/arch/arm/mach-zynq/Kconfig
> >> @@ -15,5 +15,6 @@ config ARCH_ZYNQ
> >>         select CADENCE_TTC_TIMER
> >>         select ARM_GLOBAL_TIMER
> >>         select MFD_SYSCON
> >> +       select GENERIC_ALLOCATOR
> >>         help
> >>           Support for Xilinx Zynq ARM Cortex A9 Platform
> >> diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> >> index 1b25d92..626f64b 100644
> >> --- a/arch/arm/mach-zynq/Makefile
> >> +++ b/arch/arm/mach-zynq/Makefile
> >> @@ -3,7 +3,7 @@
> >>  #
> >>
> >>  # Common support
> >> -obj-y                          := common.o slcr.o
> >> +obj-y                          := common.o slcr.o zynq_ocm.o
> >>  CFLAGS_REMOVE_hotplug.o                =-march=armv6k
> >>  CFLAGS_hotplug.o               =-Wa,-march=armv7-a -mcpu=cortex-a9
> >>  obj-$(CONFIG_HOTPLUG_CPU)      += hotplug.o
> >> diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> >> index b097844..953f6a1 100644
> >> --- a/arch/arm/mach-zynq/common.h
> >> +++ b/arch/arm/mach-zynq/common.h
> >> @@ -24,6 +24,7 @@ extern int zynq_early_slcr_init(void);
> >>  extern void zynq_slcr_system_reset(void);
> >>  extern void zynq_slcr_cpu_stop(int cpu);
> >>  extern void zynq_slcr_cpu_start(int cpu);
> >> +extern u32 zynq_slcr_get_ocm_config(void);
> >>
> >>  #ifdef CONFIG_SMP
> >>  extern void secondary_startup(void);
> >> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
> >> index c1f1499..9a37ab3 100644
> >> --- a/arch/arm/mach-zynq/slcr.c
> >> +++ b/arch/arm/mach-zynq/slcr.c
> >> @@ -26,6 +26,7 @@
> >>  #define SLCR_PS_RST_CTRL_OFFSET                0x200 /* PS Software Reset Control */
> >>  #define SLCR_A9_CPU_RST_CTRL_OFFSET    0x244 /* CPU Software Reset Control */
> >>  #define SLCR_REBOOT_STATUS_OFFSET      0x258 /* PS Reboot Status */
> >> +#define SLCR_OCM_CFG_OFFSET            0x910 /* OCM Address Mapping */
> >>
> >>  #define SLCR_UNLOCK_MAGIC              0xDF0D
> >>  #define SLCR_A9_CPU_CLKSTOP            0x10
> >> @@ -107,6 +108,20 @@ void zynq_slcr_system_reset(void)
> >>  }
> >>
> >>  /**
> >> + * zynq_slcr_get_ocm_config - Get SLCR OCM config
> >> + *
> >> + * return:     OCM config bits
> >> + */
> >> +u32 zynq_slcr_get_ocm_config(void)
> >> +{
> >> +       u32 val;
> >> +
> >> +       zynq_slcr_read(&val, SLCR_OCM_CFG_OFFSET);
> >> +
> >> +       return val;
> >> +}
> >> +
> >> +/**
> >>   * zynq_slcr_cpu_start - Start cpu
> >>   * @cpu:       cpu number
> >>   */
> >> diff --git a/arch/arm/mach-zynq/zynq_ocm.c b/arch/arm/mach-zynq/zynq_ocm.c
> >> new file mode 100644
> >> index 0000000..034a65b
> >> --- /dev/null
> >> +++ b/arch/arm/mach-zynq/zynq_ocm.c
> >> @@ -0,0 +1,243 @@
> >> +/*
> >> + * Copyright (C) 2013 Xilinx
> >> + *
> >> + * Based on "Generic on-chip SRAM allocation driver"
> > 
> > We're not adding new drivers under arch/arm, so if you need this
> > driver then you should either merge it under drivers/ somewhere, or
> > look at extending the generic driver in a way that you can reuse it.
> 
> Driver is reusing ideas from this generic driver but
> incorporation our changes to will be problematic.
> 
> It is a shame that you didn't review the rest of code below.
> The reason why I have added this driver to arch/arm/mach-zynq
> was that there is code connection to zynq SMP bootup trampoline
> which has to be added at 0x0 when OCM is placed at 0x0.
> And this memory can't be used for generic purpose.
> If you see any nice way how to it please let me know.

Rockchip just went through some of the same discussions -- they need to
use onchip SRAM for SMP spin-up. You should look at that patchset and
see if you can solve it in a similar manner, the needs seem to be quite
similar.


-Olof
