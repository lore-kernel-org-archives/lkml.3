Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaIJQ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:29:09 -0400
Received: from [217.140.108.86] ([217.140.108.86]:60863 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752388AbaIJQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:29:03 -0400
Date: Mon, 8 Sep 2014 14:54:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
Message-ID: <20140908135436.GC22717@arm.com>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
 <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
 <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:11:47PM +0100, Doug Anderson wrote:
> On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Not if you boot Linux at hyp, as we've recommended for this precise
> > reason. That doesn't fix other things like CNTFRQ if the secure
> > initialisation doesn't poke that, however.
> 
> I'll freely admit that I'm out of my league and out of my comfort zone
> here, but...
> 
> In the theory that firmware ought to be as minimal as possible
> (because it's hard to update and hard to keep in sync with kernel
> versions), it seems like firmware ought to start the kernel out in as
> permissive mode as it's willing to provide, right?

Not necessarily (and definitely not for arm64). And we've seen in
practice that the actual deployed kernel may run in a different security
mode than what's in mainline and used for initial development (you may
just not see all the patches upstream). For development, that's indeed
simpler, but once you go into production, a customer requesting some
secure OS for payments etc. and Linux is moved to the non-secure side
(and you end up putting hacks in the kernel because they were not
spotted during initial development with Linux running in secure mode).

> If the kernel is started out as permissive as possible then it can do
> anything it needs to.  Future versions of the kernel can be
> implemented to do any way-cool things that they want to do without an
> update to firmware, right?  ...and current versions of the kernel can
> just shed permissions if they don't want them.
> 
> ...so if I understand correctly, "Secure SVC" mode is more permissive
> than "Non Secure HYP" mode, right?  It looks to me as if we currently
> start the kernel in "Secure SVC" mode.  What do you think about the
> kernel detecting Secure SVC and then dropping down permission levels
> (to Non Secure HYP).  Once it did this, it could update things like
> the virtual offset and then transition down further into non-secure
> SVC mode.

If we talk about ARMv8/AArch64, Secure SVC (aka secure EL1) is not more
permissive than Non-secure Hyp (aka non-secure EL2). The only way to go
from secure EL1 to non-secure EL2 is via EL3 (and SMC call) which means
firmware code. Certain registers like CNTFRQ are only writable in EL3,
CNTVOFF in EL2 or EL3.

-- 
Catalin
