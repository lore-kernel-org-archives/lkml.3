Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaJFNua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:50:30 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53412 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaJFNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:50:25 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH v2 01/16] ACPI: Add support for device specific
 properties
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1410868367-11056-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410868367-11056-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 06 Oct 2014 14:50:21 +0100
Message-Id: <20141006135021.0EB04C43FBE@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 14:52:32 +0300
, Mika Westerberg <mika.westerberg@linux.intel.com>
 wrote:
> Device Tree is used in many embedded systems to describe the system
> configuration to the OS. It supports attaching properties or name-value
> pairs to the devices it describe. With these properties one can pass
> additional information to the drivers that would not be available
> otherwise.
> 
> ACPI is another configuration mechanism (among other things) typically
> seen, but not limited to, x86 machines. ACPI allows passing arbitrary
> data from methods but there has not been mechanism equivalent to Device
> Tree until the introduction of _DSD in the recent publication of the
> ACPI 5.1 specification.
> 
> In order to facilitate ACPI usage in systems where Device Tree is
> typically used, it would be beneficial to standardize a way to retrieve
> Device Tree style properties from ACPI devices, which is what we do in
> this patch.
> 
> If a given device described in ACPI namespace wants to export properties it
> must implement _DSD method (Device Specific Data, introduced with ACPI 5.1)
> that returns the properties in a package of packages. For example:
> 
> 	Name (_DSD, Package () {
> 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> 		Package () {
> 			Package () {"name1", <VALUE1>},
> 			Package () {"name2", <VALUE2>},
> 			...
> 		}
> 	})
> 
> The UUID reserved for properties is daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> and is documented in the ACPI 5.1 companion document called "_DSD
> Implementation Guide" [1], [2].
> 
> We add several helper functions that can be used to extract these
> properties and convert them to different Linux data types.
> 
> The ultimate goal is that we only have one device property API that
> retrieves the requested properties from Device Tree or from ACPI
> transparent to the caller.
> 
> [1] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> [2] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/acpi/Makefile   |   1 +
>  drivers/acpi/internal.h |   6 +
>  drivers/acpi/property.c | 364 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/scan.c     |   2 +
>  include/acpi/acpi_bus.h |   7 +
>  include/linux/acpi.h    |  40 ++++++
>  6 files changed, 420 insertions(+)
>  create mode 100644 drivers/acpi/property.c
> 
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 505d4d79fe3e..ba2cafe18fe4 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -46,6 +46,7 @@ acpi-y				+= acpi_pnp.o
>  acpi-y				+= power.o
>  acpi-y				+= event.o
>  acpi-y				+= sysfs.o
> +acpi-y				+= property.o
>  acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o
>  acpi-$(CONFIG_DEBUG_FS)		+= debugfs.o
>  acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 4c5cf77e7576..e34290c7af9f 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -181,4 +181,10 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev);
>  bool acpi_osi_is_win8(void);
>  #endif
>  
> +/*--------------------------------------------------------------------------
> +				Device properties
> +  -------------------------------------------------------------------------- */
> +void acpi_init_properties(struct acpi_device *adev);
> +void acpi_free_properties(struct acpi_device *adev);
> +
>  #endif /* _ACPI_INTERNAL_H_ */
> diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
> new file mode 100644
> index 000000000000..c4a3e800e82c
> --- /dev/null
> +++ b/drivers/acpi/property.c
> @@ -0,0 +1,364 @@
> +/*
> + * ACPI device specific properties support.
> + *
> + * Copyright (C) 2014, Intel Corporation
> + * All rights reserved.
> + *
> + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *          Darren Hart <dvhart@linux.intel.com>
> + *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/device.h>
> +#include <linux/export.h>
> +
> +#include "internal.h"
> +
> +/* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
> +static const u8 prp_uuid[16] = {
> +	0x14, 0xd8, 0xff, 0xda, 0xba, 0x6e, 0x8c, 0x4d,
> +	0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01
> +};

?

What is the encoding used here? I see the first 4 bytes for "daffd814"
encoded in little endian (0x14 first), and then the remaining values
encoded in big-endian for each number. Is this typical for UUID values?

Otherwise the patch looks okay.

g.

