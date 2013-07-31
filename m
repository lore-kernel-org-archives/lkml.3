Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3GaGs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:48:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:3324 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab3GaGs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,785,1367996400"; 
   d="scan'208";a="354712064"
Message-ID: <51F8B35A.6000804@intel.com>
Date: Wed, 31 Jul 2013 14:48:58 +0800
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
References: <10433383.dueoNg39qi@vostro.rjw.lan> <3386345.rYEkrXssx8@vostro.rjw.lan> <51F6FE34.2020703@intel.com> <1738639.5UcWLydKxR@vostro.rjw.lan>
In-Reply-To: <1738639.5UcWLydKxR@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 10:04 PM, Rafael J. Wysocki wrote:
> On Tuesday, July 30, 2013 07:43:48 AM Aaron Lu wrote:
>> On 07/30/2013 06:21 AM, Rafael J. Wysocki wrote:
>>> On Monday, July 29, 2013 10:09:53 PM Aaron Lu wrote:
>>>> On 07/27/2013 09:10 PM, Rafael J. Wysocki wrote:
>>>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>>
>>>>> Make acpi_device_set_power() check if the given device is power
>>>>> manageable before checking if the given power state is valid for that
>>>>> device.  Otherwise it will print that "Device does not support" that
>>>>> power state into the kernel log, which may not make sense for some
>>>>> power states (D0 and D3cold are supported by all devices by
>>>>> definition).
>>>>
>>>> It will not print "Device does not support" that power state if that
>>>> power state is D0 or D3cold since we have unconditionally set those two
>>>> power state's valid flag.
>>>
>>> So you didn't actually looked at acpi_bus_get_power_flags() that set the
>>> power.states[].flags.valid flag, because If you had looked at it, you would
>>> have seen that that's not the case.
>>>
>>> No, we don't set the valid flag for devices that aren't power manageable
>>> (i.e. have flags.power_manageable unset), which is the *whole* *point* of
>>> this change.
>>
>> Right, I missed this. Sorry for the noise.
>>
>>>
>>>> OTOH, what value should we return for a device node that is not power
>>>> manageable in acpi_device_set_power when the target state is D0 or D3
>>>> cold? The old behavior is to return 0, meanning success without taking
>>>> any actual action.
>>>>
>>>> In acpi_bus_set_power, if the device is not power manageable, we will
>>>> return -ENODEV; in acpi_dev_pm_full/low_power, we will return 0 as in
>>>> the original acpi_device_set_power. So return -EINVAL here is correct?
>>>
>>> No, the original acpi_device_set_power() will return -ENODEV then, but
>>> in my opinion returning -EINVAL is more accurate, because "power
>>> manageable" means "you can change power state of it".
>>
>> Shall I prepare a patch to update the errno in acpi_bus_set_power?
> 
> In fact, it doesn't need to check flags.power_manageable after this patch
> and the debug message won't be missed I think, so please just remove
> the whole if () from there, if that's not a problem.

Patch to remove the redundant check, apply on top of this one.

From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/3] ACPI / PM: Remove redundant check for power manageable in
 acpi_bus_set_power

Now that we will check if a device is power manageable in
acpi_device_set_power, it is no longer necessary to do this check in
acpi_bus_set_power, so remove it.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/device_pm.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 63324b8..8270711 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -245,13 +245,6 @@ int acpi_bus_set_power(acpi_handle handle, int state)
 	if (result)
 		return result;
 
-	if (!device->flags.power_manageable) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				"Device [%s] is not power manageable\n",
-				dev_name(&device->dev)));
-		return -ENODEV;
-	}
-
 	return acpi_device_set_power(device, state);
 }
 EXPORT_SYMBOL(acpi_bus_set_power);
-- 
1.8.3.2.10.g43d11f4

