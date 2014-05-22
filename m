Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaEVPmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:42:24 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47016 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbaEVPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:42:21 -0400
Message-ID: <537E1AB8.9000909@st.com>
Date: Thu, 22 May 2014 17:41:44 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <chris@printf.net>, <ulf.hansson@linaro.org>
Cc: <kernel@stlinux.com>, <lee.jones@linaro.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org> <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-22_03:2014-05-22,2014-05-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

On 05/22/2014 05:18 PM, Peter Griffin wrote:
> This platform driver adds initial support for the SDHCI host controller
> found on STMicroelectronics SoCs.
>
> It has been tested on STiH41x b2020 platforms currently.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>   drivers/mmc/host/Kconfig    |  12 +++
>   drivers/mmc/host/Makefile   |   1 +
>   drivers/mmc/host/sdhci-st.c | 244 ++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 257 insertions(+)
>   create mode 100644 drivers/mmc/host/sdhci-st.c
>

[...]

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
> +#include <linux/mmc/host.h>
> +#include <linux/reset.h>
> +
> +#include "sdhci-pltfm.h"
> +
> +struct st_mmc_platform_data {
> +	struct  reset_control	*rstc;
> +};
Since it uses the generic reset framework, could we imagine moving the 
reset to the sdhci_pltfm_host struct?
Doing this, we could get rid of st_mmc_platform_data.


> +
> +static int sdhci_st_8bit_width(struct sdhci_host *host, int width)
> +{
> +	u8 ctrl;
> +
> +	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
> +
> +	switch (width) {
> +	case MMC_BUS_WIDTH_8:
> +		ctrl |= SDHCI_CTRL_8BITBUS;
> +		ctrl &= ~SDHCI_CTRL_4BITBUS;
> +		break;
> +	case MMC_BUS_WIDTH_4:
> +		ctrl |= SDHCI_CTRL_4BITBUS;
> +		ctrl &= ~SDHCI_CTRL_8BITBUS;
> +		break;
> +	default:
> +		ctrl &= ~(SDHCI_CTRL_8BITBUS | SDHCI_CTRL_4BITBUS);
> +		break;
You can remove the break here.

> +	}
> +
> +	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
> +
> +	return 0;
> +}
> +
> +static unsigned int sdhci_st_get_max_clk(struct sdhci_host *host)
> +{
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +
> +	return clk_get_rate(pltfm_host->clk);
> +}
> +
> +static u32 sdhci_st_readl(struct sdhci_host *host, int reg)
> +{
> +	u32 ret;
> +
> +	switch (reg) {
> +	case SDHCI_CAPABILITIES:
> +		ret = readl(host->ioaddr + reg);
> +		/* Support 3.3V and 1.8V */
> +		ret &= ~SDHCI_CAN_VDD_300;
> +		break;
> +	default:
> +		ret = readl(host->ioaddr + reg);

Could we use readl_relaxed?

> +	}
> +	return ret;
> +}
> +
> +static const struct sdhci_ops sdhci_st_ops = {
> +	.get_max_clock = sdhci_st_get_max_clk,
> +	.platform_bus_width = sdhci_st_8bit_width,
> +	.read_l = sdhci_st_readl,
> +};
> +
> +static const struct sdhci_pltfm_data sdhci_st_pdata = {
> +	.ops = &sdhci_st_ops,
> +	.quirks = SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
> +	    SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
> +};
> +
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
You can remove this I think.

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
> +
> +	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
> +
> +	dev_dbg(&pdev->dev, "SDHCI ST Initialised: Host Version: 0x%x Vendor Version 0x%x\n",
> +		host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
> +			       SDHCI_VENDOR_VER_SHIFT));
Maybe you could change to dev_info here. It might be interresting to 
always have IP version.

> +
> +	return 0;
> +
> +err_out:
> +	clk_disable_unprepare(clk);
> +	sdhci_pltfm_free(pdev);
> +
> +	return ret;
> +}

[...]

Regards,
Maxime
