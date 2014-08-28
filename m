Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaH1SEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:04:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39353 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbaH1SEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:04:36 -0400
Date: Thu, 28 Aug 2014 19:04:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
Message-ID: <20140828180423.GE18005@leverpostej>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
 <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
 <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
 <53FE5B09.2020403@codeaurora.org>
 <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
 <53FE7E3B.1010500@codeaurora.org>
 <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
 <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
 <20140828093505.GC14650@leverpostej>
 <53FF624C.3090002@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FF624C.3090002@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 06:09:32PM +0100, Christopher Covington wrote:
> Hi Mark,

Hi Christopher,

> On 08/28/2014 05:35 AM, Mark Rutland wrote:
> > On Thu, Aug 28, 2014 at 04:33:31AM +0100, Doug Anderson wrote:
> >> Hi,
> >>
> >> On Wed, Aug 27, 2014 at 7:58 PM, Olof Johansson <olof@lixom.net> wrote:
> >>> On Wed, Aug 27, 2014 at 5:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >>>> On 08/27/14 15:33, Olof Johansson wrote:
> >>>>> On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >>>>>
> >>>>>> Is there any reason why the virtual counter can't be read? Maybe we're
> >>>>>> the hyp and we need to make sure we don't use the virtual timer so that
> >>>>>> the guest can use it, but that doesn't have any effect on the usage of
> >>>>>> the virtual counter for the clocksource.
> >>>>>
> >>>>> There are several cases where virtual is unusable -- in particular it
> >>>>> might not have been configured properly (i.e. the phys/virt offset is
> >>>>> at a bad value).
> >>>>
> >>>> Any specifics? It would be nice to say so in the commit text so that
> >>>> others using such devices know they need this patch. I'm guessing the
> >>>> firmware can't be fixed?
> >>
> >> Even if we could change things to use a virtual timer in some cases,
> >> Sonny's patch still fixes a bug.  The code as written right now makes
> >> pretenses about supporting the physical timer, but it doesn't work.
> >> That should be fixed.
> > 
> > The code does support the physical timer. It does not support the
> > physical counter (and makes no pretenses that it does).
> 
> I think if you could please explain the following code, that may help clear up
> some of the confusion.
> 
> 		if (arch_timer_use_virtual) {
> 			clk->irq = arch_timer_ppi[VIRT_PPI];
> 			clk->set_mode = arch_timer_set_mode_virt;
> 			clk->set_next_event = arch_timer_set_next_event_virt;
> 		} else {
> 			clk->irq = arch_timer_ppi[PHYS_SECURE_PPI];
> 			clk->set_mode = arch_timer_set_mode_phys;
> 			clk->set_next_event = arch_timer_set_next_event_phys;
> 		}
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/clocksource/arm_arch_timer.c#n272
> 
> Perhaps you mean to say the code does not support *non-secure access* to the
> physical timer?

Not quite, and one issue here is conflating the timer and the counter.

We use the physical timer iff we know it is accessible and correct to
use (e.g. when we have been booted at Hyp). If we don't know that,
arch_timer_use_virtual is set and we use the virtual timer. In that
sense, we support the use of the physical timer.

If the system is sane (with uniform CNTVOFF), that is fine. The fact
that we have a broken system to work around does not mean that the
driver is broken nor that it is making false pretenses. The driver is
perfectly functional given a sane environment.

The use of virtual/physical is not a feature that falls to personal
preference; it is a requirement for correctness that we only use the
physical timer when we have an absolute guarantee that it is possible
and correct to do so. So saying that we "support" the physical timer is
also somewhat misleading; we use what we must.

We _always_ use the virtual counter rather than the physical counter as
this saved on having different paths for host and guest (which is
important for the 64-bit VDSO, for example). In that sense we do not
support the use of the physical counter. We don't need to use it in a
sane system.

Thanks,
Mark.
