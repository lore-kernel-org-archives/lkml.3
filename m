Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaEVQur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:50:47 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53094 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaEVQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:50:44 -0400
Date: Thu, 22 May 2014 17:50:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
Message-ID: <20140522165036.GK19747@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This platform driver adds initial support for the SDHCI host controller
> found on STMicroelectronics SoCs.
> 
> It has been tested on STiH41x b2020 platforms currently.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  drivers/mmc/host/Kconfig    |  12 +++
>  drivers/mmc/host/Makefile   |   1 +
>  drivers/mmc/host/sdhci-st.c | 244 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+)
>  create mode 100644 drivers/mmc/host/sdhci-st.c

[...]

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

Move this down as far as it will go.  When do you _need_ the clock
running by?

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

If it's possible to move the clk_prepare enable down past here, then
you only need to do sdhci_pltfm_free() and you can remove all of the
err_out error path.

> +	}
> +
> +	pltfm_host->priv = pdata;
> +
> +	platform_set_drvdata(pdev, host);
> +
> +	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));

Do we want to be doing any error checking for unsupported devices
here?

[...]

> +static struct platform_driver sdhci_st_driver = {
> +	.probe = sdhci_st_probe,
> +	.remove = sdhci_st_remove,
> +	.driver = {
> +		   .name = "sdhci-st",
> +		   .owner = THIS_MODULE,
> +		   .pm = SDHCI_ST_PMOPS,
> +		   .of_match_table = of_match_ptr(st_sdhci_match),
> +		  },

Tabbing issue here.

> +};
> +
> +module_platform_driver(sdhci_st_driver);
> +
> +MODULE_DESCRIPTION("SDHCI driver for STMicroelectronics SoCs");
> +MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:st-sdhci");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
