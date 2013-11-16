Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3KPLRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:17:54 -0500
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1028 "EHLO
	smtp-out-164.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751449Ab3KPLRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:17:45 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8049
Message-ID: <52875467.7000604@metafoo.de>
Date: Sat, 16 Nov 2013 12:17:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [RFCv2] ASoC: Add support for BCM2835
References: <52827644.1090708@koalo.de>
In-Reply-To: <52827644.1090708@koalo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 07:41 PM, Florian Meier wrote:
> This driver adds support for digital audio (I2S)
> for the BCM2835 SoC that is used by the
> Raspberry Pi. External audio codecs can be
> connected to the Raspberry Pi via P5 header.
> 
> It relies on cyclic DMA engine support for BCM2835.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>

Looks mostly good in my opinion. A few comments on minor bits and pieces.

> diff --git a/sound/soc/bcm/Kconfig b/sound/soc/bcm/Kconfig
> new file mode 100644
> index 0000000..93619ec
> --- /dev/null
> +++ b/sound/soc/bcm/Kconfig
> @@ -0,0 +1,15 @@
> +config SND_BCM2835_SOC_I2S
> +	tristate
> +
> +config SND_BCM2835_SOC
> +	tristate "SoC Audio support for the Broadcom BCM2835 I2S module"
> +	depends on ARCH_BCM2835

I think there is no compile time dependency on ARCH_BCM2835. Changing this
to 'depends on ARCH_BCM2835 || COMPILE_TEST' allows to archive better build
test coverage for the driver.

> +	select SND_SOC_DMAENGINE_PCM
> +	select DMADEVICES
> +	select DMA_BCM2835

I don't think its a good idea to select DMADEVICES or DMA_BCM2835 here,
since those are user selectable symbols from another subsystem. Either
'depends on DMA_BCM2835' or nothing. Will I think nothing is better since
there is no compile time dependency.

> +	select SND_SOC_GENERIC_DMAENGINE_PCM
> +	select REGMAP_MMIO
> +	help
> +	  Say Y or M if you want to add support for codecs attached to
> +	  the BCM2835 I2S interface. You will also need
> +	  to select the audio interfaces to support below.
[...]

> +static void bcm2835_i2s_clear_fifos(struct bcm2835_i2s_dev *dev,
> +				    bool tx, bool rx)
> +{
> +	int timeout = 1000;
> +	uint32_t syncval;
> +	uint32_t csreg;
> +	uint32_t i2s_active_state;
> +	uint32_t clkreg;
> +	uint32_t clk_active_state;
> +	uint32_t off;
> +	uint32_t clr;
> +
> +	off =  tx ? BCM2835_I2S_TXON : 0;
> +	off |= rx ? BCM2835_I2S_RXON : 0;
> +
> +	clr =  tx ? BCM2835_I2S_TXCLR : 0;
> +	clr |= rx ? BCM2835_I2S_RXCLR : 0;
> +
> +	/* Backup the current state */
> +	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
> +	i2s_active_state = csreg & (BCM2835_I2S_RXON | BCM2835_I2S_TXON);
> +
> +	regmap_read(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG, &clkreg);
> +	clk_active_state = clkreg & BCM2835_CLK_ENAB;
> +
> +	/* Start clock if not running */
> +	if (!clk_active_state) {
> +		regmap_update_bits(dev->clk_regmap, BCM2835_CLK_PCMCTL_REG,
> +			BCM2835_CLK_PASSWD_MASK | BCM2835_CLK_ENAB,
> +			BCM2835_CLK_PASSWD | BCM2835_CLK_ENAB);
> +	}
> +
> +	/* Stop I2S module */
> +	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, off, 0);
> +
> +	/*
> +	 * Clear the FIFOs
> +	 * Requires at least 2 PCM clock cycles to take effect
> +	 */
> +	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, clr, -1);

I think the -1 can be confusing. Better use either clr or 0xffffffff. Same
applies to a few other places in the driver.

> +
> +	/* Wait for 2 PCM clock cycles */
> +
> +	/*
> +	 * Toggle the SYNC flag - after 2 PCM clock cycles it can be read back
> +	 * FIXME: This does not seem to work for slave mode!
> +	 */
> +	regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &syncval);
> +	syncval &= BCM2835_I2S_SYNC;
> +
> +	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
> +			BCM2835_I2S_SYNC, ~syncval);
> +
> +	/* Wait for the SYNC flag changing it's state */
> +	while (timeout > 0) {
> +		timeout--;
> +
> +		regmap_read(dev->i2s_regmap, BCM2835_I2S_CS_A_REG, &csreg);
> +		if ((csreg & BCM2835_I2S_SYNC) != syncval)
> +			break;
> +	}
> +
> +	if (timeout <= 0)
> +		dev_err(dev->dev, "I2S SYNC error!\n");
> +
> +	/* Stop clock if it was not running before */
> +	if (!clk_active_state)
> +		bcm2835_i2s_stop_clock(dev);
> +
> +	/* Restore I2S state */
> +	regmap_update_bits(dev->i2s_regmap, BCM2835_I2S_CS_A_REG,
> +			BCM2835_I2S_RXON | BCM2835_I2S_TXON, i2s_active_state);
> +}
> +
[...]
> +static int bcm2835_i2s_dai_probe(struct snd_soc_dai *dai)
> +{
> +	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
> +
> +	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].addr_width =
> +		DMA_SLAVE_BUSWIDTH_4_BYTES;
> +	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].addr_width =
> +		DMA_SLAVE_BUSWIDTH_4_BYTES;
> +
> +	/* TODO other burst parameters possible? */
> +	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].maxburst = 2;
> +	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].maxburst = 2;

I'd move the initialization of dma_data to the driver probe() function.

> +
> +	dai->playback_dma_data = &dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK];
> +	dai->capture_dma_data = &dev->dma_data[SNDRV_PCM_STREAM_CAPTURE];

snd_soc_dai_init_dma_data()

> +
> +	return 0;
> +}
> +
[...]
> +
> +static int bcm2835_i2s_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_i2s_dev *dev;
> +	int i;
> +	int ret;
> +	struct regmap *regmap[2];
> +	struct resource *mem[2];
> +
> +	/* request both ioareas */
> +	for (i = 0; i <= 1; i++) {
> +		void __iomem *base;
> +
> +		mem[i] = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		if (!mem[i]) {
> +			dev_err(&pdev->dev, "I2S probe: Memory resource could not be found.\n");
> +			return -ENODEV;
> +		}
> +
> +		base = devm_ioremap_resource(&pdev->dev, mem[i]);
> +		if (!base) {
> +			dev_err(&pdev->dev, "I2S probe: ioremap failed.\n");
> +			return -ENOMEM;
> +		}
> +
> +		regmap[i] = devm_regmap_init_mmio(&pdev->dev, base,
> +					    &bcm2835_regmap_config[i]);
> +		if (IS_ERR(regmap[i])) {
> +			dev_err(&pdev->dev, "I2S probe: regmap init failed\n");
> +			return PTR_ERR(regmap[i]);
> +		}
> +	}
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(struct bcm2835_i2s_dev),

sizeof(*dev)

> +			   GFP_KERNEL);
> +	if (!dev) {
> +		dev_err(&pdev->dev, "I2S probe: kzalloc failed.\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev->i2s_regmap = regmap[0];
> +	dev->clk_regmap = regmap[1];
> +
> +	/* Set the DMA address */
> +	dev->dma_data[SNDRV_PCM_STREAM_PLAYBACK].addr =
> +		(dma_addr_t)mem[0]->start + BCM2835_I2S_FIFO_A_REG
> +					  + BCM2835_VCMMU_SHIFT;
> +
> +	dev->dma_data[SNDRV_PCM_STREAM_CAPTURE].addr =
> +		(dma_addr_t)mem[0]->start + BCM2835_I2S_FIFO_A_REG
> +					  + BCM2835_VCMMU_SHIFT;
> +
> +	/* Store the pdev */
> +	dev->dev = &pdev->dev;
> +	dev_set_drvdata(&pdev->dev, dev);
> +
> +	ret = snd_soc_register_component(&pdev->dev,
> +			&bcm2835_i2s_component, &bcm2835_i2s_dai, 1);
> +
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not register DAI: %d\n", ret);
> +		ret = -ENOMEM;
> +		return ret;
> +	}
> +
> +	ret = bcm2835_pcm_platform_register(&pdev->dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not register PCM: %d\n", ret);
> +		snd_soc_unregister_component(&pdev->dev);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id bcm2835_i2s_of_match[] = {
> +	{ .compatible = "brcm,bcm2835-i2s", },

Bindings documentation is missing.

> +	{},
> +};
[...]
> +
> +int bcm2835_pcm_platform_register(struct device *dev)
> +{
> +	return snd_dmaengine_pcm_register(dev, NULL, 0);

Now that these functions are just simple wrappers for
snd_dmaengine_pcm_{register,unregister}() there is really no need to keep
them around. Just remove bcm2835-pcm.h and .c and call them directly from
the i2s driver.

> +}
> +EXPORT_SYMBOL_GPL(bcm2835_pcm_platform_register);
[...]
