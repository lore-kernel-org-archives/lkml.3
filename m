Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaGJHMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:12:35 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:50215 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaGJHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <1404918461-25390-2-git-send-email-peter.griffin@linaro.org>
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org>
	<1404918461-25390-2-git-send-email-peter.griffin@linaro.org>
Date: Thu, 10 Jul 2014 09:12:32 +0200
Message-ID: <CAPDyKFqxEGjgiu-4qB76Bg4Jhv4WEPXSXkbCHVuQ1sS8zw_pmw@mail.gmail.com>
Subject: Re: [PATCH v4 01/10] mmc: sdhci-st: Intial support for ST SDHCI controller
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 17:07, Peter Griffin <peter.griffin@linaro.org> wrote:
> This platform driver adds initial support for the SDHCI host controller
> found on STMicroelectronics SoCs.
>
> It has been tested on STiH41x b2020 platforms currently.
>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks! Applied for next!

Kind regards
Uffe

> ---
>  drivers/mmc/host/Kconfig    |  12 +++
>  drivers/mmc/host/Makefile   |   1 +
>  drivers/mmc/host/sdhci-st.c | 176 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 189 insertions(+)
>  create mode 100644 drivers/mmc/host/sdhci-st.c
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index a565254..6615b79 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -290,6 +290,18 @@ config MMC_MOXART
>           be found on some embedded hardware such as UC-7112-LX.
>           If you have a controller with this interface, say Y here.
>
> +config MMC_SDHCI_ST
> +       tristate "SDHCI support on STMicroelectronics SoC"
> +       depends on ARCH_STI
> +       depends on MMC_SDHCI_PLTFM
> +       select MMC_SDHCI_IO_ACCESSORS
> +       help
> +         This selects the Secure Digital Host Controller Interface in
> +         STMicroelectronics SoCs.
> +
> +         If you have a controller with this interface, say Y or M here.
> +         If unsure, say N.
> +
>  config MMC_OMAP
>         tristate "TI OMAP Multimedia Card Interface support"
>         depends on ARCH_OMAP
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index 7f81ddf..f211eed 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -68,6 +68,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_HLWD)               += sdhci-of-hlwd.o
>  obj-$(CONFIG_MMC_SDHCI_BCM_KONA)       += sdhci-bcm-kona.o
>  obj-$(CONFIG_MMC_SDHCI_BCM2835)                += sdhci-bcm2835.o
>  obj-$(CONFIG_MMC_SDHCI_MSM)            += sdhci-msm.o
> +obj-$(CONFIG_MMC_SDHCI_ST)             += sdhci-st.o
>
>  ifeq ($(CONFIG_CB710_DEBUG),y)
>         CFLAGS-cb710-mmc        += -DDEBUG
> diff --git a/drivers/mmc/host/sdhci-st.c b/drivers/mmc/host/sdhci-st.c
> new file mode 100644
> index 0000000..328f348
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-st.c
> @@ -0,0 +1,176 @@
> +/*
> + * Support for SDHCI on STMicroelectronics SoCs
> + *
> + * Copyright (C) 2014 STMicroelectronics Ltd
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + * Contributors: Peter Griffin <peter.griffin@linaro.org>
> + *
> + * Based on sdhci-cns3xxx.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/mmc/host.h>
> +
> +#include "sdhci-pltfm.h"
> +
> +static u32 sdhci_st_readl(struct sdhci_host *host, int reg)
> +{
> +       u32 ret;
> +
> +       switch (reg) {
> +       case SDHCI_CAPABILITIES:
> +               ret = readl_relaxed(host->ioaddr + reg);
> +               /* Support 3.3V and 1.8V */
> +               ret &= ~SDHCI_CAN_VDD_300;
> +               break;
> +       default:
> +               ret = readl_relaxed(host->ioaddr + reg);
> +       }
> +       return ret;
> +}
> +
> +static const struct sdhci_ops sdhci_st_ops = {
> +       .get_max_clock = sdhci_pltfm_clk_get_max_clock,
> +       .set_clock = sdhci_set_clock,
> +       .set_bus_width = sdhci_set_bus_width,
> +       .read_l = sdhci_st_readl,
> +       .reset = sdhci_reset,
> +};
> +
> +static const struct sdhci_pltfm_data sdhci_st_pdata = {
> +       .ops = &sdhci_st_ops,
> +       .quirks = SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
> +           SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
> +};
> +
> +
> +static int sdhci_st_probe(struct platform_device *pdev)
> +{
> +       struct sdhci_host *host;
> +       struct sdhci_pltfm_host *pltfm_host;
> +       struct clk *clk;
> +       int ret = 0;
> +       u16 host_version;
> +
> +       clk =  devm_clk_get(&pdev->dev, "mmc");
> +       if (IS_ERR(clk)) {
> +               dev_err(&pdev->dev, "Peripheral clk not found\n");
> +               return PTR_ERR(clk);
> +       }
> +
> +       host = sdhci_pltfm_init(pdev, &sdhci_st_pdata, 0);
> +       if (IS_ERR(host)) {
> +               dev_err(&pdev->dev, "Failed sdhci_pltfm_init\n");
> +               return PTR_ERR(host);
> +       }
> +
> +       ret = mmc_of_parse(host->mmc);
> +
> +       if (ret) {
> +               dev_err(&pdev->dev, "Failed mmc_of_parse\n");
> +               return ret;
> +       }
> +
> +       clk_prepare_enable(clk);
> +
> +       pltfm_host = sdhci_priv(host);
> +       pltfm_host->clk = clk;
> +
> +       ret = sdhci_add_host(host);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Failed sdhci_add_host\n");
> +               goto err_out;
> +       }
> +
> +       platform_set_drvdata(pdev, host);
> +
> +       host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
> +
> +       dev_info(&pdev->dev, "SDHCI ST Initialised: Host Version: 0x%x Vendor Version 0x%x\n",
> +               ((host_version & SDHCI_SPEC_VER_MASK) >> SDHCI_SPEC_VER_SHIFT),
> +               ((host_version & SDHCI_VENDOR_VER_MASK) >>
> +               SDHCI_VENDOR_VER_SHIFT));
> +
> +       return 0;
> +
> +err_out:
> +       clk_disable_unprepare(clk);
> +       sdhci_pltfm_free(pdev);
> +
> +       return ret;
> +}
> +
> +static int sdhci_st_remove(struct platform_device *pdev)
> +{
> +       struct sdhci_host *host = platform_get_drvdata(pdev);
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +
> +       clk_disable_unprepare(pltfm_host->clk);
> +
> +       return sdhci_pltfm_unregister(pdev);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int sdhci_st_suspend(struct device *dev)
> +{
> +       struct sdhci_host *host = dev_get_drvdata(dev);
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       int ret = sdhci_suspend_host(host);
> +
> +       if (ret)
> +               goto out;
> +
> +       clk_disable_unprepare(pltfm_host->clk);
> +out:
> +       return ret;
> +}
> +
> +static int sdhci_st_resume(struct device *dev)
> +{
> +       struct sdhci_host *host = dev_get_drvdata(dev);
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +
> +       clk_prepare_enable(pltfm_host->clk);
> +
> +       return sdhci_resume_host(host);
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);
> +
> +static const struct of_device_id st_sdhci_match[] = {
> +       { .compatible = "st,sdhci" },
> +       {},
> +};
> +
> +MODULE_DEVICE_TABLE(of, st_sdhci_match);
> +
> +static struct platform_driver sdhci_st_driver = {
> +       .probe = sdhci_st_probe,
> +       .remove = sdhci_st_remove,
> +       .driver = {
> +                  .name = "sdhci-st",
> +                  .pm = &sdhci_st_pmops,
> +                  .of_match_table = of_match_ptr(st_sdhci_match),
> +                 },
> +};
> +
> +module_platform_driver(sdhci_st_driver);
> +
> +MODULE_DESCRIPTION("SDHCI driver for STMicroelectronics SoCs");
> +MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:st-sdhci");
> --
> 1.9.1
>
