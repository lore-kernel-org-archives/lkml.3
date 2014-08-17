Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaHQXNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 19:13:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:45906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaHQXNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 19:13:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="373527852"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Sun, 17 Aug 2014 12:31:27 -0500
Subject: Re: [RFC PATCH 3/9] Driver core: Unified device properties interface
 for platform firmware
From: Darren Hart <dvhart@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        <linux-acpi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <D016480B.A1AC8%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 3/9] Driver core: Unified device properties interface
 for platform firmware
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-4-git-send-email-mika.westerberg@linux.intel.com>
 <20140817124913.A597FC40F4B@trevor.secretlab.ca>
In-Reply-To: <20140817124913.A597FC40F4B@trevor.secretlab.ca>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/14, 5:49, "Grant Likely" <grant.likely@secretlab.ca> wrote:

>
>Hi Mika and Rafael,
>
>Comments below...
>
>On Sun, 17 Aug 2014 09:04:13 +0300, Mika Westerberg
><mika.westerberg@linux.intel.com> wrote:
>> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>> 
>> Add a uniform interface by which device drivers can request device
>> properties from the platform firmware by providing a property name
>> and the corresponding data type.
>> 
>> Three general helper functions, device_property_get(),
>> device_property_read() and device_property_read_array() are provided.
>> The first one allows the raw value of a given device property to be
>> accessed by the driver.  The remaining two allow the value of a numeric
>> or string property and multiple numeric or string values of one array
>> property to be acquired, respectively.
>> 
>> The interface is supposed to cover both ACPI and Device Trees,
>> although the ACPI part is only implemented at this time.
>
>Nit:
>s/at this time/in this change. The DT component is implemented in a
>subsequent patch./
>
>I almost complained that the DT portion must be implemented before this
>series can even be considered, but then I found it in patch 4/9.  :-)
>
>> 
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> ---
>>  drivers/acpi/glue.c      |   4 +-
>>  drivers/acpi/property.c  | 179
>>++++++++++++++++++++++++++++++++++++++++++++++-
>>  drivers/acpi/scan.c      |  12 +++-
>>  drivers/base/Makefile    |   2 +-
>>  drivers/base/property.c  |  48 +++++++++++++
>>  include/acpi/acpi_bus.h  |   1 +
>>  include/linux/device.h   |   3 +
>>  include/linux/property.h |  50 +++++++++++++
>>  8 files changed, 293 insertions(+), 6 deletions(-)
>>  create mode 100644 drivers/base/property.c
>>  create mode 100644 include/linux/property.h
>> 

...

>>
>>  static void acpi_device_del(struct acpi_device *device)
>>  {
>>  	mutex_lock(&acpi_device_lock);
>> -	if (device->parent)
>> +	if (device->parent) {
>>  		list_del(&device->node);
>> +		device->parent->child_count--;
>
>I worry about housekeeping like this. It is easy for bugs to slip in.
>Unless returning the child count is in a critical path (which it
>shouldn't be), I would drop the child_count member and simply count the
>number of items in the list when required.
>
>This of course is not my subsystem, so I won't ACK or NACK the patch over
>this.


This would be consistent with of_get_child_count() and is unlikely to be
called much more than once per device. The maintenance however is limited
to the add/del functions, so it doesn't seem difficult to maintain. I have
no objections to just walking the list though if that is preferable.

...

>> @@ -701,6 +702,7 @@ struct acpi_dev_node {
>>   * @archdata:	For arch-specific additions.
>>   * @of_node:	Associated device tree node.
>>   * @acpi_node:	Associated ACPI device node.
>> + * @property_ops: Firmware interface for device properties
>>   * @devt:	For creating the sysfs "dev".
>>   * @id:		device instance
>>   * @devres_lock: Spinlock to protect the resource of the device.
>> @@ -777,6 +779,7 @@ struct device {
>>  
>>  	struct device_node	*of_node; /* associated device tree node */
>>  	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
>> +	struct dev_prop_ops	*property_ops;
>
>There are only 2 users of this interface. I don't think adding an ops
>pointer to each and every struct device is warrented when the wrapper
>function can check if of_node or acpi_node is set and call the
>appropriate helper. It is unlikely anything else will use this hook. It
>will result in smaller memory footprint. Also smaller code when only one
>of
>CONFIG_OF and CONFIG_ACPI are selected, which is almost always. :-)
>
>It can be refactored later if that ever changes.


Our intent was to eliminate the #ifdefery in every one of the accessors.
It was my understanding the ops structures were preferable in such
situations. For a 64-bit machine with 1000 devices (all of which use
device properties) with one or the other of ACPI/OF enabled, the
additional memory requirement here is what... Something like (8*1000 + 4)
~= 8KB ? That seems worth the arguably more maintainable code to me. Is
there more to it than this, am I missing some more significant impact?

  
>>  	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
>>  	u32			id;	/* device instance */
>> diff --git a/include/linux/property.h b/include/linux/property.h
>> new file mode 100644
>> index 000000000000..52ea7fe7fe09
>> --- /dev/null
>> +++ b/include/linux/property.h
>> @@ -0,0 +1,50 @@
>> +/*
>> + * property.h - Unified device property interface.
>> + *
>> + * Copyright (C) 2014, Intel Corporation
>> + * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef _LINUX_PROPERTY_H_
>> +#define _LINUX_PROPERTY_H_
>> +
>> +#include <linux/device.h>
>> +#include <linux/acpi.h>
>> +#include <linux/of.h>
>> +
>> +enum dev_prop_type {
>> +	DEV_PROP_U8,
>> +	DEV_PROP_U16,
>> +	DEV_PROP_U32,
>> +	DEV_PROP_U64,
>> +	DEV_PROP_STRING,
>> +	DEV_PROP_MAX,
>> +};
>> +
>> +struct dev_prop_ops {
>> +	int (*get)(struct device *dev, const char *propname, void **valptr);
>> +	int (*read)(struct device *dev, const char *propname,
>> +		    enum dev_prop_type proptype, void *val);
>> +	int (*read_array)(struct device *dev, const char *propname,
>> +			  enum dev_prop_type proptype, void *val, size_t nval);
>
>The associated DT functions that implement property reads
>(of_property_read_*) were created in part to provide some type safety
>when reading properties. This proposed API throws that away by accepting
>a void* for the data field, which I don't want to do. This API either
>needs to have a separate accessor for each data type, or it needs some
>other mechanism (accessor macros?) to ensure the right type is passed
>in.


OK, this would increase the memory impact by 6-fold for 8,16,32,and 64
byte integers, strings, and device references if additional typed function
pointers were added to the dev_prop_ops. The macros could mitigate this I
suppose.

Type checking and validation was something we had discussed as being
important to this mechanism. I believe there was some interest in seeing
this done at the ASL/FDT + Schema level - but that's not justification for
maintaining it in the kernel interface as well.

Could this be addressed by adding an enum dev_prop_type to the get/read
calls similar to that of the read_array call? That would keep the call
count down, maintain the smaller memory footprint, and still allow for
type verification within the device properties API.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



