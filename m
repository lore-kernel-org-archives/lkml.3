Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbbAVKNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:13:19 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33995 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbAVKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:13:15 -0500
MIME-Version: 1.0
In-Reply-To: <2755822.qV1ICgGMEY@vostro.rjw.lan>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
	<1418746353-3481-4-git-send-email-octavian.purdila@intel.com>
	<2755822.qV1ICgGMEY@vostro.rjw.lan>
Date: Thu, 22 Jan 2015 12:13:13 +0200
Message-ID: <CAE1zotL9LsMjW6YC9E3iq-6Zf4u2=CpB1nh=LDUroQS9k5dTsQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: dln2: add support for ACPI
From: Octavian Purdila <octavian.purdila@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:00 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>

Hi Rafael,

Thanks for reviewing the patch.

> On Tuesday, December 16, 2014 06:12:32 PM Octavian Purdila wrote:
> > This patch adds support to load a custom ACPI table that describes
> > devices connected via the DLN2 USB to I2C/SPI/GPIO bridge.
> >
> > The ACPI table can be loaded either externally (from QEMU or with
> > CONFIG_ACPI_CUSTOM_DSDT) or it can be loaded as firmware file with the
> > name dln2.aml. The driver looks for an ACPI device entry with _HID set
> > to "DLN20000" and makes it the ACPI companion for DLN2 USB
> > sub-drivers.
> >
> > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> > ---
> >  Documentation/acpi/dln2-acpi.txt |  62 ++++++++++++++++++
> >  drivers/mfd/dln2.c               | 134 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 196 insertions(+)
> >  create mode 100644 Documentation/acpi/dln2-acpi.txt
> >
> > diff --git a/Documentation/acpi/dln2-acpi.txt b/Documentation/acpi/dln2-acpi.txt
> > new file mode 100644
> > index 0000000..d76605f
> > --- /dev/null
> > +++ b/Documentation/acpi/dln2-acpi.txt
> > @@ -0,0 +1,62 @@
> > +Diolan DLN2 custom APCI table
> > +
> > +The Diolan DLN2 is an USB to I2C/SPI/GPIO bridge and as such it can be used to
> > +connect to various I2C or SPI devices. Because these busses lack an enumeration
> > +protocol, the driver obtains various information about the device (such as I2C
> > +address and GPIO pins) from either ACPI or device tree.
> > +
> > +To allow enumerating devices and their properties via ACPI, the Diolan
> > +driver looks for an ACPI tree with the root _HID set to "DLN20000". If
> > +it finds such an ACPI object it will set the ACPI companion to the
> > +DLN2 MFD driver and from their it will be propagated to all its
> > +sub-devices (I2C, GPIO, SPI).
> > +
> > +The user can either load the custom DSDT table with three methods:
>
> s/DSDT/ACPI/

OK.

> > +
> > +1. Via QEMU (see -acpitable)
> > +
> > +2. Via the CONFIG_ACPI_CUSTOM_DSDT kernel config option (see
> > +Documentation/acpi/dsdt-override.txt)
> > +
> > +3. By placing the custom DSDT in the firmware paths in a file name
> > +dln2.aml.
>
> Surely SSDT?
>

Correct.

<snip>

> > diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> > index f9c4a0b..93f6d1d 100644
> > --- a/drivers/mfd/dln2.c
> > +++ b/drivers/mfd/dln2.c
> > @@ -23,6 +23,8 @@
> >  #include <linux/mfd/core.h>
> >  #include <linux/mfd/dln2.h>
> >  #include <linux/rculist.h>
> > +#include <linux/acpi.h>
> > +#include <linux/firmware.h>
> >
>
> OK, so correct me if I'm wrong.
>
> When the (USB) dnl2 device is probed, it is supposed to find an ACPI companion
> for itself and if it's not there, the driver will try to load a custom SSDT from
> a firmware blob in the hope that the companion will be there?
>
> So if I'm not wrong, why is this not broken?
>
> It is not sufficient to call ACPI_COMPANION_SET(dev, ai->dev) to set the device's
> companion.  acpi_bind_one() needs to be run in addition to that, but acpi_bind_one()
> is not to be called from drivers.  It is called by the core automatically during
> device registration and ACPI_COMPANION_SET() is to be used *before* that, not after.
>
> So if I'm not missing anything, the design here is entirely backwards and we
> need to talk about how to implement it correctly at the design level in the
> first place.
>

The idea here is to set the companion for the MFD sub-devices. Mika's
commit "mfd: Add ACPI support" propagates the parent's companion to
the MFD sub-devices, so it is sufficient to set the ACPI companion to
the USB device.

Then, the companion will be propagated to the sub-devices after which
acpi_bind_one() will be called for the sub-devices from
mfd_add_devices (via platform_device_add -> device_add ->
platform_notify).

It is true that the USB dev will have its ACPI companion set without
having acpi_bind_one called but I do not see any harm in that. Even
though acpi_unbind_one() is called it will not find the USB dev on the
physical node list so no put_device() imbalance is caused.

> And no, "Let's come up with a patch that sort of works, throw it at the maintainers
> and see what happens" is not an acceptable approach, sorry.

This patch is based on your feedback of the previous RFC patch set:

On Thu, Dec 11, 2014 at 11:44 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

> it seems to me that it would be much more straightforward to check for the existence
> of the "DLN20000" device when you are about to register DLN2 USB sub-devices
> and set it directly as an ACPI companion for them if present.
