Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaAGOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:34:21 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53300 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaAGOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:33:51 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52CC104A.6010805@roeck-us.net>
Date: Tue, 07 Jan 2014 06:33:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>, rui.zhang@intel.com
CC: rdunlap@infradead.org, Jean Delvare <khali@linux-fr.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] thermal: fix compilation issue on CONFIG_THERMAL_OF
 dependencies
References: <52CBF1CF.2000603@ti.com> <1389098667-9826-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1389098667-9826-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 04:44 AM, Eduardo Valentin wrote:
> Users of API provided by THERMAL_OF config may suffer when
> CONFIG_THERMAL=y, causing linking issues, such as:
>
> drivers/built-in.o: In function `lm75_remove':
> lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sensor_unregister'
> drivers/built-in.o: In function `lm75_probe':
> lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sensor_register'
>
> Therefore, this patch limits the compilation build to always
> have THERMAL=y, whenever THERMAL_OF=y. In this way, whenever
> the API user is built, if THERMAL_OF=y, the build shall have
> the full thermal support, otherwise, the thermal API will provide
> stubs.
>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>   drivers/thermal/Kconfig | 29 ++++++++++++++++-------------
>   1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 58f98bd..dc315e9 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -29,19 +29,6 @@ config THERMAL_HWMON
>   	  Say 'Y' here if you want all thermal sensors to
>   	  have hwmon sysfs interface too.
>
> -config THERMAL_OF
> -	bool
> -	prompt "APIs to parse thermal data out of device tree"
> -	depends on OF
> -	default y
> -	help
> -	  This options provides helpers to add the support to
> -	  read and parse thermal data definitions out of the
> -	  device tree blob.
> -
> -	  Say 'Y' here if you need to build thermal infrastructure
> -	  based on device tree.
> -
>   choice
>   	prompt "Default Thermal governor"
>   	default THERMAL_DEFAULT_GOV_STEP_WISE
> @@ -235,3 +222,19 @@ source "drivers/thermal/samsung/Kconfig"
>   endmenu
>
>   endif
> +
> +menuconfig THERMAL_OF
> +	bool
> +	prompt "APIs to parse thermal data out of device tree"
> +	depends on OF
> +	select THERMAL
> +	default y
> +	help
> +	  This options enables DT thermal API which adds support to
> +	  read and parse thermal data definitions out of the
> +	  device tree blob. This option is mostly used by embedded
> +	  thermal drivers.
> +
> +	  Say 'Y' here if you need to build thermal infrastructure
> +	  based on device tree.
> +
>

Alternative would be something like

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7..156bb4d 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -244,7 +244,7 @@ struct thermal_genl_event {
  };

  /* Function declarations */
-#ifdef CONFIG_THERMAL_OF
+#if defined(CONFIG_THERMAL_OF) && (defined(CONFIG_THERMAL) || (defined(MODULE) && defined(CONFIG_THERMAL_MODULE)))
  struct thermal_zone_device *
  thermal_zone_of_sensor_register(struct device *dev, int id,
                                 void *data, int (*get_temp)(void *, long *),

but your patch should work as well (or even better as it won't cause confusion).

Guenter

