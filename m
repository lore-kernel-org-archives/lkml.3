Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaENONJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:13:09 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55002 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaENONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:13:06 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 5/9] dt: deps: register drivers based on the
 initialization order based on DT
To: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
In-Reply-To: <1399913280-6915-6-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<1399913280-6915-6-git-send-email-holler@ahsoftware.de>
Date: Wed, 14 May 2014 15:13:00 +0100
Message-Id: <20140514141300.67206C4153D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 18:47:56 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
> The init system currently calls unknown functions with almost unknown
> functionality in an almost random order.

Correct, we've got a module system. Some would say that is a strength!
:-) That said, I don't object to optimizing to the optimal order when
possible.

> Fixing this is on a short-term basis is a bit tricky.
> 
> In order to register drivers with a deterministic order, a list of all
> available in-kernel drivers is needed. Unfortunately such a list doesn't
> exist, just a list of initcalls does exist.
> 
> The trick now is to first call special annotated initcalls (I call those
> "well done") for platform drivers, but not actualy starting those drivers
> by calling their probe function, but just collectiong their meta datas
> (struct platform_driver). After all those informations were collected,
> available the drivers will be started according to the previously
> determined order.

Why does the initcall level matter? Why not just let the initcalls
happen, capture the calls that register a driver, and then use that list
later?

> 
> The annotation of such platform drivers is necessary because it must be
> made sure that those drivers don't care if the probe is actually called in
> their initcall or later.
> 
> That means that all platform drivers which already do use
> 
> 	module_platform_driver() or
> 	module_platform_driver_probe()
> 
> don't need any modification because their initcall is known and already well
> done. But all platform drivers which do use
> 
> 	module_init() or
> 	*_initcall()
> 
> have to be reviewed if they are "well done". If they are, they need a change
> like
> 
> 	-module_init(foo_init);
> 	+well_done_platform_module_init(foo_init);
> 
> or
> 
> 	-subsys_initcall(foo_init);
> 	+well_done_platform_initcall(subsys, foo_init);
> 
> to become included in the deterministic order in which platform drivers
> will be initialized.
> 
> All other platform drivers will still be initialized in random order before
> platform drivers included in the deterministic order will be initialized.
> "Well done" drivers which don't appear in the order (because they don't appear
> in the DT) will be initialized after those which do appear in the order.
> 
> If CONFIG_OF_DEPENDENCIES is disabled, nothing is changed at all.
> 
> The long range target to fix the problem should be to include a list (array)
> of struct platform_driver in the kernel for all in-kernel platform drivers,
> instead of just initcalls. This will be easy if all platform drivers have
> become "well done".

How will that list be constructed? How will it account for multiple
platforms, each requiring a different init order?

> 
> Unfortunately there are some drivers which will need quiet some changes
> to become "well done". As an example for such an initcall look e.g. at
> drivers/tty/serial/8250/8250_core.c.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  drivers/base/platform.c           | 13 +++++++
>  drivers/of/of_dependencies.c      | 79 +++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h |  1 +
>  include/linux/init.h              | 19 ++++++++++
>  include/linux/of_dependencies.h   |  5 +++
>  include/linux/platform_device.h   | 16 ++++++--
>  init/main.c                       | 17 ++++++++-
>  7 files changed, 145 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index bc78848..b9c9b33 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -13,6 +13,7 @@
>  #include <linux/string.h>
>  #include <linux/platform_device.h>
>  #include <linux/of_device.h>
> +#include <linux/of_dependencies.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/dma-mapping.h>
> @@ -541,6 +542,12 @@ int __platform_driver_register(struct platform_driver *drv,
>  	if (drv->shutdown)
>  		drv->driver.shutdown = platform_drv_shutdown;
>  
> +#ifdef CONFIG_OF_DEPENDENCIES
> +	if (of_init_is_recording())
> +		/* Just record the driver */
> +		return of_init_register_platform_driver(drv);
> +	else
> +#endif
>  	return driver_register(&drv->driver);
>  }
>  EXPORT_SYMBOL_GPL(__platform_driver_register);
> @@ -590,8 +597,14 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
>  
>  	/* temporary section violation during probe() */
>  	drv->probe = probe;
> +
>  	retval = code = platform_driver_register(drv);
>  
> +#ifdef CONFIG_OF_DEPENDENCIES
> +	if (of_init_is_recording())
> +		/* Just record the driver */
> +		return retval;
> +#endif
>  	/*
>  	 * Fixup that section violation, being paranoid about code scanning
>  	 * the list of drivers in order to probe new devices.  Check to see
> diff --git a/drivers/of/of_dependencies.c b/drivers/of/of_dependencies.c
> index 7905172..4af62d5 100644
> --- a/drivers/of/of_dependencies.c
> +++ b/drivers/of/of_dependencies.c
> @@ -46,9 +46,12 @@ struct init_order {
>  	/* Used to keep track of parent devices in regard to the DT */
>  	uint32_t parent_by_phandle[MAX_DT_NODES+1];
>  	struct device *device_by_phandle[MAX_DT_NODES+1];
> +	struct platform_driver *platform_drivers[MAX_DT_NODES+1];
> +	unsigned count_drivers;
>  };
>  static struct init_order order __initdata;
>  
> +static bool is_recording;
>  
>  /* Copied from drivers/of/base.c (because it's lockless). */
>  static struct property * __init __of_find_property(const struct device_node *np,
> @@ -401,3 +404,79 @@ void __init of_init_free_order(void)
>  	order.count = 0;
>  	/* remove_new_phandles(); */
>  }
> +
> +void __init of_init_set_recording(bool recording)
> +{
> +	is_recording = recording;
> +}
> +
> +bool of_init_is_recording(void)
> +{
> +	return is_recording;
> +}
> +
> +int of_init_register_platform_driver(struct platform_driver *drv)
> +{
> +	BUG_ON(!is_recording);
> +	order.platform_drivers[order.count_drivers++] = drv;
> +	return 0;
> +}
> +
> +void __init of_init_register_drivers(void)
> +{
> +	unsigned i, j;
> +	int rc __maybe_unused;
> +
> +	BUG_ON(is_recording);
> +	/*
> +	 * Because we already have a list of devices and drivers together
> +	 * with their compatible strings, the below code could be speed up
> +	 * by replacing the functions which are walking through lists with
> +	 * something which uses trees or hashes to compare/search strings.
> +	 * These are of_driver_match_device() and driver_find() (the latter
> +	 * is called again in driver_register().
> +	 */
> +	for (i = 0; i < order.count; ++i) {
> +		struct device_node *node = order.order[i];
> +		struct device *dev = order.device_by_phandle[node->phandle];
> +
> +		for (j = 0; j < order.count_drivers; ++j) {
> +			struct platform_driver *drv = order.platform_drivers[j];
> +
> +			if (of_driver_match_device(dev, &drv->driver)) {
> +				if (!driver_find(drv->driver.name,
> +				    drv->driver.bus))
> +					platform_driver_register(drv);
> +				if (dev->parent)
> +					device_lock(dev->parent);
> +				rc = device_attach(dev);
> +				if (dev->parent)
> +					device_unlock(dev->parent);
> +				break;
> +			}
> +		}
> +		if (j >= order.count_drivers) {
> +			/*
> +			 * No driver in the initialization order matched,
> +			 * try to attach the device, maybe a driver already
> +			 * exists (e.g. loaded pre-smp).
> +			 */
> +			if (dev->parent)
> +				device_lock(dev->parent);
> +			rc = device_attach(dev);
> +			if (dev->parent)
> +				device_unlock(dev->parent);
> +		}
> +	}
> +	/*
> +	 * Now just register all drivers, including those not used through
> +	 * the initialization order (well-done drivers which aren't listed
> +	 * in the DT or blacklisted through of_init_create_devices()).
> +	 */
> +	for (j = 0; j < order.count_drivers; ++j) {
> +		struct platform_driver *drv = order.platform_drivers[j];
> +
> +		if (!driver_find(drv->driver.name, drv->driver.bus))
> +			platform_driver_register(drv);
> +	}
> +}
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bc2121f..cedb3b0 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -633,6 +633,7 @@
>  		INIT_CALLS_LEVEL(rootfs)				\
>  		INIT_CALLS_LEVEL(6)					\
>  		INIT_CALLS_LEVEL(7)					\
> +		INIT_CALLS_LEVEL(8)					\
>  		VMLINUX_SYMBOL(__initcall_end) = .;
>  
>  #define CON_INITCALL							\
> diff --git a/include/linux/init.h b/include/linux/init.h
> index e168880..acb7dfa 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -209,6 +209,23 @@ extern bool initcall_debug;
>  #define late_initcall(fn)		__define_initcall(fn, 7)
>  #define late_initcall_sync(fn)		__define_initcall(fn, 7s)
>  
> +/*
> + * A well_done_platform_module_init or well_done_platform_initcall
> + * only calls platform_driver_register() or platform_driver_probe()
> + * and ignores the return code. This is necessary because the
> + * actual calls to platform_driver_register() or platform_driver_probe()
> + * will be delayed when CONFIG_OF_DEPENDENCIES is enabled. This is done
> + * to sort those calls based on the dependencies in the DT (matched to the
> + * platform driver data).
> + */
> +#ifdef CONFIG_OF_DEPENDENCIES
> +#define well_done_platform_module_init(fn)	__define_initcall(fn, 8)
> +#define well_done_platform_initcall(leve, fn)	__define_initcall(fn, 8)
> +#else
> +#define well_done_platform_module_init(fn)	module_init(fn)
> +#define well_done_platform_initcall(level, fn)	level ## _initcall(fn)
> +#endif
> +
>  #define __initcall(fn) device_initcall(fn)
>  
>  #define __exitcall(fn) \
> @@ -289,6 +306,8 @@ void __init parse_early_options(char *cmdline);
>  #define rootfs_initcall(fn)		module_init(fn)
>  #define device_initcall(fn)		module_init(fn)
>  #define late_initcall(fn)		module_init(fn)
> +#define well_done_platform_initcall(fn)	module_init(fn)
> +#define well_done_platform_module_init(fn)	module_init(fn)
>  
>  #define console_initcall(fn)		module_init(fn)
>  #define security_initcall(fn)		module_init(fn)
> diff --git a/include/linux/of_dependencies.h b/include/linux/of_dependencies.h
> index e046ce2..8869162 100644
> --- a/include/linux/of_dependencies.h
> +++ b/include/linux/of_dependencies.h
> @@ -58,4 +58,9 @@ extern void of_init_create_devices(const struct of_device_id *matches,
>   */
>  extern void of_init_free_order(void);
>  
> +void of_init_set_recording(bool recording);
> +bool of_init_is_recording(void);
> +int of_init_register_platform_driver(struct platform_driver *drv);
> +void of_init_register_drivers(void);
> +
>  #endif	/* _LINUX_OF_DEPENDENCIES_H */
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 16f6654..b8559d9 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -215,9 +215,17 @@ static inline void platform_set_drvdata(struct platform_device *pdev,
>   * boilerplate.  Each module may only use this macro once, and
>   * calling it replaces module_init() and module_exit()
>   */
> -#define module_platform_driver(__platform_driver) \
> -	module_driver(__platform_driver, platform_driver_register, \
> -			platform_driver_unregister)
> +#define module_platform_driver(__driver) \
> +static int __init __driver##_init(void) \
> +{ \
> +	return platform_driver_register(&(__driver)); \
> +} \
> +well_done_platform_module_init(__driver##_init); \
> +static void __exit __driver##_exit(void) \
> +{ \
> +	platform_driver_unregister(&(__driver)); \
> +} \
> +module_exit(__driver##_exit);
>  
>  /* module_platform_driver_probe() - Helper macro for drivers that don't do
>   * anything special in module init/exit.  This eliminates a lot of
> @@ -230,7 +238,7 @@ static int __init __platform_driver##_init(void) \
>  	return platform_driver_probe(&(__platform_driver), \
>  				     __platform_probe);    \
>  } \
> -module_init(__platform_driver##_init); \
> +well_done_platform_module_init(__platform_driver##_init); \
>  static void __exit __platform_driver##_exit(void) \
>  { \
>  	platform_driver_unregister(&(__platform_driver)); \
> diff --git a/init/main.c b/init/main.c
> index 9c7fd4c..7591cd1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -77,6 +77,7 @@
>  #include <linux/sched_clock.h>
>  #include <linux/context_tracking.h>
>  #include <linux/random.h>
> +#include <linux/of_dependencies.h>
>  
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -720,6 +721,7 @@ extern initcall_t __initcall4_start[];
>  extern initcall_t __initcall5_start[];
>  extern initcall_t __initcall6_start[];
>  extern initcall_t __initcall7_start[];
> +extern initcall_t __initcall8_start[];
>  extern initcall_t __initcall_end[];
>  
>  static initcall_t *initcall_levels[] __initdata = {
> @@ -731,6 +733,7 @@ static initcall_t *initcall_levels[] __initdata = {
>  	__initcall5_start,
>  	__initcall6_start,
>  	__initcall7_start,
> +	__initcall8_start,
>  	__initcall_end,
>  };
>  
> @@ -744,6 +747,8 @@ static char *initcall_level_names[] __initdata = {
>  	"fs",
>  	"device",
>  	"late",
> +	/* must be the last level to become excluded in do_initcalls() */
> +	"well-done-platform-driver",
>  };
>  
>  static void __init do_initcall_level(int level)
> @@ -766,7 +771,7 @@ static void __init do_initcalls(void)
>  {
>  	int level;
>  
> -	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
> +	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 3; level++)
>  		do_initcall_level(level);
>  }
>  
> @@ -787,6 +792,16 @@ static void __init do_basic_setup(void)
>  	do_ctors();
>  	usermodehelper_enable();
>  	do_initcalls();
> +#ifdef CONFIG_OF_DEPENDENCIES
> +	/* collect a list of available platform drivers */
> +	of_init_set_recording(true);
> +	do_initcall_level(ARRAY_SIZE(initcall_levels) - 2);
> +	of_init_set_recording(false);
> +	/* probe available platform drivers with deterministic order */
> +	of_init_register_drivers();
> +	/* register late drivers */
> +	do_initcall_level(ARRAY_SIZE(initcall_levels) - 3);
> +#endif
>  	random_int_secret_init();
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

