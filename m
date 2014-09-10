Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaIJReg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:34:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35871 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbaIJRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:34:35 -0400
Date: Wed, 10 Sep 2014 18:34:01 +0100
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
Message-ID: <20140910173401.GG1710@arm.com>
References: <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
 <20140908135436.GC22717@arm.com>
 <CAD=FV=Up=+zNneY-behnkFbhupi50_f5R=ECgJQeqGV5kz5d2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Up=+zNneY-behnkFbhupi50_f5R=ECgJQeqGV5kz5d2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 06:17:23PM +0100, Doug Anderson wrote:
> On Mon, Sep 8, 2014 at 6:54 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Fri, Sep 05, 2014 at 11:11:47PM +0100, Doug Anderson wrote:
> >> On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > Not if you boot Linux at hyp, as we've recommended for this precise
> >> > reason. That doesn't fix other things like CNTFRQ if the secure
> >> > initialisation doesn't poke that, however.
> >>
> >> I'll freely admit that I'm out of my league and out of my comfort zone
> >> here, but...
> >>
> >> In the theory that firmware ought to be as minimal as possible
> >> (because it's hard to update and hard to keep in sync with kernel
> >> versions), it seems like firmware ought to start the kernel out in as
> >> permissive mode as it's willing to provide, right?
> >
> > Not necessarily (and definitely not for arm64). And we've seen in
> > practice that the actual deployed kernel may run in a different security
> > mode than what's in mainline and used for initial development (you may
> > just not see all the patches upstream). For development, that's indeed
> > simpler, but once you go into production, a customer requesting some
> > secure OS for payments etc. and Linux is moved to the non-secure side
> > (and you end up putting hacks in the kernel because they were not
> > spotted during initial development with Linux running in secure mode).
> 
> I guess the important part of my statement is "as it's willing to
> provide".  In your case your firmware isn't willing to provide "secure
> SVC".  In our case it is.
> 
> We've actually shipped products where the firmware boots the kernel in
> "secure" mode.  These products have a very different security model
> than you're envisioning, I guess.  In these products, less firmware is
> better and adding firmware code to do the whole transition to "non
> secure hyp mode" just isn't worth it.  It's not just a one-time blob
> of code in the firmware before booting the kernel.  (I'm told) it
> means somehow keeping firmware code around to help out with turning
> processors off/on and to help with resume from S3.  That's
> infrastructure that we don't want to add.

Setting aside the security model, booting in secure mode can also have a
significant impact on the programming model of system IP, not just the CPU.
For example, the SMMU register file suddenly looks different and the way in
which it is programmed also changes. The GIC (v3+) is similar. Linux doesn't
have drivers that know about this so, whilst not impossible, there's a
non-trivial amount of work (and then maintenance overhead) if you want to
support booting Linux on the secure side.

The secure world may be more permissive in some regards, but it's actually
a burden in others. It's not a simple superset of non-secure, and this is
more evident than ever in ARMv8.

As I understand it, this conversation started because we're booting at
non-secure EL1 with a badly configured EL2. That sounds like something
we may have to fix/work around in Linux (Olof points out that it used to
work), but we shouldn't conflate that with booting on the secure side to
get away from broken firmware.

Will
