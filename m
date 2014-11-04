Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaKDP7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:59:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62212 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753216AbaKDP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:59:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH v6 02/12] Driver core: Unified device properties interface for platform firmware
Date: Tue, 04 Nov 2014 17:20:06 +0100
Message-ID: <1582415.u6tVhgLb2d@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141104155112.6FC67C423D0@trevor.secretlab.ca>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan> <2127128.VT1Iq03xz1@vostro.rjw.lan> <20141104155112.6FC67C423D0@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 03:51:12 PM Grant Likely wrote:
> On Tue, 21 Oct 2014 23:15:50 +0200
> , "Rafael J. Wysocki" <rjw@rjwysocki.net>
>  wrote:
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> > 
> > Add a uniform interface by which device drivers can request device
> > properties from the platform firmware by providing a property name
> > and the corresponding data type.  The purpose of it is to help to
> > write portable code that won't depend on any particular platform
> > firmware interface.
> > 
> > The following general helper functions are added:
> > 
> > device_property_present()
> > device_property_read_u8()
> > device_property_read_u16()
> > device_property_read_u32()
> > device_property_read_u64()
> > device_property_read_string()
> > device_property_read_u8_array()
> > device_property_read_u16_array()
> > device_property_read_u32_array()
> > device_property_read_u64_array()
> > device_property_read_string_array()
> > 
> > The first one allows the caller to check if the given property is
> > present.  The next 5 of them allow single-valued properties of
> > various types to be retrieved in a uniform way.  The remaining 5 are
> > for reading properties with multiple values (arrays of either numbers
> > or strings).
> > 
> > The interface covers both ACPI and Device Trees.
> > 
> > This change set includes material from Mika Westerberg and Aaron Lu.
> > 
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > Changes from v5:
> > - acpi_dev_prop_read() can now handle both list (package) and single-value
> >   properties (the latter are tried first for the last argument equal to 1).
> > - There is a new macro to generate the bodies of device_property_read_u*_array().
> > - device_property_read_u*() are implemented using device_property_read_u*_array().
> > - device_property_read_bool() is a new static inline wrapper around
> >   device_property_present().
> > 
> > ---
> >  drivers/acpi/property.c  |  178 +++++++++++++++++++++++++++++++++++
> >  drivers/base/Makefile    |    2 
> >  drivers/base/property.c  |  233 +++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/of/base.c        |  106 ++++++++++++++++++---
> >  include/linux/acpi.h     |   32 ++++++
> >  include/linux/of.h       |   22 ++++
> >  include/linux/property.h |   53 ++++++++++
> >  7 files changed, 609 insertions(+), 17 deletions(-)
> >  create mode 100644 drivers/base/property.c
> >  create mode 100644 include/linux/property.h
> > 
> > Index: linux-pm/include/linux/property.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-pm/include/linux/property.h
> > @@ -0,0 +1,53 @@
> > +/*
> > + * property.h - Unified device property interface.
> > + *
> > + * Copyright (C) 2014, Intel Corporation
> > + * Authors: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > + *          Mika Westerberg <mika.westerberg@linux.intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef _LINUX_PROPERTY_H_
> > +#define _LINUX_PROPERTY_H_
> > +
> > +#include <linux/types.h>
> > +
> > +struct device;
> > +
> > +enum dev_prop_type {
> > +	DEV_PROP_U8,
> > +	DEV_PROP_U16,
> > +	DEV_PROP_U32,
> > +	DEV_PROP_U64,
> > +	DEV_PROP_STRING,
> > +	DEV_PROP_MAX,
> > +};
> > +
> > +bool device_property_present(struct device *dev, const char *propname);
> > +int device_property_read_u8_array(struct device *dev, const char *propname,
> > +				  u8 *val, size_t nval);
> > +int device_property_read_u16_array(struct device *dev, const char *propname,
> > +				   u16 *val, size_t nval);
> > +int device_property_read_u32_array(struct device *dev, const char *propname,
> > +				   u32 *val, size_t nval);
> > +int device_property_read_u64_array(struct device *dev, const char *propname,
> > +				   u64 *val, size_t nval);
> > +int device_property_read_string_array(struct device *dev, const char *propname,
> > +				      char **val, size_t nval);
> 
> I'm not sure if I asked this elsewhere. Can 'val' be made a const char **?

You did. :-)

I have a new version of the patch with that change.  I'll send it in a while.

Rafael

