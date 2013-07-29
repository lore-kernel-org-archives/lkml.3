Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3G2XnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:43:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:43838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3G2XnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,773,1367996400"; 
   d="scan'208";a="353912069"
Message-ID: <51F6FE34.2020703@intel.com>
Date: Tue, 30 Jul 2013 07:43:48 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/3] ACPI / PM: Only set power states of devices that
 are power manageable
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1657971.1utElu0Hzo@vostro.rjw.lan> <51F677B1.9090502@intel.com> <3386345.rYEkrXssx8@vostro.rjw.lan>
In-Reply-To: <3386345.rYEkrXssx8@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 06:21 AM, Rafael J. Wysocki wrote:
> On Monday, July 29, 2013 10:09:53 PM Aaron Lu wrote:
>> On 07/27/2013 09:10 PM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> Make acpi_device_set_power() check if the given device is power
>>> manageable before checking if the given power state is valid for that
>>> device.  Otherwise it will print that "Device does not support" that
>>> power state into the kernel log, which may not make sense for some
>>> power states (D0 and D3cold are supported by all devices by
>>> definition).
>>
>> It will not print "Device does not support" that power state if that
>> power state is D0 or D3cold since we have unconditionally set those two
>> power state's valid flag.
> 
> So you didn't actually looked at acpi_bus_get_power_flags() that set the
> power.states[].flags.valid flag, because If you had looked at it, you would
> have seen that that's not the case.
> 
> No, we don't set the valid flag for devices that aren't power manageable
> (i.e. have flags.power_manageable unset), which is the *whole* *point* of
> this change.

Right, I missed this. Sorry for the noise.

> 
>> OTOH, what value should we return for a device node that is not power
>> manageable in acpi_device_set_power when the target state is D0 or D3
>> cold? The old behavior is to return 0, meanning success without taking
>> any actual action.
>>
>> In acpi_bus_set_power, if the device is not power manageable, we will
>> return -ENODEV; in acpi_dev_pm_full/low_power, we will return 0 as in
>> the original acpi_device_set_power. So return -EINVAL here is correct?
> 
> No, the original acpi_device_set_power() will return -ENODEV then, but
> in my opinion returning -EINVAL is more accurate, because "power
> manageable" means "you can change power state of it".

Shall I prepare a patch to update the errno in acpi_bus_set_power?

Thanks,
Aaron

> 
> Thanks,
> Rafael
> 
> 
>>> Tested-by: Yinghai Lu <yinghai@kernel.org>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>  drivers/acpi/device_pm.c |    3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> Index: linux-pm/drivers/acpi/device_pm.c
>>> ===================================================================
>>> --- linux-pm.orig/drivers/acpi/device_pm.c
>>> +++ linux-pm/drivers/acpi/device_pm.c
>>> @@ -159,7 +159,8 @@ int acpi_device_set_power(struct acpi_de
>>>  	int result = 0;
>>>  	bool cut_power = false;
>>>  
>>> -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
>>> +	if (!device || !device->flags.power_manageable
>>> +	    || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
>>>  		return -EINVAL;
>>>  
>>>  	/* Make sure this is a valid target state */
>>>
>>

