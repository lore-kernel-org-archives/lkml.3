Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaAQRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:09:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:55572 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQRJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:09:06 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 1/2][v3] driver/memory:Move Freescale IFC driver to a common driver
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1389850929-19873-1-git-send-email-prabhakar@freescale.com>
Date: Fri, 17 Jan 2014 11:08:44 -0600
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Scott Wood <scottwood@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E7780BC2-F914-4D0C-8AB9-9FE7437A5C48@kernel.crashing.org>
References: <1389850929-19873-1-git-send-email-prabhakar@freescale.com>
To: Prabhakar Kushwaha <prabhakar@freescale.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 15, 2014, at 11:42 PM, Prabhakar Kushwaha <prabhakar@freescale.com> wrote:

> Freescale IFC controller has been used for mpc8xxx. It will be used
> for ARM-based SoC as well. This patch moves the driver to driver/memory
> and fix the header file includes.
> 
> Also remove module_platform_driver() and  instead call
> platform_driver_register() from subsys_initcall() to make sure this module
> has been loaded before MTD partition parsing starts.
> 
> Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes for v2:
> 	- Move fsl_ifc in driver/memory
> 
> Changes for v3:
> 	- move device tree bindings to memory
> 
> .../{powerpc => memory-controllers}/fsl/ifc.txt    |    0
> arch/powerpc/sysdev/Makefile                       |    1 -
> drivers/memory/Makefile                            |    1 +
> {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c  |    8 ++++++--
> drivers/mtd/nand/fsl_ifc_nand.c                    |    2 +-
> .../include/asm => include/linux}/fsl_ifc.h        |    0
> 6 files changed, 8 insertions(+), 4 deletions(-)
> rename Documentation/devicetree/bindings/{powerpc => memory-controllers}/fsl/ifc.txt (100%)
> rename {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c (98%)
> rename {arch/powerpc/include/asm => include/linux}/fsl_ifc.h (100%)

The Kconfig option for FSL_IFC should move into drivers/memory/Kconfig

> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/ifc.txt b/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/powerpc/fsl/ifc.txt
> rename to Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
> diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
> index f67ac90..afbcc37 100644
> --- a/arch/powerpc/sysdev/Makefile
> +++ b/arch/powerpc/sysdev/Makefile
> @@ -21,7 +21,6 @@ obj-$(CONFIG_FSL_SOC)		+= fsl_soc.o fsl_mpic_err.o
> obj-$(CONFIG_FSL_PCI)		+= fsl_pci.o $(fsl-msi-obj-y)
> obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
> obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
> -obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
> obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
> obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
> obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
> index 969d923..f2bf25c 100644
> --- a/drivers/memory/Makefile
> +++ b/drivers/memory/Makefile
> @@ -6,6 +6,7 @@ ifeq ($(CONFIG_DDR),y)
> obj-$(CONFIG_OF)		+= of_memory.o
> endif
> obj-$(CONFIG_TI_EMIF)		+= emif.o
> +obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
> obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
> obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
> obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
> diff --git a/arch/powerpc/sysdev/fsl_ifc.c b/drivers/memory/fsl_ifc.c
> similarity index 98%
> rename from arch/powerpc/sysdev/fsl_ifc.c
> rename to drivers/memory/fsl_ifc.c
> index d7fc722..135a950 100644
> --- a/arch/powerpc/sysdev/fsl_ifc.c
> +++ b/drivers/memory/fsl_ifc.c
> @@ -30,8 +30,8 @@
> #include <linux/of.h>
> #include <linux/of_device.h>
> #include <linux/platform_device.h>
> +#include <linux/fsl_ifc.h>
> #include <asm/prom.h>
> -#include <asm/fsl_ifc.h>
> 
> struct fsl_ifc_ctrl *fsl_ifc_ctrl_dev;
> EXPORT_SYMBOL(fsl_ifc_ctrl_dev);
> @@ -299,7 +299,11 @@ static struct platform_driver fsl_ifc_ctrl_driver = {
> 	.remove      = fsl_ifc_ctrl_remove,
> };
> 
> -module_platform_driver(fsl_ifc_ctrl_driver);
> +static int __init fsl_ifc_init(void)
> +{
> +	return platform_driver_register(&fsl_ifc_ctrl_driver);
> +}
> +subsys_initcall(fsl_ifc_init);
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Freescale Semiconductor");
> diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
> index 4335577..865b323 100644
> --- a/drivers/mtd/nand/fsl_ifc_nand.c
> +++ b/drivers/mtd/nand/fsl_ifc_nand.c
> @@ -30,7 +30,7 @@
> #include <linux/mtd/nand.h>
> #include <linux/mtd/partitions.h>
> #include <linux/mtd/nand_ecc.h>
> -#include <asm/fsl_ifc.h>
> +#include <linux/fsl_ifc.h>
> 
> #define FSL_IFC_V1_1_0	0x01010000
> #define ERR_BYTE		0xFF /* Value returned for read
> diff --git a/arch/powerpc/include/asm/fsl_ifc.h b/include/linux/fsl_ifc.h
> similarity index 100%
> rename from arch/powerpc/include/asm/fsl_ifc.h
> rename to include/linux/fsl_ifc.h
> -- 
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

