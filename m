Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaGAJvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:51:43 -0400
Received: from smtp-out-145.synserver.de ([212.40.185.145]:1085 "EHLO
	smtp-out-145.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaGAJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:51:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21551
Message-ID: <53B284A9.6050608@metafoo.de>
Date: Tue, 01 Jul 2014 11:51:37 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: jianqun <xjq@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, robh+dt@kernel.org
CC: huangtao@rock-chips.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, yzq@rock-chips.com,
        zhangqing@rock-chips.com, linux-kernel@vger.kernel.org,
        kever.yang@rock-chips.com, cf@rock-chips.com, kfx@rock-chips.com,
        zyw@rock-chips.com, hj@rock-chips.com, zhenfu.fang@rock-chips.com
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx
 I2S controller
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com> <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
In-Reply-To: <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 10:47 AM, jianqun wrote:
[...]
> new file mode 100644
> index 0000000..946b60c
> --- /dev/null
> +++ b/sound/soc/rockchip/Kconfig
> @@ -0,0 +1,16 @@
> +config SND_SOC_ROCKCHIP
> +	tristate "ASoC support for Rockchip"
> +	depends on SND_SOC && ARCH_ROCKCHIP

No need for SND_SOC this is implicit for all drivers in sound/soc/. Also 
allow the driver to be select when COMPILE_TEST is selected.

> +	select SND_SOC_GENERIC_DMAENGINE_PCM
> +	select SND_ROCKCHIP_PCM
> +	select SND_ROCKCHIP_I2S
> +	help
> +	  Say Y or M if you want to add support for codecs attached to
> +	  the Rockchip SoCs' Audio interfaces. You will also need to
> +	  select the audio interfaces to support below.
> +
[...]
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/version.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/spinlock.h>
> +#include <linux/workqueue.h>
> +#include <asm/dma.h>
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/pcm_params.h>
> +#include <sound/initval.h>
> +#include <sound/soc.h>
> +#include <sound/dmaengine_pcm.h>

Are you sure that you need all of these includes?

> +
[...]
> +static struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
const
> +	.trigger = rockchip_i2s_trigger,
> +	.hw_params = rockchip_i2s_hw_params,
> +	.set_fmt = rockchip_i2s_set_fmt,
> +	.set_clkdiv = rockchip_i2s_set_clkdiv,
> +	.set_sysclk = rockchip_i2s_set_sysclk,
> +};
[...]
> +static int rockchip_i2s_probe(struct platform_device *pdev)
> +{
[...]
> +	/* Try to set the I2S Channel id from dt */
> +	pdev->id = of_alias_get_id(np, "i2s");
> +	dev_set_name(&pdev->dev, "%s.%d",
> +				pdev->dev.driver->name,
> +				pdev->id);

A device should not change its id or name.

> +
> +	i2s->dev = &pdev->dev;
> +	dev_set_drvdata(&pdev->dev, i2s);
> +
> +	ret = devm_snd_soc_register_component(&pdev->dev,
> +				&rockchip_i2s_component,
> +				&rockchip_i2s_dai[pdev->id], 1);

If those are two instances of the same I2S core just use one 
snd_soc_dai_driver struct. There is no need for the driver to know or care 
about how many instances of the core the system has.

[...]
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

We should try to avoid adding new users of the generic dmaengine pcm driver 
that manually specify a snd_pcm_hardware struct. We now have the 
infrastructure to autodiscover the capabilities of the DMA via the dmaengine 
API.

New drivers really should just do snd_dmaengine_pcm_register(dev, NULL, 0);

- Lars
