Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3CYOPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:15:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:24471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3CYOPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,905,1355126400"; 
   d="scan'208";a="311572539"
Message-ID: <51505C4A.3080102@intel.com>
Date: Mon, 25 Mar 2013 22:16:42 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI / PM: Fix potential problem in acpi_device_get_power()
References: <6380949.vJPdL9PvJh@vostro.rjw.lan> <5150045F.2000105@intel.com> <2098772.7Ti64jKWB7@vostro.rjw.lan>
In-Reply-To: <2098772.7Ti64jKWB7@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 09:03 PM, Rafael J. Wysocki wrote:
> On Monday, March 25, 2013 04:01:35 PM Aaron Lu wrote:
>> On 03/24/2013 07:57 AM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> Theoretically, in some situations acpi_device_get_power() may return
>>> an incorrect result, because the settings of the power resources
>>> depended on by the device may indicate a power state shallower than
>>> the actual power state of the device.
>>>
>>> Say that two devices, A and B, depend on two power resources, X and
>>> Y, in such a way that _PR0 for both A and B list both X and Y and
>>> _PR3 for both A and B list power resource Y alone.  Also suppose
>>> that _PS0 and _PS3 are present for both A and B.  Then, if devices
>>> A and B are initially in D0, power resources X and Y are initially
>>> "on" and their reference counters are equal to 2.  To put device A
>>> into power state D3hot the kernel will decrement the reference
>>> counter of power resource X, but that power resource won't be turned
>>> off, because it is still in use by device B (its reference counter is
>>> equal to 1).  Next, _PS3 will be executed for device A.  Afterward
>>> the configuration of the power resources will indicate that device
>>> A is in power state D0 (both X and Y are "on"), but in fact it is
>>> in D3hot (because _PS3 has been executed for it).
>>
>> I'm not sure if D3hot is correct here, since the power resource X is
>> still on?
> 
> I believe so.  We have followed the procedure to put the device into D3hot.
> If _PS3 were not executed, that would be moot, but then arguably _PSC should
> not return 3.

OK, please feel free to add my Reviewed-by tag then.

Thanks,
Aaron

> 
>> I agree that, at least from OSPM's perspective, D3hot is better than D0
>> here.
> 
> Yes, it is.
> 
> Thanks,
> Rafael
> 
> 
>>> In that situation, if acpi_device_get_power() is called to get the
>>> power state of device A, it will first execute _PSC for it which
>>> should return 3.  That will cause acpi_device_get_power() to run
>>> acpi_power_get_inferred_state() for device A and the resultant power
>>> state will be D0, which is incorrect.
>>>
>>> To fix that change acpi_device_get_power() to first execute
>>> acpi_power_get_inferred_state() for the given device (if it
>>> depends on power resources) and to evaluate _PSC for it subsequently,
>>> so that the result inferred from the power resources configuration
>>> can be amended by the _PSC return value.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>  drivers/acpi/device_pm.c |   39 ++++++++++++++++++++++++---------------
>>>  1 file changed, 24 insertions(+), 15 deletions(-)
>>>
>>> Index: linux-pm/drivers/acpi/device_pm.c
>>> ===================================================================
>>> --- linux-pm.orig/drivers/acpi/device_pm.c
>>> +++ linux-pm/drivers/acpi/device_pm.c
>>> @@ -145,27 +145,36 @@ int acpi_device_get_power(struct acpi_de
>>>  	}
>>>  
>>>  	/*
>>> -	 * Get the device's power state either directly (via _PSC) or
>>> -	 * indirectly (via power resources).
>>> +	 * Get the device's power state from power resources settings and _PSC,
>>> +	 * if available.
>>>  	 */
>>> +	if (device->power.flags.power_resources) {
>>> +		int error = acpi_power_get_inferred_state(device, &result);
>>> +		if (error)
>>> +			return error;
>>> +	}
>>>  	if (device->power.flags.explicit_get) {
>>> +		acpi_handle handle = device->handle;
>>>  		unsigned long long psc;
>>> -		acpi_status status = acpi_evaluate_integer(device->handle,
>>> -							   "_PSC", NULL, &psc);
>>> +		acpi_status status;
>>> +
>>> +		status = acpi_evaluate_integer(handle, "_PSC", NULL, &psc);
>>>  		if (ACPI_FAILURE(status))
>>>  			return -ENODEV;
>>>  
>>> -		result = psc;
>>> -	}
>>> -	/* The test below covers ACPI_STATE_UNKNOWN too. */
>>> -	if (result <= ACPI_STATE_D2) {
>>> -	  ; /* Do nothing. */
>>> -	} else if (device->power.flags.power_resources) {
>>> -		int error = acpi_power_get_inferred_state(device, &result);
>>> -		if (error)
>>> -			return error;
>>> -	} else if (result == ACPI_STATE_D3_HOT) {
>>> -		result = ACPI_STATE_D3;
>>> +		/*
>>> +		 * The power resources settings may indicate a power state
>>> +		 * shallower than the actual power state of the device.
>>> +		 *
>>> +		 * Moreover, on systems predating ACPI 4.0, if the device
>>> +		 * doesn't depend on any power resources and _PSC returns 3,
>>> +		 * that means "power off".  We need to maintain compatibility
>>> +		 * with those systems.
>>> +		 */
>>> +		if (psc > result && psc < ACPI_STATE_D3_COLD)
>>> +			result = psc;
>>> +		else if (result == ACPI_STATE_UNKNOWN)
>>> +			result = psc > ACPI_STATE_D2 ? ACPI_STATE_D3_COLD : psc;
>>>  	}
>>>  
>>>  	/*
>>>
>>

