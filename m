Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaEAIDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:03:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33074 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaEAIDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:03:43 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAMuHMdUdnoah1uZbMn_xONXZ2i8wG5kY7msMzCdBwS+xt9tmDA@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<7hoazpdldx.fsf@paris.lan>
	<20140429131610.29859C4094A@trevor.secretlab.ca>
	<CAMuHMdUdnoah1uZbMn_xONXZ2i8wG5kY7msMzCdBwS+xt9tmDA@mail.gmail.com>
Date: Thu, 01 May 2014 09:03:31 +0100
Message-Id: <20140501080331.D3CFAC409DA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 23:54:37 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Grant,
> 
> On Tue, Apr 29, 2014 at 3:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Fri, 25 Apr 2014 16:44:58 -0700, Kevin Hilman <khilman@linaro.org> wrote:
> >> Geert Uytterhoeven <geert+renesas@glider.be> writes:
> >>
> >> > When adding a device from DT, check if its clocks are suitable for Runtime
> >> > PM, and register them with the PM core.
> >> > If Runtime PM is disabled, just enable the clock.
> >> >
> >> > This allows the PM core to automatically manage gate clocks of devices for
> >> > Runtime PM.
> >>
> >> ...unless the device is already in an existing pm_domain, right?
> >>
> >> I like this approach, and it extends nicely what we already do on
> >> platforms using drivers/base/power/clock_ops.c into DT land.
> >>
> >> My only concern is how this will interact if it's used along with
> >> devices that have existing pm_domains.  I don't have any specific
> >> concerns (yet, because it's Friday, and my brain is turing off), but it
> >> just made me wonder if this will be potentially confusing.
> >
> > I have big concerns about this approach. First, it will only work if
> > a clock is available at deivce creation time. The conversion of irq
> > controllers to normal device drivers has already shown that is a bad
> > idea.
> 
> That's  indeed a valid concern that needs to be addressed.
> 
> > I also don't like that it tries to set up every clock, but there is no
> > guarantee that the driver will even use it. I would rather see this
> > behaviour linked into the function that obtains the clock at driver
> > .probe() time. That way it can handle deferred probe correctly and it
> > only sets up clocks that are actually used by the driver.
> 
> Not every clock. Only the clocks that are advertised by the clock driver as
> being suitable for runtime_pm management. These are typically module
> clocks, that must be enabled for the module to work. The driver doesn't
> always want to handle these explicitly.

Help me out here becasue I don't understand how that works with this
patch set. From my, admittedly naive, reading it looks like the setup is
being done at device creation time, but if the driver (or module) gets
to declare which clocks need to be enabled in order to work, then that
information is not available at device creation time.

> In fact we have one case on shmobile where the module clock for an IP
> core (rcar-gpio) is enabled unconditionally in one SoC,  while it became
> controllable through a gate clock in a later SoC.
> With my patch, just adding the clock to the DT node is sufficient to make
> it work.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

