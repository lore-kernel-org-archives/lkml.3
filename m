Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaJLTZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:25:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54772 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752505AbaJLTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:25:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] acpi: Use syscore instead of pm_power_off_prepare to prepare for poweroff
Date: Sun, 12 Oct 2014 21:45:31 +0200
Message-ID: <3090667.ydmQKSGePB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413062057-11657-2-git-send-email-linux@roeck-us.net>
References: <1413062057-11657-1-git-send-email-linux@roeck-us.net> <1413062057-11657-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 11, 2014 02:14:16 PM Guenter Roeck wrote:
> The syscore shutdown callback seems to be perfectly suited to prepare for system
> poweroff. Use it instead of pm_power_off_prepare.

How much testing did that receive?

> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/acpi/sleep.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 05a31b5..e03c74d 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -17,6 +17,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/suspend.h>
>  #include <linux/reboot.h>
> +#include <linux/syscore_ops.h>
>  #include <linux/acpi.h>
>  #include <linux/module.h>
>  #include <asm/io.h>
> @@ -820,13 +821,23 @@ int acpi_suspend(u32 acpi_state)
>  	return -EINVAL;
>  }
>  
> -static void acpi_power_off_prepare(void)
> +static void acpi_shutdown(void)
>  {
> -	/* Prepare to power off the system */
> -	acpi_sleep_prepare(ACPI_STATE_S5);
> -	acpi_disable_all_gpes();
> +	switch (system_state) {
> +	case SYSTEM_POWER_OFF:
> +		/* Prepare to power off the system */
> +		acpi_sleep_prepare(ACPI_STATE_S5);
> +		acpi_disable_all_gpes();
> +		break;
> +	default:
> +		break;
> +	}
>  }
>  
> +static struct syscore_ops acpi_syscore_ops = {
> +	.shutdown = acpi_shutdown,
> +};
> +
>  static void acpi_power_off(void)
>  {
>  	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
> @@ -850,7 +861,7 @@ int __init acpi_sleep_init(void)
>  
>  	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
>  		sleep_states[ACPI_STATE_S5] = 1;
> -		pm_power_off_prepare = acpi_power_off_prepare;
> +		register_syscore_ops(&acpi_syscore_ops);
>  		pm_power_off = acpi_power_off;
>  	}
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
