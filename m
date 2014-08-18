Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaHRI7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:59:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47295 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHRI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:59:08 -0400
Message-ID: <53F1C002.3050503@linaro.org>
Date: Mon, 18 Aug 2014 16:57:38 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/9] ACPI: Add support for device specific properties
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com> <1408255459-17625-2-git-send-email-mika.westerberg@linux.intel.com> <53F1B5A9.8060307@linaro.org> <20140818082656.GR2462@lahna.fi.intel.com>
In-Reply-To: <20140818082656.GR2462@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-18 16:27, Mika Westerberg wrote:
> On Mon, Aug 18, 2014 at 04:13:29PM +0800, Hanjun Guo wrote:
>> Hi,
>>
>> Some minor comments below.
>>
>> On 2014-8-17 14:04, Mika Westerberg wrote:
>>> Device Tree is used in many embedded systems to describe the system
>>> configuration to the OS. It supports attaching properties or name-value
>>> pairs to the devices it describe. With these properties one can pass
>>> additional information to the drivers that would not be available
>>> otherwise.
>>>
>>> ACPI is another configuration mechanism (among other things) typically
>>> seen, but not limited to, x86 machines. ACPI allows passing arbitrary
>>> data from methods but there has not been mechanism equivalent to Device
>>> Tree until the introduction of _DSD in the recent publication of the
>>> ACPI 5.1 specification.
>>>
>>> In order to facilitate ACPI usage in systems where Device Tree is
>>> typically used, it would be beneficial to standardize a way to retrieve
>>> Device Tree style properties from ACPI devices, which is what we do in
>>> this patch.
>>>
>>> If a given device described in ACPI namespace wants to export properties it
>>> must implement _DSD method (Device Specific Data, introduced with ACPI 5.1)
>>> that returns the properties in a package of packages. For example:
>>>
>>> 	Name (_DSD, Package () {
>>> 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>>> 		Package () {
>>> 			Package () {"name1", <VALUE1>},
>>> 			Package () {"name2", <VALUE2>},
>>> 			...
>>> 		}
>>> 	})
>>>
>>> The UUID reserved for properties is daffd814-6eba-4d8c-8a91-bc9bbf4aa301
>>> and is documented in the ACPI 5.1 companion document called "_DSD
>>> Implementation Guide" [1], [2].
>>>
>>> We add several helper functions that can be used to extract these
>>> properties and convert them to different Linux data types.
>>>
>>> The ultimate goal is that we only have one device property API that
>>> retrieves the requested properties from Device Tree or from ACPI
>>> transparent to the caller.
>>>
>>> [1] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
>>> [2] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
>>>
>>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>> ---
>>>  drivers/acpi/Makefile   |   1 +
>>>  drivers/acpi/internal.h |   6 +
>>>  drivers/acpi/property.c | 365 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  drivers/acpi/scan.c     |   2 +
>>>  include/acpi/acpi_bus.h |   7 +
>>>  include/linux/acpi.h    |  40 ++++++
>>>  6 files changed, 421 insertions(+)
>>>  create mode 100644 drivers/acpi/property.c
>>>
>>> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
>>> index ea55e0179f81..6e8269a111db 100644
>>> --- a/drivers/acpi/Makefile
>>> +++ b/drivers/acpi/Makefile
>>> @@ -45,6 +45,7 @@ acpi-y				+= acpi_pnp.o
>>>  acpi-y				+= power.o
>>>  acpi-y				+= event.o
>>>  acpi-y				+= sysfs.o
>>> +acpi-y				+= property.o
>>>  acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o
>>>  acpi-$(CONFIG_DEBUG_FS)		+= debugfs.o
>>>  acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
>>> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
>>> index 7de5b603f272..35001e2a8769 100644
>>> --- a/drivers/acpi/internal.h
>>> +++ b/drivers/acpi/internal.h
>>> @@ -178,4 +178,10 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev);
>>>  bool acpi_osi_is_win8(void);
>>>  #endif
>>>  
>>> +/*--------------------------------------------------------------------------
>>> +				Device properties
>>> +  -------------------------------------------------------------------------- */
>>> +void acpi_init_properties(struct acpi_device *adev);
>>> +void acpi_free_properties(struct acpi_device *adev);
>>> +
>>>  #endif /* _ACPI_INTERNAL_H_ */
>>> diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
>>> new file mode 100644
>>> index 000000000000..093e834c35db
>>> --- /dev/null
>>> +++ b/drivers/acpi/property.c
>>> @@ -0,0 +1,365 @@
>>> +/*
>>> + * ACPI device specific properties support.
>>> + *
>>> + * Copyright (C) 2014, Intel Corporation
>>> + * All rights reserved.
>>> + *
>>> + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
>>> + *          Darren Hart <dvhart@linux.intel.com>
>>> + *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#include <linux/acpi.h>
>>> +#include <linux/device.h>
>>> +#include <linux/export.h>
>>> +
>>> +#include "internal.h"
>>> +
>>> +/* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
>>> +static const u8 prp_uuid[16] = {
>>
>> s/prp_uuid/dsd_uuid ?
> 
> Well, it is actually the _DSD UUID that implements ACPI device
> properties (hence the prp_) but I have no problems in changing that to
> dsd_uuid instead.

Oh, I missed that part, since this UUID is only for ACPI device
properties, I agree with you that prp_ is better here.

Thanks
Hanjun

