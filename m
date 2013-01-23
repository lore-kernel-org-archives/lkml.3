Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3AWNyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:54:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:51806 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab3AWNyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:54:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / PM: Expose lists of device power resources to user space
Date: Wed, 23 Jan 2013 15:00:21 +0100
Message-ID: <5602050.KDl1yUI4oH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130123010359.GA2024@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <4989050.jK98Xm5BOW@vostro.rjw.lan> <20130123010359.GA2024@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 05:03:59 PM Greg Kroah-Hartman wrote:
> On Wed, Jan 23, 2013 at 01:17:47AM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, January 23, 2013 01:08:54 AM Rafael J. Wysocki wrote:
> > > On Tuesday, January 22, 2013 03:56:24 PM Greg Kroah-Hartman wrote:
> > > > On Tue, Jan 22, 2013 at 03:28:23AM +0100, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > > Oh, and same question about racing userspace, you will have problems
> > > > here in that the symlinks will be showing up after the device is
> > > > created.  Perhaps, to make the whole thing easier, you just change the
> > > > acpi core code to hold off on the notification until you get all of
> > > > these links and files set up and then tell userspace.  That's probably
> > > > an easier fix.
> > > 
> > > I suppose so.
> > > 
> > > How can I do that?
> > 
> > Should I set dev->kobj.uevent_suppress before calling device_register() and
> > then clear it and call the kobject_uevent(&dev->kobj, KOBJ_ADD) from the ACPI
> > core after device_register() has returned and the files have been created?
> 
> Ick, that might work, but the "traditional" way is to just do the
> creation of the device in two steps.
> 
> First call device_initialize().  Then you can do what you want to the
> device, add sysfs files, etc.  Then call device_add() which "finalizes"
> the device in the driver core and tells userspace all about it.

Well, this quite obviously doesn't work. :-)

If I call acpi_device_setup_files() between device_initialize() and
device_add(), it will trigger the BUG_ON() in sysfs_create_file(), because
kobj->sd is still NULL at this point.

> The USB core has been doing this since the beginning of time (well, since we
> wrote the driver model) and it has worked out pretty well.

I guess it does something slightly different from what I need to do, however.

> Calling dev_set_uevent_suppress() would also probably work, like you
> point out the firmware core uses this.

I think I'll need to use this approach.  I think that it still will be prudent
to call device_initialize() before dev_set_uevent_suppress(), though.

I'll post a new series including this later today.

> Hm, it uses this to create some sysfs files and then tell userspace about
> them, even though it uses device_add(), that's "odd".

Well, it seems to have the same problem as I do (described above).
 
> Either way should be fine, you can run 'udevadm monitor' as root to
> watch the sysfs events be sent from the kernel to make sure you have it
> all working properly.

Unfortunately, core ACPI device objects are created way too early for user
space to be useful and I don't have any systems with ACPI-based hotplug around
here ...

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
