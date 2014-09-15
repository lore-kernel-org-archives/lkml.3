Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaIOLLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:11:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40923 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaIOLLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:11:04 -0400
Date: Mon, 15 Sep 2014 12:10:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>, "olof@lixom.net" <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Mark Rutland <Mark.Rutland@arm.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
Message-ID: <20140915111055.GD1577@arm.com>
References: <1410452204-7277-1-git-send-email-dianders@chromium.org>
 <20140911164710.GW6158@arm.com>
 <5411D528.4050605@arm.com>
 <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com>
 <5411DA67.2040402@arm.com>
 <CAD=FV=UQfo4J3P4wGjOhQZQ5KXKgYAdjPsi1ykKZxQw-FwJz8w@mail.gmail.com>
 <5411DF5D.8060906@arm.com>
 <5412DC48.7030708@codeaurora.org>
 <5412E3BB.9030800@arm.com>
 <54134291.3040700@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <54134291.3040700@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Sep 2014 11:10:59.0463 (UTC) FILETIME=[BA9F0970:01CFD0D5]
X-MC-Unique: 114091512110004501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 07:59:29PM +0100, Stephen Boyd wrote:
> On 09/12/14 05:14, Marc Zyngier wrote:
> > On 12/09/14 12:43, Christopher Covington wrote:
> >> On 09/11/2014 01:43 PM, Marc Zyngier wrote:
> >>> On 11/09/14 18:29, Doug Anderson wrote:
> >>>
> >>>> I did this in the past (again, see Sonny's thread), but didn't
> >>>> consider myself knowledgeable to know if that was truly a good test:
> >>>>
> >>>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
> >>>>        pr_info("DOUG: val is %#010x", val);
> >>>>        val |= (1 << 2);
> >>>>        asm volatile("mcr p15, 0, %0, c1, c1, 0" : : "r" (val));
> >>>>        val = 0xffffffff;
> >>>>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
> >>>>        pr_info("DOUG: val is %#010x", val);
> >>>>
> >>>> The idea being that if you can make modifications to the SCR register
> >>>> (and see your changes take effect) then you must be in secure mode.
> >>>> In my case the first printout was 0x0 and the second was 0x4.

BTW, if you want to change the SCR.NS bit (and CNTVOFF), the kernel must
run in Monitor mode (by setting the CPSR mode bits, 32-bit only).

> >>> The main issue is when you're *not* in secure mode. It is likely that
> >>> this will explode badly. This is why I suggested something that is set
> >>> by the bootloader (after all. it knows which mode it is booted in), and
> >>> that the timer driver can use when the CPU comes up.
> >>
> >> What exactly does "exploding badly" look like? Causing and undefined
> >> instruction exception? That's just a branch with a mode switch. Any reason the
> >> code couldn't deal with that or even use that to its advantage?
> >
> > We surely can handle the UNDEF and do something there. We just can't do
> > it the way Doug described it above.
> 
> I suggested doing that for something else a while ago and Will and Dave
> we're not thrilled[1]. The suggestion back then was to use DT to
> indicate what mode the kernel is running in.
> 
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/105321.html

I think the context was slightly different. As I re-read the thread, it
seems that the discussion was around whether to use some SMC interface
or not based on whether the kernel is running secure or non-secure. The
argument made by Will was to actually specify the type of the firmware
SMC interface in the DT and use it in the kernel (and probably assume
the kernel is running in secure mode if no smc interface is specified in
the DT; you could have both though, running in secure mode and also
having firmware).

In this arch timer case, we need to work around a firmware bug (or
feature as 32-bit ARM kernels never required CNTVOFF initialisation by
firmware, no matter how small such firmware is). We don't expect a
specific SMC call to initialise CNTVOFF, so we can't describe it in the
DT.

One problem with undef for detecting whether the core is in secure or
non-secure mode is that sometimes the initialisation code needs to run
very early when the kernel hooks may not be fully initialised. We could
only detect this mode on the booting CPU and save it in a global
variable (of course, assuming the other CPUs boot in the same mode).
Other code could make use of such information as appropriate. Of course,
there is always a risk that it will be abused.

-- 
Catalin

