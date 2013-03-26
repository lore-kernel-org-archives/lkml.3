Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab3CZQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:53:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:20106 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab3CZQxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:53:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="284820902"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "andi@lisas.de" <andi@lisas.de>
Subject: RE: [RFC PATCH 3/5] Thermal: build thermal governors into
 thermal_sys module
Thread-Topic: [RFC PATCH 3/5] Thermal: build thermal governors into
 thermal_sys module
Thread-Index: AQHOKj6wrkErfP8TzUWnFUuGbEoo0Zi4LY2w
Date: Tue, 26 Mar 2013 16:53:07 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59C59803@BGSMSX101.gar.corp.intel.com>
References: <1364315169-15427-1-git-send-email-rui.zhang@intel.com>
 <1364315169-15427-4-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1364315169-15427-4-git-send-email-rui.zhang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

> -----Original Message-----
> From: Zhang, Rui
> Sent: Tuesday, March 26, 2013 9:56 PM
> To: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: amit.daniel@samsung.com; R, Durgadoss; andi@lisas.de; Zhang, Rui
> Subject: [RFC PATCH 3/5] Thermal: build thermal governors into thermal_sys
> module
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/thermal/Makefile       |    6 +++---
>  drivers/thermal/fair_share.c   |   15 ++-------------
>  drivers/thermal/step_wise.c    |   16 ++--------------
>  drivers/thermal/thermal_core.c |   36
> ++++++++++++++++++++++++++++++++++--
>  drivers/thermal/thermal_core.h |   25 +++++++++++++++++++++++++
>  drivers/thermal/user_space.c   |   15 ++-------------
>  include/linux/thermal.h        |    1 -
>  7 files changed, 68 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index b2009bd..b7fffc7 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -6,9 +6,9 @@ obj-$(CONFIG_THERMAL)		+= thermal_sys.o
>  thermal_sys-y			+= thermal_core.o
> 
>  # governors
> -obj-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
> -obj-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
> -obj-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
> +thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+=
> fair_share.o
> +thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
> +thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+=
> user_space.o
> 
>  # cpufreq cooling
>  obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
> diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
> index 792479f..944ba2f 100644
> --- a/drivers/thermal/fair_share.c
> +++ b/drivers/thermal/fair_share.c
> @@ -22,9 +22,6 @@
>   *
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~
>   */
> 
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
> -#include <linux/module.h>
>  #include <linux/thermal.h>
> 
>  #include "thermal_core.h"
> @@ -111,23 +108,15 @@ static int fair_share_throttle(struct
> thermal_zone_device *tz, int trip)
>  static struct thermal_governor thermal_gov_fair_share = {
>  	.name		= "fair_share",
>  	.throttle	= fair_share_throttle,
> -	.owner		= THIS_MODULE,
>  };
> 
> -static int __init thermal_gov_fair_share_init(void)
> +int thermal_gov_fair_share_register(void)
>  {
>  	return thermal_register_governor(&thermal_gov_fair_share);
>  }
> 
> -static void __exit thermal_gov_fair_share_exit(void)
> +void thermal_gov_fair_share_unregister(void)
>  {
>  	thermal_unregister_governor(&thermal_gov_fair_share);
>  }
> 
> -/* This should load after thermal framework */
> -fs_initcall(thermal_gov_fair_share_init);
> -module_exit(thermal_gov_fair_share_exit);
> -
> -MODULE_AUTHOR("Durgadoss R");
> -MODULE_DESCRIPTION("A simple weight based thermal throttling
> governor");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> index 407cde3..a6c9666 100644
> --- a/drivers/thermal/step_wise.c
> +++ b/drivers/thermal/step_wise.c
> @@ -22,9 +22,6 @@
>   *
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~
>   */
> 
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
> -#include <linux/module.h>
>  #include <linux/thermal.h>
> 
>  #include "thermal_core.h"
> @@ -180,23 +177,14 @@ static int step_wise_throttle(struct
> thermal_zone_device *tz, int trip)
>  static struct thermal_governor thermal_gov_step_wise = {
>  	.name		= "step_wise",
>  	.throttle	= step_wise_throttle,
> -	.owner		= THIS_MODULE,
>  };
> 
> -static int __init thermal_gov_step_wise_init(void)
> +int thermal_gov_step_wise_register(void)
>  {
>  	return thermal_register_governor(&thermal_gov_step_wise);
>  }
> 
> -static void __exit thermal_gov_step_wise_exit(void)
> +void thermal_gov_step_wise_unregister(void)
>  {
>  	thermal_unregister_governor(&thermal_gov_step_wise);
>  }
> -
> -/* This should load after thermal framework */
> -fs_initcall(thermal_gov_step_wise_init);
> -module_exit(thermal_gov_step_wise_exit);
> -
> -MODULE_AUTHOR("Durgadoss R");
> -MODULE_DESCRIPTION("A step-by-step thermal throttling governor");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c
> index 845ed6e..eac9745 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1858,22 +1858,54 @@ static inline int genetlink_init(void) { return 0; }
>  static inline void genetlink_exit(void) {}
>  #endif /* !CONFIG_NET */
> 
> +static int __init thermal_register_governors(void)
> +{
> +	int result;
> +
> +	result = thermal_gov_step_wise_register();
> +	if (result)

[Patches 1,2 are fine with me].

A pr_err statement here, saying the registration failed,
would help us a lot.

> +		return result;
> +
> +	result = thermal_gov_fair_share_register();
> +	if (result)
> +		return result;
> +
> +	result = thermal_gov_user_space_register();

Same check + print statement for the other two as well.

> +
> +	return result;
> +}
> +
> +static void __exit thermal_unregister_governors(void)
> +{
> +	thermal_gov_step_wise_unregister();
> +	thermal_gov_fair_share_unregister();
> +	thermal_gov_user_space_unregister();
> +}
> +
>  static int __init thermal_init(void)
>  {
> -	int result = 0;
> +	int result;
> +
> +	result = thermal_register_governors();
> +	if (result)
> +		return result;
> 
>  	result = class_register(&thermal_class);
>  	if (result)

Shouldn't we do thermal_unregister_governors here ?

>  		return result;
> 
>  	result = genetlink_init();
> +	if (result)
> +		class_unregister(&thermal_class);

Shouldn't we do thermal_unregister_governors here ?
Probably a goto would make things simpler..

> +
>  	return result;
>  }
> 
>  static void __exit thermal_exit(void)
>  {
> -	class_unregister(&thermal_class);
>  	genetlink_exit();
> +	class_unregister(&thermal_class);
> +	thermal_unregister_governors();
>  }
> 
>  fs_initcall(thermal_init);
> diff --git a/drivers/thermal/thermal_core.h
> b/drivers/thermal/thermal_core.h
> index 0d3205a..f84ea0f 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -50,4 +50,29 @@ struct thermal_instance {
>  	struct list_head cdev_node; /* node in cdev->thermal_instances */
>  };
> 
> +
> +#ifdef CONFIG_THERMAL_GOV_STEP_WISE
> +extern int thermal_gov_step_wise_register(void);
> +extern void thermal_gov_step_wise_unregister(void);
> +#else
> +static inline int thermal_gov_step_wise_register(void) { return 0; }
> +static inline void thermal_gov_step_wise_unregister(void) {}
> +#endif /* CONFIG_THERMAL_GOV_STEP_WISE */
> +
> +#ifdef CONFIG_THERMAL_GOV_FAIR_SHARE
> +extern int thermal_gov_fair_share_register(void);
> +extern void thermal_gov_fair_share_unregister(void);
> +#else
> +static inline int thermal_gov_fair_share_register(void) { return 0; }
> +static inline void thermal_gov_fair_share_unregister(void) {}
> +#endif /* CONFIG_THERMAL_GOV_FAIR_SHARE */
> +
> +#ifdef CONFIG_THERMAL_GOV_USER_SPACE
> +extern int thermal_gov_user_space_register(void);
> +extern void thermal_gov_user_space_unregister(void);
> +#else
> +static inline int thermal_gov_user_space_register(void) { return 0; }
> +static inline void thermal_gov_user_space_unregister(void) {}
> +#endif /* CONFIG_THERMAL_GOV_USER_SPACE */
> +
>  #endif /* __THERMAL_CORE_H__ */
> diff --git a/drivers/thermal/user_space.c b/drivers/thermal/user_space.c
> index 6bbb380..10adcdd 100644
> --- a/drivers/thermal/user_space.c
> +++ b/drivers/thermal/user_space.c
> @@ -22,9 +22,6 @@
>   *
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~
>   */
> 
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
> -#include <linux/module.h>
>  #include <linux/thermal.h>
> 
>  #include "thermal_core.h"
> @@ -46,23 +43,15 @@ static int notify_user_space(struct
> thermal_zone_device *tz, int trip)
>  static struct thermal_governor thermal_gov_user_space = {
>  	.name		= "user_space",
>  	.throttle	= notify_user_space,
> -	.owner		= THIS_MODULE,
>  };
> 
> -static int __init thermal_gov_user_space_init(void)
> +int thermal_gov_user_space_register(void)
>  {
>  	return thermal_register_governor(&thermal_gov_user_space);
>  }
> 
> -static void __exit thermal_gov_user_space_exit(void)
> +void thermal_gov_user_space_unregister(void)
>  {
>  	thermal_unregister_governor(&thermal_gov_user_space);
>  }
> 
> -/* This should load after thermal framework */
> -fs_initcall(thermal_gov_user_space_init);
> -module_exit(thermal_gov_user_space_exit);
> -
> -MODULE_AUTHOR("Durgadoss R");
> -MODULE_DESCRIPTION("A user space Thermal notifier");
> -MODULE_LICENSE("GPL");
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f0bd7f9..2eeec01 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -184,7 +184,6 @@ struct thermal_governor {
>  	char name[THERMAL_NAME_LENGTH];
>  	int (*throttle)(struct thermal_zone_device *tz, int trip);
>  	struct list_head	governor_list;
> -	struct module		*owner;
>  };
> 
>  /* Structure that holds binding parameters for a zone */
> --
> 1.7.9.5

