Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3CVMr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:47:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44304 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3CVMrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <1363776767-2635-2-git-send-email-p.zabel@pengutronix.de>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
	<1363776767-2635-2-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 22 Mar 2013 13:47:20 +0100
Message-ID: <CAHTX3dK_DD1WLEJzgtZbcuYE2roMrLDUeBCx_sWomC_dYVX9bQ@mail.gmail.com>
Subject: Re: [PATCH v9 RESEND 1/4] genalloc: add devres support, allow to find
 a managed pool by device
From: Michal Simek <monstr@monstr.eu>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Matt Porter <mporter@ti.com>, Dong Aisheng <dong.aisheng@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        Huang Shijie <shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013/3/20 Philipp Zabel <p.zabel@pengutronix.de>:
> This patch adds three exported functions to lib/genalloc.c:
> devm_gen_pool_create, dev_get_gen_pool, and of_get_named_gen_pool.
>
> devm_gen_pool_create is a managed version of gen_pool_create that keeps
> track of the pool via devres and allows the management code to automatically
> destroy it after device removal.
>
> dev_get_gen_pool retrieves the gen_pool for a given device, if it was
> created with devm_gen_pool_create, using devres_find.
>
> of_get_named_gen_pool retrieves the gen_pool for a given device node and
> property name, where the property must contain a phandle pointing to a
> platform device node. The corresponding platform device is then fed into
> dev_get_gen_pool and the resulting gen_pool is returned.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  include/linux/genalloc.h |   15 +++++++++
>  lib/genalloc.c           |   81 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+)
>
> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
> index dd7c569..383e8f4 100644
> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -105,4 +105,19 @@ extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
>  extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
>                 unsigned long start, unsigned int nr, void *data);
>
> +extern struct gen_pool *devm_gen_pool_create(struct device *dev,
> +               int min_alloc_order, int nid);
> +extern struct gen_pool *dev_get_gen_pool(struct device *dev);
> +
> +struct device_node;
> +#ifdef CONFIG_OF
> +extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
> +       const char *propname, int index);
> +#else
> +inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
> +       const char *propname, int index)
> +{
> +       return NULL;
> +}
> +#endif
>  #endif /* __GENALLOC_H__ */
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 5492043..b35cfa9 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -34,6 +34,8 @@
>  #include <linux/rculist.h>
>  #include <linux/interrupt.h>
>  #include <linux/genalloc.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
>
>  static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
>  {
> @@ -480,3 +482,82 @@ unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
>         return start_bit;
>  }
>  EXPORT_SYMBOL(gen_pool_best_fit);
> +
> +static void devm_gen_pool_release(struct device *dev, void *res)
> +{
> +       gen_pool_destroy(*(struct gen_pool **)res);
> +}
> +
> +/**
> + * devm_gen_pool_create - managed gen_pool_create
> + * @dev: device that provides the gen_pool
> + * @min_alloc_order: log base 2 of number of bytes each bitmap bit represents
> + * @nid: node id of the node the pool structure should be allocated on, or -1
> + *
> + * Create a new special memory pool that can be used to manage special purpose
> + * memory not managed by the regular kmalloc/kfree interface. The pool will be
> + * automatically destroyed by the device management code.
> + */
> +struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
> +               int nid)
> +{
> +       struct gen_pool **ptr, *pool;
> +
> +       ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
> +
> +       pool = gen_pool_create(min_alloc_order, nid);
> +       if (pool) {
> +               *ptr = pool;
> +               devres_add(dev, ptr);
> +       } else {
> +               devres_free(ptr);
> +       }
> +
> +       return pool;
> +}
> +
> +/**
> + * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
> + * @dev: device to retrieve the gen_pool from
> + * @name: Optional name for the gen_pool, usually NULL
> + *
> + * Returns the gen_pool for the device if one is present, or NULL.
> + */
> +struct gen_pool *dev_get_gen_pool(struct device *dev)
> +{
> +       struct gen_pool **p = devres_find(dev, devm_gen_pool_release, NULL,
> +                                       NULL);
> +
> +       if (!p)
> +               return NULL;
> +       return *p;
> +}
> +EXPORT_SYMBOL_GPL(dev_get_gen_pool);
> +
> +#ifdef CONFIG_OF
> +/**
> + * of_get_named_gen_pool - find a pool by phandle property
> + * @np: device node
> + * @propname: property name containing phandle(s)
> + * @index: index into the phandle array
> + *
> + * Returns the pool that contains the chunk starting at the physical
> + * address of the device tree node pointed at by the phandle property,
> + * or NULL if not found.
> + */
> +struct gen_pool *of_get_named_gen_pool(struct device_node *np,
> +       const char *propname, int index)
> +{
> +       struct platform_device *pdev;
> +       struct device_node *np_pool;
> +
> +       np_pool = of_parse_phandle(np, propname, index);
> +       if (!np_pool)
> +               return NULL;
> +       pdev = of_find_device_by_node(np_pool);
> +       if (!pdev)
> +               return NULL;
> +       return dev_get_gen_pool(&pdev->dev);
> +}
> +EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
> +#endif /* CONFIG_OF */
> --
> 1.7.10.4

Tested on xilinx-zynq with OCM.

Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
