Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3LFI71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:59:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:18600 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3LFI7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:59:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="439618045"
Message-ID: <52A191D7.9010106@intel.com>
Date: Fri, 06 Dec 2013 16:59:03 +0800
From: Aaron Lu <aaron.lu@intel.com>
Organization: Intel, Shanghai, PRC
MIME-Version: 1.0
To: Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org, rjw@rjwysocki.net
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Update PATCH] ACPI/Button: Fix enable Button GPEs twice
References: <1386318760-5887-1-git-send-email-tianyu.lan@intel.com>
In-Reply-To: <1386318760-5887-1-git-send-email-tianyu.lan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 04:32 PM, Lan Tianyu wrote:
> Button GPEs have been enabled in the acpi_wake_device_init() during
> boot and Button driver enables these GPEs second time. This causes
> disabling these gpes via sysfs interface requires twice "echo disable
>> /sys/firmware/acpi/interrupts/gpeXXX". This patch is to remove
> related code in the Button driver.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
> Update:
> 	fix a typo, sorry for noise.
> 
>  drivers/acpi/button.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
> index 9e3a6cb..6643f2d 100644
> --- a/drivers/acpi/button.c
> +++ b/drivers/acpi/button.c
> @@ -406,15 +406,9 @@ static int acpi_button_add(struct acpi_device *device)
>  		lid_device = device;
>  	}
>  
> -	if (device->wakeup.flags.valid) {
> -		/* Button's GPE is run-wake GPE */
> -		acpi_enable_gpe(device->wakeup.gpe_device,
> -				device->wakeup.gpe_number);
> -		if (!device_may_wakeup(&device->dev)) {
> -			device_set_wakeup_enable(&device->dev, true);
> -			button->wakeup_enabled = true;
> -		}
> -	}
> +	/* Button GPEs have been enabled in the acpi_wakeup_device_list()*/
> +	if (device->wakeup.flags.valid)
> +		button->wakeup_enabled = true;

It doesn't seem we need this wakeup_enabled flag anymore, since we want
button/lid's GPE to be always enabled no matter if button driver is in
use or not and we have already taken care of this in
acpi_wakeup_device_init function, we can drop it from button driver.

Thanks,
Aaron

>  
>  	printk(KERN_INFO PREFIX "%s [%s]\n", name, acpi_device_bid(device));
>  	return 0;
> 

