Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaH2KFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:05:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50727 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbaH2KFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:05:07 -0400
Date: Fri, 29 Aug 2014 11:04:14 +0100
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
Message-ID: <20140829100414.GA19424@leverpostej>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
 <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
 <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAPz6YkUZkqgEBsPtX0uGpU+OzF5qdv1hGMXLo4iThUv-7B-Jbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPz6YkUZkqgEBsPtX0uGpU+OzF5qdv1hGMXLo4iThUv-7B-Jbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 01:10:49AM +0100, Sonny Rao wrote:
> On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Aug 28, 2014 at 04:33:31AM +0100, Doug Anderson wrote:
> >> Hi,
> >>
> >> On Wed, Aug 27, 2014 at 7:58 PM, Olof Johansson <olof@lixom.net> wrote:
> >> > On Wed, Aug 27, 2014 at 5:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> >> On 08/27/14 15:33, Olof Johansson wrote:
> >> >>> On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> >>>
> >> >>>> Is there any reason why the virtual counter can't be read? Maybe we're
> >> >>>> the hyp and we need to make sure we don't use the virtual timer so that
> >> >>>> the guest can use it, but that doesn't have any effect on the usage of
> >> >>>> the virtual counter for the clocksource.
> >> >>> There are several cases where virtual is unusable -- in particular it
> >> >>> might not have been configured properly (i.e. the phys/virt offset is
> >> >>> at a bad value).
> >> >>>
> >> >>
> >> >> Any specifics? It would be nice to say so in the commit text so that
> >> >> others using such devices know they need this patch. I'm guessing the
> >> >> firmware can't be fixed?
> >>
> >> Even if we could change things to use a virtual timer in some cases,
> >> Sonny's patch still fixes a bug.  The code as written right now makes
> >> pretenses about supporting the physical timer, but it doesn't work.
> >> That should be fixed.
> >
> > The code does support the physical timer. It does not support the
> > physical counter (and makes no pretenses that it does).
> >
> 
> Is there some reason that it should not support it?  It seems like the
> two things are highly related.

While the two are related, in sane systems the use of the physical
counters is rendered unnecessary by the ability to write to CNTVOFF at
PL2.

If an OS is booted at PL1 the physical timers aren't guaranteed to be
accessible, so the OS must use the virtual timers. As the OS could be
virtualized it must use the virtual counters. 

If an OS is booted at PL2 it can access the physical counters, and
should do so in case something like KVM will be used later. The OS can
write to CNTVOFF at PL2, and if it sets CNTVOFF to zero the physical and
virtual counters are equivalent. Thus it can use the virtual counters
and doesn't need to have additional code in several places (including
the VDSO) where it needs to choose to read which counters to read.

The problem only exists where PL2 exists and the firmware/bootloader
skipped PL2 without initialising the necessary PL2 state. This is in
general a stupid thing to do; it introduces a problem that need not
exist and throws away the option of using the features PL2 provides.
This is a firmware/bootloader bug.

> > I had hoped we wouldn't encounter cases where CNTVOFF was hopelessly
> > ill-configured on a platform, but evidently we have. So we need some
> > workaround for that.
> >
> >> > Yeah, there are a few. The big.LITTLE on the Chromebook 2 models have
> >> > this issue, due to the A7 cluster having an incorrect offset
> >> > programmed. However, arch timers aren't supported on that SoC in the
> >> > first place, so it's not a problem in reality.
> >> >
> >> > The other known platform is rk3288. It has products out in the wild
> >> > where firmware updates are unlikely.
> >>
> >> One other reason is that (I'm told) that the virtual offset is lost in
> >> certain power down conditions (powering down a core, going into S3,
> >> etc).  When we power back up the offset is effectively reset to a
> >> random value.  That means we need something to reprogram the virtual
> >> timer offset whenever we power things back up.
> >>
> >> If we've got a hypervisor then the hypervisor will definitely be
> >> involved in powering things back up and it can reset the virtual
> >> offset.  ...but forcing systems to implement a hypervisor (or somehow
> >> adding an interface for the kernel to call back into firmware) is a
> >> huge effort and it means more hard-to-update code sitting in firmware.
> >
> > Not if you boot Linux at hyp, as we've recommended for this precise
> > reason. That doesn't fix other things like CNTFRQ if the secure
> > initialisation doesn't poke that, however.
> 
> That's interesting, we could look into that.

I would strongly recommend that you do. :)

Linux has supported booting at Hyp for quite a while now, so I would
hope the only issues would be the organisation of the firmware and/or
bootloader.

Thanks,
Mark.
