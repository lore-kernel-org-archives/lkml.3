Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3FJIfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:35:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FJIf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:35:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Date: Mon, 10 Jun 2013 10:35:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Neil Zhang <zhangwm@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com> <201306061826.19551.arnd@arndb.de> <CADApbeixEKi984QED07LxA8vzfHmLGCGT8KxEbB5cqXzpW823Q@mail.gmail.com>
In-Reply-To: <CADApbeixEKi984QED07LxA8vzfHmLGCGT8KxEbB5cqXzpW823Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101035.20924.arnd@arndb.de>
X-Provags-ID: V02:K0:XKlMDOH40yj3D5WsfGSPsiW5eDyMIOGUOY3vxYJIlvS
 AYVubREeqr4pITZjPCVkZ6ayp7z8dZrLn8Qho9fIHWUzjIrZfZ
 1QkPtiWwh5iqH8GjvgjfBEiVGtMqaMrWxvnj9zeEAkYXudtEh3
 kMbavbI4+oPwgw4MGe5Qgy7wA+NDkJlBGXdXEw/lrlj3V67Bep
 LFT/66yBhIr338Yoe+dvoX6hV+BNbyR4XYBUJsXQ+qSUbJkcCH
 IfbzMrGKE2vTZGqLeDXw4pgWyJiEzZxfmOGhUhbOn5/6kZXZ+h
 JUYA5qWmPXSrZzdhP8vi8xqNIElqxnEYDSWD/2gs8s6CKhN0Jd
 zKhDyWtdoSr77QUpJZ6A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 June 2013, Chao Xie wrote:
> hi, Arnd
> Thanks for your review.
> 
> On Fri, Jun 7, 2013 at 12:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 06 June 2013, Neil Zhang wrote:
> >>
> >> The MACH_MMPX_DT here is for standard ARM core based SoC.
> >> But PJ4 is modified by Marvell, which includes IWMMXT.
> >
> > That should not stop us from supporting them with the same kernel.
> > We can already build a kernel that will work with IWMMXT on
> > ArmadaXP (PJ4B) and Calxeda Highbank (Cortex-A9) for instance.
> >
> Yes. We can compile it, because will fail to boot up the core.
> The correct way to adding device tree support for
> iwmmx(arch/arm/kernel/pj4-cp0.c).
> I think we can do it if you agree with us.

Ah, you mean the initcall in that file breaks when executed on a
CPU that doesn't have iWMMXT?

The easiest way for that is probably to call pj4_cp0_init()
from the machine_descriptor init_late() callback. To do it properly,
I think it should be hooked up with the CPU identification code
in arch/arm/mm/proc-v7.S.

> >> > __initdata = {
> >> > >           .virtual        = (unsigned long)AXI_VIRT_BASE,
> >> > >           .length         = AXI_PHYS_SIZE,
> >> > >           .type           = MT_DEVICE,
> >> > > - },
> >> > > + }, {
> >> > > +         .pfn            = __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
> >> > > +         .virtual        = (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
> >> > > +         .length         = MMP_CORE_PERIPH_PHYS_SIZE,
> >> > > +         .type           = MT_DEVICE,
> >> > > + }
> >> > >  };
> >> > >
> >> > >  void __init mmp_map_io(void)
> >> >
> >> > What is this needed for?
> >>
> >> This function is used to static map the device registers.
> >
> > I understand what map_io does. Why do you need a static mapping?
> >
> 
> The AXI and APB bus register mapping, It does not need to be static mapping.
> Because we define the registers for each peripharals in device tree.
> The device driver can map it.

Ok. Please try if it all keeps working without these mappings (aside
from the SCU). You can leave them in as a performance optimization
since the registers will get mapped as large pages this way, but it
should really work without them.

I would also suggest defining the virtual base addresses locally in this
file rather than globally, just to ensure that no driver starts relying
on the static mapping.

> There is a exception. The address space used by core for example CPU
> SCU registers for CA9.
> We have to read/write the registers even device tree has not been
> build up in kernel, for example ->smp_prepare_cpus.
> At this point, how can we get the base address for SCU?

I guess that is a problem we have on other platforms as well, we should
find a generic solution for that. It would be nice to reserve a page
in "fixmap" and have common code map the SCU page into that.
 
> >> > > +/* PXA988 */
> >> > > +static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst
> >> > = {
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0",
> >> > NULL),
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1",
> >> > NULL),
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2",
> >> > NULL),
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0",
> >> > NULL),
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1",
> >> > NULL),
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
> >> > > + OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
> >> > > + {}
> >> > > +};
> >> >
> >> > Why do you need auxdata?
> >>
> >> Two reasons:
> >> 1. some of the device still need platform data at this time.
> >
> > None of the ones above do apparently.
> >
> Now, some devices are not added. For example, USB.
> I am trying to modify the USB driver to make it support device tree.
> For example, separate the phy and PMIC support from USB driver.
> The patches have been reviewed in USB maillist for a long time.
> Now it is hold because the maintainer think HCD and PHY need do some fix.
> So as a temporaty solution before us pushing USB patches, we have to
> use platform data for USB.

Ok, I see.

	Arnd
