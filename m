Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaJ1P6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:58:48 -0400
Received: from smtp-out-148.synserver.de ([212.40.185.148]:1037 "EHLO
	smtp-out-148.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJ1P6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:58:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1177
Message-ID: <544FBD20.5000604@metafoo.de>
Date: Tue, 28 Oct 2014 16:58:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>, alsa-devel@alsa-project.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-xtensa@linux-xtensa.org,
        Takashi Iwai <tiwai@suse.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: add xtensa xtfpga I2S interface and
 platform
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 08:07 PM, Max Filippov wrote:

A few minor things.

[...]
> +static irqreturn_t xtfpga_i2s_interrupt(int irq, void *dev_id)
> +{
> +	struct xtfpga_i2s *i2s = dev_id;
> +	struct snd_pcm_substream *tx_substream;
> +	int tx_active;
> +	unsigned int_status;
> +
> +	regmap_read(i2s->regmap, XTFPGA_I2S_INT_STATUS, &int_status);
> +	if (!(int_status & XTFPGA_I2S_INT_VALID))
> +		return IRQ_NONE;
> +
> +	if (int_status & XTFPGA_I2S_INT_UNDERRUN) {
> +		i2s->tx_fifo_sz = 0;
> +		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
> +				   XTFPGA_I2S_CONFIG_INT_ENABLE |
> +				   XTFPGA_I2S_CONFIG_TX_ENABLE, 0);
> +	} else {
> +		i2s->tx_fifo_sz = i2s->tx_fifo_low;
> +		regmap_update_bits(i2s->regmap, XTFPGA_I2S_CONFIG,
> +				   XTFPGA_I2S_CONFIG_INT_ENABLE, 0);
> +	}
> +
> +	rcu_read_lock();
> +	tx_substream = rcu_dereference(i2s->tx_substream);
> +	tx_active = tx_substream && snd_pcm_running(tx_substream);
> +	if (tx_active) {
> +		snd_pcm_period_elapsed(tx_substream);
> +		if (int_status & XTFPGA_I2S_INT_UNDERRUN)
> +			dev_dbg_ratelimited(i2s->dev, "%s: underrun\n",
> +					    __func__);
> +		tx_substream = rcu_dereference(i2s->tx_substream);
> +		tx_active = tx_substream && snd_pcm_running(tx_substream);
> +	}
> +	rcu_read_unlock();
> +
> +	if (tx_active) {
> +		if (i2s->tx_fifo_high < 256)
> +			xtfpga_i2s_refill_fifo(i2s);
> +		else
> +			tasklet_hi_schedule(&i2s->refill_fifo);

Maybe use threaded IRQs instead of IRQ + tasklet.

> +	} else {
> +		xtfpga_i2s_irq_update_config(i2s, int_status);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
[...]
> +
> +static int xtfpga_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
> +{
> +	int ret;
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_START:
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> +	case SNDRV_PCM_TRIGGER_STOP:
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> +		ret = 0;
> +		break;
> +
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}

If you don't do anything you don't need the handler. The core will handle 
things if it is NULL.

> +static struct snd_pcm_ops xtfpga_pcm_ops = {

const

> +	.open		= xtfpga_pcm_open,
> +	.close		= xtfpga_pcm_close,
> +	.ioctl		= snd_pcm_lib_ioctl,
> +	.hw_params	= xtfpga_pcm_hw_params,
> +	.trigger	= xtfpga_pcm_trigger,
> +	.pointer	= xtfpga_pcm_pointer,
> +};
[...]
> +static int xtfpga_i2s_probe(struct platform_device *pdev)
> +{
> +	struct xtfpga_i2s *i2s;
> +	struct resource *mem, *irq;
> +	int err;
> +
> +	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
> +	if (!i2s) {
> +		err = -ENOMEM;
> +		goto err;
> +	}
> +	dev_set_drvdata(&pdev->dev, i2s);

platform_set_drvdata(...)

> +	i2s->dev = &pdev->dev;
> +	dev_dbg(&pdev->dev, "dev: %p, i2s: %p\n", &pdev->dev, i2s);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem) {
> +		dev_err(&pdev->dev, "No memory resource\n");
> +		err = -ENODEV;
> +		goto err;
> +	}

devm_ioremap_resource will check if mem is NULL and print a error message, 
so the check above can be removed.

> +	i2s->regs = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(i2s->regs)) {
> +		err = PTR_ERR(i2s->regs);
> +		goto err;
> +	}
> +
> +	i2s->regmap = devm_regmap_init_mmio(&pdev->dev, i2s->regs,
> +					    &xtfpga_i2s_regmap_config);
> +	if (IS_ERR(i2s->regmap)) {
> +		dev_err(&pdev->dev, "regmap init failed\n");
> +		err = PTR_ERR(i2s->regmap);
> +		goto err;
> +	}
> +
> +	i2s->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(i2s->clk)) {
> +		dev_err(&pdev->dev, "couldn't get clock\n");
> +		err = PTR_ERR(i2s->clk);
> +		goto err;
> +	}
> +
> +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

platform_get_irq(...)

> +	if (!irq) {
> +		dev_err(&pdev->dev, "No IRQ resource\n");
> +		err = -ENODEV;
> +		goto err;
> +	}
> +	err = devm_request_irq(&pdev->dev, irq->start, xtfpga_i2s_interrupt,
> +			       IRQF_SHARED, pdev->name, i2s);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "request_irq failed\n");
> +		goto err;
> +	}
> +	tasklet_init(&i2s->refill_fifo, xtfpga_i2s_refill_fifo_tasklet,
> +		     (unsigned long)i2s);
> +

Since the tasklet is is used in the interrupt handler it should initialized 
before the IRQ is requested.


> +	regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG,
> +		     (0x1 << XTFPGA_I2S_CONFIG_CHANNEL_BASE));
> +	regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS, XTFPGA_I2S_INT_VALID);
> +	regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, XTFPGA_I2S_INT_UNDERRUN);
> +
> +	err = snd_soc_register_platform(&pdev->dev, &xtfpga_soc_platform);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "couldn't register platform\n");
> +		goto err;
> +	}
> +	err = devm_snd_soc_register_component(&pdev->dev,
> +					      &xtfpga_i2s_component,
> +					      xtfpga_i2s_dai,
> +					      ARRAY_SIZE(xtfpga_i2s_dai));
> +	if (err < 0)
> +		dev_err(&pdev->dev, "couldn't register component\n");
> +err:
> +	if (err)
> +		dev_err(&pdev->dev, "%s: err = %d\n", __func__, err);
> +	return err;
> +}
> +
> +static int xtfpga_i2s_remove(struct platform_device *pdev)
> +{
> +	struct xtfpga_i2s *i2s = dev_get_drvdata(&pdev->dev);
> +
> +	if (i2s) {

This will always be non NULL.

> +		tasklet_kill(&i2s->refill_fifo);
> +		if (i2s->regmap && !IS_ERR(i2s->regmap)) {
> +			regmap_write(i2s->regmap, XTFPGA_I2S_CONFIG, 0);
> +			regmap_write(i2s->regmap, XTFPGA_I2S_INT_MASK, 0);
> +			regmap_write(i2s->regmap, XTFPGA_I2S_INT_STATUS,
> +				     XTFPGA_I2S_INT_VALID);
> +		}
> +		if (i2s->clk_enabled)
> +			clk_disable_unprepare(i2s->clk);
> +	}
> +
> +	return 0;
> +}
[...]

