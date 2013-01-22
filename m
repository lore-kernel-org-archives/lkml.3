Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3AVSsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:48:03 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64808 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3AVSr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:47:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1358516761-20981-3-git-send-email-mika.westerberg@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
References: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358516761-20981-3-git-send-email-mika.westerberg@linux.intel.com>
Message-ID: <20130122184754.24671.16583@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v2 2/3] clk: x86: add support for Lynxpoint LPSS clocks
Date: Tue, 22 Jan 2013 10:47:54 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mika Westerberg (2013-01-18 05:46:00)
> Intel Lynxpoint Low Power Subsystem hosts peripherals like UART, I2C and
> SPI controllers. For most of these there is a configuration register that
> allows software to enable and disable the functional clock. Disabling the
> clock while the peripheral is not used saves power.
> 
> In order to take advantage of this we add a new clock gate of type
> lpss_gate that just re-uses the ordinary clk_gate but in addition is able
> to enumerate the base address register of the device using ACPI.
> 
> We then create a clock tree that models the Lynxpoint LPSS clocks using
> these gates and fixed clocks so that we can pass clock rate to the drivers
> as well.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Nice to see another architecture using this framework.

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/clk/Makefile       |    1 +
>  drivers/clk/x86/Makefile   |    2 +
>  drivers/clk/x86/clk-lpss.c |   99 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/x86/clk-lpss.h |   36 ++++++++++++++++
>  drivers/clk/x86/clk-lpt.c  |   86 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 224 insertions(+)
>  create mode 100644 drivers/clk/x86/Makefile
>  create mode 100644 drivers/clk/x86/clk-lpss.c
>  create mode 100644 drivers/clk/x86/clk-lpss.h
>  create mode 100644 drivers/clk/x86/clk-lpt.c
> 
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index ee90e87..ee11460 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_ARCH_U8500)      += ux500/
>  obj-$(CONFIG_ARCH_VT8500)      += clk-vt8500.o
>  obj-$(CONFIG_ARCH_SUNXI)       += clk-sunxi.o
>  obj-$(CONFIG_ARCH_ZYNQ)                += clk-zynq.o
> +obj-$(CONFIG_X86)              += x86/
>  
>  # Chip specific
>  obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
> diff --git a/drivers/clk/x86/Makefile b/drivers/clk/x86/Makefile
> new file mode 100644
> index 0000000..f9ba4fa
> --- /dev/null
> +++ b/drivers/clk/x86/Makefile
> @@ -0,0 +1,2 @@
> +clk-x86-lpss-objs              := clk-lpss.o clk-lpt.o
> +obj-$(CONFIG_X86_INTEL_LPSS)   += clk-x86-lpss.o
> diff --git a/drivers/clk/x86/clk-lpss.c b/drivers/clk/x86/clk-lpss.c
> new file mode 100644
> index 0000000..b5e229f
> --- /dev/null
> +++ b/drivers/clk/x86/clk-lpss.c
> @@ -0,0 +1,99 @@
> +/*
> + * Intel Low Power Subsystem clocks.
> + *
> + * Copyright (C) 2013, Intel Corporation
> + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *         Heikki Krogerus <heikki.krogerus@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +
> +static int clk_lpss_is_mmio_resource(struct acpi_resource *res, void *data)
> +{
> +       struct resource r;
> +       return !acpi_dev_resource_memory(res, &r);
> +}
> +
> +static acpi_status clk_lpss_find_mmio(acpi_handle handle, u32 level,
> +                                     void *data, void **retval)
> +{
> +       struct resource_list_entry *rentry;
> +       struct list_head resource_list;
> +       struct acpi_device *adev;
> +       const char *uid = data;
> +       int ret;
> +
> +       if (acpi_bus_get_device(handle, &adev))
> +               return AE_OK;
> +
> +       if (uid) {
> +               if (!adev->pnp.unique_id)
> +                       return AE_OK;
> +               if (strcmp(uid, adev->pnp.unique_id))
> +                       return AE_OK;
> +       }
> +
> +       INIT_LIST_HEAD(&resource_list);
> +       ret = acpi_dev_get_resources(adev, &resource_list,
> +                                    clk_lpss_is_mmio_resource, NULL);
> +       if (ret < 0)
> +               return AE_NO_MEMORY;
> +
> +       list_for_each_entry(rentry, &resource_list, node)
> +               if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> +                       *(struct resource *)retval = rentry->res;
> +                       break;
> +               }
> +
> +       acpi_dev_free_resource_list(&resource_list);
> +       return AE_OK;
> +}
> +
> +/**
> + * clk_register_lpss_gate - register LPSS clock gate
> + * @name: name of this clock gate
> + * @parent_name: parent clock name
> + * @hid: ACPI _HID of the device
> + * @uid: ACPI _UID of the device (optional)
> + * @offset: LPSS PRV_CLOCK_PARAMS offset
> + *
> + * Creates and registers LPSS clock gate.
> + */
> +struct clk *clk_register_lpss_gate(const char *name, const char *parent_name,
> +                                  const char *hid, const char *uid,
> +                                  unsigned offset)
> +{
> +       struct resource res = { };
> +       void __iomem *mmio_base;
> +       acpi_status status;
> +       struct clk *clk;
> +
> +       /*
> +        * First try to look the device and its mmio resource from the
> +        * ACPI namespace.
> +        */
> +       status = acpi_get_devices(hid, clk_lpss_find_mmio, (void *)uid,
> +                                 (void **)&res);
> +       if (ACPI_FAILURE(status) || !res.start)
> +               return ERR_PTR(-ENODEV);
> +
> +       mmio_base = ioremap(res.start, resource_size(&res));
> +       if (!mmio_base)
> +               return ERR_PTR(-ENOMEM);
> +
> +       clk = clk_register_gate(NULL, name, parent_name, 0, mmio_base + offset,
> +                               0, 0, NULL);
> +       if (IS_ERR(clk))
> +               iounmap(mmio_base);
> +
> +       return clk;
> +}
> diff --git a/drivers/clk/x86/clk-lpss.h b/drivers/clk/x86/clk-lpss.h
> new file mode 100644
> index 0000000..e9460f4
> --- /dev/null
> +++ b/drivers/clk/x86/clk-lpss.h
> @@ -0,0 +1,36 @@
> +/*
> + * Intel Low Power Subsystem clock.
> + *
> + * Copyright (C) 2013, Intel Corporation
> + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *         Heikki Krogerus <heikki.krogerus@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __CLK_LPSS_H
> +#define __CLK_LPSS_H
> +
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/clk.h>
> +
> +#ifdef CONFIG_ACPI
> +extern struct clk *clk_register_lpss_gate(const char *name,
> +                                         const char *parent_name,
> +                                         const char *hid, const char *uid,
> +                                         unsigned offset);
> +#else
> +static inline struct clk *clk_register_lpss_gate(const char *name,
> +                                                const char *parent_name,
> +                                                const char *hid,
> +                                                const char *uid,
> +                                                unsigned offset)
> +{
> +       return ERR_PTR(-ENODEV);
> +}
> +#endif
> +
> +#endif /* __CLK_LPSS_H */
> diff --git a/drivers/clk/x86/clk-lpt.c b/drivers/clk/x86/clk-lpt.c
> new file mode 100644
> index 0000000..81298ae
> --- /dev/null
> +++ b/drivers/clk/x86/clk-lpt.c
> @@ -0,0 +1,86 @@
> +/*
> + * Intel Lynxpoint LPSS clocks.
> + *
> + * Copyright (C) 2013, Intel Corporation
> + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *         Heikki Krogerus <heikki.krogerus@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/clk.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#include "clk-lpss.h"
> +
> +#define PRV_CLOCK_PARAMS 0x800
> +
> +static int lpt_clk_probe(struct platform_device *pdev)
> +{
> +       struct clk *clk;
> +
> +       /* LPSS free running clock */
> +       clk = clk_register_fixed_rate(&pdev->dev, "lpss_clk", NULL, CLK_IS_ROOT,
> +                                     100000000);
> +       if (IS_ERR(clk))
> +               return PTR_ERR(clk);
> +
> +       /* Shared DMA clock */
> +       clk_register_clkdev(clk, "hclk", "INTL9C60.0.auto");
> +
> +       /* SPI clocks */
> +       clk = clk_register_lpss_gate("spi0_clk", "lpss_clk", "INT33C0", NULL,
> +                                    PRV_CLOCK_PARAMS);
> +       if (!IS_ERR(clk))
> +               clk_register_clkdev(clk, NULL, "INT33C0:00");
> +
> +       clk = clk_register_lpss_gate("spi1_clk", "lpss_clk", "INT33C1", NULL,
> +                                    PRV_CLOCK_PARAMS);
> +       if (!IS_ERR(clk))
> +               clk_register_clkdev(clk, NULL, "INT33C1:00");
> +
> +       /* I2C clocks */
> +       clk = clk_register_lpss_gate("i2c0_clk", "lpss_clk", "INT33C2", NULL,
> +                                    PRV_CLOCK_PARAMS);
> +       if (!IS_ERR(clk))
> +               clk_register_clkdev(clk, NULL, "INT33C2:00");
> +
> +       clk = clk_register_lpss_gate("i2c1_clk", "lpss_clk", "INT33C3", NULL,
> +                                    PRV_CLOCK_PARAMS);
> +       if (!IS_ERR(clk))
> +               clk_register_clkdev(clk, NULL, "INT33C3:00");
> +
> +       /* UART clocks */
> +       clk = clk_register_lpss_gate("uart0_clk", "lpss_clk", "INT33C4", NULL,
> +                                    PRV_CLOCK_PARAMS);
> +       if (!IS_ERR(clk))
> +               clk_register_clkdev(clk, NULL, "INT33C4:00");
> +
> +       clk = clk_register_lpss_gate("uart1_clk", "lpss_clk", "INT33C5", NULL,
> +                                    PRV_CLOCK_PARAMS);
> +       if (!IS_ERR(clk))
> +               clk_register_clkdev(clk, NULL, "INT33C5:00");
> +
> +       return 0;
> +}
> +
> +static struct platform_driver lpt_clk_driver = {
> +       .driver = {
> +               .name = "clk-lpt",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = lpt_clk_probe,
> +};
> +
> +static int __init lpt_clk_init(void)
> +{
> +       return platform_driver_register(&lpt_clk_driver);
> +}
> +arch_initcall(lpt_clk_init);
> -- 
> 1.7.10.4
