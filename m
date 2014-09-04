Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaIDRru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:47:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61585 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbaIDRrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:47:49 -0400
Date: Thu, 4 Sep 2014 18:47:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
Message-ID: <20140904174701.GD2172@leverpostej>
References: <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAPz6YkUZkqgEBsPtX0uGpU+OzF5qdv1hGMXLo4iThUv-7B-Jbw@mail.gmail.com>
 <20140829100414.GA19424@leverpostej>
 <CAPz6YkVv1nbEumt9Q8gHAWddmECOm7DL=WLWfZKxBmzTfLQ00A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPz6YkVv1nbEumt9Q8gHAWddmECOm7DL=WLWfZKxBmzTfLQ00A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 06:01:27PM +0100, Sonny Rao wrote:
> On Fri, Aug 29, 2014 at 3:04 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Aug 29, 2014 at 01:10:49AM +0100, Sonny Rao wrote:
> >> On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > On Thu, Aug 28, 2014 at 04:33:31AM +0100, Doug Anderson wrote:
> >> >> Hi,
> >> >>
> >> >> On Wed, Aug 27, 2014 at 7:58 PM, Olof Johansson <olof@lixom.net> wrote:
> >> >> > On Wed, Aug 27, 2014 at 5:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> >> >> On 08/27/14 15:33, Olof Johansson wrote:
> >> >> >>> On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> >> >>>
> >> >> >>>> Is there any reason why the virtual counter can't be read? Maybe we're
> >> >> >>>> the hyp and we need to make sure we don't use the virtual timer so that
> >> >> >>>> the guest can use it, but that doesn't have any effect on the usage of
> >> >> >>>> the virtual counter for the clocksource.
> >> >> >>> There are several cases where virtual is unusable -- in particular it
> >> >> >>> might not have been configured properly (i.e. the phys/virt offset is
> >> >> >>> at a bad value).
> >> >> >>>
> >> >> >>
> >> >> >> Any specifics? It would be nice to say so in the commit text so that
> >> >> >> others using such devices know they need this patch. I'm guessing the
> >> >> >> firmware can't be fixed?
> >> >>
> >> >> Even if we could change things to use a virtual timer in some cases,
> >> >> Sonny's patch still fixes a bug.  The code as written right now makes
> >> >> pretenses about supporting the physical timer, but it doesn't work.
> >> >> That should be fixed.
> >> >
> >> > The code does support the physical timer. It does not support the
> >> > physical counter (and makes no pretenses that it does).
> >> >
> >>
> >> Is there some reason that it should not support it?  It seems like the
> >> two things are highly related.
> >
> > While the two are related, in sane systems the use of the physical
> > counters is rendered unnecessary by the ability to write to CNTVOFF at
> > PL2.
> 
> By sane, do you mean a system which starts the kernel in PL2?  Or one
> that has CNTVOFF initialized to the same value on all CPUs?

So long as all CPUs have a uniform view of time (with the same CNTFRQ
and no observable offset), things are sane.

Fundamentally, everything that can only be configured at a higher
privilege level must have been configured.

So if booted at PL2, it's not necessary for CNTVOFF to be initialised
while for PL1 it's critical that it is.

> > If an OS is booted at PL1 the physical timers aren't guaranteed to be
> > accessible, so the OS must use the virtual timers. As the OS could be
> > virtualized it must use the virtual counters.
> 
> I was curious to learn more about these modes and looked at the spec.
> The spec I have seems to say that in a VMSA implementation without
> virtualization, then CNTPCT is always available, but if it has
> virtualization then a bit needs to be set, which I think is what
> you're referring to.  I think the spec also says that virtualization
> extensions are optional.  How do you deal with the case that they are
> not implemented?  Or maybe that simply isn't supported?

Do you mean where the virtualization extensions are not implemented, but
the timers are? If so:

 * CNTVOFF doesn't exist, and there is no distinction between virtual
   and physical time.
 
 * There is no PL2.

 * The virtual counters and timers exist, and are accessible to PL1.

So using the virtual timers and counters in this case (as we do) works.

> > If an OS is booted at PL2 it can access the physical counters, and
> > should do so in case something like KVM will be used later. The OS can
> > write to CNTVOFF at PL2, and if it sets CNTVOFF to zero the physical and
> > virtual counters are equivalent. Thus it can use the virtual counters
> > and doesn't need to have additional code in several places (including
> > the VDSO) where it needs to choose to read which counters to read.
> >
> > The problem only exists where PL2 exists and the firmware/bootloader
> > skipped PL2 without initialising the necessary PL2 state. This is in
> > general a stupid thing to do; it introduces a problem that need not
> > exist and throws away the option of using the features PL2 provides.
> > This is a firmware/bootloader bug.
> 
> Well it's not quite that simple, this is actually an issue with the
> hardware that the CNTVOFF comes up with different values on different
> cores.  This happens not only at boot, but any time the core is
> powered on, which could include deep sleep or CPU hotplug and suspend
> to ram.  The firmware may not be involved in all these cases, so we
> cannot rely on it to fix this problem.

If the only thing that can restore that state is firmware, then I would
take that as an indication that firmware _must_ be involved in those
cases.

Surely there is other secure or PL2 state that you need to restore in
those cases anyhow?

> >> > I had hoped we wouldn't encounter cases where CNTVOFF was hopelessly
> >> > ill-configured on a platform, but evidently we have. So we need some
> >> > workaround for that.
> >> >
> >> >> > Yeah, there are a few. The big.LITTLE on the Chromebook 2 models have
> >> >> > this issue, due to the A7 cluster having an incorrect offset
> >> >> > programmed. However, arch timers aren't supported on that SoC in the
> >> >> > first place, so it's not a problem in reality.
> >> >> >
> >> >> > The other known platform is rk3288. It has products out in the wild
> >> >> > where firmware updates are unlikely.
> >> >>
> >> >> One other reason is that (I'm told) that the virtual offset is lost in
> >> >> certain power down conditions (powering down a core, going into S3,
> >> >> etc).  When we power back up the offset is effectively reset to a
> >> >> random value.  That means we need something to reprogram the virtual
> >> >> timer offset whenever we power things back up.
> >> >>
> >> >> If we've got a hypervisor then the hypervisor will definitely be
> >> >> involved in powering things back up and it can reset the virtual
> >> >> offset.  ...but forcing systems to implement a hypervisor (or somehow
> >> >> adding an interface for the kernel to call back into firmware) is a
> >> >> huge effort and it means more hard-to-update code sitting in firmware.
> >> >
> >> > Not if you boot Linux at hyp, as we've recommended for this precise
> >> > reason. That doesn't fix other things like CNTFRQ if the secure
> >> > initialisation doesn't poke that, however.
> >>
> >> That's interesting, we could look into that.
> >
> > I would strongly recommend that you do. :)
> >
> > Linux has supported booting at Hyp for quite a while now, so I would
> > hope the only issues would be the organisation of the firmware and/or
> > bootloader.
> 
> I'm still investigating this for our firmware (but cannot guarantee
> that anyone else will do this), but like I mentioned above, it
> probably won't solve the problem for suspend to RAM or deep
> sleep/power gating of cpu cores.

That doesn't sound right to me. I assume from those cases you'd return
back to the OS at PL2. If state is lost in those cases which an OS
cannot restore with PL2 privilege, then you have bigger problems.

Thanks,
Mark.
