Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3FHBHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:07:47 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:65168 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3FHBHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <201306061826.19551.arnd@arndb.de>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com>
	<1726105.oKcjXShr89@wuerfel>
	<175CCF5F49938B4D99B2E3EF7F558EBE3B3BA09137@SC-VEXCH4.marvell.com>
	<201306061826.19551.arnd@arndb.de>
Date: Sat, 8 Jun 2013 09:07:45 +0800
Message-ID: <CADApbeixEKi984QED07LxA8vzfHmLGCGT8KxEbB5cqXzpW823Q@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Zhang <zhangwm@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Arnd
Thanks for your review.

On Fri, Jun 7, 2013 at 12:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 06 June 2013, Neil Zhang wrote:
>> > > diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
>> > > index ebdda83..0955191 100644
>> > > --- a/arch/arm/mach-mmp/Kconfig
>> > > +++ b/arch/arm/mach-mmp/Kconfig
>> > > @@ -107,6 +107,16 @@ config MACH_MMP2_DT
>> > >     Include support for Marvell MMP2 based platforms using
>> > >     the device tree.
>> > >
>> > > +config MACH_MMPX_DT
>> > > + bool "Support no-PJ/PJ4(ARMv7) platforms from device tree"
>> > > + depends on !CPU_MOHAWK && !CPU_PJ4
>> > > + select CPU_PXA988
>> > > + select USE_OF
>> > > + select PINCTRL
>> > > + select PINCTRL_SINGLE
>> >
>> > Why would this be mutually exclusive with PJ4? Cortex-A9 and PJ4 are both
>> > ARMv7 based, so we should be able to have them in the same kernel.
>>
>> The MACH_MMPX_DT here is for standard ARM core based SoC.
>> But PJ4 is modified by Marvell, which includes IWMMXT.
>
> That should not stop us from supporting them with the same kernel.
> We can already build a kernel that will work with IWMMXT on
> ArmadaXP (PJ4B) and Calxeda Highbank (Cortex-A9) for instance.
>
Yes. We can compile it, because will fail to boot up the core.
The correct way to adding device tree support for
iwmmx(arch/arm/kernel/pj4-cp0.c).
I think we can do it if you agree with us.

>> > __initdata = {
>> > >           .virtual        = (unsigned long)AXI_VIRT_BASE,
>> > >           .length         = AXI_PHYS_SIZE,
>> > >           .type           = MT_DEVICE,
>> > > - },
>> > > + }, {
>> > > +         .pfn            = __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
>> > > +         .virtual        = (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
>> > > +         .length         = MMP_CORE_PERIPH_PHYS_SIZE,
>> > > +         .type           = MT_DEVICE,
>> > > + }
>> > >  };
>> > >
>> > >  void __init mmp_map_io(void)
>> >
>> > What is this needed for?
>>
>> This function is used to static map the device registers.
>
> I understand what map_io does. Why do you need a static mapping?
>

The AXI and APB bus register mapping, It does not need to be static mapping.
Because we define the registers for each peripharals in device tree.
The device driver can map it.
There is a exception. The address space used by core for example CPU
SCU registers for CA9.
We have to read/write the registers even device tree has not been
build up in kernel, for example ->smp_prepare_cpus.
At this point, how can we get the base address for SCU?

>> > > +/* PXA988 */
>> > > +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst
>> > = {
>> > > + OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0",
>> > NULL),
>> > > + OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1",
>> > NULL),
>> > > + OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2",
>> > NULL),
>> > > + OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0",
>> > NULL),
>> > > + OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1",
>> > NULL),
>> > > + OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
>> > > + OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
>> > > + {}
>> > > +};
>> >
>> > Why do you need auxdata?
>>
>> Two reasons:
>> 1. some of the device still need platform data at this time.
>
> None of the ones above do apparently.
>
Now, some devices are not added. For example, USB.
I am trying to modify the USB driver to make it support device tree.
For example, separate the phy and PMIC support from USB driver.
The patches have been reviewed in USB maillist for a long time.
Now it is hold because the maintainer think HCD and PHY need do some fix.
So as a temporaty solution before us pushing USB patches, we have to
use platform data for USB.

>> 2. we use device name as clk name.
>> Will change it later, but need some time.
>
> If you have no platform_data, I think you should modify the clkdev
> lookup table to refer to the DT based names so you no longer have
> to pass auxdata.
>
> The long term solution of course is to describe the clocks in the
> device tree as well.
>
Thanks for your comments. Now we are doing the clock tree changing.
Haojian has sent some patches adding device tree support for clock
tree, but pxa988 are not included.
We will do the clock changes for pxa988 after Haojian's patches been
reviewed and merged.

I hope that we can fully support device tree for pxa988 and the next
generation SOCes including all the peripahrals.
In our local code base for development, we are doing this, but it is
not that easy.

>> > > +void __init pxa988_dt_init_timer(void) {
>> > > + extern void __init mmp_dt_init_timer(void);
>> >
>> > You should never put 'extern' declarations into a .c file.
>> >
>> > > + /*
>> > > +  * Is is a SOC timer, and will be used for broadcasting
>> > > +  * when local timers are disabled.
>> > > +  */
>> > > + mmp_dt_init_timer();
>> > > +
>> > > + clocksource_of_init();
>> > > +}
>> >
>> > Please just change the mmp_dt_init_timer function to use
>> > CLOCKSOURCE_OF_DECLARE(), and if possible move the file to
>> > drivers/clocksource.
>>
>> Yes, we will change to use CLOCKSOURCE_OF_DECLARE later.
>> But it need time, so let's keep it at this time.
>
> It should be a trivial change, I'm not asking you to put the clocks
> in the DT right away, just change the way that this function gets
> called.
>
>         Arnd
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
