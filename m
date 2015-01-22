Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbbAVVrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:47:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57480 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753368AbbAVVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:46:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3/4] mfd: dln2: add support for ACPI
Date: Thu, 22 Jan 2015 23:09:33 +0100
Message-ID: <1879413.uF8phu1QrE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAE1zotL9LsMjW6YC9E3iq-6Zf4u2=CpB1nh=LDUroQS9k5dTsQ@mail.gmail.com>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com> <2755822.qV1ICgGMEY@vostro.rjw.lan> <CAE1zotL9LsMjW6YC9E3iq-6Zf4u2=CpB1nh=LDUroQS9k5dTsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 22, 2015 12:13:13 PM Octavian Purdila wrote:
> On Thu, Jan 22, 2015 at 4:00 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> 
> Hi Rafael,
> 
> Thanks for reviewing the patch.
> 
> > On Tuesday, December 16, 2014 06:12:32 PM Octavian Purdila wrote:
> > > This patch adds support to load a custom ACPI table that describes
> > > devices connected via the DLN2 USB to I2C/SPI/GPIO bridge.
> > >
> > > The ACPI table can be loaded either externally (from QEMU or with
> > > CONFIG_ACPI_CUSTOM_DSDT) or it can be loaded as firmware file with the
> > > name dln2.aml. The driver looks for an ACPI device entry with _HID set
> > > to "DLN20000" and makes it the ACPI companion for DLN2 USB
> > > sub-drivers.
> > >
> > > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> > > ---
> > >  Documentation/acpi/dln2-acpi.txt |  62 ++++++++++++++++++
> > >  drivers/mfd/dln2.c               | 134 +++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 196 insertions(+)
> > >  create mode 100644 Documentation/acpi/dln2-acpi.txt
> > >
> > > diff --git a/Documentation/acpi/dln2-acpi.txt b/Documentation/acpi/dln2-acpi.txt
> > > new file mode 100644
> > > index 0000000..d76605f
> > > --- /dev/null
> > > +++ b/Documentation/acpi/dln2-acpi.txt
> > > @@ -0,0 +1,62 @@
> > > +Diolan DLN2 custom APCI table
> > > +
> > > +The Diolan DLN2 is an USB to I2C/SPI/GPIO bridge and as such it can be used to
> > > +connect to various I2C or SPI devices. Because these busses lack an enumeration
> > > +protocol, the driver obtains various information about the device (such as I2C
> > > +address and GPIO pins) from either ACPI or device tree.
> > > +
> > > +To allow enumerating devices and their properties via ACPI, the Diolan
> > > +driver looks for an ACPI tree with the root _HID set to "DLN20000". If
> > > +it finds such an ACPI object it will set the ACPI companion to the
> > > +DLN2 MFD driver and from their it will be propagated to all its
> > > +sub-devices (I2C, GPIO, SPI).
> > > +
> > > +The user can either load the custom DSDT table with three methods:
> >
> > s/DSDT/ACPI/
> 
> OK.
> 
> > > +
> > > +1. Via QEMU (see -acpitable)
> > > +
> > > +2. Via the CONFIG_ACPI_CUSTOM_DSDT kernel config option (see
> > > +Documentation/acpi/dsdt-override.txt)
> > > +
> > > +3. By placing the custom DSDT in the firmware paths in a file name
> > > +dln2.aml.
> >
> > Surely SSDT?
> >
> 
> Correct.
> 
> <snip>
> 
> > > diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> > > index f9c4a0b..93f6d1d 100644
> > > --- a/drivers/mfd/dln2.c
> > > +++ b/drivers/mfd/dln2.c
> > > @@ -23,6 +23,8 @@
> > >  #include <linux/mfd/core.h>
> > >  #include <linux/mfd/dln2.h>
> > >  #include <linux/rculist.h>
> > > +#include <linux/acpi.h>
> > > +#include <linux/firmware.h>
> > >
> >
> > OK, so correct me if I'm wrong.
> >
> > When the (USB) dnl2 device is probed, it is supposed to find an ACPI companion
> > for itself and if it's not there, the driver will try to load a custom SSDT from
> > a firmware blob in the hope that the companion will be there?
> >
> > So if I'm not wrong, why is this not broken?
> >
> > It is not sufficient to call ACPI_COMPANION_SET(dev, ai->dev) to set the device's
> > companion.  acpi_bind_one() needs to be run in addition to that, but acpi_bind_one()
> > is not to be called from drivers.  It is called by the core automatically during
> > device registration and ACPI_COMPANION_SET() is to be used *before* that, not after.
> >
> > So if I'm not missing anything, the design here is entirely backwards and we
> > need to talk about how to implement it correctly at the design level in the
> > first place.
> >
> 
> The idea here is to set the companion for the MFD sub-devices. Mika's
> commit "mfd: Add ACPI support" propagates the parent's companion to
> the MFD sub-devices, so it is sufficient to set the ACPI companion to
> the USB device.

For the USB device itself you'll then end up with an incomplete binding (you
can't get back to the USB device from the ACPI object), so no, it isn't
sufficient.

> Then, the companion will be propagated to the sub-devices after which
> acpi_bind_one() will be called for the sub-devices from
> mfd_add_devices (via platform_device_add -> device_add ->
> platform_notify).

In fact, your use case doesn't seem to cover any of the use cases that
the Mika's commit addressed.  Namely, your parent device doesn't have
an ACPI companion to start with and you want your MFD cells to be bound
to the "DLN2000" thing.  That's why you're setting the ACPI companion
for the USB device, isn't it?

> It is true that the USB dev will have its ACPI companion set without
> having acpi_bind_one called but I do not see any harm in that. Even
> though acpi_unbind_one() is called it will not find the USB dev on the
> physical node list so no put_device() imbalance is caused.

Well, there are places where it matters.  Some links in sysfs will be missing
for one example.  Also please see the changelog of commit 52870786ff5d (ACPI:
Use ACPI companion to match only the first physical device).

Bottom line: You really should be using acpi_bind_one() here and
acpi_unbind_one() on disconnect if you have to.

> > And no, "Let's come up with a patch that sort of works, throw it at the maintainers
> > and see what happens" is not an acceptable approach, sorry.
> 
> This patch is based on your feedback of the previous RFC patch set:

Oh, is it?  I can't recall advising you to use request_firmware() for
uploading ACPI tables or some other questionable things that the patch is
doing.

And if it still was an RFC, that wouldn't be a problem, but if you just send
non-RFC patches out, that means you want people to merge them.  This is bad
if the patches in question are not in a good enough shape and this one isn't.

Now, why is this a bad idea to load ACPI tables from a driver using
request_firmware()?  Because those tables are not device firmare.  They are
not firmware that you load into a device to make it work (which then works
with all instances of the given hardware), they are part of system configuration
information and have to match what's there in the system.  For instance, if you
ship your example SSDT with a general-purpose distro, it may just not match the
hardware configuration of systems that people will try to use it with.

So, while it is sort of OK to look up "DLN2000" and bind the USB device to
that by hand (although this looks ugly to me), it is not OK to load a random
custom SSDT if it is missing.

We need to add a generic mechanism for loading custom SSDTs not present in the
firmware image and maybe even to load them on demand, but that cannot happen in
an ad-hoc way.  So the entire table loading-unloading code in your patch can go
away for now and you need to fail probing if the "DLN2000" ACPI object is not
present.

Also I think you need to add "DLN2000" to the blacklist in drivers/acpi/acpi_platform.c
to prevent the ACPI core from creating a platform device for it automatically.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
