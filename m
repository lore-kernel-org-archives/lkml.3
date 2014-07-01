Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaGAJdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:33:52 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36375 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaGAJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:33:49 -0400
Message-ID: <53B28029.90408@gmail.com>
Date: Tue, 01 Jul 2014 15:02:25 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: jianqun <xjq@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com
Subject: Re: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
References: <1404203972-30760-1-git-send-email-xjq@rock-chips.com>
In-Reply-To: <1404203972-30760-1-git-send-email-xjq@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 02:09 PM, jianqun wrote:
> From: Jianqun Xu <xjq@rock-chips.com>
>
[...]

> +
> +static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
> +	struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)

Proper indentation for function arguments, otherwise checkpatch.pl will give warning.

> +{
> +	struct rk_i2s_dev *i2s = to_info(dai);
> +	unsigned long flags;
> +	u32 tx_ctl, rx_ctl;
> +	u32 dmacr;
> +
> +	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> +		dai->playback_dma_data = &i2s->playback_dma_data;
> +	else
> +		dai->capture_dma_data = &i2s->capture_dma_data;
> +
> +	spin_lock_irqsave(&i2s->lock, flags);
> +
> +	tx_ctl = i2s_readl(i2s, I2S_TXCR);
> +	tx_ctl &= ~I2S_TXCR_VDW_MASK;
> +	switch (params_format(params)) {
> +	case SNDRV_PCM_FORMAT_S8:
> +		tx_ctl |= I2S_TXCR_VDW(8);
> +		break;
> +	case SNDRV_PCM_FORMAT_S16_LE:
> +		tx_ctl |= I2S_TXCR_VDW(16);
> +		break;
> +	case SNDRV_PCM_FORMAT_S20_3LE:
> +		tx_ctl |= I2S_TXCR_VDW(20);
> +		break;
> +	case SNDRV_PCM_FORMAT_S24_LE:
> +		tx_ctl |= I2S_TXCR_VDW(24);
> +		break;
> +	case SNDRV_PCM_FORMAT_S32_LE:
> +		tx_ctl |= I2S_TXCR_VDW(32);
> +		break;
> +	}
> +
> +	i2s_writel(i2s, tx_ctl, I2S_TXCR);
> +
> +	rx_ctl = i2s_readl(i2s, I2S_TXCR);
> +	rx_ctl &= ~I2S_TXCR_VDW_MASK;
> +	switch (params_format(params)) {
> +	case SNDRV_PCM_FORMAT_S8:
> +		rx_ctl |= I2S_TXCR_VDW(8);
> +		break;
> +	case SNDRV_PCM_FORMAT_S16_LE:
> +		rx_ctl |= I2S_TXCR_VDW(16);
> +		break;
> +	case SNDRV_PCM_FORMAT_S20_3LE:
> +		rx_ctl |= I2S_TXCR_VDW(20);
> +		break;
> +	case SNDRV_PCM_FORMAT_S24_LE:
> +		rx_ctl |= I2S_TXCR_VDW(24);
> +		break;
> +	case SNDRV_PCM_FORMAT_S32_LE:
> +		rx_ctl |= I2S_TXCR_VDW(32);
> +		break;
> +	}
> +
> +	i2s_writel(i2s, rx_ctl, I2S_RXCR);
> +
> +	dmacr = i2s_readl(i2s, I2S_DMACR);
> +	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> +		dmacr = ((dmacr & ~I2S_DMACR_TDL_MASK) |
> +				I2S_DMACR_TDL(1) |
> +				I2S_DMACR_TDE_ENABLE);
> +	else
> +		dmacr = ((dmacr & ~I2S_DMACR_RDL_MASK) |
> +				I2S_DMACR_RDL(1) |
> +				I2S_DMACR_RDE_ENABLE);
> +
> +	i2s_writel(i2s, dmacr, I2S_DMACR);
> +
> +	spin_unlock_irqrestore(&i2s->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int rockchip_i2s_trigger(struct snd_pcm_substream *substream,
> +	int cmd, struct snd_soc_dai *dai)

same..

> +{
> +	struct rk_i2s_dev *i2s = to_info(dai);
> +	int ret = 0;
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_START:
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> +		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
> +			rockchip_snd_rxctrl(i2s, 1);
> +		else
> +			rockchip_snd_txctrl(i2s, 1);
> +		break;
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +	case SNDRV_PCM_TRIGGER_STOP:
> +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> +		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
> +			rockchip_snd_rxctrl(i2s, 0);
> +		else
> +			rockchip_snd_txctrl(i2s, 0);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai,
> +	int clk_id, unsigned int freq, int dir)

same

> +{
> +	struct rk_i2s_dev *i2s = to_info(cpu_dai);
> +
> +	clk_set_rate(i2s->clk, freq);
> +
> +	return 0;
> +}
> +
> +static int rockchip_i2s_set_clkdiv(struct snd_soc_dai *cpu_dai,
> +	int div_id, int div)

same

> +{
> +	struct rk_i2s_dev *i2s = to_info(cpu_dai);
> +	unsigned long flags;
> +	u32 reg;
> +	int ret;
> +
> +	spin_lock_irqsave(&i2s->lock, flags);
> +
> +	reg = i2s_readl(i2s, I2S_CKR);
> +	switch (div_id) {
> +	case ROCKCHIP_DIV_BCLK:
> +		reg &= ~I2S_CKR_TSD_MASK;
> +		reg |= I2S_CKR_TSD(div);
> +		reg &= ~I2S_CKR_RSD_MASK;
> +		reg |= I2S_CKR_RSD(div);
> +		break;
> +	case ROCKCHIP_DIV_MCLK:
> +		reg &= ~I2S_CKR_MDIV_MASK;
> +		reg |= I2S_CKR_MDIV(div);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	i2s_writel(i2s, reg, I2S_CKR);
> +
> +exit:
> +	spin_unlock_irqrestore(&i2s->lock, flags);
> +
> +	return ret;
> +}
> +
> +static struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
> +	.trigger = rockchip_i2s_trigger,
> +	.hw_params = rockchip_i2s_hw_params,
> +	.set_fmt = rockchip_i2s_set_fmt,
> +	.set_clkdiv = rockchip_i2s_set_clkdiv,
> +	.set_sysclk = rockchip_i2s_set_sysclk,
> +};
> +
> +#define ROCKCHIP_I2S_STEREO_RATES SNDRV_PCM_RATE_8000_96000
> +#define ROCKCHIP_I2S_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | \
> +		SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE | \
> +		SNDRV_PCM_FMTBIT_S8)
> +
> +struct snd_soc_dai_driver rockchip_i2s_dai[] = {
> +	{
> +		.name = "rockchip-i2s.0",
> +		.id = 0,
> +		.playback = {
> +			.channels_min = 2,
> +			.channels_max = 8,
> +			.rates = ROCKCHIP_I2S_STEREO_RATES,
> +			.formats = ROCKCHIP_I2S_FORMATS,
> +		},
> +		.capture = {
> +			.channels_min = 2,
> +			.channels_max = 2,
> +			.rates = ROCKCHIP_I2S_STEREO_RATES,
> +			.formats = ROCKCHIP_I2S_FORMATS,
> +		},
> +		.ops = &rockchip_i2s_dai_ops,
> +		.symmetric_rates = 1,
> +	},
> +	{
> +		.name = "rockchip-i2s.1",
> +		.id = 1,
> +		.playback = {
> +			.channels_min = 2,
> +			.channels_max = 2,
> +			.rates = ROCKCHIP_I2S_STEREO_RATES,
> +			.formats = ROCKCHIP_I2S_FORMATS,
> +		},
> +		.capture = {
> +			.channels_min = 2,
> +			.channels_max = 2,
> +			.rates = ROCKCHIP_I2S_STEREO_RATES,
> +			.formats = ROCKCHIP_I2S_FORMATS,
> +		},
> +		.ops = &rockchip_i2s_dai_ops,
> +		.symmetric_rates = 1,
> +	},
> +};
> +
> +static const struct snd_soc_component_driver rockchip_i2s_component = {
> +	.name	= DRV_NAME,
> +};
> +
> +#ifdef CONFIG_PM_RUNTIME
> +static int i2s_runtime_suspend(struct device *dev)
> +{
> +	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
> +
> +	clk_disable_unprepare(i2s->clk);
> +
> +	return 0;
> +}
> +
> +static int i2s_runtime_resume(struct device *dev)
> +{
> +	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
> +
> +	return clk_prepare_enable(i2s->clk);
> +}
> +#else
> +#define i2s_runtime_suspend NULL
> +#define i2s_runtime_resume NULL
> +#endif
> +
> +static int rockchip_i2s_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct rk_i2s_dev *i2s;
> +	struct resource *res;
> +	int ret;
> +
> +	i2s = devm_kzalloc(&pdev->dev, sizeof(struct rk_i2s_dev),
> +				GFP_KERNEL);

same

> +	if (!i2s)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	i2s->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(i2s->regs)) {
> +		dev_err(&pdev->dev, "Could not get I2S source, %p\n",
> +				i2s->regs);

same...

> +		return PTR_ERR(i2s->regs);
> +	}
> +
> +	i2s->playback_dma_data.addr = res->start + I2S_TXDR;
> +	i2s->playback_dma_data.addr_width = 4;
> +	i2s->playback_dma_data.maxburst = 1;
> +
> +	i2s->capture_dma_data.addr = res->start + I2S_RXDR;
> +	i2s->capture_dma_data.addr_width = 4;
> +	i2s->capture_dma_data.maxburst = 1;
> +
> +	i2s->i2s_tx_status = false;
> +	i2s->i2s_rx_status = false;
> +
> +	spin_lock_init(&i2s->lock);
> +
> +	ret = rockchip_pcm_platform_register(&pdev->dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not register PCM\n");
> +		goto err_pcm_register;
> +	}
> +
> +	/* Must success to get some clocks from dt */
> +	i2s->hclk = devm_clk_get(&pdev->dev, "i2s_hclk");
> +	if (IS_ERR(i2s->hclk)) {
> +		dev_err(&pdev->dev, "Could not get i2s_hclk\n");
> +		return PTR_ERR(i2s->hclk);
> +	}
> +
> +	i2s->clk = devm_clk_get(&pdev->dev, "i2s_clk");
> +	if (IS_ERR(i2s->clk)) {
> +		dev_err(&pdev->dev, "Could not get i2s_clk\n");
> +		return PTR_ERR(i2s->clk);
> +	}
> +
> +	ret = clk_prepare_enable(i2s->hclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not enable i2s_hclk\n");
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(i2s->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not enable i2s_clk\n");
> +		goto err_hclk_disable;
> +	}
> +
> +	/* Try to set the I2S Channel id from dt */
> +	pdev->id = of_alias_get_id(np, "i2s");
> +	dev_set_name(&pdev->dev, "%s.%d",
> +				pdev->dev.driver->name,
> +				pdev->id);

same

> +
> +	i2s->dev = &pdev->dev;
> +	dev_set_drvdata(&pdev->dev, i2s);
> +
> +	ret = devm_snd_soc_register_component(&pdev->dev,
> +				&rockchip_i2s_component,
> +				&rockchip_i2s_dai[pdev->id], 1);

same

> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not register DAI\n");
> +		goto err_clk_disable;
> +	}
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +
> +err_clk_disable:
> +	clk_disable_unprepare(i2s->clk);
> +err_hclk_disable:
> +	clk_disable_unprepare(i2s->hclk);
> +err_pcm_register:
> +	rockchip_pcm_platform_unregister(&pdev->dev);
> +
> +	return ret;
> +}
> +
> +static int rockchip_i2s_remove(struct platform_device *pdev)
> +{
> +	struct rk_i2s_dev *i2s = dev_get_drvdata(&pdev->dev);
> +
> +	clk_disable_unprepare(i2s->clk);
> +	clk_disable_unprepare(i2s->hclk);
> +	rockchip_pcm_platform_unregister(&pdev->dev);
> +	snd_soc_unregister_component(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id rockchip_i2s_match[] = {
> +	{
> +		.compatible = "rockchip,rk3066-i2s"
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, rockchip_i2s_match);
> +
> +static const struct dev_pm_ops rockchip_i2s_pm_ops = {
> +	SET_RUNTIME_PM_OPS(i2s_runtime_suspend,
> +			i2s_runtime_resume, NULL)
> +};
> +
> +static struct platform_driver rockchip_i2s_driver = {
> +	.probe = rockchip_i2s_probe,
> +	.remove = rockchip_i2s_remove,
> +	.driver = {
> +		.name = DRV_NAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(rockchip_i2s_match),
> +		.pm = &rockchip_i2s_pm_ops,
> +	},
> +};
> +module_platform_driver(rockchip_i2s_driver);
> +
> +MODULE_DESCRIPTION("ROCKCHIP IIS ASoC Interface");
> +MODULE_AUTHOR("jianqun <jay.xu@rock-chips.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/sound/soc/rockchip/rockchip_pcm.c b/sound/soc/rockchip/rockchip_pcm.c
> new file mode 100644
> index 0000000..454c609
> --- /dev/null
> +++ b/sound/soc/rockchip/rockchip_pcm.c
> @@ -0,0 +1,64 @@
> +/* sound/soc/rockchip/pcm.c
> + *
> + * ALSA SoC Audio Layer - Rockchip I2S Controller driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/pcm_params.h>
> +#include <sound/soc.h>
> +#include <sound/dmaengine_pcm.h>
> +
> +#include "pcm.h"
> +
> +static const struct snd_pcm_hardware rockchip_pcm_hardware = {
> +	.info = SNDRV_PCM_INFO_INTERLEAVED |
> +			SNDRV_PCM_INFO_BLOCK_TRANSFER |
> +			SNDRV_PCM_INFO_MMAP |
> +			SNDRV_PCM_INFO_MMAP_VALID |
> +			SNDRV_PCM_INFO_PAUSE |
> +			SNDRV_PCM_INFO_RESUME,
> +	.formats = SNDRV_PCM_FMTBIT_S24_LE |
> +			SNDRV_PCM_FMTBIT_S20_3LE |
> +			SNDRV_PCM_FMTBIT_S16_LE,
> +	.channels_min = 2,
> +	.channels_max = 8,
> +	.buffer_bytes_max = 128*1024,
> +	.period_bytes_min = 64,
> +	.period_bytes_max = 2048*4,
> +	.periods_min = 3,
> +	.periods_max = 128,
> +	.fifo_size = 16,
> +};
> +
> +static const struct snd_dmaengine_pcm_config rockchip_dmaengine_pcm_config = {
> +	.pcm_hardware = &rockchip_pcm_hardware,
> +	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
> +	.compat_filter_fn = NULL,
> +	.prealloc_buffer_size = PAGE_SIZE * 8,
> +};
> +
> +int rockchip_pcm_platform_register(struct device *dev)
> +{
> +	return snd_dmaengine_pcm_register(dev, &rockchip_dmaengine_pcm_config,
> +			SND_DMAENGINE_PCM_FLAG_COMPAT|
> +			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);

same...

> +}
> +EXPORT_SYMBOL_GPL(rockchip_pcm_platform_register);
> +
> +void rockchip_pcm_platform_unregister(struct device *dev)
> +{
> +	snd_dmaengine_pcm_unregister(dev);
> +}
> +EXPORT_SYMBOL_GPL(rockchip_pcm_platform_unregister);
> +
> +MODULE_DESCRIPTION("ROCKCHIP PCM ASoC Interface");
> +MODULE_AUTHOR("jianqun <jay.xu@rock-chips.com>");
> +MODULE_LICENSE("GPL v2");

run checkpatch.pl on patches and fix them.

Thanks...


-- 
Varka Bhadram
