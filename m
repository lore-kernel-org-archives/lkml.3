Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaAGOFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:05:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:58552 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbaAGOFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:05:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,619,1384329600"; 
   d="scan'208";a="454852463"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <linux@roeck-us.net>, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frodo Looijaard <frodol@dds.nl>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
Thread-Topic: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
Thread-Index: AQHPC0VHmU/Fe9QCM020ZahPNTZQHpp4Ax0AgAChVoCAAAWBgIAAnXQA
Date: Tue, 7 Jan 2014 14:05:04 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B909263011BC64C@SHSMSX101.ccr.corp.intel.com>
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au>
 <52CB0948.6030702@infradead.org> <20140106203209.GA21630@roeck-us.net>
 <52CB53DC.4030901@infradead.org> <52CB65DA.2010103@roeck-us.net>
 <20140107130401.23bffcd2@endymion.delvare> <52CBF1CF.2000603@ti.com>
In-Reply-To: <52CBF1CF.2000603@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Tuesday, January 07, 2014 8:24 PM
> To: Jean Delvare
> Cc: Guenter Roeck; Randy Dunlap; Stephen Rothwell; linux-
> next@vger.kernel.org; linux-kernel@vger.kernel.org; Frodo Looijaard;
> lm-sensors@lm-sensors.org; Zhang, Rui; Eduardo Valentin; linux-
> pm@vger.kernel.org
> Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
> Importance: High
> 
> On 07-01-2014 08:04, Jean Delvare wrote:
> > Hi Guenter, Randy,
> >
> > On Mon, 06 Jan 2014 18:26:34 -0800, Guenter Roeck wrote:
> >> On 01/06/2014 05:09 PM, Randy Dunlap wrote:
> >>> From: Randy Dunlap <rdunlap@infradead.org>
> >>>
> >>> Fix SENSORS_LM75 dependencies to eliminate build errors:
> >>>
> >>> drivers/built-in.o: In function `lm75_remove':
> >>> lm75.c:(.text+0x12bd8c): undefined reference to
> `thermal_zone_of_sensor_unregister'
> >>> drivers/built-in.o: In function `lm75_probe':
> >>> lm75.c:(.text+0x12c123): undefined reference to
> `thermal_zone_of_sensor_register'
> >>>
> >>> Add depends on THERMAL_OF since that is what provides the
> >>> register/unregister functions above.
> >>>
> >>> Add depends on THERMAL since THERMAL is a tristate (while
> THERMAL_OF
> >>> is a bool) and SENSORS_LM75 (tristate) needs to be limited to
> >>> modular builds when THERMAL=m.
> >>>
> >>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >>> ---
> >>>   drivers/hwmon/Kconfig |    2 ++
> >>>   1 file changed, 2 insertions(+)
> >>>
> >>> --- linux-next-20140106.orig/drivers/hwmon/Kconfig
> >>> +++ linux-next-20140106/drivers/hwmon/Kconfig
> >>> @@ -650,6 +650,8 @@ config SENSORS_LM73
> >>>   config SENSORS_LM75
> >>>   	tristate "National Semiconductor LM75 and compatibles"
> >>>   	depends on I2C
> >>> +	depends on THERMAL
> >>> +	depends on THERMAL_OF
> >>>   	help
> >>>   	  If you say yes here you get support for one common type
> of
> >>>   	  temperature sensor chip, with models including:
> >>>
> >>>
> >> NACK. The driver does not and must not depend on THERMAL.
> >
> > Correct.
> >
> >> This needs to be addressed
> >> in the thermal code, for example with dummy declarations if
> THERMAL=m
> >> but SENSORS_LM75=y. The functions are already declared as dummies if
> THERMAL_OF=n.
> >
> > This won't fly I'm afraid, the number of hwmon drivers affected will
> > grow in the future and you certainly don't want to have to change the
> > generic thermal code every time a new driver is added/converted.
> 
> Agreed
> 
> >
> > I've looked at the problem this morning and I will admit I do not
> even
> > understand what the problem is. In Randy's config,
> CONFIG_THERMAL_OF=y
> > so both thermal_zone_of_sensor_unregister and
> > thermal_zone_of_sensor_register are built-in. SENSORS_LM75=y so the
> > calls to these functions are built-in too. I just can't see how this
> > can be a problem at link time. Can anyone enlighten me?
> >
> 
> 
> I believe the problem is more in the fact that THERMAL_OF is a bool,
> but the way it is in thermal Kconfig, it will link to the thermal
> module, in case CONFIG_THERMAL=m. Thus I am proposing the following,
> which limits the user to have THERMAL_OF only as builtin and whenever
> is selected, it will select THERMAL too. That is:
> 
> 
> From b643aa260ed4f3514d1ca51b1ecbe4be7652a8d0 Mon Sep 17 00:00:00 2001
> From: Eduardo Valentin <eduardo.valentin@ti.com>
> Date: Tue, 7 Jan 2014 08:04:02 -0400
> Subject: [PATCH 1/1] thermal: fix compilation issue on
> CONFIG_THERMAL_OF  dependencies
> 
> Users of API provided by THERMAL_OF config may suffer when
> CONFIG_THERMAL=y, causing linking issues, such as:
> 
> drivers/built-in.o: In function `lm75_remove':
> lm75.c:(.text+0x12bd8c): undefined reference to
> `thermal_zone_of_sensor_unregister'
> drivers/built-in.o: In function `lm75_probe':
> lm75.c:(.text+0x12c123): undefined reference to
> `thermal_zone_of_sensor_register'
> 
> Therefore, this patch limits the compilation build to always have
> THERMAL=y, whenever THERMAL_OF=y. In this way, whenever the API user is
> built, if THERMAL_OF=y, the build shall have the full thermal support,
> otherwise, the thermal API will provide stubs.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/Kconfig | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig index
> 58f98bd..dc315e9 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -29,19 +29,6 @@ config THERMAL_HWMON
>  	  Say 'Y' here if you want all thermal sensors to
>  	  have hwmon sysfs interface too.
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
>  choice
>  	prompt "Default Thermal governor"
>  	default THERMAL_DEFAULT_GOV_STEP_WISE
> @@ -235,3 +222,19 @@ source "drivers/thermal/samsung/Kconfig"
>  endmenu
> 
>  endif
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
> --
> 1.8.2.1.342.gfa7285d
> 
> Randy, can you please confirm if this fix the issue for you?
> 
The patch looks good to me, will apply it after it has been verified to fix the problem.
BTW, I've been thinking of make CONFIG_THERMAL a bool since long time ago, the only thing that blocks me is that Thermal subsystem needs to register a hwmon device for each thermal zone and CONFIG_HWMON is a tristate.

Thanks,
rui
> --
> You have got to be excited about what you are doing. (L. Lamport)
> 
> Eduardo Valentin

