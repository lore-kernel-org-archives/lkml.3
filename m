Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaCZLAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:00:05 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39244 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147AbaCZLAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:00:03 -0400
Date: Wed, 26 Mar 2014 10:59:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: machine_power_off should not return
Message-ID: <20140326105940.GX7528@n2100.arm.linux.org.uk>
References: <1395684784-12601-1-git-send-email-sebastian.capella@linaro.org> <20140325224554.GC12185@arch.cereza> <20140326005115.GW7528@n2100.arm.linux.org.uk> <20140326101227.GC941@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326101227.GC941@arch.cereza>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 07:12:27AM -0300, Ezequiel Garcia wrote:
> On Mar 26, Russell King - ARM Linux wrote:
> > On Tue, Mar 25, 2014 at 07:45:55PM -0300, Ezequiel Garcia wrote:
> > > 
> > > Without this patch we got the heartbeat's reboot_notifier called twice while
> > > testing the recent hibernation patches, which was unexpected and produced a
> > > kernel panic: https://lkml.org/lkml/2014/3/19/363
> > 
> > I don't see why we should make this change.  kernel/reboot.c handles
> > this function returning, so other places should do too.
> > 
> > Even on x86, this function can return:
> > 
> [..]
> > 
> > Therefore, I'd say... it's a bug in the hibernation code - or we probably
> > have many buggy architectures.  I'd suggest fixing the hibernation code
> > rather than stuffing some workaround like an endless loop into every
> > architecture.
> > 
> 
> Which is exactly what Sebastian did first:
> 
> https://lkml.org/lkml/2014/3/20/605
> 
> But Pavel asked to fix ARM's machine_power_off instead.
> 
> Also, looking at the other architectures, it seems this API is not well
> defined: some of them have an infinite loop, some don't. So it's hard to
> say the function is supposed to return or not.

I'm going by x86 (which I regard as definitive) and the generic power-off
kernel code (which I've looked at all the way back to 2.6.12-rc2).

The hibernation code path should really be fixed - the paths in
kernel/reboot.c have coped for 9+ with all of these platform hooks
returning, and it's only the silly switch() in the hibernation code
that doesn't use a "default" case to handle the kernel_halt() case
which is the real cause of the problem.

As you've found, calling kernel_power_off() followed by kernel_halt()
leads to bugs in drivers: this is not an architecture thing, it's partly
a hibernation code failure for doing that, and partly a driver bug for
trying to unregister something that it's already unregistered.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
