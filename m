Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823AbaGYVmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:42:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59497 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761152AbaGYVmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:42:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53B59221.5080100@samsung.com>
Cc: wsa@the-dreams.de, broonie@kernel.org,
        linux-arm-kernel@lists.infradead.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, gregkh@linuxfoundation.org,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org
References: <1403105372-30403-1-git-send-email-s.nawrocki@samsung.com>
 <1403105372-30403-2-git-send-email-s.nawrocki@samsung.com>
 <53B59221.5080100@samsung.com>
Message-ID: <20140725214231.5177.86866@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH/RFC V8 1/1] clk: Support for clock parents and rates assigned
 from device tree
Date: Fri, 25 Jul 2014 14:42:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sylwester Nawrocki (2014-07-03 10:25:53)
> On 18/06/14 17:29, Sylwester Nawrocki wrote:
> > This patch adds helper functions to configure clock parents and rates
> > as specified through 'assigned-clock-parents', 'assigned-clock-rates'
> > DT properties for a clock provider or clock consumer device.
> > The helpers are now being called by the bus code for the platform, I2C
> > and SPI busses, before the driver probing and also in the clock core
> > after registration of a clock provider.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Could someone please take a look and review that patch ?
> Any further suggestions, ACKs/NAKs ?

Patch looks good to me. I'm happy to take it.

> 
> I would appreciate a DT, SPI or the I2C maintainer opinions.

Yes, Acks from SPI and I2C maintainers would be good. I might need to
drop those parts of this patch if they don't come through :-(

Regards,
Mike

> 
> Thanks,
> Sylwester
> > ---
> > Changes since v6:
> >  - use a set of separate DT properties to specify the default parent
> >    clocks and rates;
> >  - the clock defaults setting extended to the I2C and SPI busses.
> > 
> > Changes since v5:
> >  - updated the DT binding description (dropped 'assigned-clocks' node);
> >  - fixed detecting of null phandles (ENOENT error handling);
> >  - modified of_clk_init() to account for that the clocks property may now
> >    contain a clock specifier with a phandle that points to our node;
> > 
> > Changes since v4:
> >  - added note explaining how to skip setting parent and rate
> >    of a clock,
> >  - moved of_clk_dev_init() calls to the platform bus,
> >  - added missing call to of_node_put(),
> >  - dropped debug traces.
> > 
> > Changes since v3:
> >  - added detailed description of the assigned-clocks subnode,
> >  - added missing 'static inline' to the function stub definition,
> >  - clk-conf.c is now excluded when CONFIG_OF is not set,
> >  - s/of_clk_device_setup/of_clk_device_init.
> > 
> > Changes since v2:
> >  - edited in clock-bindings.txt, added note about 'assigned-clocks'
> >    subnode which may be used to specify "global" clocks configuration
> >    at a clock provider node,
> >  - moved of_clk_device_setup() function declaration from clk-provider.h
> >    to clk-conf.h so required function stubs are available when
> >    CONFIG_COMMON_CLK is not enabled,
> > 
> > Changes since v1:
> >  - the helper function to parse and set assigned clock parents and
> >    rates made public so it is available to clock providers to call
> >    directly;
> >  - dropped the platform bus notification and call of_clk_device_setup()
> >    is is now called from the driver core, rather than from the
> >    notification callback;
> >  - s/of_clk_get_list_entry/of_clk_get_by_property.
> > ---
> >  .../devicetree/bindings/clock/clock-bindings.txt   |   36 +++++
> >  drivers/base/platform.c                            |    5 +
> >  drivers/clk/Makefile                               |    3 +
> >  drivers/clk/clk-conf.c                             |  143 ++++++++++++++++++++
> >  drivers/clk/clk.c                                  |   12 +-
> >  drivers/i2c/i2c-core.c                             |    5 +
> >  drivers/spi/spi.c                                  |    5 +
> >  include/linux/clk/clk-conf.h                       |   20 +++
> >  8 files changed, 227 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/clk/clk-conf.c
> >  create mode 100644 include/linux/clk/clk-conf.h
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> > index f1578781..06fc6d5 100644
> > --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> > @@ -131,3 +131,39 @@ clock signal, and a UART.
> >    ("pll" and "pll-switched").
> >  * The UART has its baud clock connected the external oscillator and its
> >    register clock connected to the PLL clock (the "pll-switched" signal)
> > +
> > +==Assigned clock parents and rates==
> > +
> > +Some platforms may require initial configuration of default parent clocks
> > +and clock frequencies. Such a configuration can be specified in a device tree
> > +node through assigned-clocks, assigned-clock-parents and assigned-clock-rates
> > +properties. The assigned-clock-parents property should contain a list of parent
> > +clocks in form of phandle and clock specifier pairs, the assigned-clock-parents
> > +property the list of assigned clock frequency values - corresponding to clocks
> > +listed in the assigned-clocks property.
> > +
> > +To skip setting parent or rate of a clock its corresponding entry should be
> > +set to 0, or can be omitted if it is not followed by any non-zero entry.
> > +
> > +    uart@a000 {
> > +        compatible = "fsl,imx-uart";
> > +        reg = <0xa000 0x1000>;
> > +        ...
> > +        clocks = <&osc 0>, <&pll 1>;
> > +        clock-names = "baud", "register";
> > +
> > +        assigned-clocks = <&clkcon 0>, <&pll 2>;
> > +        assigned-clock-parents = <&pll 2>;
> > +        assigned-clock-rates = <0>, <460800>;
> > +    };
> > +
> > +In this example the <&pll 2> clock is set as parent of clock <&clkcon 0> and
> > +the <&pll 2> clock is assigned a frequency value of 460800 Hz.
> > +
> > +Configuring a clock's parent and rate through the device node that consumes
> > +the clock can be done only for clocks that have a single user. Specifying
> > +conflicting parent or rate configuration in multiple consumer nodes for
> > +a shared clock is forbidden.
> > +
> > +Configuration of common clocks, which affect multiple consumer devices can
> > +be similarly specified in the clock provider node.
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 5b47210..f622733 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/idr.h>
> >  #include <linux/acpi.h>
> > +#include <linux/clk/clk-conf.h>
> > 
> >  #include "base.h"
> >  #include "power/power.h"
> > @@ -486,6 +487,10 @@ static int platform_drv_probe(struct device *_dev)
> >       struct platform_device *dev = to_platform_device(_dev);
> >       int ret;
> > 
> > +     ret = of_clk_set_defaults(_dev->of_node, false);
> > +     if (ret < 0)
> > +             return ret;
> > +
> >       acpi_dev_pm_attach(_dev, true);
> > 
> >       ret = drv->probe(dev);
> > diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> > index b25a1fe..7fe358c 100644
> > --- a/drivers/clk/Makefile
> > +++ b/drivers/clk/Makefile
> > @@ -8,6 +8,9 @@ obj-$(CONFIG_COMMON_CLK)      += clk-fixed-rate.o
> >  obj-$(CONFIG_COMMON_CLK)     += clk-gate.o
> >  obj-$(CONFIG_COMMON_CLK)     += clk-mux.o
> >  obj-$(CONFIG_COMMON_CLK)     += clk-composite.o
> > +ifeq ($(CONFIG_OF), y)
> > +obj-$(CONFIG_COMMON_CLK)     += clk-conf.o
> > +endif
> > 
> >  # hardware specific clock types
> >  # please keep this section sorted lexicographically by file/directory path name
> > diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
> > new file mode 100644
> > index 0000000..1f73019
> > --- /dev/null
> > +++ b/drivers/clk/clk-conf.c
> > @@ -0,0 +1,143 @@
> > +/*
> > + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
> > + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/clk-provider.h>
> > +#include <linux/clk/clk-conf.h>
> > +#include <linux/device.h>
> > +#include <linux/of.h>
> > +#include <linux/printk.h>
> > +#include "clk.h"
> > +
> > +static int __set_clk_parents(struct device_node *node, bool clk_supplier)
> > +{
> > +     struct of_phandle_args clkspec;
> > +     int index, rc, num_parents;
> > +     struct clk *clk, *pclk;
> > +
> > +     num_parents = of_count_phandle_with_args(node, "assigned-clock-parents",
> > +                                              "#clock-cells");
> > +     if (num_parents == -EINVAL)
> > +             pr_err("clk: invalid value of clock-parents property at %s\n",
> > +                    node->full_name);
> > +
> > +     for (index = 0; index < num_parents; index++) {
> > +             rc = of_parse_phandle_with_args(node, "assigned-clock-parents",
> > +                                     "#clock-cells", index, &clkspec);
> > +             if (rc < 0) {
> > +                     /* skip empty (null) phandles */
> > +                     if (rc == -ENOENT)
> > +                             continue;
> > +                     else
> > +                             return rc;
> > +             }
> > +             if (clkspec.np == node && !clk_supplier)
> > +                     return 0;
> > +             pclk = of_clk_get_by_clkspec(&clkspec);
> > +             if (IS_ERR(pclk)) {
> > +                     pr_warn("clk: couldn't get parent clock %d for %s\n",
> > +                             index, node->full_name);
> > +                     return PTR_ERR(pclk);
> > +             }
> > +
> > +             rc = of_parse_phandle_with_args(node, "assigned-clocks",
> > +                                     "#clock-cells", index, &clkspec);
> > +             if (rc < 0)
> > +                     goto err;
> > +             if (clkspec.np == node && !clk_supplier) {
> > +                     rc = 0;
> > +                     goto err;
> > +             }
> > +             clk = of_clk_get_by_clkspec(&clkspec);
> > +             if (IS_ERR(pclk)) {
> > +                     pr_warn("clk: couldn't get parent clock %d for %s\n",
> > +                             index, node->full_name);
> > +                     rc = PTR_ERR(pclk);
> > +                     goto err;
> > +             }
> > +
> > +             rc = clk_set_parent(clk, pclk);
> > +             if (rc < 0)
> > +                     pr_err("clk: failed to reparent %s to %s: %d\n",
> > +                            __clk_get_name(clk), __clk_get_name(pclk), rc);
> > +             clk_put(clk);
> > +             clk_put(pclk);
> > +     }
> > +     return 0;
> > +err:
> > +     clk_put(pclk);
> > +     return rc;
> > +}
> > +
> > +static int __set_clk_rates(struct device_node *node, bool clk_supplier)
> > +{
> > +     struct of_phandle_args clkspec;
> > +     struct property *prop;
> > +     const __be32 *cur;
> > +     int rc, index = 0;
> > +     struct clk *clk;
> > +     u32 rate;
> > +
> > +     of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
> > +             if (rate) {
> > +                     rc = of_parse_phandle_with_args(node, "assigned-clocks",
> > +                                     "#clock-cells", index, &clkspec);
> > +                     if (rc < 0) {
> > +                             /* skip empty (null) phandles */
> > +                             if (rc == -ENOENT)
> > +                                     continue;
> > +                             else
> > +                                     return rc;
> > +                     }
> > +                     if (clkspec.np == node && !clk_supplier)
> > +                             return 0;
> > +
> > +                     clk = of_clk_get_by_clkspec(&clkspec);
> > +                     if (IS_ERR(clk)) {
> > +                             pr_warn("clk: couldn't get clock %d for %s\n",
> > +                                     index, node->full_name);
> > +                             return PTR_ERR(clk);
> > +                     }
> > +
> > +                     rc = clk_set_rate(clk, rate);
> > +                     if (rc < 0)
> > +                             pr_err("clk: couldn't set %s clock rate: %d\n",
> > +                                    __clk_get_name(clk), rc);
> > +                     clk_put(clk);
> > +             }
> > +             index++;
> > +     }
> > +     return 0;
> > +}
> > +
> > +/**
> > + * of_clk_set_defaults() - parse and set assigned clocks configuration
> > + * @node: device node to apply clock settings for
> > + * @clk_supplier: true if clocks supplied by @node should also be considered
> > + *
> > + * This function parses 'assigned-{clocks/clock-parents/clock-rates}' properties
> > + * and sets any specified clock parents and rates. The @clk_supplier argument
> > + * should be set to true if @node may be also a clock supplier of any clock
> > + * listed in its 'assigned-clocks' or 'assigned-clock-parents' properties.
> > + * If @clk_supplier is false the function exits returnning 0 as soon as it
> > + * determines the @node is also a supplier of any of the clocks.
> > + */
> > +int of_clk_set_defaults(struct device_node *node, bool clk_supplier)
> > +{
> > +     int rc;
> > +
> > +     if (!node)
> > +             return 0;
> > +
> > +     rc = __set_clk_parents(node, clk_supplier);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     return __set_clk_rates(node, clk_supplier);
> > +}
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index 8b73ede..a77af45 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -10,6 +10,7 @@
> >   */
> > 
> >  #include <linux/clk-private.h>
> > +#include <linux/clk/clk-conf.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> >  #include <linux/spinlock.h>
> > @@ -2414,6 +2415,7 @@ int of_clk_add_provider(struct device_node *np,
> >                       void *data)
> >  {
> >       struct of_clk_provider *cp;
> > +     int ret;
> > 
> >       cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
> >       if (!cp)
> > @@ -2428,7 +2430,11 @@ int of_clk_add_provider(struct device_node *np,
> >       mutex_unlock(&of_clk_mutex);
> >       pr_debug("Added clock from %s\n", np->full_name);
> > 
> > -     return 0;
> > +     ret = of_clk_set_defaults(np, true);
> > +     if (ret < 0)
> > +             of_clk_del_provider(np);
> > +
> > +     return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(of_clk_add_provider);
> > 
> > @@ -2605,7 +2611,10 @@ void __init of_clk_init(const struct of_device_id *matches)
> >               list_for_each_entry_safe(clk_provider, next,
> >                                       &clk_provider_list, node) {
> >                       if (force || parent_ready(clk_provider->np)) {
> > +
> >                               clk_provider->clk_init_cb(clk_provider->np);
> > +                             of_clk_set_defaults(clk_provider->np, true);
> > +
> >                               list_del(&clk_provider->node);
> >                               kfree(clk_provider);
> >                               is_init_done = true;
> > @@ -2620,7 +2629,6 @@ void __init of_clk_init(const struct of_device_id *matches)
> >                */
> >               if (!is_init_done)
> >                       force = true;
> > -
> >       }
> >  }
> >  #endif
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index 7c7f4b8..66aa83b 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_irq.h>
> > +#include <linux/clk/clk-conf.h>
> >  #include <linux/completion.h>
> >  #include <linux/hardirq.h>
> >  #include <linux/irqflags.h>
> > @@ -274,6 +275,10 @@ static int i2c_device_probe(struct device *dev)
> >                                       client->flags & I2C_CLIENT_WAKE);
> >       dev_dbg(dev, "probe\n");
> > 
> > +     status = of_clk_set_defaults(dev->of_node, false);
> > +     if (status < 0)
> > +             return status;
> > +
> >       acpi_dev_pm_attach(&client->dev, true);
> >       status = driver->probe(client, i2c_match_id(driver->id_table, client));
> >       if (status)
> > diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> > index 939edf4..8374620 100644
> > --- a/drivers/spi/spi.c
> > +++ b/drivers/spi/spi.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_irq.h>
> > +#include <linux/clk/clk-conf.h>
> >  #include <linux/slab.h>
> >  #include <linux/mod_devicetable.h>
> >  #include <linux/spi/spi.h>
> > @@ -259,6 +260,10 @@ static int spi_drv_probe(struct device *dev)
> >       const struct spi_driver         *sdrv = to_spi_driver(dev->driver);
> >       int ret;
> > 
> > +     ret = of_clk_set_defaults(dev->of_node, false);
> > +     if (ret)
> > +             return ret;
> > +
> >       acpi_dev_pm_attach(dev, true);
> >       ret = sdrv->probe(to_spi_device(dev));
> >       if (ret)
> > diff --git a/include/linux/clk/clk-conf.h b/include/linux/clk/clk-conf.h
> > new file mode 100644
> > index 0000000..f3050e1
> > --- /dev/null
> > +++ b/include/linux/clk/clk-conf.h
> > @@ -0,0 +1,20 @@
> > +/*
> > + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
> > + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +struct device_node;
> > +
> > +#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
> > +int of_clk_set_defaults(struct device_node *node, bool clk_supplier);
> > +#else
> > +static inline int of_clk_set_defaults(struct device_node *node,
> > +                                   bool clk_supplier)
> > +{
> > +     return 0;
> > +}
> > +#endif
> > --
> > 1.7.9.5
