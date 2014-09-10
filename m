Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaIJPzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:55:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34451 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbaIJPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:55:14 -0400
Date: Wed, 10 Sep 2014 16:55:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
Message-ID: <20140910155509.GA7519@leverpostej>
References: <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
 <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
 <54106707.4010006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54106707.4010006@codeaurora.org>
Thread-Topic: [PATCH] clocksource: arch_timer: Fix code to use physical
 timers when requested
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:58:15PM +0100, Christopher Covington wrote:
> On 09/05/2014 06:11 PM, Doug Anderson wrote:
> > Mark,
> > 
> > On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> Not if you boot Linux at hyp, as we've recommended for this precise
> >> reason. That doesn't fix other things like CNTFRQ if the secure
> >> initialisation doesn't poke that, however.
> > 
> > I'll freely admit that I'm out of my league and out of my comfort zone
> > here, but...
> > 
> > In the theory that firmware ought to be as minimal as possible
> > (because it's hard to update and hard to keep in sync with kernel
> > versions), it seems like firmware ought to start the kernel out in as
> > permissive mode as it's willing to provide, right?
> > 
> > If the kernel is started out as permissive as possible then it can do
> > anything it needs to.  Future versions of the kernel can be
> > implemented to do any way-cool things that they want to do without an
> > update to firmware, right?  ...and current versions of the kernel can
> > just shed permissions if they don't want them.
> > 
> > ...so if I understand correctly, "Secure SVC" mode is more permissive
> > than "Non Secure HYP" mode, right?  It looks to me as if we currently
> > start the kernel in "Secure SVC" mode.  What do you think about the
> > kernel detecting Secure SVC and then dropping down permission levels
> > (to Non Secure HYP).  Once it did this, it could update things like
> > the virtual offset and then transition down further into non-secure
> > SVC mode.
> > 
> > ...or maybe this has been discussed millions of times already and I'm
> > just clueless.  ...or maybe this is just too hard for the kernel to do
> > in a generic way?
> 
> I think this is a great idea. When running on simulators, it would make (the
> non-DTB parts of) the bootwrapper and QEMU's built-in bootloader unnecessary.

That's not true in general as other secure initialization will still be
necessary, and the extent and character of that initialization is going
to be implementation specific. 

If you have the infrastructure necessary to load and boot an arbitrary
kernel at the most highly privileged exception level, then you
necessarily have all the plumbing in place for loading an updateable
firmware into that level. That latter option is preferable.

The issue at hand is not whether Linux should be in charge of secure
world state. The issue at hand is that firmware booted Linux at PL1
without taking ownership of all PL2 state (CNTVOFF included). Were
either the firmware or Linux to manage PL2 (configuring CNTVOFF with a
consistent value on all CPUs) that problem would not exist.

> Implementing it on AArch64 should be trivial as you can just read
> CurrentEL
> and work from whatever EL/PL you're at.

While it's trivial to identify which EL software is executing in, doing
the right thing based on that is going to be far harder, especially in a
general purpose OS.

A loadable piece of firmware can know what is best for a particular
platform (e.g. which errata apply which require poking implementation
defined registers with magic implementation defined values) as it is
tied to that piece of hardware.

Mark.
