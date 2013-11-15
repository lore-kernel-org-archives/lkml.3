Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3KOPFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:05:34 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:37822 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3KOPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:04:33 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: Strange location and name for platform  devices when device-tree is used.
To: NeilBrown <neilb@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20131102104505.34105cbb@notabene.brown>
References: <20131101145925.66e22f73@notabene.brown> <1383279744.28909.26. camel@pasglop> <1383280054.28909.30.camel@pasglop> <20131101160329.37f3707b @notabene.brown> <1383282516.28909.36.camel@pasglop> <20131101204749. GA19662@kroah.com> <1383347425.28909.63.camel@pasglop> <20131102104505. 34105cbb@notabene.brown>
Date: Fri, 15 Nov 2013 16:44:16 +0900
Message-Id: <20131115074416.4DA8DC40828@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Nov 2013 10:45:05 +1100, NeilBrown <neilb@suse.de> wrote:
> On Sat, 02 Nov 2013 10:10:25 +1100 Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> 
> > On Fri, 2013-11-01 at 13:47 -0700, Greg Kroah-Hartman wrote:
> > 
> > > > > On my device I seem to have some platform devices registered through
> > > > > device-tree, and some registered through platform_device_add (e.g.
> > > > > 'alarmtimer').  Guaranteeing they remain disjoint sets if the kernel is
> > > > > allowed to evolve independently of the devicetree might be tricky....
> > > > > Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platform" ??
> > > > 
> > > > No, I think device-tree created platform devices should go
> > > > to /sys/devices/platform like the "classic" ones.
> > > > 
> > > > The problem is really how to deal with potential name duplication. We
> > > > could try to register, if we get -EEXIST (assuming sysfs returns the
> > > > right stuff), try again with ".1" etc...
> > > 
> > > How can there be device name collisions?  All platform devices _should_
> > > be named uniquely, if not, you have bigger problems...
> > 
> > The problem is how to create a unique name for a platform device created
> > from a device-tree node.
> > 
> > Device tree nodes aren't necessarily uniquely named. They are unique
> > under a given parent but that hierarchy isn't preserved when creating
> > corresponding platform devices (and it would be very tricky to do so).
> > 
> > Currently, we simply append a number to the name when creating them,
> > which is obtained from a global counter.
> > 
> > Neil is unhappy about that because on his specific hardware, the device
> > has a unique name and thus we introduce a naming difference between
> > device-tree usage and old-style "hard coded" board file usage.
> 
> It occurs to me that a different approach could solve my problem.
> 
> My problem stems from the fact that the name of the device on the
> platform-bus is used as the name of the device in the "backlight" class.
> 
> As Greg writes elsewhere, depending on names with /sys/devices is not
> supported - we need to accept that bus-names might change.
> However names in class devices tend to be a lot more stable.
> Several devices allow these to be explicitly set.
>  leds have 'label'
>  regulators has "regulator-name"
>  gpio-keys has 'label'.
> 
> I could just teach pwm_bl to allow a 'label' property which would be used in
> place of the platform-bus device name when creating the class/backlight
> device.
> 
> The maxim "you cannot trust names to remain stable in /sys/devices" can
> justify both the movement of platform devices into /sys/devices/platform, and
> the use of "label" rather than the device-name for creating the class device.
> 
> Does that sound convincing?

The problem with a property in the node in this case is that there is no
guarantee of uniqueness. An alternative however would be to look for an
alias in /aliases. Those are unique.

g.
