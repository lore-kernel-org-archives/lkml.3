Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3KVWxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:53:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3KVWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:53:31 -0500
Date: Fri, 22 Nov 2013 14:53:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20131122225330.GA25361@kroah.com>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
 <20130316162140.GB2630@kroah.com>
 <20131122224734.GB12800@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122224734.GB12800@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:47:38PM -0800, Dmitry Torokhov wrote:
> On Sat, Mar 16, 2013 at 09:21:40AM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Mar 14, 2013 at 08:24:45PM -0700, Guenter Roeck wrote:
> > > Provide devres functions for device_create_file, sysfs_create_file,
> > > and sysfs_create_group plus the respective remove functions.
> > > 
> > > Idea is to be able to drop calls to the remove functions from the various
> > > drivers using those calls.
> > 
> > Hm, despite the fact that almost every driver that makes these calls is
> > broken?  :)
> > 
> > > Potential savings are substantial. There are more than 700 calls to
> > > device_remove_file in the kernel, more than 500 calls to sysfs_remove_group,
> > > and some 50 calls to sysfs_remove_file (though not all of those use dev->kobj
> > > as parameter). Expanding the API to sysfs_create_bin_file would add another 80+
> > > opportunities, and adding sysfs_create_link would create another 100 or so.
> > 
> > The idea is nice, but why are these drivers adding sysfs files on their
> > own?  Are they doing this in a way that is race-free with userspace
> > (i.e. creating them before userspace is told about the device), or are
> > they broken and need to have these calls added to the "default
> > device/driver/bus" attribute list for them instead?
> 
> Just stumbled upon this thread...
> 
> There is a need for drivers to add driver-specific attributes to a
> device. Since they are driver specific they can not go into bus or class
> or whatever default attributes that are created when device is
> instantiated, but rather attached to the device when a driver binds to
> them. An example would be a PS/2 mouse driver allowing user to control
> report rate and resolution of the device. Since it only applicable to
> PS/2 mice the knob does not belong to the generic serio layer/bus nor
> should it go into input layer as it is again PS/2 specific. So psmouse
> creates it while binding to a serio port.

Yeah, platform drivers also "need" this type of thing as well, so you
are right, I can't forbit it for everyone.

> Do we send a uevent when driver binds/unbinds from a device?

No, we don't, see kobject_actions[] for what we implement.

> If not I think we should so that userspace can check for additional
> attributes, if any.

We might be able to do a "change" event for the device itself after it
has been bound / unbound, but I don't know what userspace will do with
that information at this point in time (i.e. 10+ years without that
information...)

thanks,

greg k-h
