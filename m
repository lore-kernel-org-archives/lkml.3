Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3G2OJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:09:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:59106 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab3G2OJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:09:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,769,1367996400"; 
   d="scan'208";a="338470048"
Message-ID: <51F677B1.9090502@intel.com>
Date: Mon, 29 Jul 2013 22:09:53 +0800
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
References: <10433383.dueoNg39qi@vostro.rjw.lan> <1657971.1utElu0Hzo@vostro.rjw.lan>
In-Reply-To: <1657971.1utElu0Hzo@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 09:10 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Make acpi_device_set_power() check if the given device is power
> manageable before checking if the given power state is valid for that
> device.  Otherwise it will print that "Device does not support" that
> power state into the kernel log, which may not make sense for some
> power states (D0 and D3cold are supported by all devices by
> definition).

It will not print "Device does not support" that power state if that
power state is D0 or D3cold since we have unconditionally set those two
power state's valid flag.

OTOH, what value should we return for a device node that is not power
manageable in acpi_device_set_power when the target state is D0 or D3
cold? The old behavior is to return 0, meanning success without taking
any actual action.

In acpi_bus_set_power, if the device is not power manageable, we will
return -ENODEV; in acpi_dev_pm_full/low_power, we will return 0 as in
the original acpi_device_set_power. So return -EINVAL here is correct?

-Aaron

> 
> Tested-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/device_pm.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/acpi/device_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/device_pm.c
> +++ linux-pm/drivers/acpi/device_pm.c
> @@ -159,7 +159,8 @@ int acpi_device_set_power(struct acpi_de
>  	int result = 0;
>  	bool cut_power = false;
>  
> -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> +	if (!device || !device->flags.power_manageable
> +	    || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
>  		return -EINVAL;
>  
>  	/* Make sure this is a valid target state */
> 

