Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3IMNXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:23:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43338 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab3IMNXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130913112042.GI22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	<20130912143922.GC22013@e106331-lin.cambridge.arm.com>
	<CAK3cCBzQxJqrse-OP-wv81uB26YxHBw_mN2HQD6QVnge5-Kabg@mail.gmail.com>
	<20130913112042.GI22013@e106331-lin.cambridge.arm.com>
Date: Fri, 13 Sep 2013 21:23:15 +0800
Message-ID: <CAK3cCByVcz8QdTKXGDmmUDOMjTcnoueVZ9qWFpahcOLo0gCLMA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add smp support for Allwinner A20 and phy arch count timer
From: cinifr <cinifr@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2013 19:20, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Sep 12, 2013 at 04:46:42PM +0100, cinifr wrote:
>> >You seem to be suggesting a kernel change (using CNTPCT), but also
>> >bootloader changes (setting CNTHCTL.PL1PCTEN) to make this possible at
>> >all. If the bootloader needs to be modified, why can it not be modified
>> >to set CNTVOFF (or to boot the kernel in Hyp where it can set it
>> >itself)?
>>
>> I think kernel should can support both CNTVCT and CNTPCT. Yes, if
>> bootloader have set  CNTVOFF to zero, then CNTVCT is OK, kvm guest
>> using CNTVCT can run more efficient then that using CNTPCT. but if
>> bootloader dont set it, how about kernel booting? I think kernel
>> should try it's best to boot and run ok even bootload dont set any
>> generic timer register including  CNTVOFF  and  CNTHCTL. So i gave a
>> compile options using  CNTPCT. That is only options, If CNTVCT can not
>> working, you have others choice.
>> Of cause, It is best that kerne can select which timer count is used
>> in running time,
>
> CNTVOFF doesn't need to be zero -- when a guest runs under a hypervisor,
> CNTVOFF may change across a suspend/resume of a VM (to give the guest
> the illusion that time wasn't ticking when it wasn't running). All
> that's required is that all the CPUs have the same CNTVOFF value, and
> this has been valid for all platforms so far.
>
> Does CNTVOFF vary between your CPUs, or are they a consistent value
> (event if it's not zero)?
Yes, It is vary in A20 CPUS,

> For ARMv8 systems, CNTVOFF and CNTHCTL reset to an UNDEFINED value, so
> we cannot rely on the physical timers and counters being available --
> the firmware and/or hypervisor must set at least one of them for an OS
> to be able to use the system. The virtual timers and counters are
> *always* available to PL1/EL1, so our best bet is to use them.
>
> I'd prefer not to have to have a run-time solution to a problem that can
> be avoided entirely with a simple modification to the bootloader now.
I agree it now,
>>
>> >I'm not sure what you mean by selecting which timer to use be reading
>> >the current running mode. We currently decide to use CNTVCT if booted in
>> >PL1, or CNTPCT if booted in Hyp. I assume this isn't the mode you're
>> >referring to?
>> Yep, kernel can run PL1 NS=1, PL1 NS=0, PL2. If kernel can know
>> current running Mode.then kernel can chose which timer is OK in
>> running time. 1: If kernel is runing at PL2 and PL1 NS=0, then CNTPCT
>> is OK in any case even CNTVOFF is not zero and CNTHCTL.PL1PCTEN is
>> zero. 2: if kernel is running at  PL1 NS=1,then kernel maybe should
>> select CNTVCT. But it has risk to using CNTVCT when CNTVOFF is not
>> zero.
>> How to deal with the case CNTHCTL.PL1PCTEN is zero and  CNTVOFF is not
>> zero? current kernel cant using any arch timer incluing   CNTVCT and
>> CNTPCT. with this case, I think kernel should use CNTVCT by other
>> ways: Kernel runing CPUn read CNTVCT and save it to  local variable
>> for example InitVctVALUEn in initialization, then kernel running CPUn
>> read timer later return a value as  ReadTIMERn=CNTVCTn-InitVctVALUEn,
>> This way can run in any  generic timer registe set and in any kernel
>> runing mode. I try to write this patch for new way. But the new way
>> should need more time than old in read timer funcation  because it
>> need more calculate.
>
> I don't think that would work. You have no way of ensuring that all CPUs
> read CNTVCT at the same time, so they may record offsets that give them
> different views of time. Consider the case that CNTVOFF was zero on all
> CPUs. CPU0 and CPU1 might read CNTVCT at different instants, and CPU1
> could record its offset as 100 while CPU1 could record its offset as
> 2000. That would leave CPU1 thinking it's further ahead in time than
> CPU0, which could break all sorts of things. AFAICS there's no way of
> telling this apart from each CPU booting with a different CNTVOFF.

> As SMP support for this platform is not yet in mainline, and the
> bootloader can be fixed to set CNTVOFF (as KVM and Xen do for guests),
> we should get the bootloader to set CNTVOFF to a consistent value across
> all CPUs.
Yes, you are right, I will remove phy count timer support patch.and
try to modify bootloader for fix the problem. Bootloader do it better,
more simple and more  efficiency.

Thanks
         Fan.
