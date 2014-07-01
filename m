Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbaGARIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:08:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42810 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbaGARIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:08:37 -0400
Date: Tue, 1 Jul 2014 18:07:47 +0100
From: Mark Brown <broonie@kernel.org>
To: jianqun <xjq@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com
Message-ID: <20140701170747.GA15028@sirena.org.uk>
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
 <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
X-Cookie: Pournelle must die!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 01, 2014 at 04:47:38PM +0800, jianqun wrote:

> --- /dev/null
> +++ b/sound/soc/rockchip/i2s.h
> @@ -0,0 +1,222 @@
> +/*
> + * i2s.h - ALSA IIS interface for the rockchip SoC
> + *
> + * Driver for rockchip iis audio
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/version.h>

You should never need to include this.

> +	bool i2s_tx_status;
> +	bool i2s_rx_status;

Can we have more meaningful names for these please?

> +static inline void i2s_writel(struct rk_i2s_dev *i2s, u32 value,
> +			      unsigned int offset)
> +{
> +	writel_relaxed(value, i2s->regs + offset);
> +}
> +
> +static inline u32 i2s_readl(struct rk_i2s_dev *i2s, unsigned int offset)
> +{
> +	return readl_relaxed(i2s->regs + offset);
> +}

Perhaps use regmap?  The main advantage would be the debug
infrastructure, though you could also use _update_bits() to reduce the
amount of time spent locked.

> +	if (need_delay) {
> +		while (i2s_readl(i2s, I2S_CLR) && try_cnt) {
> +			udelay(1);
> +			try_cnt--;
> +		}
> +	}

It's not reall a delay but rather a wait for the hardware to be ready I
guess?  I'd expect to see some kind of message printed if we time out
without the hardware reporting it's ready - that probably means
something is going wrong.

> +	case SND_SOC_DAIFMT_I2S:
> +		tx_ctl &= ~I2S_TXCR_IBM_MASK;
> +		tx_ctl |= I2S_TXCR_IBM_NORMAL;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	i2s_writel(i2s, tx_ctl, I2S_TXCR);

It's not a serious problem but it's more normal to defer the writes to
the end of the function after all the error checking so that if the
function fails we don't end up writing out part of the configuration.

> +static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai,
> +	int clk_id, unsigned int freq, int dir)
> +{
> +	struct rk_i2s_dev *i2s = to_info(cpu_dai);
> +
> +	clk_set_rate(i2s->clk, freq);

You should check (or just directly return) the error code here.  It'd
also be good to define and validate a clock number, even if there's only
one right now, in order to avoid problems later on.

> +static int rockchip_i2s_set_clkdiv(struct snd_soc_dai *cpu_dai,
> +	int div_id, int div)

Why are you defining a set_clkdiv() operation?  The code appears to just
support MCLK and BCLK dividers both of which the driver ought to be able
to just configure automatically.

> +
> +static int i2s_runtime_resume(struct device *dev)
> +{
> +	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
> +
> +	return clk_prepare_enable(i2s->clk);

Error checking.

> +	/* Try to set the I2S Channel id from dt */
> +	pdev->id = of_alias_get_id(np, "i2s");
> +	dev_set_name(&pdev->dev, "%s.%d",
> +				pdev->dev.driver->name,
> +				pdev->id);

No, this is seriously broken - a driver should never attempt to change
its own device name, just use the name that the kernel set.

> +	ret = devm_snd_soc_register_component(&pdev->dev,
> +				&rockchip_i2s_component,
> +				&rockchip_i2s_dai[pdev->id], 1);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not register DAI\n");
> +		goto err_clk_disable;
> +	}
> +
> +	pm_runtime_enable(&pdev->dev);

Error checking and I'd expect this to happen before the device is
registered - remember that the device may be bound into a sound card
within the component registration so it has to be able to run normally.

> +	snd_soc_unregister_component(&pdev->dev);

Not neeed with devm_snd_soc_register_component().

> +static const struct of_device_id rockchip_i2s_match[] = {
> +	{
> +		.compatible = "rockchip,rk3066-i2s"
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, rockchip_i2s_match);

Needs an empty terminating entry and the binding document listed two
compatible strings.

> @@ -0,0 +1,64 @@
> +/* sound/soc/rockchip/pcm.c
> + *
> + * ALSA SoC Audio Layer - Rockchip I2S Controller driver

Submit this as a separate patch.

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

The framework is supposed to be able to figure this out automatically
with current kernels - if there's something not working there we should
at least understand what and ideally fix it.

> +static const struct snd_dmaengine_pcm_config rockchip_dmaengine_pcm_config = {
> +	.pcm_hardware = &rockchip_pcm_hardware,
> +	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
> +	.compat_filter_fn = NULL,

No need to set NULL explicitly.

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsurfAAoJELSic+t+oim9XuIP/0ljuEl/+FtVQNnIsLLOGpiK
6ptA/SYDPfwtfKMfxoT7ox9OEwFy1KKY9dn8lfEqzOf4P0jXhd+z6zLm/b6ZvQCY
t5cHQ3JLJLsS08UwYc4wQD4simzih7QbhrHhyUpDSasQTAQLURTyUb87zo7ci1pV
5k9MFV7hvIuZirohENJoAAgFs5CZthcjxJsevaF61Ws8+FyifikmvKzN5+ia8/mL
CIpuxicyO+skz7oKyYKYbLO2DxriIoSXDaJtenJZ15+lXYCObVWdRjtMOg71cgWy
LH6bdzwNbKR4n72bWW9uEPXDeL1IWKZCJwxwJqMch8wzqpLHCjzHc2w11zIrKHuC
leZOeoBvKCMo/Oesjx7Jm4fdlBbVFhRz8tAPUhEkyu9my6h8vNCkfoC7USR5beZu
K0uytTF3CQcKduoO55sYKzKWeqplmPkozf+o+aeF/K+pAg5lXIXt/YW5MXJXne3B
Xaek2hmPUyVJ01Uqy8tNosTe2FOajLVGOEdf3w6uN4VPfI2713yS3hERmKz26Rw0
8on89gauKUNPSv5nR0/jJgoVYqwjFrTGRV6ACLHZA73pL82sHuKIApzFFw+U3Z7G
zi6Dw74hK09gpfHZKmWaRGQmpeQafV0v+s+Jxl4+7zRBoZ3nOBHVaLtxasmDPJ7C
lJLdF/F4jZa7E27LiTyx
=FP6f
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
