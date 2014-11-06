Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaKFWLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:11:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60199 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750970AbaKFWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:11:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 34/48] acpi: Register power-off handler with kernel power-off handler
Date: Thu, 06 Nov 2014 23:32:26 +0100
Message-ID: <2274417.WekTW87bGm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415292213-28652-35-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-35-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 06, 2014 08:43:18 AM Guenter Roeck wrote:
> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with high priority to reflect that the driver explicitly
> overrides existing power-off handlers.
> 
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

That's fine by me.

Rafael


> ---
> v5:
> - Rebase to v3.18-rc3
> v4:
> - Do not use notifiers but internal functions and data structures to manage
>   the list of power-off handlers. Drop unused parameters from callbacks, and
>   make the power-off function type void
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> - Replace acpi: with ACPI: in log message
> v2:
> - Use define to specify poweroff handler priority
> - Use pr_warn instead of pr_err
> 
>  drivers/acpi/sleep.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 05a31b5..a73cfad 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -16,6 +16,7 @@
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
>  #include <linux/suspend.h>
> +#include <linux/pm.h>
>  #include <linux/reboot.h>
>  #include <linux/acpi.h>
>  #include <linux/module.h>
> @@ -827,7 +828,7 @@ static void acpi_power_off_prepare(void)
>  	acpi_disable_all_gpes();
>  }
>  
> -static void acpi_power_off(void)
> +static void acpi_power_off(struct power_off_handler_block *this)
>  {
>  	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
>  	printk(KERN_DEBUG "%s called\n", __func__);
> @@ -835,6 +836,11 @@ static void acpi_power_off(void)
>  	acpi_enter_sleep_state(ACPI_STATE_S5);
>  }
>  
> +static struct power_off_handler_block acpi_power_off_hb = {
> +	.handler = acpi_power_off,
> +	.priority = POWER_OFF_PRIORITY_HIGH,
> +};
> +
>  int __init acpi_sleep_init(void)
>  {
>  	char supported[ACPI_S_STATE_COUNT * 3 + 1];
> @@ -851,7 +857,8 @@ int __init acpi_sleep_init(void)
>  	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
>  		sleep_states[ACPI_STATE_S5] = 1;
>  		pm_power_off_prepare = acpi_power_off_prepare;
> -		pm_power_off = acpi_power_off;
> +		if (register_power_off_handler(&acpi_power_off_hb))
> +			pr_warn("ACPI: Failed to register power-off handler\n");
>  	}
>  
>  	supported[0] = 0;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
