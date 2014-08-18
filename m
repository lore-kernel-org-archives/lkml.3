Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaHRI16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:27:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:52482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaHRI14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,884,1400050800"; 
   d="scan'208";a="586256127"
Date: Mon, 18 Aug 2014 11:27:48 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/9] ACPI: Add support for device specific properties
Message-ID: <20140818082656.GR2462@lahna.fi.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-2-git-send-email-mika.westerberg@linux.intel.com>
 <53F1B5A9.8060307@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F1B5A9.8060307@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 04:13:29PM +0800, Hanjun Guo wrote:
> Hi,
> 
> Some minor comments below.
> 
> On 2014-8-17 14:04, Mika Westerberg wrote:
> > Device Tree is used in many embedded systems to describe the system
> > configuration to the OS. It supports attaching properties or name-value
> > pairs to the devices it describe. With these properties one can pass
> > additional information to the drivers that would not be available
> > otherwise.
> > 
> > ACPI is another configuration mechanism (among other things) typically
> > seen, but not limited to, x86 machines. ACPI allows passing arbitrary
> > data from methods but there has not been mechanism equivalent to Device
> > Tree until the introduction of _DSD in the recent publication of the
> > ACPI 5.1 specification.
> > 
> > In order to facilitate ACPI usage in systems where Device Tree is
> > typically used, it would be beneficial to standardize a way to retrieve
> > Device Tree style properties from ACPI devices, which is what we do in
> > this patch.
> > 
> > If a given device described in ACPI namespace wants to export properties it
> > must implement _DSD method (Device Specific Data, introduced with ACPI 5.1)
> > that returns the properties in a package of packages. For example:
> > 
> > 	Name (_DSD, Package () {
> > 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > 		Package () {
> > 			Package () {"name1", <VALUE1>},
> > 			Package () {"name2", <VALUE2>},
> > 			...
> > 		}
> > 	})
> > 
> > The UUID reserved for properties is daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> > and is documented in the ACPI 5.1 companion document called "_DSD
> > Implementation Guide" [1], [2].
> > 
> > We add several helper functions that can be used to extract these
> > properties and convert them to different Linux data types.
> > 
> > The ultimate goal is that we only have one device property API that
> > retrieves the requested properties from Device Tree or from ACPI
> > transparent to the caller.
> > 
> > [1] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> > [2] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > 
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/acpi/Makefile   |   1 +
> >  drivers/acpi/internal.h |   6 +
> >  drivers/acpi/property.c | 365 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/acpi/scan.c     |   2 +
> >  include/acpi/acpi_bus.h |   7 +
> >  include/linux/acpi.h    |  40 ++++++
> >  6 files changed, 421 insertions(+)
> >  create mode 100644 drivers/acpi/property.c
> > 
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index ea55e0179f81..6e8269a111db 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -45,6 +45,7 @@ acpi-y				+= acpi_pnp.o
> >  acpi-y				+= power.o
> >  acpi-y				+= event.o
> >  acpi-y				+= sysfs.o
> > +acpi-y				+= property.o
> >  acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o
> >  acpi-$(CONFIG_DEBUG_FS)		+= debugfs.o
> >  acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
> > diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> > index 7de5b603f272..35001e2a8769 100644
> > --- a/drivers/acpi/internal.h
> > +++ b/drivers/acpi/internal.h
> > @@ -178,4 +178,10 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev);
> >  bool acpi_osi_is_win8(void);
> >  #endif
> >  
> > +/*--------------------------------------------------------------------------
> > +				Device properties
> > +  -------------------------------------------------------------------------- */
> > +void acpi_init_properties(struct acpi_device *adev);
> > +void acpi_free_properties(struct acpi_device *adev);
> > +
> >  #endif /* _ACPI_INTERNAL_H_ */
> > diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
> > new file mode 100644
> > index 000000000000..093e834c35db
> > --- /dev/null
> > +++ b/drivers/acpi/property.c
> > @@ -0,0 +1,365 @@
> > +/*
> > + * ACPI device specific properties support.
> > + *
> > + * Copyright (C) 2014, Intel Corporation
> > + * All rights reserved.
> > + *
> > + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> > + *          Darren Hart <dvhart@linux.intel.com>
> > + *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/device.h>
> > +#include <linux/export.h>
> > +
> > +#include "internal.h"
> > +
> > +/* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
> > +static const u8 prp_uuid[16] = {
> 
> s/prp_uuid/dsd_uuid ?

Well, it is actually the _DSD UUID that implements ACPI device
properties (hence the prp_) but I have no problems in changing that to
dsd_uuid instead.

> 
> > +	0x14, 0xd8, 0xff, 0xda, 0xba, 0x6e, 0x8c, 0x4d,
> > +	0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01
> > +};
> > +
> > +static bool acpi_property_value_ok(const union acpi_object *value)
> > +{
> > +	int j;
> > +
> > +	/*
> > +	 * The value must be an integer, a string, a reference, or a package
> > +	 * whose every element must be an integer, a string, or a reference.
> > +	 */
> > +	switch (value->type) {
> > +	case ACPI_TYPE_INTEGER:
> > +	case ACPI_TYPE_STRING:
> > +	case ACPI_TYPE_LOCAL_REFERENCE:
> > +		return true;
> > +
> > +	case ACPI_TYPE_PACKAGE:
> > +		for (j = 0; j < value->package.count; j++)
> > +			switch (value->package.elements[j].type) {
> > +			case ACPI_TYPE_INTEGER:
> > +			case ACPI_TYPE_STRING:
> > +			case ACPI_TYPE_LOCAL_REFERENCE:
> > +				continue;
> > +
> > +			default:
> > +				return false;
> > +			}
> > +
> > +		return true;
> > +	}
> > +	return false;
> > +}
> > +
> > +static bool acpi_properties_format_valid(const union acpi_object *properties)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < properties->package.count; i++) {
> > +		const union acpi_object *property;
> > +
> > +		property = &properties->package.elements[i];
> > +		/*
> > +		 * Only two elements allowed, the first one must be a string and
> > +		 * the second one has to satisfy certain conditions.
> > +		 */
> > +		if (property->package.count != 2
> > +		    || property->package.elements[0].type != ACPI_TYPE_STRING
> > +		    || !acpi_property_value_ok(&property->package.elements[1]))
> > +			return false;
> > +	}
> > +	return true;
> > +}
> > +
> > +void acpi_init_properties(struct acpi_device *adev)
> > +{
> > +
> 
> I think the above line is not needed.

Right, I'll remove it.

> With that fixed,
> 
> Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>

Thanks!
