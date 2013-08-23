Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3HWHfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:35:24 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:55580 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3HWHfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:35:21 -0400
Message-ID: <1377243247.18389.10.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH RFC v3] mmc: sdhci-msm: Add support for MSM chipsets
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Date: Fri, 23 Aug 2013 10:34:07 +0300
In-Reply-To: <1377017077-9834-1-git-send-email-gdjakov@mm-sol.com>
References: <1377017077-9834-1-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi, 

On Tue, 2013-08-20 at 19:44 +0300, Georgi Djakov wrote: 
> This platform driver adds the support of Secure Digital Host
> Controller Interface compliant controller in MSM chipsets.
> 
> CC: Asutosh Das <asutoshd@codeaurora.org>
> CC: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> CC: Sahitya Tummala <stummala@codeaurora.org>
> CC: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> Changes from v2:
> - Added DT bindings for clocks
> - Moved voltage regulators data to platform data
> - Removed unneeded includes
> - Removed obsolete and wrapper functions
> - Removed error checking where unnecessary
> - Removed redundant _clk suffix from clock names
> - Just return instead of goto where possible
> - Minor fixes
> 

Is this version intermediate step before you address
all previous comments?

<snip>

> +
> +static const struct of_device_id sdhci_msm_dt_match[] = {
> +	{.compatible = "qcom,sdhci-msm"},

Missing termination entry

> +};
> +
> +MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
> +
> +static int sdhci_msm_probe(struct platform_device *pdev)
> +{
> +	struct sdhci_host *host;
> +	struct sdhci_pltfm_host *pltfm_host;
> +	struct sdhci_msm_host *msm_host;
> +	struct resource *core_memres = NULL;
> +	int ret = 0, dead = 0;
> +	struct pinctrl	*pinctrl;
> +
> +	msm_host = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_msm_host),
> +				GFP_KERNEL);
> +	if (!msm_host)
> +		return -ENOMEM;
> +
> +	host = sdhci_pltfm_init(pdev, &msm_host->sdhci_msm_pdata, 0);
> +	if (IS_ERR(host)) {
> +		dev_err(mmc_dev(host->mmc), "sdhci_pltfm_init error\n");
> +		return PTR_ERR(host);
> +	}
> +
> +	pltfm_host = sdhci_priv(host);
> +	pltfm_host->priv = msm_host;
> +	msm_host->mmc = host->mmc;
> +	msm_host->pdev = pdev;
> +
> +	ret = mmc_of_parse(host->mmc);
> +	if (ret)

Shouldn't sdhci_pltfm_init operation be reverted?

> +		return ret;
> +
> +	/* Extract platform data */
> +	if (pdev->dev.of_node) {
> +		msm_host->pdata = sdhci_msm_populate_pdata(&pdev->dev);
> +		if (!msm_host->pdata) {
> +			dev_err(&pdev->dev, "DT parsing error\n");
> +			goto pltfm_free;
> +		}
> +	} else {
> +		dev_err(&pdev->dev, "No device tree node\n");
> +		goto pltfm_free;
> +	}
> +
> +	/* Setup pins */
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev, "pins are not configured by the driver\n");
> +
> +	/* Setup Clocks */
> +
> +	/* Setup SDCC bus voter clock. */
> +	msm_host->bus_clk = devm_clk_get(&pdev->dev, "bus");
> +	if (!IS_ERR_OR_NULL(msm_host->bus_clk)) {
> +		/* Vote for max. clk rate for max. performance */
> +		ret = clk_set_rate(msm_host->bus_clk, INT_MAX);
> +		if (ret)
> +			goto pltfm_free;
> +		ret = clk_prepare_enable(msm_host->bus_clk);
> +		if (ret)
> +			goto pltfm_free;
> +	}
> +
> +	/* Setup main peripheral bus clock */
> +	msm_host->pclk = devm_clk_get(&pdev->dev, "iface");
> +	if (!IS_ERR(msm_host->pclk)) {
> +		ret = clk_prepare_enable(msm_host->pclk);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"Main peripheral clock setup failed (%d)\n",
> +				ret);
> +			goto bus_clk_disable;
> +		}
> +	}
> +
> +	/* Setup SDC MMC clock */
> +	msm_host->clk = devm_clk_get(&pdev->dev, "core");
> +	if (IS_ERR(msm_host->clk)) {
> +		ret = PTR_ERR(msm_host->clk);
> +		dev_err(&pdev->dev, "SDC MMC clock setup failed (%d)\n", ret);
> +		goto pclk_disable;
> +	}
> +
> +	ret = clk_prepare_enable(msm_host->clk);
> +	if (ret)
> +		goto pclk_disable;
> +
> +	/* Setup regulators */
> +	ret = sdhci_msm_vreg_init(&pdev->dev, msm_host->pdata, true);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Regulator setup failed (%d)\n", ret);
> +		goto clk_disable;
> +	}
> +
> +	/* Reset the core and Enable SDHC mode */
> +	core_memres = platform_get_resource_byname(pdev,
> +						   IORESOURCE_MEM, "core_mem");
> +	msm_host->core_mem = devm_ioremap(&pdev->dev, core_memres->start,
> +					  resource_size(core_memres));
> +
> +	if (!msm_host->core_mem) {
> +		dev_err(&pdev->dev, "Failed to remap registers\n");
> +		ret = -ENOMEM;
> +		goto vreg_deinit;
> +	}
> +
> +	/* Set SW_RST bit in POWER register (Offset 0x0) */
> +	writel_relaxed(CORE_SW_RST, msm_host->core_mem + CORE_POWER);
> +	/* Set HC_MODE_EN bit in HC_MODE register */
> +	writel_relaxed(HC_MODE_EN, (msm_host->core_mem + CORE_HC_MODE));
> +
> +	/*
> +	 * Following are the deviations from SDHC spec v3.0 -
> +	 * 1. Card detection is handled using separate GPIO.
> +	 * 2. Bus power control is handled by interacting with PMIC.
> +	 */
> +	host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
> +
> +	/* Setup PWRCTL irq */
> +	msm_host->pwr_irq = platform_get_irq_byname(pdev, "pwr_irq");
> +	if (msm_host->pwr_irq < 0) {
> +		dev_err(&pdev->dev, "Failed to get pwr_irq by name (%d)\n",
> +			msm_host->pwr_irq);
> +		goto vreg_deinit;
> +	}
> +	ret = devm_request_threaded_irq(&pdev->dev, msm_host->pwr_irq, NULL,
> +					sdhci_msm_pwr_irq, IRQF_ONESHOT,
> +					dev_name(&pdev->dev), host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Request threaded irq(%d) failed (%d)\n",
> +			msm_host->pwr_irq, ret);
> +		goto vreg_deinit;
> +	}
> +
> +	/* Enable pwr irq interrupts */
> +	writel_relaxed(INT_MASK, (msm_host->core_mem + CORE_PWRCTL_MASK));
> +
> +	/* Set host capabilities */
> +	msm_host->mmc->caps |= msm_host->pdata->caps;
> +	msm_host->mmc->caps2 |= msm_host->pdata->caps2;
> +
> +	ret = sdhci_add_host(host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Add host failed (%d)\n", ret);
> +		goto vreg_deinit;
> +	}
> +
> +	/* Set core clk rate */
> +	ret = clk_set_rate(msm_host->clk, host->max_clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "MClk rate set failed (%d)\n", ret);
> +		goto remove_host;
> +	}
> +
> +	host->mmc->max_current_180 = host->mmc->max_current_300 =
> +	host->mmc->max_current_330 = sdhci_msm_get_vdd_max_current(msm_host);
> +
> +	/* Successful initialization */
> +	goto out;
> +
> +remove_host:
> +	dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
> +	sdhci_remove_host(host, dead);
> +vreg_deinit:
> +	sdhci_msm_vreg_init(&pdev->dev, msm_host->pdata, false);
> +clk_disable:
> +	if (!IS_ERR(msm_host->clk))
> +		clk_disable_unprepare(msm_host->clk);
> +pclk_disable:
> +	if (!IS_ERR(msm_host->pclk))
> +		clk_disable_unprepare(msm_host->pclk);
> +bus_clk_disable:
> +	if (!IS_ERR_OR_NULL(msm_host->bus_clk))
> +		clk_disable_unprepare(msm_host->bus_clk);
> +pltfm_free:
> +	sdhci_pltfm_free(pdev);
> +out:
> +	return ret;
> +}
> +

<snip>

> +
> +static struct platform_driver sdhci_msm_driver = {
> +	.probe = sdhci_msm_probe,
> +	.remove = sdhci_msm_remove,
> +	.driver = {
> +		   .name = "sdhci_msm",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(sdhci_msm_dt_match),

of_match_ptr is not really required.

Regards,
Ivan

> +		   },
> +};
> +
> +module_platform_driver(sdhci_msm_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm Secure Digital Host Controller Interface driver");
> +MODULE_LICENSE("GPL v2");


