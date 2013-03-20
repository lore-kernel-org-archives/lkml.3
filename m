Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3CTSJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:09:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53973 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3CTSJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:09:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Turquette <mturquette@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/2] ACPI / scan: Add special handler for Intel Lynxpoint LPSS devices
Date: Wed, 20 Mar 2013 19:17:01 +0100
Message-ID: <2494755.7YKH5fdcWQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130320165401.18043.17922@quantum>
References: <1878438.IOSu0hheXQ@vostro.rjw.lan> <1490138.pE1ld6sXHn@vostro.rjw.lan> <20130320165401.18043.17922@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 20, 2013 09:54:01 AM Mike Turquette wrote:
> Quoting Rafael J. Wysocki (2013-03-02 14:27:52)
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Devices on the Intel Lynxpoint Low Power Subsystem (LPSS) have some
> > common features that aren't shared with any other platform devices,
> > including the clock and LTR (Latency Tolerance Reporting) registers.
> > It is better to handle those features in common code than to bother
> > device drivers with doing that (I/O functionality-wise the LPSS
> > devices are generally compatible with other devices that don't
> > have those special registers and may be handled by the same drivers).
> > 
> > The clock registers of the LPSS devices are now taken care of by
> > the special clk-x86-lpss driver, but the MMIO mappings used for
> > accessing those registers can also be used for accessing the LTR
> > registers on those devices (LTR support for the Lynxpoint LPSS is
> > going to be added by a subsequent patch).  Thus it is convenient
> > to add a special ACPI scan handler for the Lynxpoint LPSS devices
> > that will create the MMIO mappings for accessing the clock (and
> > LTR in the future) registers and will register the LPSS devices'
> > clocks, so the clk-x86-lpss driver will only need to take care of
> > the main Lynxpoint LPSS clock.
> > 
> > Introduce a special ACPI scan handler for Intel Lynxpoint LPSS
> > devices as described above.  This also reduces overhead related to
> > browsing the ACPI namespace in search of the LPSS devices before the
> > registration of their clocks, removes some LPSS-specific (and
> > somewhat ugly) code from acpi_platform.c and shrinks the overall code
> > size slightly.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Better late than never.  For the clk changes:
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

Thanks Mike!

> > ---
> >  drivers/acpi/Makefile                  |    1 
> >  drivers/acpi/acpi_lpss.c               |  163 +++++++++++++++++++++++++++++++++
> >  drivers/acpi/acpi_platform.c           |   40 --------
> >  drivers/acpi/internal.h                |    8 +
> >  drivers/acpi/scan.c                    |    1 
> >  drivers/clk/x86/Makefile               |    2 
> >  drivers/clk/x86/clk-lpss.c             |   99 --------------------
> >  drivers/clk/x86/clk-lpss.h             |   36 -------
> >  drivers/clk/x86/clk-lpt.c              |   40 --------
> >  include/linux/platform_data/clk-lpss.h |   18 +++
> >  10 files changed, 195 insertions(+), 213 deletions(-)
> >  create mode 100644 drivers/acpi/acpi_lpss.c
> >  delete mode 100644 drivers/clk/x86/clk-lpss.c
> >  delete mode 100644 drivers/clk/x86/clk-lpss.h
> >  create mode 100644 include/linux/platform_data/clk-lpss.h
> > 
> > Index: linux-pm/drivers/acpi/Makefile
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/Makefile
> > +++ linux-pm/drivers/acpi/Makefile
> > @@ -39,6 +39,7 @@ acpi-y                                += ec.o
> >  acpi-$(CONFIG_ACPI_DOCK)       += dock.o
> >  acpi-y                         += pci_root.o pci_link.o pci_irq.o
> >  acpi-y                         += csrt.o
> > +acpi-$(CONFIG_X86_INTEL_LPSS)  += acpi_lpss.o
> >  acpi-y                         += acpi_platform.o
> >  acpi-y                         += power.o
> >  acpi-y                         += event.o
> > Index: linux-pm/drivers/acpi/acpi_lpss.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-pm/drivers/acpi/acpi_lpss.c
> > @@ -0,0 +1,163 @@
> > +/*
> > + * ACPI support for Intel Lynxpoint LPSS.
> > + *
> > + * Copyright (C) 2013, Intel Corporation
> > + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> > + *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/clk.h>
> > +#include <linux/clkdev.h>
> > +#include <linux/clk-provider.h>
> > +#include <linux/err.h>
> > +#include <linux/io.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/platform_data/clk-lpss.h>
> > +
> > +#include "internal.h"
> > +
> > +ACPI_MODULE_NAME("acpi_lpss");
> > +
> > +#define LPSS_CLK_OFFSET 0x800
> > +#define LPSS_CLK_SIZE  0x04
> > +
> > +struct lpss_device_desc {
> > +       bool clk_required;
> > +       const char *clk_parent;
> > +};
> > +
> > +struct lpss_private_data {
> > +       void __iomem *mmio_base;
> > +       resource_size_t mmio_size;
> > +       struct clk *clk;
> > +       const struct lpss_device_desc *dev_desc;
> > +};
> > +
> > +static struct lpss_device_desc lpt_dev_desc = {
> > +       .clk_required = true,
> > +       .clk_parent = "lpss_clk",
> > +};
> > +
> > +static const struct acpi_device_id acpi_lpss_device_ids[] = {
> > +       /* Lynxpoint LPSS devices */
> > +       { "INT33C0", (unsigned long)&lpt_dev_desc },
> > +       { "INT33C1", (unsigned long)&lpt_dev_desc },
> > +       { "INT33C2", (unsigned long)&lpt_dev_desc },
> > +       { "INT33C3", (unsigned long)&lpt_dev_desc },
> > +       { "INT33C4", (unsigned long)&lpt_dev_desc },
> > +       { "INT33C5", (unsigned long)&lpt_dev_desc },
> > +       { "INT33C6", },
> > +       { "INT33C7", },
> > +
> > +       { }
> > +};
> > +
> > +static int is_memory(struct acpi_resource *res, void *not_used)
> > +{
> > +       struct resource r;
> > +       return !acpi_dev_resource_memory(res, &r);
> > +}
> > +
> > +/* LPSS main clock device. */
> > +static struct platform_device *lpss_clk_dev;
> > +
> > +static inline void lpt_register_clock_device(void)
> > +{
> > +       lpss_clk_dev = platform_device_register_simple("clk-lpt", -1, NULL, 0);
> > +}
> > +
> > +static int register_device_clock(struct acpi_device *adev,
> > +                                struct lpss_private_data *pdata)
> > +{
> > +       const struct lpss_device_desc *dev_desc = pdata->dev_desc;
> > +
> > +       if (!lpss_clk_dev)
> > +               lpt_register_clock_device();
> > +
> > +       if (!dev_desc->clk_parent || !pdata->mmio_base
> > +           || pdata->mmio_size < LPSS_CLK_OFFSET + LPSS_CLK_SIZE)
> > +               return -ENODATA;
> > +
> > +       pdata->clk = clk_register_gate(NULL, dev_name(&adev->dev),
> > +                                      dev_desc->clk_parent, 0,
> > +                                      pdata->mmio_base + LPSS_CLK_OFFSET,
> > +                                      0, 0, NULL);
> > +       if (IS_ERR(pdata->clk))
> > +               return PTR_ERR(pdata->clk);
> > +
> > +       clk_register_clkdev(pdata->clk, NULL, dev_name(&adev->dev));
> > +       return 0;
> > +}
> > +
> > +static int acpi_lpss_create_device(struct acpi_device *adev,
> > +                                  const struct acpi_device_id *id)
> > +{
> > +       struct lpss_device_desc *dev_desc;
> > +       struct lpss_private_data *pdata;
> > +       struct resource_list_entry *rentry;
> > +       struct list_head resource_list;
> > +       int ret;
> > +
> > +       dev_desc = (struct lpss_device_desc *)id->driver_data;
> > +       if (!dev_desc)
> > +               return acpi_create_platform_device(adev, id);
> > +
> > +       pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> > +       if (!pdata)
> > +               return -ENOMEM;
> > +
> > +       INIT_LIST_HEAD(&resource_list);
> > +       ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
> > +       if (ret < 0)
> > +               goto err_out;
> > +
> > +       list_for_each_entry(rentry, &resource_list, node)
> > +               if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> > +                       pdata->mmio_size = resource_size(&rentry->res);
> > +                       pdata->mmio_base = ioremap(rentry->res.start,
> > +                                                  pdata->mmio_size);
> > +                       pdata->dev_desc = dev_desc;
> > +                       break;
> > +               }
> > +
> > +       acpi_dev_free_resource_list(&resource_list);
> > +
> > +       if (dev_desc->clk_required) {
> > +               ret = register_device_clock(adev, pdata);
> > +               if (ret) {
> > +                       /*
> > +                        * Skip the device, but don't terminate the namespace
> > +                        * scan.
> > +                        */
> > +                       ret = 0;
> > +                       goto err_out;
> > +               }
> > +       }
> > +
> > +       adev->driver_data = pdata;
> > +       ret = acpi_create_platform_device(adev, id);
> > +       if (ret > 0)
> > +               return ret;
> > +
> > +       adev->driver_data = NULL;
> > +
> > + err_out:
> > +       kfree(pdata);
> > +       return ret;
> > +}
> > +
> > +static struct acpi_scan_handler lpss_handler = {
> > +       .ids = acpi_lpss_device_ids,
> > +       .attach = acpi_lpss_create_device,
> > +};
> > +
> > +void __init acpi_lpss_init(void)
> > +{
> > +       if (!lpt_clk_init())
> > +               acpi_scan_add_handler(&lpss_handler);
> > +}
> > Index: linux-pm/drivers/acpi/acpi_platform.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/acpi_platform.c
> > +++ linux-pm/drivers/acpi/acpi_platform.c
> > @@ -22,9 +22,6 @@
> >  
> >  ACPI_MODULE_NAME("platform");
> >  
> > -/* Flags for acpi_create_platform_device */
> > -#define ACPI_PLATFORM_CLK      BIT(0)
> > -
> >  /*
> >   * The following ACPI IDs are known to be suitable for representing as
> >   * platform devices.
> > @@ -33,33 +30,9 @@ static const struct acpi_device_id acpi_
> >  
> >         { "PNP0D40" },
> >  
> > -       /* Haswell LPSS devices */
> > -       { "INT33C0", ACPI_PLATFORM_CLK },
> > -       { "INT33C1", ACPI_PLATFORM_CLK },
> > -       { "INT33C2", ACPI_PLATFORM_CLK },
> > -       { "INT33C3", ACPI_PLATFORM_CLK },
> > -       { "INT33C4", ACPI_PLATFORM_CLK },
> > -       { "INT33C5", ACPI_PLATFORM_CLK },
> > -       { "INT33C6", ACPI_PLATFORM_CLK },
> > -       { "INT33C7", ACPI_PLATFORM_CLK },
> > -
> >         { }
> >  };
> >  
> > -static int acpi_create_platform_clks(struct acpi_device *adev)
> > -{
> > -       static struct platform_device *pdev;
> > -
> > -       /* Create Lynxpoint LPSS clocks */
> > -       if (!pdev && !strncmp(acpi_device_hid(adev), "INT33C", 6)) {
> > -               pdev = platform_device_register_simple("clk-lpt", -1, NULL, 0);
> > -               if (IS_ERR(pdev))
> > -                       return PTR_ERR(pdev);
> > -       }
> > -
> > -       return 0;
> > -}
> > -
> >  /**
> >   * acpi_create_platform_device - Create platform device for ACPI device node
> >   * @adev: ACPI device node to create a platform device for.
> > @@ -71,10 +44,9 @@ static int acpi_create_platform_clks(str
> >   *
> >   * Name of the platform device will be the same as @adev's.
> >   */
> > -static int acpi_create_platform_device(struct acpi_device *adev,
> > -                                      const struct acpi_device_id *id)
> > +int acpi_create_platform_device(struct acpi_device *adev,
> > +                               const struct acpi_device_id *id)
> >  {
> > -       unsigned long flags = id->driver_data;
> >         struct platform_device *pdev = NULL;
> >         struct acpi_device *acpi_parent;
> >         struct platform_device_info pdevinfo;
> > @@ -83,14 +55,6 @@ static int acpi_create_platform_device(s
> >         struct resource *resources;
> >         int count;
> >  
> > -       if (flags & ACPI_PLATFORM_CLK) {
> > -               int ret = acpi_create_platform_clks(adev);
> > -               if (ret) {
> > -                       dev_err(&adev->dev, "failed to create clocks\n");
> > -                       return ret;
> > -               }
> > -       }
> > -
> >         /* If the ACPI node already has a physical device attached, skip it. */
> >         if (adev->physical_node_count)
> >                 return 0;
> > Index: linux-pm/drivers/acpi/internal.h
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/internal.h
> > +++ linux-pm/drivers/acpi/internal.h
> > @@ -48,6 +48,11 @@ int acpi_debugfs_init(void);
> >  #else
> >  static inline void acpi_debugfs_init(void) { return; }
> >  #endif
> > +#ifdef CONFIG_X86_INTEL_LPSS
> > +void acpi_lpss_init(void);
> > +#else
> > +static inline void acpi_lpss_init(void) {}
> > +#endif
> >  
> >  /* --------------------------------------------------------------------------
> >                       Device Node Initialization / Removal
> > @@ -131,4 +136,7 @@ static inline void suspend_nvs_restore(v
> >    -------------------------------------------------------------------------- */
> >  struct platform_device;
> >  
> > +int acpi_create_platform_device(struct acpi_device *adev,
> > +                               const struct acpi_device_id *id);
> > +
> >  #endif /* _ACPI_INTERNAL_H_ */
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -1788,6 +1788,7 @@ int __init acpi_scan_init(void)
> >         acpi_pci_root_init();
> >         acpi_pci_link_init();
> >         acpi_platform_init();
> > +       acpi_lpss_init();
> >         acpi_csrt_init();
> >         acpi_container_init();
> >         acpi_pci_slot_init();
> > Index: linux-pm/drivers/clk/x86/Makefile
> > ===================================================================
> > --- linux-pm.orig/drivers/clk/x86/Makefile
> > +++ linux-pm/drivers/clk/x86/Makefile
> > @@ -1,2 +1,2 @@
> > -clk-x86-lpss-objs              := clk-lpss.o clk-lpt.o
> > +clk-x86-lpss-objs              := clk-lpt.o
> >  obj-$(CONFIG_X86_INTEL_LPSS)   += clk-x86-lpss.o
> > Index: linux-pm/drivers/clk/x86/clk-lpss.c
> > ===================================================================
> > --- linux-pm.orig/drivers/clk/x86/clk-lpss.c
> > +++ /dev/null
> > @@ -1,99 +0,0 @@
> > -/*
> > - * Intel Low Power Subsystem clocks.
> > - *
> > - * Copyright (C) 2013, Intel Corporation
> > - * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> > - *         Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > - *
> > - * This program is free software; you can redistribute it and/or modify
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> > - */
> > -
> > -#include <linux/acpi.h>
> > -#include <linux/clk.h>
> > -#include <linux/clk-provider.h>
> > -#include <linux/err.h>
> > -#include <linux/io.h>
> > -#include <linux/module.h>
> > -
> > -static int clk_lpss_is_mmio_resource(struct acpi_resource *res, void *data)
> > -{
> > -       struct resource r;
> > -       return !acpi_dev_resource_memory(res, &r);
> > -}
> > -
> > -static acpi_status clk_lpss_find_mmio(acpi_handle handle, u32 level,
> > -                                     void *data, void **retval)
> > -{
> > -       struct resource_list_entry *rentry;
> > -       struct list_head resource_list;
> > -       struct acpi_device *adev;
> > -       const char *uid = data;
> > -       int ret;
> > -
> > -       if (acpi_bus_get_device(handle, &adev))
> > -               return AE_OK;
> > -
> > -       if (uid) {
> > -               if (!adev->pnp.unique_id)
> > -                       return AE_OK;
> > -               if (strcmp(uid, adev->pnp.unique_id))
> > -                       return AE_OK;
> > -       }
> > -
> > -       INIT_LIST_HEAD(&resource_list);
> > -       ret = acpi_dev_get_resources(adev, &resource_list,
> > -                                    clk_lpss_is_mmio_resource, NULL);
> > -       if (ret < 0)
> > -               return AE_NO_MEMORY;
> > -
> > -       list_for_each_entry(rentry, &resource_list, node)
> > -               if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> > -                       *(struct resource *)retval = rentry->res;
> > -                       break;
> > -               }
> > -
> > -       acpi_dev_free_resource_list(&resource_list);
> > -       return AE_OK;
> > -}
> > -
> > -/**
> > - * clk_register_lpss_gate - register LPSS clock gate
> > - * @name: name of this clock gate
> > - * @parent_name: parent clock name
> > - * @hid: ACPI _HID of the device
> > - * @uid: ACPI _UID of the device (optional)
> > - * @offset: LPSS PRV_CLOCK_PARAMS offset
> > - *
> > - * Creates and registers LPSS clock gate.
> > - */
> > -struct clk *clk_register_lpss_gate(const char *name, const char *parent_name,
> > -                                  const char *hid, const char *uid,
> > -                                  unsigned offset)
> > -{
> > -       struct resource res = { };
> > -       void __iomem *mmio_base;
> > -       acpi_status status;
> > -       struct clk *clk;
> > -
> > -       /*
> > -        * First try to look the device and its mmio resource from the
> > -        * ACPI namespace.
> > -        */
> > -       status = acpi_get_devices(hid, clk_lpss_find_mmio, (void *)uid,
> > -                                 (void **)&res);
> > -       if (ACPI_FAILURE(status) || !res.start)
> > -               return ERR_PTR(-ENODEV);
> > -
> > -       mmio_base = ioremap(res.start, resource_size(&res));
> > -       if (!mmio_base)
> > -               return ERR_PTR(-ENOMEM);
> > -
> > -       clk = clk_register_gate(NULL, name, parent_name, 0, mmio_base + offset,
> > -                               0, 0, NULL);
> > -       if (IS_ERR(clk))
> > -               iounmap(mmio_base);
> > -
> > -       return clk;
> > -}
> > Index: linux-pm/drivers/clk/x86/clk-lpss.h
> > ===================================================================
> > --- linux-pm.orig/drivers/clk/x86/clk-lpss.h
> > +++ /dev/null
> > @@ -1,36 +0,0 @@
> > -/*
> > - * Intel Low Power Subsystem clock.
> > - *
> > - * Copyright (C) 2013, Intel Corporation
> > - * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> > - *         Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > - *
> > - * This program is free software; you can redistribute it and/or modify
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> > - */
> > -
> > -#ifndef __CLK_LPSS_H
> > -#define __CLK_LPSS_H
> > -
> > -#include <linux/err.h>
> > -#include <linux/errno.h>
> > -#include <linux/clk.h>
> > -
> > -#ifdef CONFIG_ACPI
> > -extern struct clk *clk_register_lpss_gate(const char *name,
> > -                                         const char *parent_name,
> > -                                         const char *hid, const char *uid,
> > -                                         unsigned offset);
> > -#else
> > -static inline struct clk *clk_register_lpss_gate(const char *name,
> > -                                                const char *parent_name,
> > -                                                const char *hid,
> > -                                                const char *uid,
> > -                                                unsigned offset)
> > -{
> > -       return ERR_PTR(-ENODEV);
> > -}
> > -#endif
> > -
> > -#endif /* __CLK_LPSS_H */
> > Index: linux-pm/drivers/clk/x86/clk-lpt.c
> > ===================================================================
> > --- linux-pm.orig/drivers/clk/x86/clk-lpt.c
> > +++ linux-pm/drivers/clk/x86/clk-lpt.c
> > @@ -10,7 +10,6 @@
> >   * published by the Free Software Foundation.
> >   */
> >  
> > -#include <linux/acpi.h>
> >  #include <linux/clk.h>
> >  #include <linux/clkdev.h>
> >  #include <linux/clk-provider.h>
> > @@ -18,8 +17,6 @@
> >  #include <linux/module.h>
> >  #include <linux/platform_device.h>
> >  
> > -#include "clk-lpss.h"
> > -
> >  #define PRV_CLOCK_PARAMS 0x800
> >  
> >  static int lpt_clk_probe(struct platform_device *pdev)
> > @@ -34,40 +31,6 @@ static int lpt_clk_probe(struct platform
> >  
> >         /* Shared DMA clock */
> >         clk_register_clkdev(clk, "hclk", "INTL9C60.0.auto");
> > -
> > -       /* SPI clocks */
> > -       clk = clk_register_lpss_gate("spi0_clk", "lpss_clk", "INT33C0", NULL,
> > -                                    PRV_CLOCK_PARAMS);
> > -       if (!IS_ERR(clk))
> > -               clk_register_clkdev(clk, NULL, "INT33C0:00");
> > -
> > -       clk = clk_register_lpss_gate("spi1_clk", "lpss_clk", "INT33C1", NULL,
> > -                                    PRV_CLOCK_PARAMS);
> > -       if (!IS_ERR(clk))
> > -               clk_register_clkdev(clk, NULL, "INT33C1:00");
> > -
> > -       /* I2C clocks */
> > -       clk = clk_register_lpss_gate("i2c0_clk", "lpss_clk", "INT33C2", NULL,
> > -                                    PRV_CLOCK_PARAMS);
> > -       if (!IS_ERR(clk))
> > -               clk_register_clkdev(clk, NULL, "INT33C2:00");
> > -
> > -       clk = clk_register_lpss_gate("i2c1_clk", "lpss_clk", "INT33C3", NULL,
> > -                                    PRV_CLOCK_PARAMS);
> > -       if (!IS_ERR(clk))
> > -               clk_register_clkdev(clk, NULL, "INT33C3:00");
> > -
> > -       /* UART clocks */
> > -       clk = clk_register_lpss_gate("uart0_clk", "lpss_clk", "INT33C4", NULL,
> > -                                    PRV_CLOCK_PARAMS);
> > -       if (!IS_ERR(clk))
> > -               clk_register_clkdev(clk, NULL, "INT33C4:00");
> > -
> > -       clk = clk_register_lpss_gate("uart1_clk", "lpss_clk", "INT33C5", NULL,
> > -                                    PRV_CLOCK_PARAMS);
> > -       if (!IS_ERR(clk))
> > -               clk_register_clkdev(clk, NULL, "INT33C5:00");
> > -
> >         return 0;
> >  }
> >  
> > @@ -79,8 +42,7 @@ static struct platform_driver lpt_clk_dr
> >         .probe = lpt_clk_probe,
> >  };
> >  
> > -static int __init lpt_clk_init(void)
> > +int __init lpt_clk_init(void)
> >  {
> >         return platform_driver_register(&lpt_clk_driver);
> >  }
> > -arch_initcall(lpt_clk_init);
> > Index: linux-pm/include/linux/platform_data/clk-lpss.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-pm/include/linux/platform_data/clk-lpss.h
> > @@ -0,0 +1,18 @@
> > +/*
> > + * Intel Low Power Subsystem clocks.
> > + *
> > + * Copyright (C) 2013, Intel Corporation
> > + * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> > + *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef __CLK_LPSS_H
> > +#define __CLK_LPSS_H
> > +
> > +extern int lpt_clk_init(void);
> > +
> > +#endif /* __CLK_LPSS_H */
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
