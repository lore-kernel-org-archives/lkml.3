Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab3CVMrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:47:48 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55150 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CVMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <1363776767-2635-3-git-send-email-p.zabel@pengutronix.de>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
	<1363776767-2635-3-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 22 Mar 2013 13:47:44 +0100
Message-ID: <CAHTX3dK4Aerg=npRxHOS5m6JHY266KHXn58kRqvkkuSfCtP12g@mail.gmail.com>
Subject: Re: [PATCH v9 RESEND 2/4] misc: Generic on-chip SRAM allocation driver
From: Michal Simek <monstr@monstr.eu>
To: Philipp Zabel <p.zabel@pengutronix.de>
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

2013/3/20 Philipp Zabel <p.zabel@pengutronix.de>:
> This driver requests and remaps a memory region as configured in the
> device tree. It serves memory from this region via the genalloc API.
> It optionally enables the SRAM clock.
>
> Other drivers can retrieve the genalloc pool from a phandle pointing
> to this drivers' device node in the device tree.
>
> The allocation granularity is hard-coded to 32 bytes for now,
> to make the SRAM driver useful for the 6502 remoteproc driver.
> There is overhead for bigger SRAMs, where only a much coarser
> allocation granularity is needed: At 32 bytes minimum allocation
> size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> Changes since v8:
>  - Changed device tree compatible string to "mmio-sram"
> ---
>  Documentation/devicetree/bindings/misc/sram.txt |   16 +++
>  drivers/misc/Kconfig                            |    9 ++
>  drivers/misc/Makefile                           |    1 +
>  drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
>  4 files changed, 147 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/sram.txt
>  create mode 100644 drivers/misc/sram.c
>
> diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> new file mode 100644
> index 0000000..4d0a00e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/sram.txt
> @@ -0,0 +1,16 @@
> +Generic on-chip SRAM
> +
> +Simple IO memory regions to be managed by the genalloc API.
> +
> +Required properties:
> +
> +- compatible : mmio-sram
> +
> +- reg : SRAM iomem address range
> +
> +Example:
> +
> +sram: sram@5c000000 {
> +       compatible = "mmio-sram";
> +       reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
> +};
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index e83fdfe..4878507 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -510,6 +510,15 @@ config LATTICE_ECP3_CONFIG
>
>           If unsure, say N.
>
> +config SRAM
> +       bool "Generic on-chip SRAM driver"
> +       depends on HAS_IOMEM
> +       select GENERIC_ALLOCATOR
> +       help
> +         This driver allows to declare a memory region to be managed
> +         by the genalloc API. It is supposed to be used for small
> +         on-chip SRAM areas found on many SoCs.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 35a1463..08e2007 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -52,3 +52,4 @@ obj-$(CONFIG_INTEL_MEI)               += mei/
>  obj-$(CONFIG_MAX8997_MUIC)     += max8997-muic.o
>  obj-$(CONFIG_VMWARE_VMCI)      += vmw_vmci/
>  obj-$(CONFIG_LATTICE_ECP3_CONFIG)      += lattice-ecp3-config.o
> +obj-$(CONFIG_SRAM)             += sram.o
> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> new file mode 100644
> index 0000000..7858c62
> --- /dev/null
> +++ b/drivers/misc/sram.c
> @@ -0,0 +1,121 @@
> +/*
> + * Generic on-chip SRAM allocation driver
> + *
> + * Copyright (C) 2012 Philipp Zabel, Pengutronix
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> + * MA 02110-1301, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/genalloc.h>
> +
> +#define SRAM_GRANULARITY       32
> +
> +struct sram_dev {
> +       struct gen_pool *pool;
> +       struct clk *clk;
> +};
> +
> +static int sram_probe(struct platform_device *pdev)
> +{
> +       void __iomem *virt_base;
> +       struct sram_dev *sram;
> +       struct resource *res;
> +       unsigned long size;
> +       int ret;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res)
> +               return -EINVAL;
> +
> +       size = resource_size(res);
> +
> +       virt_base = devm_request_and_ioremap(&pdev->dev, res);
> +       if (!virt_base)
> +               return -EADDRNOTAVAIL;
> +
> +       sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
> +       if (!sram)
> +               return -ENOMEM;
> +
> +       sram->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(sram->clk))
> +               sram->clk = NULL;
> +       else
> +               clk_prepare_enable(sram->clk);
> +
> +       sram->pool = devm_gen_pool_create(&pdev->dev, ilog2(SRAM_GRANULARITY), -1);
> +       if (!sram->pool)
> +               return -ENOMEM;
> +
> +       ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
> +                               res->start, size, -1);
> +       if (ret < 0) {
> +               gen_pool_destroy(sram->pool);
> +               return ret;
> +       }
> +
> +       platform_set_drvdata(pdev, sram);
> +
> +       dev_dbg(&pdev->dev, "SRAM pool: %ld KiB @ 0x%p\n", size / 1024, virt_base);
> +
> +       return 0;
> +}
> +
> +static int sram_remove(struct platform_device *pdev)
> +{
> +       struct sram_dev *sram = platform_get_drvdata(pdev);
> +
> +       if (gen_pool_avail(sram->pool) < gen_pool_size(sram->pool))
> +               dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
> +
> +       gen_pool_destroy(sram->pool);
> +
> +       if (sram->clk)
> +               clk_disable_unprepare(sram->clk);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id sram_dt_ids[] = {
> +       { .compatible = "mmio-sram" },
> +       {}
> +};
> +#endif
> +
> +static struct platform_driver sram_driver = {
> +       .driver = {
> +               .name = "sram",
> +               .of_match_table = of_match_ptr(sram_dt_ids),
> +       },
> +       .probe = sram_probe,
> +       .remove = sram_remove,
> +};
> +
> +int __init sram_init(void)
> +{
> +       return platform_driver_register(&sram_driver);
> +}
> +
> +postcore_initcall(sram_init);
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
