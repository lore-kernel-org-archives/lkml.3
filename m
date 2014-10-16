Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaJPO7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:59:32 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64879 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaJPO7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:59:30 -0400
Date: Thu, 16 Oct 2014 15:59:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 42/44] efi: Register poweroff handler with kernel
 poweroff handler
Message-ID: <20141016145927.GI14343@console-pimps.org>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-43-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412659726-29957-43-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct, at 10:28:44PM, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with low priority value of 64 since the efi code
> states that this is a poweroff handler of last resort.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/firmware/efi/reboot.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
 
Looks OK to me. Mark?

> diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
> index 9c59d1c..c082439 100644
> --- a/drivers/firmware/efi/reboot.c
> +++ b/drivers/firmware/efi/reboot.c
> @@ -3,6 +3,8 @@
>   * Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter@redhat.com>
>   */
>  #include <linux/efi.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/reboot.h>
>  
>  int efi_reboot_quirk_mode = -1;
> @@ -38,19 +40,32 @@ bool __weak efi_poweroff_required(void)
>  	return false;
>  }
>  
> -static void efi_power_off(void)
> +static int efi_power_off(struct notifier_block *this,
> +			 unsigned long unused1, void *unused2)
>  {
>  	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
> +
> +	return NOTIFY_DONE;
>  }
>  
> +static struct notifier_block efi_poweroff_nb = {
> +	.notifier_call = efi_power_off,
> +	.priority = 64,
> +};
> +
>  static int __init efi_shutdown_init(void)
>  {
> +	int ret = 0;
> +
>  	if (!efi_enabled(EFI_RUNTIME_SERVICES))
>  		return -ENODEV;
>  
> -	if (efi_poweroff_required())
> -		pm_power_off = efi_power_off;
> +	if (efi_poweroff_required()) {
> +		ret = register_poweroff_handler(&efi_poweroff_nb);
> +		if (ret)
> +			pr_err("efi: Failed to register poweroff handler\n");
> +	}
>  
> -	return 0;
> +	return ret;
>  }
>  late_initcall(efi_shutdown_init);
> -- 
> 1.9.1


-- 
Matt Fleming, Intel Open Source Technology Center
