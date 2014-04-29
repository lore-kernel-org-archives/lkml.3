Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbaD2QBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:01:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60920 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbaD2QBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:01:03 -0400
Date: Tue, 29 Apr 2014 17:00:57 +0100
From: Javi Merino <javi.merino@arm.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 4/4] acerhdf: Use bang-bang thermal governor
Message-ID: <20140429160057.GC31488@e102654-lin.cambridge.arm.com>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1398763077-5542-1-git-send-email-peter@piie.net>
 <1398763077-5542-5-git-send-email-peter@piie.net>
MIME-Version: 1.0
In-Reply-To: <1398763077-5542-5-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Apr 2014 16:01:12.0628 (UTC) FILETIME=[3E41E740:01CF63C4]
X-MC-Unique: 114042917010100901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:17:57AM +0100, Peter Feuerer wrote:
> acerhdf has been doing an on-off fan control using hysteresis by
> post-manipulating the outcome of thermal subsystem trip point handling.
> This patch enables acerhdf to use the bang-bang governor, which is
> intended for on-off controlled fans.
> 
> CC: Zhang Rui <rui.zhang@intel.com>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Peter Feuerer <peter@piie.net>
> ---
>  drivers/platform/x86/Kconfig   |  2 +-
>  drivers/platform/x86/acerhdf.c | 48 +++++++++++++++++++++++++++++++++++-------
>  2 files changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 27df2c5..0c15d89 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -38,7 +38,7 @@ config ACER_WMI
>  
>  config ACERHDF
>  	tristate "Acer Aspire One temperature and fan driver"
> -	depends on THERMAL && ACPI
> +	depends on ACPI && THERMAL_GOV_BANG_BANG
>  	---help---
>  	  This is a driver for Acer Aspire One netbooks. It allows to access
>  	  the temperature sensor and to control the fan.
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 176edbd..f3884f9 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -50,7 +50,7 @@
>   */
>  #undef START_IN_KERNEL_MODE
>  
> -#define DRV_VER "0.5.30"
> +#define DRV_VER "0.5.31"
>  
>  /*
>   * According to the Atom N270 datasheet,
> @@ -135,8 +135,8 @@ struct bios_settings_t {
>  	const char *vendor;
>  	const char *product;
>  	const char *version;
> -	unsigned char fanreg;
> -	unsigned char tempreg;
> +	u8 fanreg;
> +	u8 tempreg;
>  	struct fancmd cmd;
>  	int mcmd_enable;
>  };
> @@ -259,6 +259,17 @@ static const struct bios_settings_t bios_tbl[] = {
>  
>  static const struct bios_settings_t *bios_cfg __read_mostly;
>  
> +/*
> + * this struct is used to instruct thermal layer to use bang_bang instead of
> + * default governor for acerhdf
> + */
> +static struct thermal_zone_params acerhdf_zone_params = {
> +	.governor_name = "bang_bang",
> +	.no_hwmon = 0,
> +	.num_tbps = 0,
> +	.tbp = 0,
> +};

You don't need to initialize statics to 0.  checkpatch only considers
it an error if it finds it in a variable, but I think it also applies
to fields in struct.

> +
>  static int acerhdf_get_temp(int *temp)
>  {
>  	u8 read_temp;
> @@ -436,6 +447,17 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
>  {
>  	if (trip == 0)
>  		*type = THERMAL_TRIP_ACTIVE;
> +	if (trip == 1)
> +		*type = THERMAL_TRIP_CRITICAL;

This looks like an unrelated change that should be on a patch on its
own.

> +
> +	return 0;
> +}
> +
> +static int acerhdf_get_trip_hyst(struct thermal_zone_device *thermal, int trip,
> +				 unsigned long *temp)
> +{
> +	if (trip == 0)
> +		*temp = fanon - fanoff;
>  
>  	return 0;
>  }
> @@ -445,6 +467,8 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>  {
>  	if (trip == 0)
>  		*temp = fanon;
> +	else if (trip == 1)
> +		*temp = ACERHDF_TEMP_CRIT;
>  
>  	return 0;
>  }
> @@ -464,8 +488,10 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>  	.get_mode = acerhdf_get_mode,
>  	.set_mode = acerhdf_set_mode,
>  	.get_trip_type = acerhdf_get_trip_type,
> +	.get_trip_hyst = acerhdf_get_trip_hyst,
>  	.get_trip_temp = acerhdf_get_trip_temp,
>  	.get_crit_temp = acerhdf_get_crit_temp,
> +	.notify = NULL,

Same as before, no need to initialize static to NULL.

Cheers,
Javi

