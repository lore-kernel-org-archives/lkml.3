Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaIJSrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:47:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36784 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaIJSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:47:35 -0400
Date: Wed, 10 Sep 2014 19:46:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
Message-ID: <20140910184652.GP1710@arm.com>
References: <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
 <20140908135436.GC22717@arm.com>
 <CAD=FV=Up=+zNneY-behnkFbhupi50_f5R=ECgJQeqGV5kz5d2g@mail.gmail.com>
 <20140910173401.GG1710@arm.com>
 <CAD=FV=WJpP1aAo-r9bnUQg5xarGQYo8pROvyh0a5dt+m1OOn4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WJpP1aAo-r9bnUQg5xarGQYo8pROvyh0a5dt+m1OOn4g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 07:09:59PM +0100, Doug Anderson wrote:
> On Wed, Sep 10, 2014 at 10:34 AM, Will Deacon <will.deacon@arm.com> wrote:
> > Setting aside the security model, booting in secure mode can also have a
> > significant impact on the programming model of system IP, not just the CPU.
> > For example, the SMMU register file suddenly looks different and the way in
> > which it is programmed also changes. The GIC (v3+) is similar. Linux doesn't
> > have drivers that know about this so, whilst not impossible, there's a
> > non-trivial amount of work (and then maintenance overhead) if you want to
> > support booting Linux on the secure side.
> 
> Hrm.  I could have sworn someone told me that exynos5250-snow is
> booted in Secure SVC mode and has been that way forever.  I could
> certainly be wrong.  Stupid question, but should any of your
> statements apply to an A15 or an A12?  Maybe things change with newer
> CPUs?

Snow does boot secure, which is why you don't get KVM without hacking the
bootloader. However, snow also doesn't use:

  - An ARMv8 CPU
  - GICv3
  - ARM SMMU
  - Virtualisation (in the supported software image)
  - Secure services (by the architectural definition)

> On the rk3288 I have in front of me I tried running the following at
> (semi early) boot to help confirm we were in Secure SVC.  Standard "I
> don't know what I'm doing" caveats apply:
> 
>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>        pr_info("DOUG: val is %#010x", val);
>        val |= (1 << 2);
>        asm volatile("mcr p15, 0, %0, c1, c1, 0" : : "r" (val));
>        val = 0xffffffff;
>        asm volatile("mrc p15, 0, %0, c1, c1, 0" : "=r" (val));
>        pr_info("DOUG: val is %#010x", val);
> 
> When I did that I found that I was able to read back 0x00000004.  OK,
> and I just replicated that same behavior on exynos5250-snow.
> 
> Since I think the SCR register is only accessible from "Secure PL1
> modes" and I showed that I could change it, to me that meant that I
> must be in "Secure PL1".  Please yell if I'm just being an idiot and I
> can look for some other way to test for secure mode.

Again, this isn't the kind of platform I was referring to. Until recently,
(32-bit) Linux has booted in secure svc just fine and there's no reason to
break platforms relying on that.

> Also: I wasn't actually suggesting running Linux in secure mode, I was
> only suggesting _booting_ Linux in secure mode.  The idea was that
> Linux would realize this and immediately switch to nonsecure HYP mode.
> Linux doesn't normally run at HYP mode, so it would eventually drop
> down into nonsecure SVC mode, too.

For ARMv7, fill your boots. For ARMv8, this doesn't work unless you enter at
EL3, in which case the kernel is going to need to grow an awful lot of
knowledge to initialise arbitrary systems.

> The other (important) justification was to keep bootloaders simple.
> All of the "I've never even thought about secure mode" bootloaders
> that I've seen just happen to boot the kernel in Secure SVC.  That
> makes me think that must be the easiest thing for them to do.  We
> should support them.

Just to reiterate, you're talking ARMv7 and I'm talking ARMv8. For ARMv7,
there is a separate argument about whether we should make bootloaders
simple and the OS more complex, which has been had on the mailing list
before (I don't think there was a good conclusion though -- Nico and Catalin
were discussing about MCPM and PSCI, which is very much related to this
topic).

> > The secure world may be more permissive in some regards, but it's actually
> > a burden in others. It's not a simple superset of non-secure, and this is
> > more evident than ever in ARMv8.
> >
> > As I understand it, this conversation started because we're booting at
> > non-secure EL1 with a badly configured EL2. That sounds like something
> > we may have to fix/work around in Linux (Olof points out that it used to
> > work), but we shouldn't conflate that with booting on the secure side to
> > get away from broken firmware.
> 
> See above and also my summary to Mark Rutland.  I don't think your
> statement above is quite where we're at, but hopefully we're on the
> same page now.  :)

If `where we're at' is trying to boot an ARMv7 product, then you can boot in
secure svc and lose virtualisation support. Looking forward to ARMv8, this
isn't going to work, so I'd encourage you to start thinking about getting
a working bootloader as a requirement.

Will
