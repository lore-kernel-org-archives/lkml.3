Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaEWGS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:18:59 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43598 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaEWGS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:18:57 -0400
Message-ID: <537EE84C.2020607@linaro.org>
Date: Fri, 23 May 2014 07:18:52 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org
CC: devicetree@vger.kernel.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, lee.jones@linaro.org
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org> <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On 22/05/14 16:18, Peter Griffin wrote:

>
>   ifeq ($(CONFIG_CB710_DEBUG),y)
>   	CFLAGS-cb710-mmc	+= -DDEBUG
> diff --git a/drivers/mmc/host/sdhci-st.c b/drivers/mmc/host/sdhci-st.c
> new file mode 100644
> index 0000000..1790fa7
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-st.c
> @@ -0,0 +1,244 @@
> +/*
> + * Support for SDHCI on STMicroelectronics SoCs
> + *
> + * Copyright (C) 2014 STMicroelectronics Ltd
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
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
> +#include <linux/of_gpio.h>
Do you need this header?

> +#include <linux/mmc/host.h>
> +#include <linux/reset.h>
> +
> +#include "sdhci-pltfm.h"
> +
> +struct st_mmc_platform_data {
> +	struct  reset_control	*rstc;
> +};

st_mmc_platform_data name is bit missleading as this data is not part of 
platform data. Probably you could rename it to struct sdhci_st_data.
...
> +
> +static int sdhci_st_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct sdhci_host *host;
> +	struct st_mmc_platform_data *pdata;
> +	struct sdhci_pltfm_host *pltfm_host;
> +	struct clk *clk;
> +	int ret = 0;
> +	u16 host_version;
> +
> +	dev_dbg(&pdev->dev, "SDHCI ST platform driver\n");
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	pdata->rstc = devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(pdata->rstc))
> +		pdata->rstc = NULL;
> +	else
> +		reset_control_deassert(pdata->rstc);
> +
> +	clk =  devm_clk_get(&pdev->dev, "mmc");
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "Perpheral clk not found\n");
> +		return PTR_ERR(clk);
> +	}
> +
> +	host = sdhci_pltfm_init(pdev, &sdhci_st_pdata, 0);
> +	if (IS_ERR(host)) {
> +		dev_err(&pdev->dev, "Failed sdhci_pltfm_init\n");
> +		return PTR_ERR(host);
> +	}
> +
> +	clk_prepare_enable(clk);
> +
> +	host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_BUS_WIDTH_TEST
> +			| MMC_CAP_1_8V_DDR;
> +
> +	if (of_property_read_bool(np, "non-removable"))
> +		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
> +
> +	pltfm_host = sdhci_priv(host);
> +	pltfm_host->clk = clk;
> +
> +	ret = sdhci_add_host(host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed sdhci_add_host\n");
> +		goto err_out;
> +	}
> +
> +	pltfm_host->priv = pdata;
> +
> +	platform_set_drvdata(pdev, host);

Why not platform_set_drvdata(pdev, priv_host);
As you are not using sdhci_host directly, this will reduced few 
indirections in the driver.


> +
> +	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
> +
> +	dev_dbg(&pdev->dev, "SDHCI ST Initialised: Host Version: 0x%x Vendor Version 0x%x\n",
> +		host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
> +			       SDHCI_VENDOR_VER_SHIFT));
> +
> +	return 0;
> +
> +err_out:
> +	clk_disable_unprepare(clk);
> +	sdhci_pltfm_free(pdev);
> +
IP could be left out of reset in this path.
> +	return ret;
> +}
> +
> +static int sdhci_st_remove(struct platform_device *pdev)
> +{
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +	int ret;
> +
> +	clk_disable_unprepare(pltfm_host->clk);
> +
> +	ret = sdhci_pltfm_unregister(pdev);
> +
> +	if (pdata->rstc)
> +		reset_control_assert(pdata->rstc);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int sdhci_st_suspend(struct device *dev)
> +{
> +	struct sdhci_host *host = dev_get_drvdata(dev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +	int ret = sdhci_suspend_host(host);
> +
> +	if (ret)
> +		goto out;
> +
> +	if (pdata->rstc)
> +		reset_control_assert(pdata->rstc);
> +
> +	clk_disable_unprepare(pltfm_host->clk);
> +out:
> +	return ret;
> +}
> +
> +static int sdhci_st_resume(struct device *dev)
> +{
> +	struct sdhci_host *host = dev_get_drvdata(dev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +
> +	clk_prepare_enable(pltfm_host->clk);
> +
> +	if (pdata->rstc)
> +		reset_control_deassert(pdata->rstc);
> +
> +	return sdhci_resume_host(host);
> +}
> +

replace:
[...
> +static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);
> +#define SDHCI_ST_PMOPS (&sdhci_st_pmops)
> +#else
> +#define SDHCI_ST_PMOPS NULL
> +#endif
...]

with :

#endif

static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);

	
> +
> +static const struct of_device_id st_sdhci_match[] = {
> +	{ .compatible = "st,sdhci" },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, st_sdhci_match);
> +
> +static struct platform_driver sdhci_st_driver = {
> +	.probe = sdhci_st_probe,
> +	.remove = sdhci_st_remove,
> +	.driver = {
> +		   .name = "sdhci-st",
> +		   .owner = THIS_MODULE,
> +		   .pm = SDHCI_ST_PMOPS,
use .pm = sdhci_st_pmops,

> +		   .of_match_table = of_match_ptr(st_sdhci_match),
> +		  },
> +};
> +
> +module_platform_driver(sdhci_st_driver);
> +
> +MODULE_DESCRIPTION("SDHCI driver for STMicroelectronics SoCs");
> +MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:st-sdhci");
>
