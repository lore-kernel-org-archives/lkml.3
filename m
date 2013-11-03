Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3KCVND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 16:13:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:46067 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3KCVNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:13:00 -0500
Message-ID: <1383513150.4776.33.camel@pasglop>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Mon, 04 Nov 2013 08:12:30 +1100
In-Reply-To: <20131102204021.GA13994@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
	 <1383279744.28909.26.camel@pasglop> <1383280054.28909.30.camel@pasglop>
	 <20131101160329.37f3707b@notabene.brown>
	 <1383282516.28909.36.camel@pasglop> <20131101204749.GA19662@kroah.com>
	 <1383347399.28909.46.camel@pasglop> <20131102155824.GG23938@kroah.com>
	 <1383423730.4776.16.camel@pasglop> <20131102204021.GA13994@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-02 at 13:40 -0700, Greg Kroah-Hartman wrote:
> On Sun, Nov 03, 2013 at 07:22:10AM +1100, Benjamin Herrenschmidt wrote:
> > On Sat, 2013-11-02 at 08:58 -0700, Greg Kroah-Hartman wrote:
> > > Just loop through all the platform devices before registering it to
> > > determine if you need to do this, the platform code can do this just
> > > fine.  If you try to register a duplicate name with the driver core,
> > > odds are it will complain loudly, so don't do that.
> > 
> > But that loop + registration is racy ... oh well, we might do something
> > better with Neil's idea of labels instead.
> 
> How is it racy?  Only one platform device should be allowed to be
> registered at a time, there is a per-bus lock that should be used to
> enforce this, right?

No, platform devices can be registered from different "sources" and
possibly from different threads. There's no fundamental reason why the
registration would have to be serialized accross all possible entities
capable of crating them (though it generally is at the moment).

There's no global mutex used by every piece of code in the kernel that
might create/register a platform device.

However, let's leave that aside for now and go back to the original
issue because that's probably worth discussing a bit more.

Normally, a device "name" in sysfs shouldn't be relevant to user space,
I think we agree. Devices get identified by function (class typically)
and additional functional attributes associated with them.

For platform devices, things get a bit more murky though, ie, let's say
we have a backlight device, that's good ... but nothing tells us what
specific display it controls (there could be more than one in a system).

The device-tree typically provide such cross linking, but sysfs doesn't.

My understanding, and Neil correct me if I'm wrong, is that it's become
a case where userspace has started relying on the "name" of the platform
device to identify it's specific function within a class. Is that
correct ? IE. Which screen this backlight is associated to isn't an
explicit information provided somewhere in sysfs but something intuited
by user space tools based on the platform device name.

Greg, I'm not saying that's a good thing btw :-) I'm just trying to get
a grasp of the exact scope of the problem.

Now, there's a way for userspace to sort that out using device-tree of
course, they can parse /proc/device-tree, find the linkage, and related
the device-tree nodes to the corresponding platform devices (are we
creating the devspec files btw ?)

But that only works for DT-created platform devices, not the hand-made
ones.

Another option would be for classes that are meaningless "seldomly" such
as a backlight control (ie, it's always attached to *something*, a
screen for example, etc...) to associate a separate name which isn't the
device name in sysfs but a "label" as Neil proposed. In this case we'd
need to add an attribute but I would object to this being specific to
pwm_bl, instead of should generally be an attribute of all backlight
devices.

This could then be class specific... but should it be ? it might
actually be a useful thing to generally be able to label devices,
especially in the embedded world.

But that's just one option ... the point remains, people seem to be
relying on platform device names in sysfs and yes, that's not right, but
we need to understand why they do it and what's the right way to do to
replace that practice. 

Cheers,
Ben.


