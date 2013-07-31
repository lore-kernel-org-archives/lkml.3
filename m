Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab3GaGwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:52:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:22237 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab3GaGwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:52:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,785,1367996400"; 
   d="scan'208";a="373851360"
Message-ID: <51F8B445.1070000@intel.com>
Date: Wed, 31 Jul 2013 14:52:53 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPI / PM: Make messages in acpi_device_set_power()
 print device names
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1895563.95T8SxMegu@vostro.rjw.lan> <51F5D390.5040506@intel.com> <4285597.UpTJrMA8Fu@vostro.rjw.lan>
In-Reply-To: <4285597.UpTJrMA8Fu@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:20 PM, Rafael J. Wysocki wrote:
> On Monday, July 29, 2013 10:29:36 AM Aaron Lu wrote:
>> On 07/27/2013 09:11 PM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> Modify acpi_device_set_power() so that diagnostic messages printed by
>>> it to the kernel log always contain the name of the device concerned
>>> to make it possible to identify the device that triggered the message
>>> if need be.
>>>
>>> Also replace printk(KERN_WARNING ) with dev_warn() everywhere in that
>>> function.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>  drivers/acpi/device_pm.c |   22 ++++++++++------------
>>>  1 file changed, 10 insertions(+), 12 deletions(-)
>>>
>>> Index: linux-pm/drivers/acpi/device_pm.c
>>> ===================================================================
>>> --- linux-pm.orig/drivers/acpi/device_pm.c
>>> +++ linux-pm/drivers/acpi/device_pm.c
>>> @@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
>>>  	/* Make sure this is a valid target state */
>>>  
>>>  	if (state == device->power.state) {
>>> -		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
>>> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] already in %s\n",
>>> +				  device->pnp.bus_id,
>>>  				  acpi_power_state_string(state)));
>>>  		return 0;
>>>  	}
>>>  
>>>  	if (!device->power.states[state].flags.valid) {
>>> -		printk(KERN_WARNING PREFIX "Device does not support %s\n",
>>> -		       acpi_power_state_string(state));
>>> +		dev_warn(&device->dev, "Power state %s not supported\n",
>>> +			 acpi_power_state_string(state));
>>>  		return -ENODEV;
>>>  	}
>>>  	if (device->parent && (state < device->parent->power.state)) {
>>> -		printk(KERN_WARNING PREFIX
>>> -			      "Cannot set device to a higher-powered"
>>> -			      " state than parent\n");
>>> +		dev_warn(&device->dev, "Cannot transition to a higher-powered "
>>> +			 "state than parent\n");
>>
>> I think the state information would also be useful here:
>>
>> 		dev_warn(&device->dev, "Cannot transition to a higher-powereed "
>> 		         "state %d than paeren's state %d\n", state,
>> 			 device->parent->power.state);
> 
> This is not the scope of this patch, please send another one on top of it.
> 

Patch to add state information in error message, apply on top of this
one.

From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] ACPI / PM: Add state information in error message for
 acpi_device_set_power

The state information can be useful to know what the problem is when it
appeared in an error message about a device can not being set to a higher
power state than its parent, so this patch adds such state information
for both the target state of the device failed to be set and the current
parent's state.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/device_pm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index beb9625..707258b 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -179,7 +179,8 @@ int acpi_device_set_power(struct acpi_device *device, int state)
 	}
 	if (device->parent && (state < device->parent->power.state)) {
 		dev_warn(&device->dev,
-			 "Cannot transition to a higher-powered state than parent\n");
+			 "Cannot transition to a higher-powered state %d than parent's state %d\n",
+			 state, device->parent->power.state);
 		return -ENODEV;
 	}
 
-- 
1.8.3.2.10.g43d11f4

