Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaK0NYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:24:50 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60257 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbaK0NYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:24:47 -0500
Message-ID: <547725F8.1050106@st.com>
Date: Thu, 27 Nov 2014 14:24:08 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>, <broonie@kernel.org>, <kernel@stlinux.com>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 1/4] spi: Add new driver for STMicroelectronics' SPI Controller
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org> <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-11-27_06:2014-11-27,2014-11-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/27/2014 12:43 PM, Lee Jones wrote:
> This patch adds support for the SPI portion of ST's SSC device.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/spi/Kconfig  |   8 +
>   drivers/spi/Makefile |   1 +
>   drivers/spi/spi-st.c | 535 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 544 insertions(+)
>   create mode 100644 drivers/spi/spi-st.c
<snip>

> +
> +static int spi_st_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct spi_master *master;
> +	struct resource *res;
> +	struct spi_st *spi_st;
> +	int num_cs, cs_gpio, i, ret = 0;
> +	u32 var;
> +	
> +	printk("LEE: %s: %s()[%d]: Probing\n", __FILE__, __func__, __LINE__);
> +
> +	master = spi_alloc_master(&pdev->dev, sizeof(*spi_st));
> +	if (!master) {
> +		dev_err(&pdev->dev, "failed to allocate spi master\n");
> +		return -ENOMEM;
> +	}
> +	spi_st = spi_master_get_devdata(master);
> +
> +	if (!IS_ERR(dev->pins->p)) {
> +		spi_st->pins_sleep =
> +			pinctrl_lookup_state(dev->pins->p, PINCTRL_STATE_SLEEP);
> +		if (IS_ERR(spi_st->pins_sleep))
> +			dev_warn(&pdev->dev, "could not get sleep pinstate\n");
> +	}
> +
> +	num_cs = of_gpio_named_count(np, "cs-gpios");
> +
> +	for (i = 0; i < num_cs; i++) {
> +		cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
> +
> +		if (!gpio_is_valid(cs_gpio)) {
> +			dev_err(&pdev->dev,
> +				"%d is not a valid gpio\n", cs_gpio);
> +			return -EINVAL;
> +		}
> +			
> +		if (devm_gpio_request(&pdev->dev, cs_gpio, pdev->name)) {
> +			dev_err(&pdev->dev,
> +				"could not request %d gpio\n", cs_gpio);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	spi_st->clk = of_clk_get_by_name(np, "ssc");
> +	if (IS_ERR(spi_st->clk)) {
> +		dev_err(&pdev->dev, "Unable to request clock\n");
> +		ret = PTR_ERR(spi_st->clk);
> +		goto free_master;
> +	}
> +
> +	ret = clk_prepare_enable(spi_st->clk);
> +	if (ret)
> +		goto free_master;
> +
> +	master->dev.of_node		= np;
> +	master->bus_num			= pdev->id;
> +	master->mode_bits		= MODEBITS;
> +	spi_st->bitbang.master		= spi_master_get(master);
> +	spi_st->bitbang.setup_transfer	= spi_st_setup_transfer;
> +	spi_st->bitbang.txrx_bufs	= spi_st_txrx_bufs;
> +	spi_st->bitbang.master->setup	= spi_st_setup;
> +	spi_st->bitbang.master->cleanup	= spi_st_cleanup;
> +	spi_st->bitbang.chipselect	= spi_st_gpio_chipselect;
> +	spi_st->dev			= dev;
> +
> +	init_completion(&spi_st->done);
> +
> +	/* Get resources */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	spi_st->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(spi_st->base)) {
> +		ret = PTR_ERR(spi_st->base);
> +		goto clk_disable;
> +	}
> +
> +	spi_st->irq = irq_of_parse_and_map(np, 0);
> +	if (!spi_st->irq) {
> +		dev_err(&pdev->dev, "IRQ missing or invalid\n");
> +		ret = -EINVAL;
> +		goto clk_disable;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, spi_st->irq, spi_st_irq, 0,
> +			       pdev->name, spi_st);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request irq %d\n", spi_st->irq);
> +		goto clk_disable;
> +	}
> +
> +	/* Disable I2C and Reset SSC */
> +	writel_relaxed(0x0, spi_st->base + SSC_I2C);
> +	var = readw(spi_st->base + SSC_CTL);
Why not readw_relaxed to be consistent with readl:s?
> +	var |= SSC_CTL_SR;
> +	writel_relaxed(var, spi_st->base + SSC_CTL);
> +
> +	udelay(1);
> +	var = readl_relaxed(spi_st->base + SSC_CTL);
> +	var &= ~SSC_CTL_SR;
> +	writel_relaxed(var, spi_st->base + SSC_CTL);
> +
> +	/* Set SSC into slave mode before reconfiguring PIO pins */
> +	var = readl_relaxed(spi_st->base + SSC_CTL);
> +	var &= ~SSC_CTL_MS;
> +	writel_relaxed(var, spi_st->base + SSC_CTL);
> +
> +	/* Start "bitbang" worker */
> +	ret = spi_bitbang_start(&spi_st->bitbang);
> +	if (ret) {
> +		dev_err(&pdev->dev, "bitbang start failed [%d]\n", ret);
> +		goto clk_disable;
> +	}
> +
> +	dev_info(&pdev->dev, "registered SPI Bus %d\n", master->bus_num);
> +
> +	platform_set_drvdata(pdev, master);

Shouldn't you call devm_spi_register_master ?
> +
> +	/* by default the device is on */
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +
> +clk_disable:
> +	clk_disable_unprepare(spi_st->clk);
> +free_master:
> +	spi_master_put(master);
> +
> +	return ret;
> +}
> +
> +static int spi_st_remove(struct platform_device *pdev)
> +{
> +	struct spi_master *master = platform_get_drvdata(pdev);
> +	struct spi_st *spi_st = spi_master_get_devdata(master);
> +
> +	spi_bitbang_stop(&spi_st->bitbang);
> +	clk_disable_unprepare(spi_st->clk);
> +
> +	if (spi_st->pins_sleep)
> +		pinctrl_select_state(pdev->dev.pins->p, spi_st->pins_sleep);
You should use pinctrl_pm_select_sleep_state(dev); instead.

> +
> +	spi_master_put(spi_st->bitbang.master);
If you use devm_spi_register_master at probe time,
you shouldn't need to call spi_master_put IIUC.

> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int spi_st_suspend(struct device *dev)
> +{
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct spi_st *spi_st = spi_master_get_devdata(master);
> +
> +	writel_relaxed(0, spi_st->base + SSC_IEN);
> +
> +	if (!IS_ERR(spi_st->pins_sleep))
> +		pinctrl_select_state(dev->pins->p, spi_st->pins_sleep);
Ditto
> +
> +	clk_disable_unprepare(spi_st->clk);
> +
> +	return 0;
> +}
> +
> +static int spi_st_resume(struct device *dev)
> +{
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct spi_st *spi_st = spi_master_get_devdata(master);
> +	int ret;
> +
> +	ret = clk_prepare_enable(spi_st->clk);
> +
> +	if (!IS_ERR(dev->pins->default_state))
> +		pinctrl_select_state(dev->pins->p, dev->pins->default_state);
     pinctrl_pm_select_default_state(i2c_dev->dev);
     pinctrl_pm_select_idle_state(i2c_dev->dev);

> +
> +	return ret;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(spi_st_pm, spi_st_suspend, spi_st_resume);
> +
> +static struct of_device_id stm_spi_match[] = {
> +	{ .compatible = "st,comms-ssc-spi", },
> +	{ .compatible = "st,comms-ssc4-spi", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, stm_spi_match);
> +
> +static struct platform_driver spi_st_driver = {
> +	.driver = {
> +		.name = "spi-st",
> +		.pm = &spi_st_pm,
> +		.of_match_table = of_match_ptr(stm_spi_match),
> +	},
> +	.probe = spi_st_probe,
> +	.remove = spi_st_remove,
> +};
> +module_platform_driver(spi_st_driver);
> +
> +MODULE_AUTHOR("Patrice Chotard <patrice.chotard@st.com>");
> +MODULE_DESCRIPTION("STM SSC SPI driver");
> +MODULE_LICENSE("GPL v2");

