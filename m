Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaJ1ITd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:19:33 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34371 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ1IT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:19:27 -0400
Date: Tue, 28 Oct 2014 09:16:16 +0100
From: Johan Hovold <johan@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johan Hovold <johan@kernel.org>,
        Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141028081616.GL2006@localhost>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
 <20141024160845.GM26941@saruman>
 <20141024190251.GB19377@localhost>
 <20141024192540.GD11455@saruman>
 <20141024192948.GE11455@saruman>
 <20141024193655.GD19377@localhost>
 <20141024194442.GG11455@saruman>
 <20141024195532.GF19377@localhost>
 <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028002552.GX12379@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:25:52AM +0000, Russell King - ARM Linux wrote:
> On Mon, Oct 27, 2014 at 04:22:51PM -0700, Andrew Morton wrote:
> > On Fri, 24 Oct 2014 21:55:32 +0200 Johan Hovold <johan@kernel.org> wrote:
> > > I will. :) Just wanted to see whether Andrew preferred I resend the
> > > whole series or just that one patch first.
> > > 
> > > The diff is minimal:
> > > 
> > > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > > index e74750f00b18..e4f97ad9eb21 100644
> > > --- a/drivers/rtc/rtc-omap.c
> > > +++ b/drivers/rtc/rtc-omap.c
> > > @@ -423,6 +423,8 @@ static void omap_rtc_power_off(void)
> > >         val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
> > >         rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
> > >                         val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
> > > +
> > > +       mdelay(2000);
> > >  }
> > 
> > Yes, having read this threadlet: we need a very good comment in there
> > explaining what's going on, please.
> >
> > Do we even need this delay on anything other than arm?  Or even on all arm?
> 
> I think I've already commented on the behaviour of the reboot syscalls
> such as power off which can return to userspace, pointing out that
> x86 can return to userspace.
> 
> As long as x86 can return to userspace, I see no harm in ARM returning
> to userspace.  If a driver which is hooking into the power off stuff
> is unable to immediately shut off the power (wtf it can't for 2 sec
> I've no idea) then having that driver work around that hardware's
> specific brokenness with a delay seems entirely reasonable.

Yeah, there are two issues here. If a power-off handler is crazy slow
there really should be a delay in the handler. That was just an
oversight on my part. [ In this case it takes between one and two
seconds due to the resolution of the rtc and they way it's alarm events
are triggered. ]

The other issue is whether arch code should inform the user about failed
power-off, in really exactly the same way as it does for failed reboot,
see:

	ac15e00b1efe ("ARM: restart: move reboot failure handing into
	machine_restart()"

by Russell.

It looks like we're soon to be having power-off call chains, with
configurable priorities, to shut of various parts of the hardware and
this is all at least partly configurable through DT. [1] I think it's
reasonable to expect to see more frequent failures to power off either
due to (DT) misconfiguration or broken or flakey hardware.

Having a short delay (I proposed 1s as for reboot) would also prevent
any oopses when returning to user-space for just quite slow devices
(e.g. millisecond range) without requiring explicit delays in these
handlers.

But as Andrew points out above, this really isn't an arm-specific issue,
and currently various arches deal with this differently, where some
return to user-space, some spin indefinitely (without an error message),
and some spin on failed reboot but not power-off (e.g. arm and arm64).

> That allows those SoCs which can do the right thing to do the right
> thing without being hindered by such silliness.  And it also stops
> the next person coming along and bumping the delay from 2 to 3, to 5,
> and then what... 10 seconds?

That wouldn't be an issue then. Arch code would only handle the
non-crazy case and complete power-off failures.

> Keeping it in the driver means that the workaround for the broken
> hardware is kept with the driver for the broken hardware - exactly
> where it should be.

Agreed.

Johan

[1] https://lkml.org/lkml/2014/10/27/506
