Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaAPQeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:34:19 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49914 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaAPQeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:34:16 -0500
Date: Thu, 16 Jan 2014 16:34:09 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain
 look-up
Message-ID: <20140116163409.GD25540@e102568-lin.cambridge.arm.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 Jan 2014 16:34:10.0753 (UTC) FILETIME=[C8C39310:01CF12D8]
X-MC-Unique: 114011616341313201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

thank you for posting this series. I would like to use the DT bindings
for power domains in the bindings for C-states on ARM:

http://comments.gmane.org/gmane.linux.power-management.general/41012

and in particular link a given C-state to a given power domain so that the
kernel will have a way to actually check what devices are lost upon C-state
entry (and for devices I also mean CPU peripheral like PMUs, GIC CPU IF,
caches and possibly cpus, all of them already represented with DT nodes).

I have a remark:

-  Can we group device nodes under a single power-domain-parent so that
   all devices defined under that parent won't have to re-define a
   power-domain property (a property like interrupt-parent, so to speak)

What do you think ?

Thanks,
Lorenzo

On Sat, Jan 11, 2014 at 07:42:46PM +0000, Tomasz Figa wrote:
> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
> 
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  .../devicetree/bindings/power/power_domain.txt     |  51 ++++
>  drivers/base/power/domain.c                        | 339 +++++++++++++++++++++
>  include/linux/pm_domain.h                          |  34 +++
>  kernel/power/Kconfig                               |   4 +
>  4 files changed, 428 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt
> 
> diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
> new file mode 100644
> index 0000000..93be5d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/power_domain.txt
> @@ -0,0 +1,51 @@
> +* Generic power domains
> +
> +System on chip designs are often divided into multiple power domains that
> +can be used for power gating of selected IP blocks for power saving by
> +reduced leakage current.
> +
> +This device tree binding can be used to bind power domain consumer devices
> +with their power domains provided by power domain providers. A power domain
> +provider can be represented by any node in the device tree and can provide
> +one or more power domains. A consumer node can refer to the provider by
> +a phandle and a set of phandle arguments (so called power domain specifier)
> +of length specified by #power-domain-cells property in the power domain
> +provider node.
> +
> +==Power domain providers==
> +
> +Required properties:
> + - #power-domain-cells : Number of cells in a power domain specifier;
> +   Typically 0 for nodes representing a single power domain and 1 for nodes
> +   providing multiple power domains (e.g. power controllers), but can be
> +   any value as specified by device tree binding documentation of particular
> +   provider.
> +
> +Example:
> +
> +       power: power-controller@12340000 {
> +               compatible = "foo,power-controller";
> +               reg = <0x12340000 0x1000>;
> +               #power-domain-cells = <1>;
> +       };
> +
> +The node above defines a power controller that is a power domain provider
> +and expects one cell as its phandle argument.
> +
> +==Power domain consumers==
> +
> +Required properties:
> + - power-domain : A phandle and power domain specifier as defined by bindings
> +                  of power controller specified by phandle.
> +
> +Example:
> +
> +       leaky-device@12350000 {
> +               compatible = "foo,i-leak-current";
> +               reg = <0x12350000 0x1000>;
> +               power-domain = <&power 0>;
> +       };
> +
> +The node above defines a typical power domain consumer device, which is located
> +inside power domain with index 0 of power controller represented by node with
> +label "power".
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index bfb8955..6d47498 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -3,12 +3,16 @@
>   *
>   * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
>   *
> + * Support for Device Tree based power domain providers:
> + * Copyright (C) 2014 Tomasz Figa <tomasz.figa@gmail.com>
> + *
>   * This file is released under the GPLv2.
>   */
> 
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> +#include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pm_domain.h>
>  #include <linux/pm_qos.h>
> @@ -2177,3 +2181,338 @@ void pm_genpd_init(struct generic_pm_domain *genpd,
>         list_add(&genpd->gpd_list_node, &gpd_list);
>         mutex_unlock(&gpd_list_lock);
>  }
> +
> +#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
> +/*
> + * DEVICE TREE BASED POWER DOMAIN PROVIDERS
> + *
> + * The code below implements generic device tree based power domain providers
> + * that bind device tree nodes with generic power domains registered in the
> + * system.
> + *
> + * Any driver that registers generic power domains and need to support binding
> + * of devices to these domains is supposed to register a power domain provider,
> + * which maps a power domain specifier retrieved from device tree to a power
> + * domain.
> + *
> + * Two simple mapping functions have been provided for convenience:
> + *  - of_genpd_xlate_simple() for 1:1 device tree node to domain mapping,
> + *  - of_genpd_xlate_onecell() for mapping of multiple domains per node
> + *    by index.
> + */
> +
> +/**
> + * struct of_genpd_provider - Power domain provider registration structure
> + * @link: Entry in global list of domain providers
> + * @node: Pointer to device tree node of domain provider
> + * @xlate: Provider-specific xlate callback mapping a set of specifier cells
> + *         into a power domain.
> + * @data: context pointer to be passed into @xlate callback
> + */
> +struct of_genpd_provider {
> +       struct list_head link;
> +
> +       struct device_node *node;
> +       genpd_xlate_t xlate;
> +       void *data;
> +};
> +
> +/* List of registered power domain providers. */
> +static LIST_HEAD(of_genpd_providers);
> +/* Mutex to protect the list above. */
> +static DEFINE_MUTEX(of_genpd_mutex);
> +
> +/**
> + * of_genpd_lock() - Lock access to of_genpd_providers list
> + */
> +static void of_genpd_lock(void)
> +{
> +       mutex_lock(&of_genpd_mutex);
> +}
> +
> +/**
> + * of_genpd_unlock() - Unlock access to of_genpd_providers list
> + */
> +static void of_genpd_unlock(void)
> +{
> +       mutex_unlock(&of_genpd_mutex);
> +}
> +
> +/**
> + * of_genpd_xlate_simple() - Xlate function for direct node-domain mapping
> + * @genpdspec: OF phandle args to map into a power domain
> + * @data: xlate function private data - pointer to struct generic_pm_domain
> + *
> + * This is a generic xlate function that can be used to model power domains
> + * that have their own device tree nodes. The private data of xlate function
> + * needs to be a valid pointer to struct generic_pm_domain.
> + */
> +struct generic_pm_domain *of_genpd_xlate_simple(
> +                                       struct of_phandle_args *genpdspec,
> +                                       void *data)
> +{
> +       if (genpdspec->args_count != 0)
> +               return ERR_PTR(-EINVAL);
> +       return data;
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_xlate_simple);
> +
> +/**
> + * of_genpd_xlate_onecell() - Xlate function for providers using single index.
> + * @genpdspec: OF phandle args to map into a power domain
> + * @data: xlate function private data - pointer to struct genpd_onecell_data
> + *
> + * This is a generic xlate function that can be used to model simple power
> + * domain controllers that have one device tree node and provide multiple
> + * power domains. A single cell is used as an index to an array of power
> + * domains specified in genpd_onecell_data struct when registering the
> + * provider.
> + */
> +struct generic_pm_domain *of_genpd_xlate_onecell(
> +                                       struct of_phandle_args *genpdspec,
> +                                       void *data)
> +{
> +       struct genpd_onecell_data *genpd_data = data;
> +       unsigned int idx = genpdspec->args[0];
> +
> +       if (genpdspec->args_count != 1)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (idx >= genpd_data->domain_num) {
> +               pr_err("%s: invalid domain index %d\n", __func__, idx);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       return genpd_data->domains[idx];
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_xlate_onecell);
> +
> +/**
> + * of_genpd_add_provider() - Register a domain provider for a node
> + * @np: Device node pointer associated with domain provider
> + * @genpd_src_get: callback for decoding domain
> + * @data: context pointer for @genpd_src_get callback.
> + */
> +int of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
> +                         void *data)
> +{
> +       struct of_genpd_provider *cp;
> +
> +       cp = kzalloc(sizeof(struct of_genpd_provider), GFP_KERNEL);
> +       if (!cp)
> +               return -ENOMEM;
> +
> +       cp->node = of_node_get(np);
> +       cp->data = data;
> +       cp->xlate = xlate;
> +
> +       of_genpd_lock();
> +       list_add(&cp->link, &of_genpd_providers);
> +       of_genpd_unlock();
> +       pr_debug("Added domain provider from %s\n", np->full_name);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_add_provider);
> +
> +/**
> + * of_genpd_del_provider() - Remove a previously registered domain provider
> + * @np: Device node pointer associated with domain provider
> + */
> +void of_genpd_del_provider(struct device_node *np)
> +{
> +       struct of_genpd_provider *cp;
> +
> +       of_genpd_lock();
> +       list_for_each_entry(cp, &of_genpd_providers, link) {
> +               if (cp->node == np) {
> +                       list_del(&cp->link);
> +                       of_node_put(cp->node);
> +                       kfree(cp);
> +                       break;
> +               }
> +       }
> +       of_genpd_unlock();
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_del_provider);
> +
> +/* See of_genpd_get_from_provider(). */
> +static struct generic_pm_domain *__of_genpd_get_from_provider(
> +                                       struct of_phandle_args *genpdspec)
> +{
> +       struct of_genpd_provider *provider;
> +       struct generic_pm_domain *genpd = ERR_PTR(-ENOENT);
> +
> +       /* Check if we have such a provider in our array */
> +       list_for_each_entry(provider, &of_genpd_providers, link) {
> +               if (provider->node == genpdspec->np)
> +                       genpd = provider->xlate(genpdspec, provider->data);
> +               if (!IS_ERR(genpd))
> +                       break;
> +       }
> +
> +       return genpd;
> +}
> +
> +/**
> + * of_genpd_get_from_provider() - Look-up power domain
> + * @genpdspec: OF phandle args to use for look-up
> + *
> + * Looks for domain provider under node specified by @genpdspec and if found
> + * uses xlate function of the provider to map phandle args to a power domain.
> + *
> + * Returns a valid pointer to struct generic_pm_domain on success or ERR_PTR()
> + * on failure.
> + */
> +static struct generic_pm_domain *of_genpd_get_from_provider(
> +                                       struct of_phandle_args *genpdspec)
> +{
> +       struct generic_pm_domain *genpd;
> +
> +       of_genpd_lock();
> +       genpd = __of_genpd_get_from_provider(genpdspec);
> +       of_genpd_unlock();
> +
> +       return genpd;
> +}
> +
> +/*
> + * DEVICE<->DOMAIN BINDING USING DEVICE TREE LOOK-UP
> + *
> + * The code below registers a notifier for platform bus devices'
> + * BUS_NOTIFY_BIND_DRIVER events and tries to attach devices to their power
> + * domains by looking them up using Device Tree.
> + *
> + * Similarly in BUS_NOTIFY_UNBOUND_DRIVER the device is detached from its
> + * domain, since it no longer supports runtime PM without any driver bound
> + * to it.
> + *
> + * Both generic and legacy Samsung-specific DT bindings are supported to
> + * keep backwards compatibility with existing DTBs.
> + */
> +
> +/**
> + * of_genpd_add_to_domain - Bind device to its power domain using Device Tree.
> + * @dev: Device to bind to its power domain.
> + *
> + * Tries to parse power domain specifier from device's OF node and if succeeds
> + * attaches the device to retrieved power domain.
> + *
> + * Returns 0 on success or negative error code otherwise.
> + */
> +static int of_genpd_add_to_domain(struct device *dev)
> +{
> +       struct of_phandle_args pd_args;
> +       struct generic_pm_domain *pd;
> +       int ret;
> +
> +       ret = of_parse_phandle_with_args(dev->of_node, "power-domain",
> +                                       "#power-domain-cells", 0, &pd_args);
> +       if (ret < 0) {
> +               if (ret != ENOENT)
> +                       return ret;
> +
> +               /*
> +                * Try legacy Samsung-specific bindings
> +                * (for backwards compatibility of DT ABI)
> +                */
> +               pd_args.args_count = 0;
> +               pd_args.np = of_parse_phandle(dev->of_node,
> +                                               "samsung,power-domain", 0);
> +               if (!pd_args.np)
> +                       return 0;
> +       }
> +
> +       pd = of_genpd_get_from_provider(&pd_args);
> +       if (IS_ERR(pd))
> +               return PTR_ERR(pd);
> +
> +       dev_dbg(dev, "adding to power domain %s\n", pd->name);
> +
> +       while (1) {
> +               ret = pm_genpd_add_device(pd, dev);
> +               if (ret != -EAGAIN)
> +                       break;
> +               cond_resched();
> +       }
> +
> +       if (!ret)
> +               pm_genpd_dev_need_restore(dev, true);
> +
> +       return ret;
> +}
> +
> +/**
> + * of_genpd_del_from_domain - Unbind device from its power domain.
> + * @dev: Device to unbind from its power domain.
> + *
> + * Unbinds device from power domain previously bound to it.
> + *
> + * Returns 0 on success or negative error code otherwise.
> + */
> +static int of_genpd_del_from_domain(struct device *dev)
> +{
> +       struct generic_pm_domain *genpd = dev_to_genpd(dev);
> +       int ret;
> +
> +       if (IS_ERR(genpd))
> +               return 0;
> +
> +       dev_dbg(dev, "removing from power domain %s\n", genpd->name);
> +
> +       while (1) {
> +               ret = pm_genpd_remove_device(genpd, dev);
> +               if (ret != -EAGAIN)
> +                       break;
> +               cond_resched();
> +       }
> +
> +       return ret;
> +}
> +
> +/**
> + * of_genpd_notifier_call - Receive device driver bind/unbind events
> + * @nb: Notifier block which sent the event.
> + * @event: Received event.
> + * @data: Data attached to received event (struct device *).
> + *
> + * Registered handler for device driver bind/unbind events that lets the
> + * code above perform the magic of adding/removing devices to/from its
> + * power domains.
> + */
> +static int of_genpd_notifier_call(struct notifier_block *nb,
> +                                 unsigned long event, void *data)
> +{
> +       struct device *dev = data;
> +       int ret;
> +
> +       if (!dev->of_node)
> +               return NOTIFY_DONE;
> +
> +       switch (event) {
> +       case BUS_NOTIFY_BIND_DRIVER:
> +               ret = of_genpd_add_to_domain(dev);
> +               break;
> +
> +       case BUS_NOTIFY_UNBOUND_DRIVER:
> +               ret = of_genpd_del_from_domain(dev);
> +               break;
> +
> +       default:
> +               return NOTIFY_DONE;
> +       }
> +
> +       return notifier_from_errno(ret);
> +}
> +
> +static struct notifier_block of_genpd_notifier_block = {
> +       .notifier_call = of_genpd_notifier_call,
> +};
> +
> +static int of_genpd_init(void)
> +{
> +       return bus_register_notifier(&platform_bus_type,
> +                                       &of_genpd_notifier_block);
> +}
> +core_initcall(of_genpd_init);
> +#endif
> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
> index 7c1d252..08adac0 100644
> --- a/include/linux/pm_domain.h
> +++ b/include/linux/pm_domain.h
> @@ -310,4 +310,38 @@ static inline void pm_genpd_syscore_poweron(struct device *dev)
>         pm_genpd_syscore_switch(dev, false);
>  }
> 
> +/* OF power domain providers */
> +struct of_device_id;
> +
> +struct genpd_onecell_data {
> +       struct generic_pm_domain **domains;
> +       unsigned int domain_num;
> +};
> +
> +typedef struct generic_pm_domain *(*genpd_xlate_t)(struct of_phandle_args *args,
> +                                                  void *data);
> +
> +#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
> +int of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
> +                         void *data);
> +void of_genpd_del_provider(struct device_node *np);
> +
> +struct generic_pm_domain *of_genpd_xlate_simple(
> +                                       struct of_phandle_args *genpdspec,
> +                                       void *data);
> +struct generic_pm_domain *of_genpd_xlate_onecell(
> +                                       struct of_phandle_args *genpdspec,
> +                                       void *data);
> +#else /* !CONFIG_PM_GENERIC_DOMAINS_OF */
> +static inline int of_genpd_add_provider(struct device_node *np,
> +                                       genpd_xlate_t xlate, void *data)
> +{
> +       return 0;
> +}
> +static inline void of_genpd_del_provider(struct device_node *np) {}
> +
> +#define of_genpd_xlate_simple          NULL
> +#define of_genpd_xlate_onecell         NULL
> +#endif /* CONFIG_PM_GENERIC_DOMAINS_OF */
> +
>  #endif /* _LINUX_PM_DOMAIN_H */
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 2fac9cc..45aa98e 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -306,6 +306,10 @@ config PM_GENERIC_DOMAINS_RUNTIME
>         def_bool y
>         depends on PM_RUNTIME && PM_GENERIC_DOMAINS
> 
> +config PM_GENERIC_DOMAINS_OF
> +       def_bool y
> +       depends on PM_GENERIC_DOMAINS && OF && !ARCH_EXYNOS
> +
>  config CPU_PM
>         bool
>         depends on SUSPEND || CPU_IDLE
> --
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

