Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaIPKnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:43:05 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33139 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaIPKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:43:03 -0400
Date: Tue, 16 Sep 2014 11:42:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>, "olof@lixom.net" <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
Message-ID: <20140916104242.GC27273@arm.com>
References: <5412DC48.7030708@codeaurora.org>
 <5412E3BB.9030800@arm.com>
 <54134291.3040700@codeaurora.org>
 <20140915111055.GD1577@arm.com>
 <54174CFF.7050504@codeaurora.org>
 <CAPz6YkU8hEL6yocPf7UL8-tz9Onuu-9bevAToK3CDWsShN92YQ@mail.gmail.com>
 <54175EFE.6010509@codeaurora.org>
 <CAPz6YkWbxiGHO8RK==HbQ3P22amZ9sDKpGew=a2U8gO7soQCDg@mail.gmail.com>
 <CAPz6YkWwzpd4oxarEH4Vu-Z_eH+ysw0TNubpPsv_eC6QJPcw7g@mail.gmail.com>
 <54176D62.9010600@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54176D62.9010600@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:51:14PM +0100, Christopher Covington wrote:
> Hi Sonny,
> 
> On 09/15/2014 06:04 PM, Sonny Rao wrote:
> > On Mon, Sep 15, 2014 at 2:52 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
> >> On Mon, Sep 15, 2014 at 2:49 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >>> On 09/15/14 14:47, Sonny Rao wrote:
> >>>> On Mon, Sep 15, 2014 at 1:33 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >>>>> On 09/15/14 04:10, Catalin Marinas wrote:
> >>>>>> On Fri, Sep 12, 2014 at 07:59:29PM +0100, Stephen Boyd wrote:
> >>>>>>> On 09/12/14 05:14, Marc Zyngier wrote:
> >>>>>>>> We surely can handle the UNDEF and do something there. We just can't do
> >>>>>>>> it the way Doug described it above.
> >>>>>>> I suggested doing that for something else a while ago and Will and Dave
> >>>>>>> we're not thrilled[1]. The suggestion back then was to use DT to
> >>>>>>> indicate what mode the kernel is running in.
> >>>>>>>
> >>>>>>> [1]
> >>>>>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/105321.html
> >>>>>> I think the context was slightly different. As I re-read the thread, it
> >>>>>> seems that the discussion was around whether to use some SMC interface
> >>>>>> or not based on whether the kernel is running secure or non-secure. The
> >>>>>> argument made by Will was to actually specify the type of the firmware
> >>>>>> SMC interface in the DT and use it in the kernel (and probably assume
> >>>>>> the kernel is running in secure mode if no smc interface is specified in
> >>>>>> the DT; you could have both though, running in secure mode and also
> >>>>>> having firmware).
> >>>>>>
> >>>>>> In this arch timer case, we need to work around a firmware bug (or
> >>>>>> feature as 32-bit ARM kernels never required CNTVOFF initialisation by
> >>>>>> firmware, no matter how small such firmware is). We don't expect a
> >>>>>> specific SMC call to initialise CNTVOFF, so we can't describe it in the
> >>>>>> DT.
> >>>>> Agreed, we can't described SMC calls that don't exist. From my
> >>>>> perspective it's just another part of the cpu boot sequence that needs
> >>>>> to be handled in the kernel, so describing the requirement via the
> >>>>> cpu-boot method seems appropriate. It seems like we're making it harder
> >>>>> than it should be by handling the undef when we could have slightly
> >>>>> different SMP boot code (and suspend/resume code) depending on the boot
> >>>>> method property.
> >>>>
> >>>> +heiko
> >>>>
> >>>> So, for the case of rk3288, based on this discussion what I'm going to
> >>>> propose is to add code to rockchip.c which looks for a particular SMP
> >>>> enable method -- say something like "rockchip,rk3288-smp-secure-svc"
> >>>> which will then assume we have been booted in secure SVC mode and do
> >>>> the CNTVOFF fixup.  I believe, it will need to do this on the boot CPU
> >>>> as well, so I think it will need to scan the DT fairly early on the
> >>>> boot CPU and also perform the function there.
> >>>>
> >>>> I'll look into implementing this and post code.  Comments and
> >>>> suggestions appreciated, thanks.
> >>>
> >>> What goes wrong if we read the cntvoff from the boot CPU during
> >>> smp_prepare_cpus() phase and use that to set the cntvoff on the other
> >>> CPUs? That avoids needing to do anything very early by making the value
> >>> the same. It does mean that cntvoff is some random out of reset value
> >>> for CPU0, but at least it's consistent.
> >>
> >> I think we cannot read the value if we're not in hyp mode.
> > 
> > Well, thinking about it a little more, I think you still have a good point.
> > 
> > We don't need to do this early on, as long as we haven't started using
> > the arch timers yet.  If we are still able to do this at the point
> > where we're executing the code in arch/arm/mach-rockchip/platsmp.c
> > that finds the enable method then we can just handle it there.
> 
> I've been playing around with the probe-based approach and while I need to do
> a lot more testing, it seems to be working for the first tens of instructions.
> I hope to be able to share a draft of that soon. Basically, I just read the
> current NSACR value and write it back (although maybe in the long term we
> would want to make sure a few of those bits are set or cleared). If that
> succeeds, we know we're in secure SVC and can proceed to set up MON and HYP.

But when it doesn't succeed, you get an undefined instruction fault
(since NSACR is only writable in secure mode).

-- 
Catalin
