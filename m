Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbaH1BSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:18:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:42218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaH1BSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:18:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="564484600"
Message-ID: <1409188672.8085.26.camel@rzhang1-toshiba>
Subject: Re: [PATCH v5 4/6] acerhdf: Use bang-bang thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Javi Merino <javi.merino@arm.com>
Date: Thu, 28 Aug 2014 09:17:52 +0800
In-Reply-To: <cone.1409126464.428976.2744.1000@mups>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
	 <1406043436-17068-1-git-send-email-peter@piie.net>
	 <1406043436-17068-5-git-send-email-peter@piie.net>
	 <1409125727.8085.23.camel@rzhang1-toshiba>
	 <cone.1409126464.428976.2744.1000@mups>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-27 at 10:01 +0200, Peter Feuerer wrote:
> Zhang Rui writes:
> 
> > On Tue, 2014-07-22 at 17:37 +0200, Peter Feuerer wrote:
> >> acerhdf has been doing an on-off fan control using hysteresis by
> >> post-manipulating the outcome of thermal subsystem trip point handling.
> >> This patch enables acerhdf to use the bang-bang governor, which is
> >> intended for on-off controlled fans.
> >> 
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> CC: Zhang Rui <rui.zhang@intel.com>
> >> Cc: Andreas Mohr <andi@lisas.de>
> >> Cc: Javi Merino <javi.merino@arm.com>
> >> Acked-and-tested-by: Borislav Petkov <bp@suse.de>
> >> Signed-off-by: Peter Feuerer <peter@piie.net>
> > 
> > Peter,
> > 
> > will you take this patch, or do you want me to take this patch along
> > with Patch 3/6?
> 
> Hi Rui,
> 
> please apply the whole series.  I don't have a git repository where Linus 
> pulls from.
> 
No, I can not apply the whole series.
I should take patch 3/6, and the others should goto Matthew Garrett'
tree. Or I can take them with Matthew' Acked-by.

thanks,
rui

> thanks and kind regards,
> --peter;
> 
> 
> > 
> > thanks,
> > rui
> >> ---
> >>  drivers/platform/x86/Kconfig   |  3 ++-
> >>  drivers/platform/x86/acerhdf.c | 36 +++++++++++++++++++++++++++++++-----
> >>  2 files changed, 33 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> >> index 172f26c..b5e80dc 100644
> >> --- a/drivers/platform/x86/Kconfig
> >> +++ b/drivers/platform/x86/Kconfig
> >> @@ -38,7 +38,8 @@ config ACER_WMI
> >>  
> >>  config ACERHDF
> >>  	tristate "Acer Aspire One temperature and fan driver"
> >> -	depends on THERMAL && ACPI
> >> +	select THERMAL_GOV_BANG_BANG
> >> +	depends on ACPI
> >>  	---help---
> >>  	  This is a driver for Acer Aspire One netbooks. It allows to access
> >>  	  the temperature sensor and to control the fan.
> >> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> >> index f30767f..7fe7dbf 100644
> >> --- a/drivers/platform/x86/acerhdf.c
> >> +++ b/drivers/platform/x86/acerhdf.c
> >> @@ -50,7 +50,7 @@
> >>   */
> >>  #undef START_IN_KERNEL_MODE
> >>  
> >> -#define DRV_VER "0.5.30"
> >> +#define DRV_VER "0.7.0"
> >>  
> >>  /*
> >>   * According to the Atom N270 datasheet,
> >> @@ -258,6 +258,14 @@ static const struct bios_settings_t bios_tbl[] = {
> >>  
> >>  static const struct bios_settings_t *bios_cfg __read_mostly;
> >>  
> >> +/*
> >> + * this struct is used to instruct thermal layer to use bang_bang instead of
> >> + * default governor for acerhdf
> >> + */
> >> +static struct thermal_zone_params acerhdf_zone_params = {
> >> +	.governor_name = "bang_bang",
> >> +};
> >> +
> >>  static int acerhdf_get_temp(int *temp)
> >>  {
> >>  	u8 read_temp;
> >> @@ -439,6 +447,17 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
> >>  	return 0;
> >>  }
> >>  
> >> +static int acerhdf_get_trip_hyst(struct thermal_zone_device *thermal, int trip,
> >> +				 unsigned long *temp)
> >> +{
> >> +	if (trip != 0)
> >> +		return -EINVAL;
> >> +
> >> +	*temp = fanon - fanoff;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
> >>  				 unsigned long *temp)
> >>  {
> >> @@ -463,6 +482,7 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
> >>  	.get_mode = acerhdf_get_mode,
> >>  	.set_mode = acerhdf_set_mode,
> >>  	.get_trip_type = acerhdf_get_trip_type,
> >> +	.get_trip_hyst = acerhdf_get_trip_hyst,
> >>  	.get_trip_temp = acerhdf_get_trip_temp,
> >>  	.get_crit_temp = acerhdf_get_crit_temp,
> >>  };
> >> @@ -515,9 +535,7 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
> >>  	}
> >>  
> >>  	if (state == 0) {
> >> -		/* turn fan off only if below fanoff temperature */
> >> -		if ((cur_state == ACERHDF_FAN_AUTO) &&
> >> -		    (cur_temp < fanoff))
> >> +		if (cur_state == ACERHDF_FAN_AUTO)
> >>  			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
> >>  	} else {
> >>  		if (cur_state == ACERHDF_FAN_OFF)
> >> @@ -696,11 +714,19 @@ static int acerhdf_register_thermal(void)
> >>  		return -EINVAL;
> >>  
> >>  	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
> >> -					      &acerhdf_dev_ops, NULL, 0,
> >> +					      &acerhdf_dev_ops,
> >> +					      &acerhdf_zone_params, 0,
> >>  					      (kernelmode) ? interval*1000 : 0);
> >>  	if (IS_ERR(thz_dev))
> >>  		return -EINVAL;
> >>  
> >> +	if (strcmp(thz_dev->governor->name,
> >> +				acerhdf_zone_params.governor_name)) {
> >> +		pr_err("Didn't get thermal governor %s, perhaps not compiled into thermal subsystem.\n",
> >> +				acerhdf_zone_params.governor_name);
> >> +		return -EINVAL;
> >> +	}
> >> +
> >>  	return 0;
> >>  }
> >>  
> > 
> > 


