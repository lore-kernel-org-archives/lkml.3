Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3G2OOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:14:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:19510 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3G2OOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,769,1367996400"; 
   d="scan'208";a="338473761"
Message-ID: <51F67901.9050409@intel.com>
Date: Mon, 29 Jul 2013 22:15:29 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Joe Perches <joe@perches.com>, Lan Tianyu <lantianyu1986@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPI / PM: Make messages in acpi_device_set_power()
 print device names
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1782275.A7JEhQIj8Q@vostro.rjw.lan> <51F65D1F.9050402@cogentembedded.com> <8023117.JJXk2RBLtn@vostro.rjw.lan>
In-Reply-To: <8023117.JJXk2RBLtn@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 09:36 PM, Rafael J. Wysocki wrote:
> On Monday, July 29, 2013 04:16:31 PM Sergei Shtylyov wrote:
>> Hello.
>>
>> On 29-07-2013 16:17, Rafael J. Wysocki wrote:
>>
>> [...]
>>
>>>>>> @@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
>>>> []
>>>>>>          if (device->parent && (state < device->parent->power.state)) {
>>>>>> -               printk(KERN_WARNING PREFIX
>>>>>> -                             "Cannot set device to a higher-powered"
>>>>>> -                             " state than parent\n");
>>>>>> +               dev_warn(&device->dev, "Cannot transition to a higher-powered "
>>>>>> +                        "state than parent\n");
>>
>>>> coalesce format please.
>>
>>> I can, but then it'll cross the 80 columns boundary.
>>
>>    It's not a problem with checkpatch.pl anymore. Contrariwise, it whines 
>> about the broken up string literals, AFAIR.
> 
> Oh, at last.
> 
> Updated patch follows.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / PM: Make messages in acpi_device_set_power() print device names
> 
> Modify acpi_device_set_power() so that diagnostic messages printed by
> it to the kernel log always contain the name of the device concerned
> to make it possible to identify the device that triggered the message
> if need be.
> 
> Also replace printk(KERN_WARNING ) with dev_warn() everywhere in that
> function.

This makes the log much more informative, thanks!

> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Aaron Lu <aaron.lu@intel.com>

And I'll add the state information in another patch on top of this one
later.

-Aaron

> ---
>  drivers/acpi/device_pm.c |   22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> Index: linux-pm/drivers/acpi/device_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/device_pm.c
> +++ linux-pm/drivers/acpi/device_pm.c
> @@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
>  	/* Make sure this is a valid target state */
>  
>  	if (state == device->power.state) {
> -		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] already in %s\n",
> +				  device->pnp.bus_id,
>  				  acpi_power_state_string(state)));
>  		return 0;
>  	}
>  
>  	if (!device->power.states[state].flags.valid) {
> -		printk(KERN_WARNING PREFIX "Device does not support %s\n",
> -		       acpi_power_state_string(state));
> +		dev_warn(&device->dev, "Power state %s not supported\n",
> +			 acpi_power_state_string(state));
>  		return -ENODEV;
>  	}
>  	if (device->parent && (state < device->parent->power.state)) {
> -		printk(KERN_WARNING PREFIX
> -			      "Cannot set device to a higher-powered"
> -			      " state than parent\n");
> +		dev_warn(&device->dev,
> +			 "Cannot transition to a higher-powered state than parent\n");
>  		return -ENODEV;
>  	}
>  
> @@ -192,8 +192,8 @@ int acpi_device_set_power(struct acpi_de
>  
>  	if (state < device->power.state && state != ACPI_STATE_D0
>  	    && device->power.state >= ACPI_STATE_D3_HOT) {
> -		printk(KERN_WARNING PREFIX
> -			"Cannot transition to non-D0 state from D3\n");
> +		dev_warn(&device->dev,
> +			 "Cannot transition to non-D0 state from D3\n");
>  		return -ENODEV;
>  	}
>  
> @@ -220,10 +220,8 @@ int acpi_device_set_power(struct acpi_de
>  
>   end:
>  	if (result) {
> -		printk(KERN_WARNING PREFIX
> -			      "Device [%s] failed to transition to %s\n",
> -			      device->pnp.bus_id,
> -			      acpi_power_state_string(state));
> +		dev_warn(&device->dev, "Failed to change power state to %s\n",
> +			 acpi_power_state_string(state));
>  	} else {
>  		device->power.state = state;
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> 

