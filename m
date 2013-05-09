Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3EIPIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:08:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47443 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3EIPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:08:13 -0400
Date: Thu, 9 May 2013 16:07:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>,
        Ming Lei <tom.leiming@gmail.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
	complete during init
Message-ID: <20130509150750.GW18614@n2100.arm.linux.org.uk>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org> <1368076726-11492-2-git-send-email-skannan@codeaurora.org> <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com> <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com> <20130509135017.GD3200@sirena.org.uk> <20130509141444.GV18614@n2100.arm.linux.org.uk> <20130509143702.GE3200@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509143702.GE3200@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 03:37:02PM +0100, Mark Brown wrote:
> On Thu, May 09, 2013 at 03:14:45PM +0100, Russell King - ARM Linux wrote:
> > On Thu, May 09, 2013 at 02:50:17PM +0100, Mark Brown wrote:
> 
> > > Even if the driver copes fine it can still be desirable to avoid the
> > > power down/up cycle if it involves some user visible effect - things
> > > like blinking the display off then on for example.  That said I am a
> > > little suspicious about this approach, it doesn't feel as robust as it
> > > should to go round individual callers.
> 
> > What if the driver for something like your display is a module which
> > needs to be loaded from userland?
> 
> That's clearly a "don't do that then" sort of thing; while we don't want
> to be unhelpful there's no guarantees with this approach.

That's not a "don't do that then" thing, because in this case it's
unreasonable to say that.  The display subsystems like fbdev and
DRM represent quite a sizable chunk:

- Base DRM is around 200k.
- DRM drivers typically around 100k each.
- Base FBdev is around 100k.

It won't take long before you're into the territory of having a
significant portion of your kernel being display drivers of one
type or other, much of which won't be usable on any one specific
platform.  So to say "don't build your display drivers as modules"
is an unreasonable position to take.

> Yes, exactly - all we're trying to do here is cover the 90% case, not
> solve all the possible problems since as you say that's not achievable.  
> There's a clear and reasonable desire to turn off resources we know
> aren't in use at the current time, but equally well doing so as soon as
> we start controlling the resources is pretty much guranteed to introduce
> user visible issues on some systems so it's a question of picking some
> reasonable point after that.

I beg to differ on whether it's possible to solve it completely.

> Another option here which is more in tune with deferred probing and
> hotplugging would be to switch the delay over to be time based rather
> than initcall based; do the shutdown at some point based on the time the
> last resource was registered.  That still won't cover everything
> though we could make the delay tunable.

Yuck.  That's crap design.  Really, time based stuff is crap.  I've seen
this too many times with the gnome crap in Ubuntu 12.04 - where if you
boot this off SD card it will complain that some applets fail to start
(and sure enough, half your panel is missing.)  Boot it off eSATA and
it works 100% reliably.

Time based stuff to guess when stuff has finished is never a good thing
and can never be reliable.

A better solution may be to avoid the problem in kernel space altogether.
That's already done in the past with the scsi_wait_scan module.  Make the
the shutdown of stuff a separate loadable module which userspace can load
at the appropriate time to trigger the shutdown of unused resources.  Or
provide a different method for userspace to trigger that action.

With that kind of solution, it is possible to know that the system has
finished booting (many userspace implementations already do this with
stuff like not permitting login via network until after the system has
finished booting despite sshd et.al. already being started.)
