Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3IMLWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:22:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53500 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596Ab3IMLWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:22:13 -0400
Date: Fri, 13 Sep 2013 12:20:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: cinifr <cinifr@gmail.com>
Cc: "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 0/4] Add smp support for Allwinner A20 and phy arch
 count timer
Message-ID: <20130913112042.GI22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
 <20130912143922.GC22013@e106331-lin.cambridge.arm.com>
 <CAK3cCBzQxJqrse-OP-wv81uB26YxHBw_mN2HQD6QVnge5-Kabg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK3cCBzQxJqrse-OP-wv81uB26YxHBw_mN2HQD6QVnge5-Kabg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 04:46:42PM +0100, cinifr wrote:
> >You seem to be suggesting a kernel change (using CNTPCT), but also
> >bootloader changes (setting CNTHCTL.PL1PCTEN) to make this possible at
> >all. If the bootloader needs to be modified, why can it not be modified
> >to set CNTVOFF (or to boot the kernel in Hyp where it can set it
> >itself)?
> 
> I think kernel should can support both CNTVCT and CNTPCT. Yes, if
> bootloader have set  CNTVOFF to zero, then CNTVCT is OK, kvm guest
> using CNTVCT can run more efficient then that using CNTPCT. but if
> bootloader dont set it, how about kernel booting? I think kernel
> should try it's best to boot and run ok even bootload dont set any
> generic timer register including  CNTVOFF  and  CNTHCTL. So i gave a
> compile options using  CNTPCT. That is only options, If CNTVCT can not
> working, you have others choice.
> Of cause, It is best that kerne can select which timer count is used
> in running time,

CNTVOFF doesn't need to be zero -- when a guest runs under a hypervisor,
CNTVOFF may change across a suspend/resume of a VM (to give the guest
the illusion that time wasn't ticking when it wasn't running). All
that's required is that all the CPUs have the same CNTVOFF value, and
this has been valid for all platforms so far.

Does CNTVOFF vary between your CPUs, or are they a consistent value
(event if it's not zero)?

For ARMv8 systems, CNTVOFF and CNTHCTL reset to an UNDEFINED value, so
we cannot rely on the physical timers and counters being available --
the firmware and/or hypervisor must set at least one of them for an OS
to be able to use the system. The virtual timers and counters are
*always* available to PL1/EL1, so our best bet is to use them.

I'd prefer not to have to have a run-time solution to a problem that can
be avoided entirely with a simple modification to the bootloader now.

> 
> >I'm not sure what you mean by selecting which timer to use be reading
> >the current running mode. We currently decide to use CNTVCT if booted in
> >PL1, or CNTPCT if booted in Hyp. I assume this isn't the mode you're
> >referring to?
> Yep, kernel can run PL1 NS=1, PL1 NS=0, PL2. If kernel can know
> current running Mode.then kernel can chose which timer is OK in
> running time. 1: If kernel is runing at PL2 and PL1 NS=0, then CNTPCT
> is OK in any case even CNTVOFF is not zero and CNTHCTL.PL1PCTEN is
> zero. 2: if kernel is running at  PL1 NS=1,then kernel maybe should
> select CNTVCT. But it has risk to using CNTVCT when CNTVOFF is not
> zero.
> How to deal with the case CNTHCTL.PL1PCTEN is zero and  CNTVOFF is not
> zero? current kernel cant using any arch timer incluing   CNTVCT and
> CNTPCT. with this case, I think kernel should use CNTVCT by other
> ways: Kernel runing CPUn read CNTVCT and save it to  local variable
> for example InitVctVALUEn in initialization, then kernel running CPUn
> read timer later return a value as  ReadTIMERn=CNTVCTn-InitVctVALUEn,
> This way can run in any  generic timer registe set and in any kernel
> runing mode. I try to write this patch for new way. But the new way
> should need more time than old in read timer funcation  because it
> need more calculate.

I don't think that would work. You have no way of ensuring that all CPUs
read CNTVCT at the same time, so they may record offsets that give them
different views of time. Consider the case that CNTVOFF was zero on all
CPUs. CPU0 and CPU1 might read CNTVCT at different instants, and CPU1
could record its offset as 100 while CPU1 could record its offset as
2000. That would leave CPU1 thinking it's further ahead in time than
CPU0, which could break all sorts of things. AFAICS there's no way of
telling this apart from each CPU booting with a different CNTVOFF.

As SMP support for this platform is not yet in mainline, and the
bootloader can be fixed to set CNTVOFF (as KVM and Xen do for guests),
we should get the bootloader to set CNTVOFF to a consistent value across
all CPUs.

Thanks,
Mark.

> 
> .
> Thanks for your question.
> 
> On 12 September 2013 22:39, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Sep 12, 2013 at 07:51:23AM +0100, Fan Rong wrote:
> >> The patchs add smp support for Allwinner A20. It add cpuregister node
> >> in dts forsmp configure. The patchs also add a options for phy count
> >> timer to replace vir count timer as ARM arch timer clocksource. About
> >> ARM arch timer: 1. Current kernel use vir count timer, vir count timer
> >> can be accessed in any cpu mode for kernel, but it need bootloader set
> >> vir count offset rigister zero at first. 2. Phy count timer can be
> >> accessed in most cpu mode for kernel except NS-PL1 mode when register
> >> CNTHCTL.PL1PCTEN is set to zero. To ensure to use phy count timer,
> >> bootloader should set register CNTHCTL.PL1PCTEN is 1 at first. At all,
> >> to ensure kernel can use arch timer, bootload should set some generic
> >> timer register(cntvoff or cnthctl) at first. the kernel should select
> >> which count timer by reading current kernel running mode.
> >
> > Sorry, but I find the above text difficult to understand. It jumps
> > between several issues and isn't well formatted.
> >
> > You seem to be suggesting a kernel change (using CNTPCT), but also
> > bootloader changes (setting CNTHCTL.PL1PCTEN) to make this possible at
> > all. If the bootloader needs to be modified, why can it not be modified
> > to set CNTVOFF (or to boot the kernel in Hyp where it can set it
> > itself)?
> >
> > I'm not sure what you mean by selecting which timer to use be reading
> > the current running mode. We currently decide to use CNTVCT if booted in
> > PL1, or CNTPCT if booted in Hyp. I assume this isn't the mode you're
> > referring to?
> >
> > Thanks,
> > Mark.
> >
> >>
> >> Fan Rong (4):
> >>   Add smp support for Allwinner A20(sunxi 7i).
> >>   Add cpuconfig nodes in dts for smp configure.
> >>   Add physical count arch timer support for clocksource in ARMv7.
> >>   Add arch count timer node in dts for Allwinner A20(sunxi 7i).
> >>
> >>  arch/arm/boot/dts/sun7i-a20.dtsi     |   18 +-
> >>  arch/arm/include/asm/arch_timer.h    |   11 ++
> >>  arch/arm/mach-sunxi/Makefile         |    2 +
> >>  arch/arm/mach-sunxi/headsmp.S        |   12 ++
> >>  arch/arm/mach-sunxi/platform.h       |  346 ++++++++++++++++++++++++++++++++++
> >>  arch/arm/mach-sunxi/platsmp.c        |  166 ++++++++++++++++
> >>  arch/arm/mach-sunxi/sunxi.c          |    4 +
> >>  drivers/clocksource/Kconfig          |    8 +
> >>  drivers/clocksource/arm_arch_timer.c |   10 +-
> >>  9 files changed, 574 insertions(+), 3 deletions(-)
> >>  create mode 100644 arch/arm/mach-sunxi/headsmp.S
> >>  create mode 100644 arch/arm/mach-sunxi/platform.h
> >>  create mode 100644 arch/arm/mach-sunxi/platsmp.c
> >>
> >> --
> >> 1.7.9.5
> >>
> >>
> 
