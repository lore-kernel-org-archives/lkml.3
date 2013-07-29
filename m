Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3G2C3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:29:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:51801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3G2C3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:29:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,766,1367996400"; 
   d="scan'208";a="353323191"
Message-ID: <51F5D390.5040506@intel.com>
Date: Mon, 29 Jul 2013 10:29:36 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/3] ACPI / PM: Make messages in acpi_device_set_power()
 print device names
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1895563.95T8SxMegu@vostro.rjw.lan>
In-Reply-To: <1895563.95T8SxMegu@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 09:11 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify acpi_device_set_power() so that diagnostic messages printed by
> it to the kernel log always contain the name of the device concerned
> to make it possible to identify the device that triggered the message
> if need be.
> 
> Also replace printk(KERN_WARNING ) with dev_warn() everywhere in that
> function.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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
> +		dev_warn(&device->dev, "Cannot transition to a higher-powered "
> +			 "state than parent\n");

I think the state information would also be useful here:

		dev_warn(&device->dev, "Cannot transition to a higher-powereed "
		         "state %d than paeren's state %d\n", state,
			 device->parent->power.state);

Thanks,
Aaron

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

